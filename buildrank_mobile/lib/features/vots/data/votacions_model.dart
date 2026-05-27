class VotacioResumModel {
  final int id;
  final String titol;
  final String estat;
  final DateTime dataCreacio;
  final DateTime? dataLimit;
  final int numVotsTotal;

  const VotacioResumModel({
    required this.id,
    required this.titol,
    required this.estat,
    required this.dataCreacio,
    this.dataLimit,
    required this.numVotsTotal,
  });

  factory VotacioResumModel.fromJson(Map<String, dynamic> json) {
    return VotacioResumModel(
      id: _readInt(json['id']) ?? 0,
      titol: json['titol']?.toString() ?? '',
      estat: json['estat']?.toString() ?? 'oberta',
      dataCreacio:
          DateTime.tryParse(json['dataCreacio']?.toString() ?? '') ??
          DateTime.now(),
      dataLimit: json['dataLimit'] != null
          ? DateTime.tryParse(json['dataLimit'].toString())
          : null,
      numVotsTotal: _readInt(json['num_vots_total']) ?? 0,
    );
  }
}

class OpcioVotModel {
  final int id;
  final String text;
  final int ordre;
  final int numVots;

  const OpcioVotModel({
    required this.id,
    required this.text,
    required this.ordre,
    required this.numVots,
  });

  factory OpcioVotModel.fromJson(Map<String, dynamic> json) {
    return OpcioVotModel(
      id: _readInt(json['id']) ?? 0,
      text: json['text']?.toString() ?? '',
      ordre: _readInt(json['ordre']) ?? 0,
      numVots: _readInt(json['num_vots']) ?? 0,
    );
  }
}

class OpcioResultatModel {
  final int id;
  final String text;
  final int numVots;
  final double percentatge;

  const OpcioResultatModel({
    required this.id,
    required this.text,
    required this.numVots,
    required this.percentatge,
  });

  factory OpcioResultatModel.fromJson(Map<String, dynamic> json) {
    return OpcioResultatModel(
      id: _readInt(json['id']) ?? 0,
      text: json['text']?.toString() ?? '',
      numVots: _readInt(json['num_vots']) ?? 0,
      percentatge: _readDouble(json['percentatge']) ?? 0.0,
    );
  }
}

class VotacioDetallModel {
  final int id;
  final int edifici;
  final String titol;
  final String? descripcio;
  final String estat;
  final DateTime dataCreacio;
  final DateTime? dataLimit;
  final int numVotsTotal;
  final bool haVotat;
  final List<OpcioVotModel> opcions;

  const VotacioDetallModel({
    required this.id,
    required this.edifici,
    required this.titol,
    this.descripcio,
    required this.estat,
    required this.dataCreacio,
    this.dataLimit,
    required this.numVotsTotal,
    required this.haVotat,
    required this.opcions,
  });

  factory VotacioDetallModel.fromJson(Map<String, dynamic> json) {
    final opcionsRaw = json['opcions'];
    final opcions = opcionsRaw is List
        ? opcionsRaw
              .whereType<Map>()
              .map((o) => OpcioVotModel.fromJson(Map<String, dynamic>.from(o)))
              .toList()
        : <OpcioVotModel>[];

    return VotacioDetallModel(
      id: _readInt(json['id']) ?? 0,
      edifici: _readInt(json['edifici']) ?? 0,
      titol: json['titol']?.toString() ?? '',
      descripcio: json['descripcio']?.toString().isNotEmpty == true
          ? json['descripcio'].toString()
          : null,
      estat: json['estat']?.toString() ?? 'oberta',
      dataCreacio:
          DateTime.tryParse(json['dataCreacio']?.toString() ?? '') ??
          DateTime.now(),
      dataLimit: json['dataLimit'] != null
          ? DateTime.tryParse(json['dataLimit'].toString())
          : null,
      numVotsTotal: _readInt(json['num_vots_total']) ?? 0,
      haVotat: json['ha_votat'] == true,
      opcions: opcions,
    );
  }
}

class ResultatsVotacioModel {
  final int id;
  final String titol;
  final String estat;
  final DateTime? dataLimit;
  final int numVotsTotal;
  final List<OpcioResultatModel> opcions;

  const ResultatsVotacioModel({
    required this.id,
    required this.titol,
    required this.estat,
    this.dataLimit,
    required this.numVotsTotal,
    required this.opcions,
  });

  factory ResultatsVotacioModel.fromJson(Map<String, dynamic> json) {
    final opcionsRaw = json['opcions'];
    final opcions = opcionsRaw is List
        ? opcionsRaw
              .whereType<Map>()
              .map(
                (o) =>
                    OpcioResultatModel.fromJson(Map<String, dynamic>.from(o)),
              )
              .toList()
        : <OpcioResultatModel>[];

    return ResultatsVotacioModel(
      id: _readInt(json['id']) ?? 0,
      titol: json['titol']?.toString() ?? '',
      estat: json['estat']?.toString() ?? 'oberta',
      dataLimit: json['dataLimit'] != null
          ? DateTime.tryParse(json['dataLimit'].toString())
          : null,
      numVotsTotal: _readInt(json['num_vots_total']) ?? 0,
      opcions: opcions,
    );
  }
}

int? _readInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.round();
  if (value is String) {
    return int.tryParse(value.trim()) ?? double.tryParse(value.trim())?.round();
  }
  return null;
}

double? _readDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value.trim());
  return null;
}
