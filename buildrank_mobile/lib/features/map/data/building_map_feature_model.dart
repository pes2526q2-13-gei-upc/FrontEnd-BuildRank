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
    );
  }

  bool get hasValidCoordinates {
    return latitude != 0 && longitude != 0;
  }

  LatLng get point => LatLng(latitude, longitude);

  int get roundedScore {
    final score = puntuacioBase;
    if (score == null) return 0;
    return score.round().clamp(0, 100);
  }

  String get scoreText {
    final score = puntuacioBase;
    if (score == null) return 'Sense dades';
    return '${score.round()}/100';
  }

  String get energyClassText {
    final value = classificacioEstimada?.trim();
    if (value == null || value.isEmpty) return '—';
    return value;
  }

  String get sourceText {
    if (fontOpenData) return 'Open Data oficial';
    if (classificacioFont != null && classificacioFont!.isNotEmpty) {
      return classificacioFont!;
    }
    return 'Dades internes';
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
