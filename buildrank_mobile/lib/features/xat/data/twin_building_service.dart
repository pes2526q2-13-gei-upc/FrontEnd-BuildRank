import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:buildrank_mobile/core/config/api_config.dart';
import 'package:buildrank_mobile/features/auth/data/token_storage.dart';
import 'package:buildrank_mobile/features/xat/data/twin_building_model.dart';
import 'package:http/http.dart' as http;

class TwinBuildingService {
  Future<Map<String, String>> _headers() async {
    final accessToken = await TokenStorage.getAccessToken();

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (accessToken != null && accessToken.isNotEmpty)
        'Authorization': 'Bearer $accessToken',
    };
  }

  Future<List<TwinBuildingAdminCandidate>> getCandidates(int idEdifici) async {
    try {
      final response = await http
          .get(
            ApiConfig.uri(ApiConfig.twinBuildingAdmins(idEdifici)),
            headers: await _headers(),
          )
          .timeout(const Duration(seconds: 10));

      final decoded = _decode(response.body);

      if (response.statusCode != 200) {
        throw TwinBuildingApiException(
          _extractError(
            decoded,
            'No s’han pogut carregar edificis comparables.',
          ),
          statusCode: response.statusCode,
        );
      }

      final results = decoded is Map ? decoded['results'] : null;
      if (results is! List) {
        throw const TwinBuildingApiException(
          'La resposta de Twin Building no té el format esperat.',
        );
      }

      return results
          .whereType<Map>()
          .map(
            (item) => TwinBuildingAdminCandidate.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    } on TwinBuildingApiException {
      rethrow;
    } on TimeoutException {
      throw const TwinBuildingApiException('La càrrega ha trigat massa.');
    } on SocketException {
      throw const TwinBuildingApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    }
  }

  Future<TwinBuildingChannelResult> createChannel({
    required int idEdifici,
    required int targetEdificiId,
  }) async {
    try {
      final response = await http
          .post(
            ApiConfig.uri(ApiConfig.twinBuildingChannel(idEdifici)),
            headers: await _headers(),
            body: jsonEncode({'target_edifici_id': targetEdificiId}),
          )
          .timeout(const Duration(seconds: 12));

      final decoded = _decode(response.body);

      if (response.statusCode != 200) {
        throw TwinBuildingApiException(
          _extractError(decoded, 'No s’ha pogut crear el xat Twin Building.'),
          statusCode: response.statusCode,
        );
      }

      if (decoded is! Map) {
        throw const TwinBuildingApiException(
          'La resposta del canal no té el format esperat.',
        );
      }

      return TwinBuildingChannelResult.fromJson(
        Map<String, dynamic>.from(decoded),
      );
    } on TwinBuildingApiException {
      rethrow;
    } on TimeoutException {
      throw const TwinBuildingApiException(
        'La creació del xat ha trigat massa.',
      );
    } on SocketException {
      throw const TwinBuildingApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    }
  }

  dynamic _decode(String body) {
    if (body.isEmpty) return {};
    return jsonDecode(body);
  }

  String _extractError(dynamic decoded, String fallback) {
    if (decoded is Map<String, dynamic>) {
      if (decoded['detail'] != null) return decoded['detail'].toString();
      if (decoded.entries.isNotEmpty) {
        final value = decoded.entries.first.value;
        if (value is List && value.isNotEmpty) return value.first.toString();
        return value.toString();
      }
    }
    if (decoded is String && decoded.trim().isNotEmpty) return decoded;
    return fallback;
  }
}

class TwinBuildingApiException implements Exception {
  final String message;
  final int? statusCode;

  const TwinBuildingApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
