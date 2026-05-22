class Season {
  final int? id;
  final String name;
  final DateTime? startDate;
  final DateTime? endDate;
  final String status;
  final int participants;
  final Map<String, dynamic> raw;

  const Season({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.participants,
    required this.raw,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    final id = _readInt(
      json['id'] ?? json['id_temporada'] ?? json['temporada_id'],
    );

    return Season(
      id: id,
      name:
          _readString(
            json['nom'] ??
                json['name'] ??
                json['nom_temporada'] ??
                json['season_name'],
          ) ??
          (id == null ? 'Temporada' : 'Temporada $id'),
      startDate: _readDate(
        json['data_inici'] ??
            json['dataInici'] ??
            json['start_date'] ??
            json['startDate'],
      ),
      endDate: _readDate(
        json['data_fi'] ??
            json['dataFi'] ??
            json['end_date'] ??
            json['endDate'],
      ),
      status:
          _readString(json['estat'] ?? json['status'] ?? json['state']) ??
          'TANCADA',
      participants:
          _readInt(
            json['participants'] ??
                json['edificis'] ??
                json['num_edificis'] ??
                json['buildings_count'] ??
                json['participations_count'],
          ) ??
          0,
      raw: Map<String, dynamic>.from(json),
    );
  }

  bool get isActive {
    final normalized = status.trim().toUpperCase();
    return normalized == 'ACTIVA' ||
        normalized == 'ACTIU' ||
        normalized == 'ACTIVE';
  }

  String get range {
    if (startDate == null && endDate == null) return 'Dates no disponibles';

    final start = startDate == null ? null : _formatDate(startDate!);
    final end = endDate == null ? null : _formatDate(endDate!);

    if (start != null && end != null) return '$start - $end';
    if (start != null) return 'Des de $start';
    return 'Fins $end';
  }

  static String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}

class SeasonActivationResult {
  final Season? season;
  final String? message;
  final Map<String, dynamic> baseScoresSummary;
  final Map<String, dynamic> rankingSnapshotSummary;
  final Map<String, dynamic> raw;

  const SeasonActivationResult({
    required this.season,
    required this.message,
    required this.baseScoresSummary,
    required this.rankingSnapshotSummary,
    required this.raw,
  });

  factory SeasonActivationResult.fromJson(Map<String, dynamic> json) {
    final seasonJson = _readMap(
      json['temporada'] ??
          json['season'] ??
          json['nova_temporada'] ??
          json['new_season'] ??
          json['data'],
    );

    return SeasonActivationResult(
      season: seasonJson == null ? null : Season.fromJson(seasonJson),
      message: _readString(
        json['message'] ?? json['detail'] ?? json['missatge'],
      ),
      baseScoresSummary:
          _readMap(
            json['resum_puntuacions_base'] ?? json['base_scores_summary'],
          ) ??
          const {},
      rankingSnapshotSummary:
          _readMap(
            json['resum_snapshot_ranking'] ?? json['ranking_snapshot_summary'],
          ) ??
          const {},
      raw: Map<String, dynamic>.from(json),
    );
  }

  String displaySummary(String fallback) {
    final pieces = <String>[];

    final seasonName = season?.name;
    if (seasonName != null && seasonName.trim().isNotEmpty) {
      pieces.add(seasonName);
    }

    final baseCount = _firstInt(baseScoresSummary, const [
      'actualitzades',
      'updated',
      'updated_count',
      'total',
    ]);
    if (baseCount != null) {
      pieces.add('$baseCount puntuacions base');
    }

    final snapshotCount = _firstInt(rankingSnapshotSummary, const [
      'creats',
      'created',
      'created_count',
      'total',
    ]);
    if (snapshotCount != null) {
      pieces.add('$snapshotCount snapshots');
    }

    if (pieces.isNotEmpty) return pieces.join(' · ');
    if (message != null && message!.trim().isNotEmpty) return message!;
    return fallback;
  }
}

int? _firstInt(Map<String, dynamic> map, List<String> keys) {
  for (final key in keys) {
    final value = _readInt(map[key]);
    if (value != null) return value;
  }
  return null;
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
    final normalized = value.replaceAll(',', '').trim();
    return int.tryParse(normalized) ?? double.tryParse(normalized)?.round();
  }
  return null;
}

DateTime? _readDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
