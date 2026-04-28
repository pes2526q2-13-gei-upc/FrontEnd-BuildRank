class SimulationResultModel {
  final String versioMotor;
  final int edificiId;
  final SimulationSnapshot abans;
  final SimulationSnapshot despres;
  final SimulationDelta delta;
  final List<SimulationItemResult> items;
  final Map<String, dynamic> raw;

  const SimulationResultModel({
    required this.versioMotor,
    required this.edificiId,
    required this.abans,
    required this.despres,
    required this.delta,
    required this.items,
    required this.raw,
  });

  factory SimulationResultModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];

    return SimulationResultModel(
      versioMotor: json['versioMotor']?.toString() ?? '-',
      edificiId: _readInt(json['edificiId']),
      abans: SimulationSnapshot.fromJson(_readMap(json['abans'])),
      despres: SimulationSnapshot.fromJson(_readMap(json['despres'])),
      delta: SimulationDelta.fromJson(_readMap(json['delta'])),
      items: rawItems is List
          ? rawItems
                .whereType<Map>()
                .map(
                  (item) => SimulationItemResult.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : const [],
      raw: json,
    );
  }

  static int _readInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static Map<String, dynamic> _readMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return {};
  }
}

class SimulationSnapshot {
  final double consumFinalKwhAny;
  final double emissionsKgCO2Any;
  final double costAnualEnergia;
  final double score;
  final String origenDades;

  const SimulationSnapshot({
    required this.consumFinalKwhAny,
    required this.emissionsKgCO2Any,
    required this.costAnualEnergia,
    required this.score,
    required this.origenDades,
  });

  factory SimulationSnapshot.fromJson(Map<String, dynamic> json) {
    return SimulationSnapshot(
      consumFinalKwhAny: _readDouble(json['consumFinalKwhAny']),
      emissionsKgCO2Any: _readDouble(json['emissionsKgCO2Any']),
      costAnualEnergia: _readDouble(json['costAnualEnergia']),
      score: _readDouble(json['score']),
      origenDades: json['origenDades']?.toString() ?? '-',
    );
  }

  static double _readDouble(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}

class SimulationDelta {
  final double reduccioConsumKwhAny;
  final double reduccioConsumPercent;
  final double reduccioEmissionsKgCO2Any;
  final double reduccioEmissionsPercent;
  final double estalviAnualEstimatiu;
  final double costTotalEstimat;
  final double incrementScore;

  const SimulationDelta({
    required this.reduccioConsumKwhAny,
    required this.reduccioConsumPercent,
    required this.reduccioEmissionsKgCO2Any,
    required this.reduccioEmissionsPercent,
    required this.estalviAnualEstimatiu,
    required this.costTotalEstimat,
    required this.incrementScore,
  });

  factory SimulationDelta.fromJson(Map<String, dynamic> json) {
    return SimulationDelta(
      reduccioConsumKwhAny: _readDouble(json['reduccioConsumKwhAny']),
      reduccioConsumPercent: _readDouble(json['reduccioConsumPercent']),
      reduccioEmissionsKgCO2Any: _readDouble(json['reduccioEmissionsKgCO2Any']),
      reduccioEmissionsPercent: _readDouble(json['reduccioEmissionsPercent']),
      estalviAnualEstimatiu: _readDouble(json['estalviAnualEstimatiu']),
      costTotalEstimat: _readDouble(json['costTotalEstimat']),
      incrementScore: _readDouble(json['incrementScore']),
    );
  }

  static double _readDouble(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}

class SimulationItemResult {
  final int milloraId;
  final String? slug;
  final String nom;
  final double costEstimat;
  final double reduccioConsumKwhAny;
  final double reduccioEmissionsKgCO2Any;
  final double impactePunts;
  final double coberturaPercent;
  final double quantitatAplicada;

  const SimulationItemResult({
    required this.milloraId,
    required this.slug,
    required this.nom,
    required this.costEstimat,
    required this.reduccioConsumKwhAny,
    required this.reduccioEmissionsKgCO2Any,
    required this.impactePunts,
    required this.coberturaPercent,
    required this.quantitatAplicada,
  });

  factory SimulationItemResult.fromJson(Map<String, dynamic> json) {
    return SimulationItemResult(
      milloraId: _readInt(json['milloraId']),
      slug: json['slug']?.toString(),
      nom: json['nom']?.toString() ?? 'Millora',
      costEstimat: _readDouble(json['costEstimat']),
      reduccioConsumKwhAny: _readDouble(json['reduccioConsumKwhAny']),
      reduccioEmissionsKgCO2Any: _readDouble(json['reduccioEmissionsKgCO2Any']),
      impactePunts: _readDouble(json['impactePunts']),
      coberturaPercent: _readDouble(json['coberturaPercent']),
      quantitatAplicada: _readDouble(json['quantitatAplicada']),
    );
  }

  static int _readInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _readDouble(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
