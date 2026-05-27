import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:buildrank_mobile/core/config/api_config.dart';
import 'package:buildrank_mobile/core/services/api_client.dart';
import 'package:buildrank_mobile/features/map/data/building_map_feature_model.dart';

class BuildingMapService {
  const BuildingMapService();

  Future<BuildingMapResponse> getBuildingsForMap({
    String scope = 'public',
    String? search,
    double? scoreMin,
    int limit = 500,
  }) async {
    final cleanSearch = search?.trim();

    final queryParameters = <String, dynamic>{
      'scope': scope,
      'limit': limit,
      if (cleanSearch != null && cleanSearch.isNotEmpty) 'q': cleanSearch,
      if (scoreMin != null) 'score_min': scoreMin.round(),
    };

    final uri = ApiConfig.uri(
      ApiConfig.edificisMapa,
      queryParameters: queryParameters,
    );

    try {
      final response = await ApiClient.get(
        uri,
        timeout: const Duration(seconds: 12),
      );

      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw BuildingMapApiException(
          _extractErrorMessage(
            decoded,
            fallback: 'No s’ha pogut carregar el mapa d’edificis.',
          ),
          statusCode: response.statusCode,
          details: decoded,
        );
      }

      if (decoded is! Map) {
        throw const BuildingMapApiException(
          'La resposta del mapa no té el format esperat.',
        );
      }

      return BuildingMapResponse.fromJson(Map<String, dynamic>.from(decoded));
    } on BuildingMapApiException {
      rethrow;
    } on TimeoutException {
      throw const BuildingMapApiException(
        'La càrrega del mapa ha trigat massa. Torna-ho a provar.',
      );
    } on SocketException {
      throw const BuildingMapApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } on FormatException {
      throw const BuildingMapApiException(
        'La resposta del servidor no té format JSON vàlid.',
      );
    } catch (_) {
      throw const BuildingMapApiException(
        'S’ha produït un error inesperat carregant el mapa.',
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

    if (data is Map<String, dynamic>) {
      if (data.isEmpty) return fallback;

      if (data['detail'] != null) {
        return data['detail'].toString();
      }

      final firstEntry = data.entries.first;
      final value = firstEntry.value;

      if (value is List && value.isNotEmpty) {
        return value.first.toString();
      }

      return value.toString();
    }

    return data.toString();
  }
}

class BuildingMapApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const BuildingMapApiException(this.message, {this.statusCode, this.details});

  @override
  String toString() => message;
}
