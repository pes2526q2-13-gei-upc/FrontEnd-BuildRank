class ImplementedImprovementModel {
  final int id;
  final String nom;
  final String dataExecucio;
  final double costReal;
  final String estatValidacio;
  final String observacionsAdmin;

  const ImplementedImprovementModel({
    required this.id,
    required this.nom,
    required this.dataExecucio,
    required this.costReal,
    required this.estatValidacio,
    required this.observacionsAdmin,
  });

  factory ImplementedImprovementModel.fromJson(Map<String, dynamic> json) {
    final millora = json['millora'];

    return ImplementedImprovementModel(
      id: _readInt(json['id']),
      nom: millora is Map
          ? (millora['nom']?.toString() ?? 'Millora')
          : 'Millora',
      dataExecucio: json['dataExecucio']?.toString() ?? '-',
      costReal: _readDouble(json['costReal']),
      estatValidacio: json['estatValidacio']?.toString() ?? '-',
      observacionsAdmin: json['observacionsAdmin']?.toString() ?? '',
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
