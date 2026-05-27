enum RankingScope { league, comparableLeague, comparableSeason }

extension RankingScopeLabel on RankingScope {
  String get label {
    switch (this) {
      case RankingScope.league:
        return 'La meva lliga';
      case RankingScope.comparableLeague:
        return 'Similars lliga';
      case RankingScope.comparableSeason:
        return 'Similars temporada';
    }
  }

  String get apiValue {
    switch (this) {
      case RankingScope.league:
        return 'league';
      case RankingScope.comparableLeague:
        return 'comparable_league';
      case RankingScope.comparableSeason:
        return 'comparable_season';
    }
  }
}

class RankingResponse {
  final RankingSummary summary;
  final List<RankingEntry> entries;
  final int page;
  final bool hasMore;

  const RankingResponse({
    required this.summary,
    required this.entries,
    required this.page,
    required this.hasMore,
  });

  factory RankingResponse.fromJson(
    Map<String, dynamic> json, {
    required int currentBuildingId,
    RankingSummary? summaryOverride,
    int? pageOverride,
  }) {
    final rawEntries = json['results'] ?? json['entries'] ?? json['ranking'];

    return RankingResponse(
      summary:
          summaryOverride ??
          RankingSummary.fromJson(_readMap(json['summary']) ?? json),
      entries: rawEntries is List
          ? rawEntries
                .whereType<Map>()
                .map(
                  (item) => RankingEntry.fromJson(
                    Map<String, dynamic>.from(item),
                    currentBuildingId: currentBuildingId,
                  ),
                )
                .toList()
          : const [],
      page: pageOverride ?? _readInt(json['page']) ?? 1,
      hasMore: json['next'] != null || json['hasMore'] == true,
    );
  }

  RankingResponse copyWith({
    RankingSummary? summary,
    List<RankingEntry>? entries,
    int? page,
    bool? hasMore,
  }) {
    return RankingResponse(
      summary: summary ?? this.summary,
      entries: entries ?? this.entries,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class RankingSummary {
  final String seasonName;
  final String leagueName;
  final int currentPoints;
  final int targetPoints;
  final double progress;
  final int daysRemaining;
  final String promotionText;
  final int currentPosition;

  const RankingSummary({
    required this.seasonName,
    required this.leagueName,
    required this.currentPoints,
    required this.targetPoints,
    required this.progress,
    required this.daysRemaining,
    required this.promotionText,
    required this.currentPosition,
  });

  factory RankingSummary.fromJson(Map<String, dynamic> json) {
    final currentPoints =
        _readInt(
          json['currentPoints'] ??
              json['current_points'] ??
              json['puntsActuals'] ??
              json['puntuacion_actual'] ??
              json['puntuacio'] ??
              json['points'],
        ) ??
        0;

    final targetPoints =
        _readInt(
          json['targetPoints'] ??
              json['target_points'] ??
              json['puntsObjectiu'],
        ) ??
        1200;

    final rawProgress = _readDouble(json['progress'] ?? json['progres']);

    return RankingSummary(
      seasonName:
          _readString(
            json['seasonName'] ?? json['season_name'] ?? json['temporada'],
          ) ??
          'Temporada activa',
      leagueName:
          _readString(
            json['leagueName'] ??
                json['league_name'] ??
                json['lliga'] ??
                json['liga'] ??
                json['league'],
          ) ??
          'La meva lliga',
      currentPoints: currentPoints,
      targetPoints: targetPoints,
      progress:
          rawProgress ??
          (targetPoints == 0
                  ? 0.0
                  : (currentPoints / targetPoints).clamp(0.0, 1.0))
              .toDouble(),
      daysRemaining:
          _readInt(
            json['daysRemaining'] ??
                json['days_remaining'] ??
                json['diesRestants'],
          ) ??
          0,
      promotionText:
          _readString(
            json['promotionText'] ??
                json['promotion_text'] ??
                json['missatgePromocio'],
          ) ??
          'Segueix millorant per pujar posicions.',
      currentPosition:
          _readInt(
            json['currentPosition'] ??
                json['current_position'] ??
                json['posicion'] ??
                json['posicio'],
          ) ??
          0,
    );
  }

  factory RankingSummary.mock({required int currentPoints}) {
    const target = 1200;

    return RankingSummary(
      seasonName: 'Hivern 26',
      leagueName: 'Silver League',
      currentPoints: currentPoints,
      targetPoints: target,
      progress: target == 0
          ? 0.0
          : (currentPoints / target).clamp(0.0, 1.0).toDouble(),
      daysRemaining: 4,
      promotionText: 'El top 15% puja en 4 dies!',
      currentPosition: 4,
    );
  }
}

class RankingEntry {
  final int idEdifici;
  final int position;
  final String name;
  final String? address;
  final int points;
  final String? league;
  final int? scoreDelta;
  final bool isCurrentBuilding;

  const RankingEntry({
    required this.idEdifici,
    required this.position,
    required this.name,
    this.address,
    required this.points,
    this.league,
    this.scoreDelta,
    required this.isCurrentBuilding,
  });

  factory RankingEntry.fromJson(
    Map<String, dynamic> json, {
    required int currentBuildingId,
  }) {
    final id =
        _readInt(
          json['idEdifici'] ??
              json['id_edifici'] ??
              json['edificiId'] ??
              json['edifici_id'] ??
              json['edifici'] ??
              json['id'],
        ) ??
        0;

    final explicitName = _readString(
      json['name'] ??
          json['nom'] ??
          json['title'] ??
          json['buildingName'] ??
          json['building_name'],
    );

    final address = _readString(
      json['address'] ?? json['adreca'] ?? json['localitzacio'],
    );

    final cleanExplicitName = explicitName == null
        ? null
        : _cleanBuildingDisplayName(explicitName);

    final displayName =
        cleanExplicitName != null && !_isGenericBuildingName(cleanExplicitName)
        ? cleanExplicitName
        : address ?? cleanExplicitName ?? 'Edifici #$id';

    return RankingEntry(
      idEdifici: id,
      position:
          _readInt(
            json['position'] ??
                json['posicio'] ??
                json['posicion'] ??
                json['rank'] ??
                json['ranking'],
          ) ??
          0,
      name: displayName,
      address: address,
      points:
          _readInt(
            json['points'] ??
                json['punts'] ??
                json['score'] ??
                json['puntuacio'] ??
                json['puntuacion'] ??
                json['puntuacioBase'],
          ) ??
          0,
      league: _readString(
        json['nom_lliga'] ?? json['league'] ?? json['lliga'] ?? json['liga'],
      ),
      scoreDelta: _readInt(
        json['scoreDelta'] ?? json['score_delta'] ?? json['diferencia'],
      ),
      isCurrentBuilding:
          json['isCurrentBuilding'] == true ||
          json['is_current_building'] == true ||
          id == currentBuildingId,
    );
  }

  factory RankingEntry.mock({
    required int idEdifici,
    required int position,
    required String name,
    required int points,
    String? address,
    bool isCurrentBuilding = false,
  }) {
    return RankingEntry(
      idEdifici: idEdifici,
      position: position,
      name: name,
      address: address,
      points: points,
      league: 'Silver League',
      scoreDelta: null,
      isCurrentBuilding: isCurrentBuilding,
    );
  }
}

class RankingProgressPoint {
  final int seasonId;
  final String seasonName;
  final String category;
  final int points;
  final int position;
  final String? division;
  final DateTime? calculatedAt;

  const RankingProgressPoint({
    required this.seasonId,
    required this.seasonName,
    required this.category,
    required this.points,
    required this.position,
    this.division,
    this.calculatedAt,
  });

  factory RankingProgressPoint.fromJson(Map<String, dynamic> json) {
    return RankingProgressPoint(
      seasonId: _readInt(json['temporada'] ?? json['season']) ?? 0,
      seasonName:
          _readString(json['nom_temporada'] ?? json['season_name']) ??
          'Temporada',
      category: _readString(json['categoria'] ?? json['category']) ?? 'PROGRES',
      points: _readInt(json['puntuacio'] ?? json['points']) ?? 0,
      position: _readInt(json['posicio'] ?? json['position']) ?? 0,
      division: _readString(json['divisio'] ?? json['division']),
      calculatedAt: DateTime.tryParse(
        (json['data_calcul'] ?? json['calculated_at'] ?? '').toString(),
      ),
    );
  }
}

class ProgressRankingEntry {
  final int idEdifici;
  final int position;
  final String name;
  final String? address;
  final int startPoints;
  final int currentPoints;
  final int delta;
  final String? division;
  final bool isCurrentBuilding;
  final List<RankingProgressPoint> series;

  const ProgressRankingEntry({
    required this.idEdifici,
    required this.position,
    required this.name,
    required this.startPoints,
    required this.currentPoints,
    required this.delta,
    required this.series,
    this.address,
    this.division,
    this.isCurrentBuilding = false,
  });

  double get percentage {
    if (startPoints <= 0) return 0;
    return delta / startPoints;
  }

  factory ProgressRankingEntry.fromJson(
    Map<String, dynamic> json, {
    int? currentBuildingId,
  }) {
    final id = _readInt(json['edifici'] ?? json['idEdifici']) ?? 0;
    final seriesRaw = json['serie_temporal'];

    return ProgressRankingEntry(
      idEdifici: id,
      position: _readInt(json['posicio'] ?? json['position']) ?? 0,
      name:
          _readString(json['nom'] ?? json['name'] ?? json['adreca']) ??
          'Edifici #$id',
      address: _readString(json['adreca'] ?? json['address']),
      startPoints:
          _readInt(json['puntuacio_inicial'] ?? json['initial_points']) ?? 0,
      currentPoints:
          _readInt(json['puntuacio_actual'] ?? json['current_points']) ?? 0,
      delta: _readInt(json['delta'] ?? json['progres']) ?? 0,
      division: _readString(json['divisio_actual'] ?? json['divisio']),
      isCurrentBuilding: id == currentBuildingId,
      series: seriesRaw is List
          ? seriesRaw
                .whereType<Map>()
                .map(
                  (item) => RankingProgressPoint.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : const [],
    );
  }
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

String _cleanBuildingDisplayName(String value) {
  return value
      .replaceFirst(
        RegExp(r'^Edifici\s*#?\s*\d+\s*[-–—]\s*', caseSensitive: false),
        '',
      )
      .trim();
}

bool _isGenericBuildingName(String value) {
  return RegExp(
    r'^Edifici\s*#?\s*\d+$',
    caseSensitive: false,
  ).hasMatch(value.trim());
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

double? _readDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value.trim());
  return null;
}
