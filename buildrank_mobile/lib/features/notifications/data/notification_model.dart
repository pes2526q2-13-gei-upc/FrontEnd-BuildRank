class NotificacioModel {
  final int id;
  final String tipus;
  final String titol;
  final String cos;
  final bool llegida;
  final DateTime dataCreacio;
  final int? objecteId;

  const NotificacioModel({
    required this.id,
    required this.tipus,
    required this.titol,
    required this.cos,
    required this.llegida,
    required this.dataCreacio,
    this.objecteId,
  });

  factory NotificacioModel.fromJson(Map<String, dynamic> json) {
    return NotificacioModel(
      id: json['id'] as int,
      tipus: json['tipus'] as String? ?? '',
      titol: json['titol'] as String? ?? '',
      cos: json['cos'] as String? ?? '',
      llegida: json['llegida'] as bool? ?? false,
      dataCreacio: DateTime.parse(json['dataCreacio'] as String),
      objecteId: json['objecte_id'] as int?,
    );
  }

  NotificacioModel copyWith({bool? llegida}) {
    return NotificacioModel(
      id: id,
      tipus: tipus,
      titol: titol,
      cos: cos,
      llegida: llegida ?? this.llegida,
      dataCreacio: dataCreacio,
      objecteId: objecteId,
    );
  }
}
