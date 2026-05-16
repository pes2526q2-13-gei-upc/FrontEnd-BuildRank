import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:buildrank_mobile/core/config/api_config.dart';
import 'package:buildrank_mobile/features/auth/data/token_storage.dart';
import 'package:http/http.dart' as http;

class PendingBuildingRequestsService {
  const PendingBuildingRequestsService();

  Future<Map<String, String>> _buildHeaders() async {
    final token = await TokenStorage.getAccessToken();

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<PendingBuildingRequestItem>> getPendingRequests({
    required int idEdifici,
  }) async {
    final uri = Uri.parse(ApiConfig.habitatgesPendents);

    try {
      final response = await http
          .get(uri, headers: await _buildHeaders())
          .timeout(const Duration(seconds: 10));

      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode != 200) {
        throw PendingBuildingRequestsApiException(
          'No s’han pogut carregar les sol·licituds pendents.',
          statusCode: response.statusCode,
          details: decoded,
        );
      }

      if (decoded is! List) {
        throw const PendingBuildingRequestsApiException(
          'La resposta de sol·licituds pendents no té el format esperat.',
        );
      }

      return decoded
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .where((item) => _readBuildingId(item['edifici']) == idEdifici)
          .map(PendingBuildingRequestItem.fromJson)
          .toList();
    } on TimeoutException {
      throw const PendingBuildingRequestsApiException(
        'La consulta de sol·licituds ha trigat massa.',
      );
    } on SocketException {
      throw const PendingBuildingRequestsApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } on FormatException {
      throw const PendingBuildingRequestsApiException(
        'La resposta del servidor no té el format esperat.',
      );
    } on PendingBuildingRequestsApiException {
      rethrow;
    } catch (_) {
      throw const PendingBuildingRequestsApiException(
        'S’ha produït un error inesperat carregant les sol·licituds.',
      );
    }
  }

  Future<void> validateRequest({
    required String referenciaCadastral,
    required bool accepted,
  }) async {
    final uri = Uri.parse(ApiConfig.habitatgeValidarAcces(referenciaCadastral));

    final payload = {'estat': accepted ? 'Validada' : 'Rebutjada'};

    try {
      final response = await http
          .post(uri, headers: await _buildHeaders(), body: jsonEncode(payload))
          .timeout(const Duration(seconds: 10));

      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw PendingBuildingRequestsApiException(
          accepted
              ? 'No s’ha pogut acceptar la sol·licitud.'
              : 'No s’ha pogut rebutjar la sol·licitud.',
          statusCode: response.statusCode,
          details: decoded,
        );
      }
    } on TimeoutException {
      throw const PendingBuildingRequestsApiException(
        'L’operació ha trigat massa.',
      );
    } on SocketException {
      throw const PendingBuildingRequestsApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } on PendingBuildingRequestsApiException {
      rethrow;
    } catch (_) {
      throw const PendingBuildingRequestsApiException(
        'S’ha produït un error inesperat validant la sol·licitud.',
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

  static int? _readBuildingId(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    if (value is Map) {
      return _readBuildingId(value['idEdifici'] ?? value['id']);
    }
    return null;
  }
}

class PendingBuildingRequestItem {
  final int id;
  final String requesterName;
  final String requesterEmail;
  final String refCadastral;
  final String? planta;
  final String? porta;
  final double? superficie;
  final DateTime submittedAt;

  const PendingBuildingRequestItem({
    required this.id,
    required this.requesterName,
    required this.requesterEmail,
    required this.refCadastral,
    required this.planta,
    required this.porta,
    required this.superficie,
    required this.submittedAt,
  });

  factory PendingBuildingRequestItem.fromJson(Map<String, dynamic> json) {
    final refCadastral = _readString(json['referenciaCadastral']) ?? '';
    final requesterId = _readInt(json['solicitant']);

    return PendingBuildingRequestItem(
      id: _readInt(json['id']) ?? refCadastral.hashCode,
      requesterName:
          _readString(json['solicitantNom']) ??
          _readString(json['solicitant_name']) ??
          _readString(json['requesterName']) ??
          (requesterId != null ? 'Usuari #$requesterId' : 'Usuari pendent'),
      requesterEmail:
          _readString(json['solicitantEmail']) ??
          _readString(json['solicitant_email']) ??
          _readString(json['requesterEmail']) ??
          'Correu no disponible',
      refCadastral: refCadastral,
      planta: _readString(json['planta']),
      porta: _readString(json['porta']),
      superficie: _readDouble(json['superficie']),
      submittedAt:
          DateTime.tryParse(
            _readString(json['created_at']) ??
                _readString(json['dataSolicitud']) ??
                '',
          ) ??
          DateTime.now(),
    );
  }

  static String? _readString(dynamic value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static int? _readInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) return int.tryParse(value.trim());
    return null;
  }

  static double? _readDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value.replaceAll(',', '.').trim());
    }
    return null;
  }
}

class PendingBuildingRequestsApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const PendingBuildingRequestsApiException(
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
