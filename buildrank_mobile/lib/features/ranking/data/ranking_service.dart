import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:buildrank_mobile/core/config/api_config.dart';
import 'package:buildrank_mobile/features/auth/data/token_storage.dart';
import 'package:buildrank_mobile/features/ranking/data/ranking_model.dart';
import 'package:http/http.dart' as http;

class RankingService {
  final bool useMockData;

  const RankingService({this.useMockData = false});

  Future<Map<String, String>> _buildHeaders() async {
    final token = await TokenStorage.getAccessToken();

    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  Future<RankingResponse> getRanking({
    required int idEdifici,
    required String buildingName,
    required int currentPoints,
    required RankingScope scope,
    String? search,
    int page = 1,
    int targetTop = 3,
  }) async {
    if (useMockData) {
      return _getMockRanking(
        idEdifici: idEdifici,
        buildingName: buildingName,
        currentPoints: currentPoints,
        scope: scope,
        search: search,
        page: page,
        targetTop: targetTop,
      );
    }

    try {
      final context = await _loadRankingContext(idEdifici: idEdifici);

      final positionJson = await _getJson(
        ApiConfig.buildingPosition(
          leagueId: context.leagueId,
          buildingId: idEdifici,
          top: targetTop,
          segment: scope == RankingScope.comparable,
        ),
      );

      final positionData = Map<String, dynamic>.from(positionJson);
      final groupId = _readInt(positionData['grup_utilitzat']);

      final rankingJson = await _getJson(
        ApiConfig.leagueRanking(
          leagueId: context.leagueId,
          groupId: scope == RankingScope.comparable ? groupId : null,
          page: page,
          pageSize: 10,
          search: search,
        ),
      );

      final summary = _buildSummary(
        context: context,
        positionData: positionData,
        fallbackPoints: currentPoints,
        scope: scope,
      );

      return RankingResponse.fromJson(
        Map<String, dynamic>.from(rankingJson),
        currentBuildingId: idEdifici,
        summaryOverride: summary,
        pageOverride: page,
      );
    } on TimeoutException {
      throw const RankingApiException(
        'La consulta del rànquing ha trigat massa. Torna-ho a provar.',
      );
    } on SocketException {
      throw const RankingApiException(
        'No s’ha pogut connectar amb el servidor.',
      );
    } on FormatException {
      throw const RankingApiException(
        'La resposta del servidor no té el format esperat.',
      );
    } on RankingApiException {
      rethrow;
    } catch (_) {
      throw const RankingApiException(
        'S’ha produït un error inesperat carregant el rànquing.',
      );
    }
  }

  Future<_RankingContext> _loadRankingContext({required int idEdifici}) async {
    final seasonsJson = await _getJson(Uri.parse(ApiConfig.seasons));
    final leaguesJson = await _getJson(Uri.parse(ApiConfig.leagues));
    final participationsJson = await _getJson(
      Uri.parse(ApiConfig.participations),
    );

    final seasons = _extractList(seasonsJson);
    final leagues = _extractList(leaguesJson);
    final participations = _extractList(participationsJson);

    Map<String, dynamic>? activeSeason;

    for (final season in seasons) {
      if (season['activa'] == true) {
        activeSeason = season;
        break;
      }
    }

    activeSeason ??= seasons.isNotEmpty ? seasons.first : null;

    if (activeSeason == null) {
      throw const RankingApiException('No hi ha cap temporada disponible.');
    }

    final activeSeasonId = _readInt(
      activeSeason['id_temporada'] ?? activeSeason['id'],
    );

    if (activeSeasonId == null) {
      throw const RankingApiException(
        'La temporada activa no té identificador.',
      );
    }

    final leaguesById = <int, Map<String, dynamic>>{};
    final activeLeagueIds = <int>{};

    for (final league in leagues) {
      final id = _readInt(league['id']);
      if (id == null) continue;

      leaguesById[id] = league;

      final seasonId = _readInt(league['temporada']);
      if (seasonId == activeSeasonId) {
        activeLeagueIds.add(id);
      }
    }

    Map<String, dynamic>? selectedParticipation;

    for (final participation in participations) {
      final buildingId = _readInt(participation['edifici']);
      final leagueId = _readInt(participation['lliga']);

      if (buildingId == idEdifici &&
          leagueId != null &&
          activeLeagueIds.contains(leagueId)) {
        selectedParticipation = participation;
        break;
      }
    }

    if (selectedParticipation == null) {
      for (final participation in participations) {
        if (_readInt(participation['edifici']) == idEdifici) {
          selectedParticipation = participation;
          break;
        }
      }
    }

    if (selectedParticipation == null) {
      throw const RankingApiException(
        'Aquest edifici encara no té participació assignada a cap lliga.',
      );
    }

    final leagueId = _readInt(selectedParticipation['lliga']);
    if (leagueId == null) {
      throw const RankingApiException('La participació no té lliga assignada.');
    }

    final league = leaguesById[leagueId];
    if (league == null) {
      throw const RankingApiException(
        'No s’ha trobat la lliga de la participació.',
      );
    }

    return _RankingContext(
      seasonId: activeSeasonId,
      seasonName: _readString(activeSeason['nom']) ?? 'Temporada activa',
      seasonEndDate: _readDate(activeSeason['dataFi']),
      leagueId: leagueId,
      leagueName:
          _readString(league['nom']) ??
          _readString(league['divisio']) ??
          'La meva lliga',
      leagueDivision: _readString(league['divisio']),
      participation: selectedParticipation,
    );
  }

  RankingSummary _buildSummary({
    required _RankingContext context,
    required Map<String, dynamic> positionData,
    required int fallbackPoints,
    required RankingScope scope,
  }) {
    final currentPoints =
        _readInt(positionData['puntuacion_actual']) ??
        _readInt(context.participation['puntuacio']) ??
        fallbackPoints;

    final pointsToTop = _readInt(positionData['punt_per_top']) ?? 0;
    final targetPoints = pointsToTop <= 0
        ? currentPoints
        : currentPoints + pointsToTop;
    final isInTop = positionData['esta_en_top'] == true;
    final topTarget = _readInt(positionData['top_objetivo']) ?? 3;
    final position =
        _readInt(positionData['posicion']) ??
        _readInt(context.participation['posicio']) ??
        0;

    final daysRemaining = _daysRemaining(context.seasonEndDate);
    final segmentText = scope == RankingScope.comparable
        ? ' entre edificis similars'
        : ' de la lliga';

    final promotionText = isInTop
        ? 'Ja formes part del Top $topTarget$segmentText.'
        : pointsToTop > 0
        ? 'Et falten $pointsToTop punts per entrar al Top $topTarget$segmentText.'
        : 'Segueix millorant per pujar posicions$segmentText.';

    return RankingSummary(
      seasonName: context.seasonName,
      leagueName: context.leagueName,
      currentPoints: currentPoints,
      targetPoints: targetPoints,
      progress: targetPoints <= 0
          ? 0.0
          : (currentPoints / targetPoints).clamp(0.0, 1.0).toDouble(),
      daysRemaining: daysRemaining,
      promotionText: promotionText,
      currentPosition: position,
    );
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    final response = await http
        .get(uri, headers: await _buildHeaders())
        .timeout(const Duration(seconds: 10));

    final decoded = _tryDecodeBody(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw RankingApiException(
        'No s’ha pogut carregar el rànquing.',
        statusCode: response.statusCode,
        details: decoded,
      );
    }

    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }

    if (decoded is List) {
      return {'results': decoded};
    }

    throw const RankingApiException(
      'La resposta del rànquing no té el format esperat.',
    );
  }

  List<Map<String, dynamic>> _extractList(dynamic decoded) {
    final raw = decoded is Map ? decoded['results'] : decoded;

    if (raw is! List) return const [];

    return raw
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  Future<RankingResponse> _getMockRanking({
    required int idEdifici,
    required String buildingName,
    required int currentPoints,
    required RankingScope scope,
    required String? search,
    required int page,
    int targetTop = 3,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final baseEntries = <RankingEntry>[
      RankingEntry.mock(
        idEdifici: 101,
        position: 1,
        name: 'Green Heights Residencial',
        address: 'Eixample · Barcelona',
        points: 2840,
      ),
      RankingEntry.mock(
        idEdifici: 102,
        position: 2,
        name: 'EcoTower Suites',
        address: 'Sant Martí · Barcelona',
        points: 2715,
      ),
      RankingEntry.mock(
        idEdifici: 103,
        position: 3,
        name: 'Solaris Complex',
        address: 'Gràcia · Barcelona',
        points: 2690,
      ),
      RankingEntry.mock(
        idEdifici: idEdifici,
        position: 4,
        name: buildingName,
        address: scope == RankingScope.league
            ? 'El teu edifici · La meva lliga'
            : 'El teu edifici · Edificis similars',
        points: currentPoints,
        isCurrentBuilding: true,
      ),
      RankingEntry.mock(
        idEdifici: 104,
        position: 5,
        name: 'Central Park West',
        address: 'Les Corts · Barcelona',
        points: 2480,
      ),
      RankingEntry.mock(
        idEdifici: 105,
        position: 6,
        name: 'Habitatges Maragall',
        address: 'Horta · Barcelona',
        points: 2355,
      ),
      RankingEntry.mock(
        idEdifici: 106,
        position: 7,
        name: 'Bloc Mediterrani',
        address: 'Sants · Barcelona',
        points: 2290,
      ),
      RankingEntry.mock(
        idEdifici: 107,
        position: 8,
        name: 'Residencial Nord',
        address: 'Nou Barris · Barcelona',
        points: 2180,
      ),
    ];

    final query = search?.trim().toLowerCase() ?? '';

    final filtered = query.isEmpty
        ? baseEntries
        : baseEntries.where((entry) {
            return entry.name.toLowerCase().contains(query) ||
                (entry.address?.toLowerCase().contains(query) ?? false);
          }).toList();

    const pageSize = 5;
    final start = (page - 1) * pageSize;
    final end = start + pageSize;

    final pageEntries = start >= filtered.length
        ? <RankingEntry>[]
        : filtered.sublist(
            start,
            end > filtered.length ? filtered.length : end,
          );

    return RankingResponse(
      summary: RankingSummary.mock(currentPoints: currentPoints),
      entries: pageEntries,
      page: page,
      hasMore: end < filtered.length,
    );
  }

  dynamic _tryDecodeBody(String body) {
    if (body.isEmpty) return {};

    try {
      return jsonDecode(body);
    } catch (_) {
      return body;
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
      final normalized = value.replaceAll(',', '').trim();
      return int.tryParse(normalized) ?? double.tryParse(normalized)?.round();
    }
    return null;
  }

  DateTime? _readDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  int _daysRemaining(DateTime? endDate) {
    if (endDate == null) return 0;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    return end.difference(today).inDays.clamp(0, 9999).toInt();
  }
}

class _RankingContext {
  final int seasonId;
  final String seasonName;
  final DateTime? seasonEndDate;
  final int leagueId;
  final String leagueName;
  final String? leagueDivision;
  final Map<String, dynamic> participation;

  const _RankingContext({
    required this.seasonId,
    required this.seasonName,
    required this.seasonEndDate,
    required this.leagueId,
    required this.leagueName,
    required this.leagueDivision,
    required this.participation,
  });
}

class RankingApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic details;

  const RankingApiException(this.message, {this.statusCode, this.details});

  @override
  String toString() {
    if (details == null) return message;
    return '$message Detall: $details';
  }
}
