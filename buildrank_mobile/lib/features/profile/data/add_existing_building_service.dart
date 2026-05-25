import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:buildrank_mobile/core/config/api_config.dart';
import 'package:buildrank_mobile/features/auth/data/token_storage.dart';
import 'package:buildrank_mobile/features/verification/data/admin_verification_service.dart';
import 'package:http/http.dart' as http;

class AddExistingBuildingService {
  const AddExistingBuildingService();

  Future<Map<String, String>> _buildHeaders() async {
    final token = await TokenStorage.getAccessToken();

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<ExistingBuildingItem>> searchBuildings(String query) async {
    final trimmed = query.trim();

    if (trimmed.length < 3) {
      return const [];
    }

    final uri = ApiConfig.searchExistingBuildings(trimmed);

    try {
      final response = await http
          .get(uri, headers: await _buildHeaders())
          .timeout(const Duration(seconds: 10));

      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode != 200) {
        throw AddExistingBuildingApiException(
          'No s’han pogut cercar edificis.',
          statusCode: response.statusCode,
          details: decoded,
        );
      }

      if (decoded is! List) {
        throw const AddExistingBuildingApiException(
          'La resposta de cerca d’edificis no té el format esperat.',
        );
      }

      return decoded
          .whereType<Map>()
          .map(
            (item) =>
                ExistingBuildingItem.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    } on TimeoutException {
      throw const AddExistingBuildingApiException(
        'La cerca d’edificis ha trigat massa. Torna-ho a provar.',
      );
    } on SocketException {
      throw const AddExistingBuildingApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } on FormatException {
      throw const AddExistingBuildingApiException(
        'La resposta del servidor no té el format esperat.',
      );
    } on AddExistingBuildingApiException {
      rethrow;
    } catch (_) {
      throw const AddExistingBuildingApiException(
        'S’ha produït un error inesperat cercant edificis.',
      );
    }
  }

  Future<void> createJoinRequest({
    required ExistingBuildingItem building,
    required String userRole,
    required Map<String, dynamic> habitatgePayload,
    List<AdminVerificationDocumentInput> verificationDocuments = const [],
  }) async {
    if (userRole == 'admin') {
      await const AdminVerificationService().createVerification(
        idEdifici: building.id,
        documents: verificationDocuments,
      );
      return;
    }

    await _createResidentJoinRequest(
      building: building,
      userRole: userRole,
      habitatgePayload: habitatgePayload,
    );
  }

  Future<void> _createResidentJoinRequest({
    required ExistingBuildingItem building,
    required String userRole,
    required Map<String, dynamic> habitatgePayload,
  }) async {
    final referencia =
        _readString(
          habitatgePayload['referenciaCadastral'] ??
              habitatgePayload['referencia_cadastral'],
        ) ??
        '';

    if (referencia.isEmpty) {
      throw const AddExistingBuildingApiException(
        'La referència cadastral és obligatòria.',
      );
    }

    final normalizedRole = userRole.toLowerCase().trim();
    final isTenant =
        normalizedRole == 'tenant' ||
        normalizedRole == 'llogater' ||
        normalizedRole == 'resident';
    final isOwner = normalizedRole == 'owner' || normalizedRole == 'propietari';

    if (isTenant) {
      try {
        await _postJson(
          Uri.parse(ApiConfig.habitatgeSolicitarAcces(referencia)),
          const {},
        );
        return;
      } on AddExistingBuildingApiException catch (e) {
        if (e.statusCode == 404) {
          throw const AddExistingBuildingApiException(
            'No s’ha trobat cap habitatge amb aquesta referència cadastral. Revisa-la o demana al propietari que registri primer l’habitatge.',
          );
        }
        rethrow;
      }
    }

    if (!isOwner) {
      throw const AddExistingBuildingApiException(
        'Aquest rol no pot sol·licitar la vinculació a un habitatge.',
      );
    }

    final planta = _readString(habitatgePayload['planta']) ?? '';
    final porta = _readString(habitatgePayload['porta']) ?? '';
    final superficie = _readDouble(habitatgePayload['superficie']);

    if (planta.isEmpty || porta.isEmpty) {
      throw const AddExistingBuildingApiException(
        'La planta i la porta són obligatòries.',
      );
    }

    if (superficie == null || superficie <= 0) {
      throw const AddExistingBuildingApiException(
        'La superfície ha de ser un número superior a 0.',
      );
    }

    final payload = {
      'referenciaCadastral': referencia,
      'edifici': building.id,
      'planta': planta,
      'porta': porta,
      'superficie': superficie,
    };

    try {
      await _postJson(Uri.parse(ApiConfig.habitatges), payload);
    } on AddExistingBuildingApiException catch (e) {
      if (e.statusCode == 400 && _looksLikeDuplicateReference(e.details)) {
        await _postJson(
          Uri.parse(ApiConfig.habitatgeSolicitarAcces(referencia)),
          const {},
        );
        return;
      }

      rethrow;
    }
  }

  Future<dynamic> _postJson(Uri uri, Map<String, dynamic> payload) async {
    try {
      final response = await http
          .post(uri, headers: await _buildHeaders(), body: jsonEncode(payload))
          .timeout(const Duration(seconds: 10));

      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw AddExistingBuildingApiException(
          'No s’ha pogut enviar la sol·licitud.',
          statusCode: response.statusCode,
          details: decoded,
        );
      }

      return decoded;
    } on TimeoutException {
      throw const AddExistingBuildingApiException(
        'L’enviament de la sol·licitud ha trigat massa.',
      );
    } on SocketException {
      throw const AddExistingBuildingApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } on FormatException {
      throw const AddExistingBuildingApiException(
        'La resposta del servidor no té el format esperat.',
      );
    } on AddExistingBuildingApiException {
      rethrow;
    } catch (_) {
      throw const AddExistingBuildingApiException(
        'S’ha produït un error inesperat enviant la sol·licitud.',
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

  bool _looksLikeDuplicateReference(dynamic details) {
    final text = details.toString().toLowerCase();

    return text.contains('referencia') &&
        (text.contains('existeix') ||
            text.contains('already exists') ||
            text.contains('unique'));
  }
}

class ExistingBuildingItem {
  final int id;
  final String name;
  final String address;
  final String? city;
  final bool acceptsNewRequests;
  final bool isBlock;

  final String? carrer;
  final int? numero;
  final String? codiPostal;
  final int? anyConstruccio;

  const ExistingBuildingItem({
    required this.id,
    required this.name,
    required this.address,
    this.city,
    this.acceptsNewRequests = true,
    this.isBlock = true,
    this.carrer,
    this.numero,
    this.codiPostal,
    this.anyConstruccio,
  });

  factory ExistingBuildingItem.fromJson(Map<String, dynamic> json) {
    final localitzacioRaw = json['localitzacio'];
    final localitzacio = localitzacioRaw is Map
        ? Map<String, dynamic>.from(localitzacioRaw)
        : <String, dynamic>{};

    final id = _readInt(json['idEdifici'] ?? json['id']) ?? 0;
    final carrer = _readString(localitzacio['carrer']);
    final numero = _readInt(localitzacio['numero']);
    final codiPostal = _readString(localitzacio['codiPostal']);
    final barri = _readString(localitzacio['barri']);
    final anyConstruccio = _readInt(json['anyConstruccio']);

    final addressParts = [?carrer, ?numero?.toString()];
    final cityParts = [?barri, ?codiPostal];

    final displayAddress = addressParts.isEmpty
        ? 'Adreça no disponible'
        : addressParts.join(', ');

    return ExistingBuildingItem(
      id: id,
      name: displayAddress,
      address: displayAddress,
      city: cityParts.isEmpty ? 'Barcelona' : cityParts.join(' · '),
      acceptsNewRequests: true,
      isBlock: true,
      carrer: carrer,
      numero: numero,
      codiPostal: codiPostal,
      anyConstruccio: anyConstruccio,
    );
  }
}

class AddExistingBuildingApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const AddExistingBuildingApiException(
    this.message, {
    this.statusCode,
    this.details,
  });

  @override
  String toString() {
    if (details == null) return message;
    return '$message Detall: $details';
  }
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
    final normalized = value.trim();
    return int.tryParse(normalized) ?? double.tryParse(normalized)?.round();
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
