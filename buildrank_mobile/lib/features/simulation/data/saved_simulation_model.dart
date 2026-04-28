class SavedSimulationModel {
  final int id;
  final String descripcio;
  final double reduccioConsumPrevista;
  final double reduccioEmissionsPrevista;
  final double costEstimat;
  final double estalviAnual;
  final String dataSimulacio;
  final String versioMotor;

  const SavedSimulationModel({
    required this.id,
    required this.descripcio,
    required this.reduccioConsumPrevista,
    required this.reduccioEmissionsPrevista,
    required this.costEstimat,
    required this.estalviAnual,
    required this.dataSimulacio,
    required this.versioMotor,
  });

  factory SavedSimulationModel.fromJson(Map<String, dynamic> json) {
    return SavedSimulationModel(
      id: _readInt(json['id']),
      descripcio: json['descripcio']?.toString() ?? 'Simulació',
      reduccioConsumPrevista: _readDouble(json['reduccioConsumPrevista']),
      reduccioEmissionsPrevista: _readDouble(json['reduccioEmissionsPrevista']),
      costEstimat: _readDouble(json['costEstimat']),
      estalviAnual: _readDouble(json['estalviAnual']),
      dataSimulacio: json['dataSimulacio']?.toString() ?? '-',
      versioMotor: json['versioMotor']?.toString() ?? '-',
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
