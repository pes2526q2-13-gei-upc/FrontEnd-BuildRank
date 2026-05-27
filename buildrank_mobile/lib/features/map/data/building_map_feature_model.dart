import 'package:latlong2/latlong.dart';

class BuildingMapResponse {
  final int count;
  final String scope;
  final int limit;
  final bool truncated;
  final List<BuildingMapFeature> features;

  const BuildingMapResponse({
    required this.count,
    required this.scope,
    required this.limit,
    required this.truncated,
    required this.features,
  });

  factory BuildingMapResponse.fromJson(Map<String, dynamic> json) {
    final meta = _readMap(json['meta']) ?? {};
    final rawFeatures = json['features'];

    final features = rawFeatures is List
        ? rawFeatures
              .whereType<Map>()
              .map((item) => BuildingMapFeature.fromJson(item))
              .where((feature) => feature.hasValidCoordinates)
              .toList()
        : <BuildingMapFeature>[];

    return BuildingMapResponse(
      count: _readInt(json['count']) ?? features.length,
      scope: _readString(meta['scope']) ?? 'public',
      limit: _readInt(meta['limit']) ?? features.length,
      truncated: meta['truncated'] == true,
      features: features,
    );
  }
}

class BuildingMapFeature {
  final int idEdifici;
  final double latitude;
  final double longitude;
  final String title;
  final String address;
  final String? barri;
  final String? codiPostal;
  final String? tipologia;
  final int? anyConstruccio;
  final double? superficieTotal;
  final double? puntuacioBase;
  final String puntuacioLabel;
  final String? classificacioEstimada;
  final String? classificacioFont;
  final bool fontOpenData;
  final String? detailEndpoint;

  final MapDataProvenance? procedenciaDades;
  final MapBhsSummary? bhs;
  final MapHeatRiskSummary? heatRisk;
  final List<MapBadgeSummary> badgesSummary;

  const BuildingMapFeature({
    required this.idEdifici,
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.address,
    required this.barri,
    required this.codiPostal,
    required this.tipologia,
    required this.anyConstruccio,
    required this.superficieTotal,
    required this.puntuacioBase,
    required this.puntuacioLabel,
    required this.classificacioEstimada,
    required this.classificacioFont,
    required this.fontOpenData,
    required this.detailEndpoint,
    required this.procedenciaDades,
    required this.bhs,
    required this.heatRisk,
    required this.badgesSummary,
  });

  factory BuildingMapFeature.fromJson(Map<dynamic, dynamic> json) {
    final feature = Map<String, dynamic>.from(json);
    final geometry = _readMap(feature['geometry']) ?? {};
    final properties = _readMap(feature['properties']) ?? {};

    final coordinates = geometry['coordinates'];
    double longitude = 0;
    double latitude = 0;

    if (coordinates is List && coordinates.length >= 2) {
      longitude = _readDouble(coordinates[0]) ?? 0;
      latitude = _readDouble(coordinates[1]) ?? 0;
    }

    final id =
        _readInt(properties['idEdifici']) ??
        _readInt(feature['id']) ??
        _readInt(properties['id']) ??
        0;

    final title =
        _readString(properties['titol']) ??
        _readString(properties['title']) ??
        'Edifici #$id';

    final address =
        _readString(properties['adreca']) ??
        _readString(properties['address']) ??
        'Localització disponible';

    final badgesRaw = properties['badgesSummary'];
    final badgesSummary = badgesRaw is List
        ? badgesRaw
              .whereType<Map>()
              .map((item) => MapBadgeSummary.fromJson(item))
              .where((badge) => badge.label.isNotEmpty)
              .toList()
        : <MapBadgeSummary>[];

    return BuildingMapFeature(
      idEdifici: id,
      latitude: latitude,
      longitude: longitude,
      title: title,
      address: address,
      barri: _readString(properties['barri']),
      codiPostal: _readString(properties['codiPostal']),
      tipologia: _readString(properties['tipologia']),
      anyConstruccio: _readInt(properties['anyConstruccio']),
      superficieTotal: _readDouble(properties['superficieTotal']),
      puntuacioBase: _readDouble(properties['puntuacioBase']),
      puntuacioLabel:
          _readString(properties['puntuacioLabel']) ?? 'SENSE_DADES',
      classificacioEstimada: _readString(properties['classificacioEstimada']),
      classificacioFont: _readString(properties['classificacioFont']),
      fontOpenData: properties['fontOpenData'] == true,
      detailEndpoint: _readString(properties['detailEndpoint']),
      procedenciaDades: MapDataProvenance.fromDynamic(
        properties['procedenciaDades'],
      ),
      bhs: MapBhsSummary.fromDynamic(properties['bhs']),
      heatRisk: MapHeatRiskSummary.fromDynamic(properties['heatRisk']),
      badgesSummary: badgesSummary,
    );
  }

  bool get hasValidCoordinates {
    return latitude != 0 && longitude != 0;
  }

  LatLng get point => LatLng(latitude, longitude);

  double? get displayScore => bhs?.score ?? puntuacioBase;

  bool get hasScore => displayScore != null;

  int get roundedScore {
    final score = displayScore;
    if (score == null) return 0;
    return score.round().clamp(0, 100);
  }

  String get scoreText {
    final score = displayScore;
    if (score == null) return 'Sense dades';

    final label = bhs?.label;
    if (label != null && label.isNotEmpty) {
      return '${score.round()}/100 · $label';
    }

    return '${score.round()}/100';
  }

  String get energyClassText {
    final value = classificacioEstimada?.trim();
    if (value == null || value.isEmpty) return '—';
    return value;
  }

  String get sourceText {
    final provenanceLabel = procedenciaDades?.label;
    if (provenanceLabel != null && provenanceLabel.isNotEmpty) {
      return provenanceLabel;
    }

    if (fontOpenData) return 'Open Data oficial';

    if (classificacioFont != null && classificacioFont!.isNotEmpty) {
      return classificacioFont!;
    }

    return 'Dades internes';
  }

  String? get heatRiskText {
    final summary = heatRisk;
    if (summary == null || !summary.hasData) return null;

    if (summary.index == null) return summary.etiqueta;

    return '${summary.etiqueta} · ${summary.index!.round()}/100';
  }

  List<MapBadgeSummary> get visibleBadges {
    return badgesSummary.take(3).toList();
  }
}

class MapDataProvenance {
  final String tipus;
  final String label;
  final String descripcio;
  final bool esOficial;
  final bool esEstimada;

  const MapDataProvenance({
    required this.tipus,
    required this.label,
    required this.descripcio,
    required this.esOficial,
    required this.esEstimada,
  });

  static MapDataProvenance? fromDynamic(dynamic value) {
    final map = _readMap(value);
    if (map == null) return null;

    return MapDataProvenance(
      tipus: _readString(map['tipus']) ?? '',
      label: _readString(map['label']) ?? '',
      descripcio: _readString(map['descripcio']) ?? '',
      esOficial: map['esOficial'] == true,
      esEstimada: map['esEstimada'] == true,
    );
  }
}

class MapBhsSummary {
  final double? score;
  final String font;
  final String label;
  final bool rankejable;

  const MapBhsSummary({
    required this.score,
    required this.font,
    required this.label,
    required this.rankejable,
  });

  static MapBhsSummary? fromDynamic(dynamic value) {
    final map = _readMap(value);
    if (map == null) return null;

    return MapBhsSummary(
      score: _readDouble(map['score']),
      font: _readString(map['font']) ?? '',
      label: _readString(map['label']) ?? '',
      rankejable: map['rankejable'] == true,
    );
  }
}

class MapHeatRiskSummary {
  final double? index;
  final String? font;
  final String etiqueta;

  const MapHeatRiskSummary({
    required this.index,
    required this.font,
    required this.etiqueta,
  });

  static MapHeatRiskSummary? fromDynamic(dynamic value) {
    final map = _readMap(value);
    if (map == null) return null;

    return MapHeatRiskSummary(
      index: _readDouble(map['index']),
      font: _readString(map['font']),
      etiqueta: _readString(map['etiqueta']) ?? 'Sense dades',
    );
  }

  bool get hasData {
    return index != null || etiqueta.trim().isNotEmpty;
  }
}

class MapBadgeSummary {
  final String code;
  final String label;
  final String categoria;
  final String scope;

  const MapBadgeSummary({
    required this.code,
    required this.label,
    required this.categoria,
    required this.scope,
  });

  factory MapBadgeSummary.fromJson(Map<dynamic, dynamic> json) {
    final map = Map<String, dynamic>.from(json);

    return MapBadgeSummary(
      code: _readString(map['code']) ?? '',
      label:
          _readString(map['nom']) ??
          _readString(map['label']) ??
          _readString(map['name']) ??
          _readString(map['titol']) ??
          _readString(map['title']) ??
          '',
      categoria: _readString(map['categoria']) ?? '',
      scope: _readString(map['scope']) ?? '',
    );
  }
}

Map<String, dynamic>? _readMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

int? _readInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.round();
  if (value is String) return int.tryParse(value);
  return null;
}

double? _readDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value.replaceAll(',', '.'));
  return null;
}

String? _readString(dynamic value) {
  final text = value?.toString().trim();
  if (text == null || text.isEmpty) return null;
  return text;
}
