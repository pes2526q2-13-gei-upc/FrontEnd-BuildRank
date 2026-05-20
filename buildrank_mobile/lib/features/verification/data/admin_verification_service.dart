import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:buildrank_mobile/core/config/api_config.dart';
import 'package:buildrank_mobile/features/auth/data/token_storage.dart';
import 'package:http_parser/http_parser.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class AdminVerificationService {
  const AdminVerificationService();

  Future<Map<String, String>> _buildJsonHeaders() async {
    final token = await TokenStorage.getAccessToken();

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, String>> _buildMultipartHeaders() async {
    final token = await TokenStorage.getAccessToken();

    return {
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> createVerification({
    required int idEdifici,
    required List<AdminVerificationDocumentInput> documents,
  }) async {
    if (documents.isEmpty) {
      throw const AdminVerificationApiException(
        'Cal adjuntar almenys un document per sol·licitar la verificació.',
      );
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConfig.verificationCreate),
    );

    request.headers.addAll(await _buildMultipartHeaders());
    request.fields['edifici'] = idEdifici.toString();

    for (final document in documents) {
      request.files.add(
        http.MultipartFile.fromString('documents_doc_type', document.docType),
      );

      final file = document.file;
      final contentType = MediaType('image', 'jpeg');

      if (file.bytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'documents_fitxer',
            file.bytes!,
            filename: file.name,
            contentType: contentType,
          ),
        );
      } else if (file.path != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'documents_fitxer',
            file.path!,
            filename: file.name,
            contentType: contentType,
          ),
        );
      } else {
        throw AdminVerificationApiException(
          'No s’ha pogut llegir el fitxer ${file.name}.',
        );
      }
    }

    try {
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 45),
      );

      final response = await http.Response.fromStream(streamedResponse);
      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw AdminVerificationApiException(
          _extractErrorMessage(
            decoded,
            fallback: 'No s’ha pogut enviar la documentació de verificació.',
          ),
          statusCode: response.statusCode,
          details: decoded,
        );
      }

      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);

      return {'data': decoded};
    } on TimeoutException {
      throw const AdminVerificationApiException(
        'L’enviament de la documentació ha trigat massa.',
      );
    } on SocketException {
      throw const AdminVerificationApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } on AdminVerificationApiException {
      rethrow;
    } catch (_) {
      throw const AdminVerificationApiException(
        'S’ha produït un error inesperat enviant la documentació.',
      );
    }
  }

  Future<List<AdminVerificationItem>> listVerifications() async {
    try {
      final response = await http
          .get(
            Uri.parse(ApiConfig.verifications),
            headers: await _buildJsonHeaders(),
          )
          .timeout(const Duration(seconds: 15));

      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode != 200) {
        throw AdminVerificationApiException(
          _extractErrorMessage(
            decoded,
            fallback: 'No s’han pogut carregar les verificacions.',
          ),
          statusCode: response.statusCode,
          details: decoded,
        );
      }

      final rawList = decoded is List
          ? decoded
          : decoded is Map
          ? decoded['results'] ?? decoded['data']
          : null;

      if (rawList is! List) {
        throw const AdminVerificationApiException(
          'La resposta de verificacions no té el format esperat.',
        );
      }

      return rawList
          .whereType<Map>()
          .map(
            (item) =>
                AdminVerificationItem.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    } on TimeoutException {
      throw const AdminVerificationApiException(
        'La càrrega de verificacions ha trigat massa.',
      );
    } on SocketException {
      throw const AdminVerificationApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } on FormatException {
      throw const AdminVerificationApiException(
        'La resposta del servidor no té el format esperat.',
      );
    } on AdminVerificationApiException {
      rethrow;
    } catch (_) {
      throw const AdminVerificationApiException(
        'S’ha produït un error inesperat carregant les verificacions.',
      );
    }
  }

  Future<void> reviewVerification({
    required int verificationId,
    required bool approve,
    String? reason,
  }) async {
    final payload = {
      'accio': approve ? 'aprovar' : 'rebutjar',
      if (!approve && reason != null && reason.trim().isNotEmpty)
        'motiu': reason.trim(),
    };

    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.verificationReview(verificationId)),
            headers: await _buildJsonHeaders(),
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 15));

      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw AdminVerificationApiException(
          _extractErrorMessage(
            decoded,
            fallback: approve
                ? 'No s’ha pogut aprovar la verificació.'
                : 'No s’ha pogut rebutjar la verificació.',
          ),
          statusCode: response.statusCode,
          details: decoded,
        );
      }
    } on TimeoutException {
      throw const AdminVerificationApiException(
        'La revisió de la verificació ha trigat massa.',
      );
    } on SocketException {
      throw const AdminVerificationApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } on AdminVerificationApiException {
      rethrow;
    } catch (_) {
      throw const AdminVerificationApiException(
        'S’ha produït un error inesperat revisant la verificació.',
      );
    }
  }

  dynamic _tryDecodeBody(String body) {
    if (body.isEmpty) return {};

    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }

  String _extractErrorMessage(dynamic data, {required String fallback}) {
    if (data == null) return fallback;

    if (data is Map) {
      if (data['detail'] != null) return data['detail'].toString();
      if (data['error'] != null) return data['error'].toString();
      if (data['message'] != null) return data['message'].toString();

      if (data.isNotEmpty) {
        final firstValue = data.values.first;
        if (firstValue is List && firstValue.isNotEmpty) {
          return firstValue.first.toString();
        }

        return firstValue.toString();
      }
    }

    return data.toString();
  }
}

class AdminVerificationDocumentInput {
  final PlatformFile file;
  final String docType;

  const AdminVerificationDocumentInput({
    required this.file,
    required this.docType,
  });

  AdminVerificationDocumentInput copyWith({
    PlatformFile? file,
    String? docType,
  }) {
    return AdminVerificationDocumentInput(
      file: file ?? this.file,
      docType: docType ?? this.docType,
    );
  }
}

class AdminVerificationDocumentType {
  final String code;
  final String label;

  const AdminVerificationDocumentType({
    required this.code,
    required this.label,
  });

  static const values = [
    AdminVerificationDocumentType(
      code: 'acta_junta',
      label: 'Acta de junta de propietaris',
    ),
    AdminVerificationDocumentType(
      code: 'certificat',
      label: 'Certificat de nomenament',
    ),
    AdminVerificationDocumentType(
      code: 'contracte',
      label: 'Contracte d’administració',
    ),
    AdminVerificationDocumentType(
      code: 'cert_col',
      label: 'Certificat col·legial',
    ),
    AdminVerificationDocumentType(
      code: 'identificatiu',
      label: 'Document identificatiu',
    ),
    AdminVerificationDocumentType(
      code: 'factura',
      label: 'Factura o document de la comunitat',
    ),
  ];

  static String labelFor(String code) {
    return values
        .firstWhere(
          (item) => item.code == code,
          orElse: () => AdminVerificationDocumentType(code: code, label: code),
        )
        .label;
  }
}

class AdminVerificationItem {
  final int id;
  final String status;
  final double? score;
  final String? suggeriment;
  final List<String> scoreFlags;
  final String requesterName;
  final String requesterEmail;
  final int? edificiId;
  final String edificiTitle;
  final List<AdminVerificationDocumentSummary> documents;

  const AdminVerificationItem({
    required this.id,
    required this.status,
    required this.score,
    required this.suggeriment,
    required this.scoreFlags,
    required this.requesterName,
    required this.requesterEmail,
    required this.edificiId,
    required this.edificiTitle,
    required this.documents,
  });

  bool get isReadyForReview => status.toLowerCase() == 'review';

  factory AdminVerificationItem.fromJson(Map<String, dynamic> json) {
    final userDetail =
        _readMap(json['user_detail']) ??
        _readMap(json['user'] ?? json['usuari']);

    final edificiDetail =
        _readMap(json['edifici_detail']) ?? _readMap(json['edifici']);

    final localitzacio = _readMap(edificiDetail?['localitzacio']);

    final userId = _readInt(
      userDetail?['id'] ?? json['user'] ?? json['usuari'],
    );

    final firstName = _readString(userDetail?['first_name']);
    final lastName = _readString(userDetail?['last_name']);
    final email = _readString(userDetail?['email']);

    final requesterName = [?firstName, ?lastName].join(' ').trim();

    final carrer = _readString(localitzacio?['carrer']);
    final numero = _readString(localitzacio?['numero']);
    final codiPostal = _readString(localitzacio?['codiPostal']);

    final addressParts = [?carrer, ?numero];

    final postalSuffix = codiPostal == null ? '' : ' ($codiPostal)';
    final adreca = _readString(edificiDetail?['adreca']);

    final fallbackEdificiTitle = addressParts.isEmpty
        ? null
        : '${addressParts.join(', ')}$postalSuffix';

    final documentsRaw = json['documents'];

    return AdminVerificationItem(
      id: _readInt(json['id']) ?? 0,
      status: _readString(json['status']) ?? 'pending',
      score: _readDouble(json['score']),
      suggeriment: _readString(json['suggeriment']),
      scoreFlags: _readStringList(json['score_flags']),
      requesterName: requesterName.isNotEmpty
          ? requesterName
          : userId == null
          ? 'Usuari'
          : 'Usuari #$userId',
      requesterEmail: email ?? 'Correu no disponible',
      edificiId: _readInt(
        edificiDetail?['idEdifici'] ?? edificiDetail?['id'] ?? json['edifici'],
      ),
      edificiTitle:
          adreca ??
          _readString(edificiDetail?['titol'] ?? edificiDetail?['name']) ??
          fallbackEdificiTitle ??
          (_readInt(json['edifici']) == null
              ? 'Edifici pendent'
              : 'Edifici #${_readInt(json['edifici'])}'),
      documents: documentsRaw is List
          ? documentsRaw
                .whereType<Map>()
                .map(
                  (item) => AdminVerificationDocumentSummary.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : const [],
    );
  }
}

class AdminVerificationDocumentSummary {
  final String docType;
  final double? confidence;
  final double? score;
  final List<String> scoreFlags;

  const AdminVerificationDocumentSummary({
    required this.docType,
    required this.confidence,
    required this.score,
    required this.scoreFlags,
  });

  factory AdminVerificationDocumentSummary.fromJson(Map<String, dynamic> json) {
    return AdminVerificationDocumentSummary(
      docType: _readString(json['doc_type']) ?? 'desconegut',
      confidence: _readDouble(json['confidence']),
      score: _readDouble(json['score']),
      scoreFlags: _readStringList(json['score_flags']),
    );
  }
}

class AdminVerificationApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const AdminVerificationApiException(
    this.message, {
    this.statusCode,
    this.details,
  });

  @override
  String toString() => message;
}

Map<String, dynamic>? _readMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

String? _readString(dynamic value) {
  if (value == null) return null;

  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

int? _readInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.round();

  if (value is String) {
    return int.tryParse(value.trim()) ?? double.tryParse(value.trim())?.round();
  }

  return null;
}

double? _readDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();

  if (value is String) {
    return double.tryParse(value.trim().replaceAll(',', '.'));
  }

  return null;
}

List<String> _readStringList(dynamic value) {
  if (value is List) {
    return value.map((item) => item.toString()).toList();
  }

  if (value == null) return const [];

  return [value.toString()];
}
