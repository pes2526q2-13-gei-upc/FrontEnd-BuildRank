import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:buildrank_mobile/core/config/api_config.dart';
import 'package:buildrank_mobile/core/services/api_client.dart';
import 'package:http/http.dart' as http;

class BuildingService {
  Future<List<Map<String, dynamic>>> getMyBuildings() async {
    try {
      final response = await ApiClient.get(Uri.parse(ApiConfig.meEdificis));

      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode != 200) {
        throw BuildingApiException(
          _extractErrorMessage(
            decoded,
            fallback: 'No s’han pogut carregar els edificis vinculats.',
          ),
          statusCode: response.statusCode,
          details: decoded,
        );
      }

      if (decoded is! List) {
        throw const BuildingApiException(
          'La resposta d’edificis no té el format esperat.',
        );
      }

      return decoded
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } on BuildingApiException {
      rethrow;
    } on TimeoutException {
      throw const BuildingApiException(
        'La càrrega d’edificis ha trigat massa. Torna-ho a provar.',
      );
    } on SocketException {
      throw const BuildingApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } on FormatException {
      throw const BuildingApiException(
        'La resposta del servidor no té el format esperat.',
      );
    } catch (_) {
      throw const BuildingApiException(
        'S’ha produït un error inesperat carregant els edificis.',
      );
    }
  }

  Future<Map<String, dynamic>> getBuildingDetail(int idEdifici) async {
    try {
      final response = await ApiClient.get(
        ApiConfig.uri(ApiConfig.edificiDetail(idEdifici)),
      );

      final data = _decodeBody(response);

      if (response.statusCode == 200) {
        return data;
      }

      throw BuildingApiException(
        _extractErrorMessage(
          data,
          fallback: 'No s’ha pogut carregar el detall de l’edifici.',
        ),
        statusCode: response.statusCode,
        details: data,
      );
    } on BuildingApiException {
      rethrow;
    } on TimeoutException {
      throw const BuildingApiException(
        'La càrrega del detall de l’edifici ha trigat massa.',
      );
    } on SocketException {
      throw const BuildingApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } on FormatException {
      throw const BuildingApiException(
        'La resposta del servidor no té el format esperat.',
      );
    } catch (_) {
      throw const BuildingApiException(
        'S’ha produït un error inesperat carregant l’edifici.',
      );
    }
  }

  Future<BuildingBadgesResponse> getBuildingBadges(int idEdifici) async {
    try {
      final response = await ApiClient.get(
        ApiConfig.uri(ApiConfig.edificiBadges(idEdifici)),
      );

      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode == 200) {
        return BuildingBadgesResponse.fromDecoded(decoded);
      }

      throw BuildingApiException(
        _extractErrorMessage(
          decoded,
          fallback: 'No s’han pogut carregar les insígnies de l’edifici.',
        ),
        statusCode: response.statusCode,
        details: decoded,
      );
    } on BuildingApiException {
      rethrow;
    } on TimeoutException {
      throw const BuildingApiException(
        'La càrrega d’insígnies ha trigat massa. Torna-ho a provar.',
      );
    } on SocketException {
      throw const BuildingApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } on FormatException {
      throw const BuildingApiException(
        'La resposta d’insígnies no té el format esperat.',
      );
    } catch (_) {
      throw const BuildingApiException(
        'S’ha produït un error inesperat carregant les insígnies.',
      );
    }
  }

  Future<BuildingBadgesResponse> recalculateBuildingBadges(
    int idEdifici,
  ) async {
    try {
      final response = await ApiClient.post(
        ApiConfig.uri(ApiConfig.edificiBadgesRecalcular(idEdifici)),
      );

      final decoded = _tryDecodeBody(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return BuildingBadgesResponse.fromDecoded(decoded);
      }

      throw BuildingApiException(
        _extractErrorMessage(
          decoded,
          fallback: 'No s’han pogut recalcular les insígnies de l’edifici.',
        ),
        statusCode: response.statusCode,
        details: decoded,
      );
    } on BuildingApiException {
      rethrow;
    } on TimeoutException {
      throw const BuildingApiException(
        'El recalcul d’insígnies ha trigat massa. Torna-ho a provar.',
      );
    } on SocketException {
      throw const BuildingApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } on FormatException {
      throw const BuildingApiException(
        'La resposta del recalcul no té el format esperat.',
      );
    } catch (_) {
      throw const BuildingApiException(
        'S’ha produït un error inesperat recalculant les insígnies.',
      );
    }
  }

  Future<List<Map<String, dynamic>>> autocompleteCarrers(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.length < 2) {
      return [];
    }

    final uri = ApiConfig.uri(
      ApiConfig.carrersAutocomplete,
      queryParameters: {'q': trimmedQuery},
    );

    try {
      if (kDebugMode) {
        debugPrint('[BuildingService] GET $uri');
      }

      final response = await ApiClient.get(uri);

      if (kDebugMode) {
        debugPrint('[BuildingService] Status: ${response.statusCode}');
        debugPrint('[BuildingService] Body: ${response.body}');
      }

      if (response.statusCode != 200) {
        final decoded = _tryDecodeBody(response.body);

        throw BuildingApiException(
          _extractErrorMessage(
            decoded,
            fallback:
                'No s’han pogut carregar els suggeriments de carrers. Codi ${response.statusCode}.',
          ),
          statusCode: response.statusCode,
          details: decoded,
        );
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! List) {
        throw const BuildingApiException(
          'La resposta del cercador de carrers no és una llista.',
        );
      }

      return decoded
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } on BuildingApiException {
      rethrow;
    } on TimeoutException {
      throw const BuildingApiException(
        'La consulta de carrers ha trigat massa. Torna-ho a provar.',
      );
    } on SocketException {
      throw const BuildingApiException(
        'No s’ha pogut connectar amb el servidor. Revisa la IP configurada al frontend.',
      );
    } on FormatException {
      throw const BuildingApiException(
        'La resposta del servidor no té format JSON vàlid.',
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[BuildingService] Error autocompleteCarrers: $e');
      }

      throw const BuildingApiException(
        'S’ha produït un error inesperat carregant els carrers.',
      );
    }
  }

  Future<Map<String, dynamic>> createLocalitzacio(
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await ApiClient.post(
        ApiConfig.uri(ApiConfig.localitzacions),
        body: jsonEncode(payload),
      );

      final data = _decodeBody(response);

      if (response.statusCode == 201) {
        return data;
      }

      throw BuildingApiException(
        _extractErrorMessage(
          data,
          fallback: 'No s\'ha pogut crear la localització.',
        ),
        statusCode: response.statusCode,
        details: data,
      );
    } on BuildingApiException {
      rethrow;
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
        'S\'ha produït un error inesperat creant la localització.',
      );
    }
  }

  Future<Map<String, dynamic>> createEdifici(
    Map<String, dynamic> payload,
  ) async {
    try {
      final response = await ApiClient.post(
        ApiConfig.uri(ApiConfig.crearEdifici),
        body: jsonEncode(payload),
      );

      final data = _decodeBody(response);

      if (response.statusCode == 201) {
        return data;
      }

      throw BuildingApiException(
        _extractErrorMessage(
          data,
          fallback: 'No s\'ha pogut crear l\'edifici.',
        ),
        statusCode: response.statusCode,
        details: data,
      );
    } on BuildingApiException {
      rethrow;
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
        'S\'ha produït un error inesperat creant l\'edifici.',
      );
    }
  }

  Future<Map<String, dynamic>> createBuildingWithLocation({
    required Map<String, dynamic> localitzacioPayload,
    required Map<String, dynamic> edificiPayload,
  }) async {
    final localitzacio = await createLocalitzacio(localitzacioPayload);

    final localitzacioId = _extractId(localitzacio);
    if (localitzacioId == null) {
      throw const BuildingApiException(
        'La localització s’ha creat però la resposta no conté cap id reconeixible.',
      );
    }

    final payloadAmbLocalitzacio = {
      ...edificiPayload,

      // Camp nou i explícit acceptat pel serializer backend.
      'localitzacioId': localitzacioId,

      // Camp mantingut temporalment per compatibilitat si alguna branca antiga
      // del backend encara el feia servir. Si el serializer no l'utilitza, s'ignora.
      'localitzacio': localitzacioId,
    };

    return createEdifici(payloadAmbLocalitzacio);
  }

  Map<String, dynamic> _decodeBody(http.Response response) {
    if (response.body.isEmpty) return {};

    final decoded = jsonDecode(response.body);

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    return {'data': decoded};
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

      if (firstEntry.value is List && (firstEntry.value as List).isNotEmpty) {
        return (firstEntry.value as List).first.toString();
      }

      return firstEntry.value.toString();
    }

    return data.toString();
  }

  int? _extractId(Map<String, dynamic> json) {
    const possibleKeys = ['id', 'idLocalitzacio', 'pk'];

    for (final key in possibleKeys) {
      final value = json[key];
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
    }

    return null;
  }
}

class BuildingBadgesResponse {
  final List<BuildingBadgeItem> badges;
  final List<BuildingBadgeItem> summary;
  final int total;

  const BuildingBadgesResponse({
    required this.badges,
    required this.summary,
    required this.total,
  });

  factory BuildingBadgesResponse.fromDecoded(dynamic decoded) {
    if (decoded is List) {
      final badges = decoded
          .whereType<Map>()
          .map(BuildingBadgeItem.fromJson)
          .where((badge) => badge.name.isNotEmpty)
          .toList();

      return BuildingBadgesResponse(
        badges: badges,
        summary: badges.take(3).toList(),
        total: badges.length,
      );
    }

    if (decoded is Map) {
      final map = Map<String, dynamic>.from(decoded);

      final badgesRaw =
          map['badges'] ?? map['results'] ?? map['data'] ?? map['items'];

      final summaryRaw = map['summary'];

      final badges = badgesRaw is List
          ? badgesRaw
                .whereType<Map>()
                .map(BuildingBadgeItem.fromJson)
                .where((badge) => badge.name.isNotEmpty)
                .toList()
          : <BuildingBadgeItem>[];

      final summary = summaryRaw is List
          ? summaryRaw
                .whereType<Map>()
                .map(BuildingBadgeItem.fromJson)
                .where((badge) => badge.name.isNotEmpty)
                .toList()
          : badges.take(3).toList();

      return BuildingBadgesResponse(
        badges: badges,
        summary: summary,
        total: _badgeReadInt(map['total']) ?? badges.length,
      );
    }

    return const BuildingBadgesResponse(badges: [], summary: [], total: 0);
  }
}

class BuildingBadgeItem {
  final String code;
  final String name;
  final String description;
  final String category;
  final String scope;
  final String? season;
  final String? awardedAt;

  const BuildingBadgeItem({
    required this.code,
    required this.name,
    required this.description,
    required this.category,
    required this.scope,
    required this.season,
    required this.awardedAt,
  });

  factory BuildingBadgeItem.fromJson(Map<dynamic, dynamic> json) {
    final map = Map<String, dynamic>.from(json);
    final seasonRaw = map['temporada'] ?? map['season'];

    return BuildingBadgeItem(
      code: _badgeReadString(map['code']) ?? '',
      name:
          _badgeReadString(map['nom']) ??
          _badgeReadString(map['label']) ??
          _badgeReadString(map['name']) ??
          _badgeReadString(map['titol']) ??
          _badgeReadString(map['title']) ??
          '',
      description:
          _badgeReadString(map['descripcio']) ??
          _badgeReadString(map['description']) ??
          '',
      category: _badgeReadString(map['categoria']) ?? '',
      scope: _badgeReadString(map['scope']) ?? '',
      season: _badgeReadSeason(seasonRaw),
      awardedAt:
          _badgeReadString(map['awarded_at']) ??
          _badgeReadString(map['awardedAt']) ??
          _badgeReadString(map['data_assignacio']),
    );
  }

  String get categoryLabel {
    final value = category.trim();
    if (value.isEmpty) return 'General';

    switch (value.toLowerCase()) {
      case 'bhs':
        return 'BHS';
      case 'emissions':
        return 'Emissions';
      case 'dades':
        return 'Dades';
      case 'millores':
        return 'Millores';
      case 'progres':
      case 'progrés':
        return 'Progrés';
      case 'ranking':
        return 'Rànquing';
      default:
        return value;
    }
  }

  String get scopeLabel {
    final value = scope.trim().toLowerCase();

    if (value == 'seasonal' || value == 'temporada') {
      return 'Temporada';
    }

    if (value == 'permanent') {
      return 'Permanent';
    }

    return scope.trim().isEmpty ? 'General' : scope.trim();
  }

  String get subtitle {
    final parts = [
      categoryLabel,
      scopeLabel,
      if (season != null && season!.isNotEmpty) season!,
    ];

    return parts.where((part) => part.trim().isNotEmpty).join(' · ');
  }

  String get awardedText {
    final value = awardedAt?.trim();

    if (value == null || value.isEmpty) {
      return scopeLabel;
    }

    if (value.length >= 10) {
      return value.substring(0, 10);
    }

    return value;
  }
}

String? _badgeReadSeason(dynamic value) {
  if (value == null) return null;

  if (value is Map) {
    final map = Map<String, dynamic>.from(value);

    return _badgeReadString(map['nom']) ??
        _badgeReadString(map['name']) ??
        _badgeReadString(map['titol']) ??
        _badgeReadString(map['title']) ??
        _badgeReadString(map['id']);
  }

  return _badgeReadString(value);
}

String? _badgeReadString(dynamic value) {
  final text = value?.toString().trim();
  if (text == null || text.isEmpty || text == 'null') return null;
  return text;
}

int? _badgeReadInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.round();
  if (value is String) return int.tryParse(value);
  return null;
}

class BuildingApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const BuildingApiException(this.message, {this.statusCode, this.details});

  @override
  String toString() => message;
}
