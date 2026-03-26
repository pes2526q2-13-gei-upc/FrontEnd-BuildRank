import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class BuildingService {
  final String baseUrl;
  final Future<String?> Function()? getAccessToken;

  BuildingService({required this.baseUrl, this.getAccessToken});

  Future<Map<String, String>> _buildHeaders() async {
    final token = await getAccessToken?.call();

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Uri _buildUri(String path, [Map<String, dynamic>? queryParameters]) {
    final normalizedBase = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;

    final normalizedPath = path.startsWith('/') ? path : '/$path';

    return Uri.parse('$normalizedBase$normalizedPath').replace(
      queryParameters: queryParameters?.map(
        (key, value) => MapEntry(key, value?.toString()),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> autocompleteCarrers(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) return [];

    final uri = _buildUri('/api/buildings/carrers/autocomplete/', {
      'q': trimmedQuery,
    });

    try {
      final response = await http
          .get(uri, headers: await _buildHeaders())
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw BuildingApiException(
          'No s\'han pogut carregar els suggeriments de carrers.',
          statusCode: response.statusCode,
          details: _tryDecodeBody(response.body),
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! List) return [];

      return decoded
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } on TimeoutException {
      throw const BuildingApiException(
        'La consulta de carrers ha trigat massa. Torna-ho a provar.',
      );
    } on SocketException {
      throw const BuildingApiException(
        'No s\'ha pogut connectar amb el servidor.',
      );
    } on FormatException {
      throw const BuildingApiException(
        'La resposta del servidor no té el format esperat.',
      );
    } catch (_) {
      throw const BuildingApiException(
        'S\'ha produït un error inesperat carregant els carrers.',
      );
    }
  }

  Future<Map<String, dynamic>> createLocalitzacio(
    Map<String, dynamic> payload,
  ) async {
    final uri = _buildUri('/api/buildings/localitzacions/');

    final response = await http.post(
      uri,
      headers: await _buildHeaders(),
      body: jsonEncode(payload),
    );

    if (response.statusCode != 201) {
      throw BuildingApiException(
        'No s\'ha pogut crear la localització.',
        statusCode: response.statusCode,
        details: _tryDecodeBody(response.body),
      );
    }

    final decoded = jsonDecode(response.body);
    return Map<String, dynamic>.from(decoded as Map);
  }

  Future<Map<String, dynamic>> createEdifici(
    Map<String, dynamic> payload,
  ) async {
    final uri = _buildUri('/api/buildings/edificis/crear/');

    final response = await http.post(
      uri,
      headers: await _buildHeaders(),
      body: jsonEncode(payload),
    );

    if (response.statusCode != 201) {
      throw BuildingApiException(
        'No s\'ha pogut crear l\'edifici.',
        statusCode: response.statusCode,
        details: _tryDecodeBody(response.body),
      );
    }

    final decoded = jsonDecode(response.body);
    return Map<String, dynamic>.from(decoded as Map);
  }

  Future<Map<String, dynamic>> createBuildingWithLocation({
    required Map<String, dynamic> localitzacioPayload,
    required Map<String, dynamic> edificiPayload,
  }) async {
    final localitzacio = await createLocalitzacio(localitzacioPayload);

    final localitzacioId = _extractId(localitzacio);
    if (localitzacioId == null) {
      throw const BuildingApiException(
        'La localització s\'ha creat però la resposta no conté cap id reconeixible.',
      );
    }

    final payloadAmbLocalitzacio = {
      ...edificiPayload,
      'localitzacio': localitzacioId,
    };

    return createEdifici(payloadAmbLocalitzacio);
  }

  int? _extractId(Map<String, dynamic> json) {
    final possibleKeys = ['id', 'idLocalitzacio', 'pk'];

    for (final key in possibleKeys) {
      final value = json[key];
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
    }

    return null;
  }

  dynamic _tryDecodeBody(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
    }
  }
}

class BuildingApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const BuildingApiException(this.message, {this.statusCode, this.details});

  @override
  String toString() {
    if (details == null) return message;
    return '$message Detall: $details';
  }
}
