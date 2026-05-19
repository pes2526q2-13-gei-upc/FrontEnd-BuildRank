class VotationModel {
  final int id;
  final String titol;
  final String descripcio;
  final int edificiId;
  final VotationSimulationModel? simulacio;
  final DateTime? dataInici;
  final DateTime? dataFi;
  final double quorumPercent;
  final double majoriaPercent;
  final String estat;
  final int totalVots;
  final int votsFavor;
  final int votsContra;
  final double participacioPercent;
  final double favorPercent;
  final bool potVotar;
  final String? elMeuVot;

  const VotationModel({
    required this.id,
    required this.titol,
    required this.descripcio,
    required this.edificiId,
    required this.simulacio,
    required this.dataInici,
    required this.dataFi,
    required this.quorumPercent,
    required this.majoriaPercent,
    required this.estat,
    required this.totalVots,
    required this.votsFavor,
    required this.votsContra,
    required this.participacioPercent,
    required this.favorPercent,
    required this.potVotar,
    required this.elMeuVot,
  });

  factory VotationModel.fromJson(Map<String, dynamic> json) {
    final simulacioRaw = json['simulacio'];

    return VotationModel(
      id: _readInt(json['id']),
      titol: json['titol']?.toString() ?? 'Votació',
      descripcio: json['descripcio']?.toString() ?? '',
      edificiId: _readInt(json['edifici']),
      simulacio: simulacioRaw is Map
          ? VotationSimulationModel.fromJson(
              Map<String, dynamic>.from(simulacioRaw),
            )
          : null,
      dataInici: _readDate(json['dataInici']),
      dataFi: _readDate(json['dataFi']),
      quorumPercent: _readDouble(json['quorumPercent'], fallback: 75),
      majoriaPercent: _readDouble(json['majoriaPercent'], fallback: 50),
      estat: json['estat']?.toString() ?? 'activa',
      totalVots: _readInt(json['totalVots']),
      votsFavor: _readInt(json['votsFavor']),
      votsContra: _readInt(json['votsContra']),
      participacioPercent: _readDouble(json['participacioPercent']),
      favorPercent: _readDouble(json['favorPercent']),
      potVotar: json['potVotar'] == true,
      elMeuVot: json['elMeuVot']?.toString(),
    );
  }

  bool get isActive => estat == 'activa';

  bool get isCompleted => !isActive;

  bool get hasVoted => elMeuVot != null && elMeuVot!.isNotEmpty;

  int? get diesRestants {
    if (dataFi == null) return null;
    final diff = dataFi!.difference(DateTime.now());
    if (diff.isNegative) return 0;
    return diff.inDays + (diff.inHours % 24 > 0 ? 1 : 0);
  }

  String get estatLabel {
    switch (estat) {
      case 'activa':
        return 'Activa';
      case 'aprovada':
        return 'Aprovada';
      case 'rebutjada':
        return 'Rebutjada';
      case 'caducada':
        return 'Caducada';
      default:
        return estat;
    }
  }
}

class VotationSimulationModel {
  final int id;
  final String descripcio;
  final String estatAplicacio;
  final double costEstimat;
  final double estalviAnual;
  final double reduccioConsumPrevista;
  final double reduccioEmissionsPrevista;
  final List<VotationSimulationItemModel> items;

  const VotationSimulationModel({
    required this.id,
    required this.descripcio,
    required this.estatAplicacio,
    required this.costEstimat,
    required this.estalviAnual,
    required this.reduccioConsumPrevista,
    required this.reduccioEmissionsPrevista,
    required this.items,
  });

  factory VotationSimulationModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];

    return VotationSimulationModel(
      id: _readInt(json['id']),
      descripcio: json['descripcio']?.toString() ?? 'Simulació',
      estatAplicacio: json['estatAplicacio']?.toString() ?? '',
      costEstimat: _readDouble(json['costEstimat']),
      estalviAnual: _readDouble(json['estalviAnual']),
      reduccioConsumPrevista: _readDouble(json['reduccioConsumPrevista']),
      reduccioEmissionsPrevista: _readDouble(json['reduccioEmissionsPrevista']),
      items: rawItems is List
          ? rawItems
                .whereType<Map>()
                .map(
                  (item) => VotationSimulationItemModel.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : const [],
    );
  }
}

class VotationSimulationItemModel {
  final String nom;
  final double costEstimat;
  final double impactePunts;

  const VotationSimulationItemModel({
    required this.nom,
    required this.costEstimat,
    required this.impactePunts,
  });

  factory VotationSimulationItemModel.fromJson(Map<String, dynamic> json) {
    final millora = json['millora'];
    final milloraMap = millora is Map ? Map<String, dynamic>.from(millora) : {};

    return VotationSimulationItemModel(
      nom:
          milloraMap['nom']?.toString() ?? json['nom']?.toString() ?? 'Millora',
      costEstimat: _readDouble(json['costEstimat']),
      impactePunts: _readDouble(json['impactePunts']),
    );
  }
}

int _readInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _readDouble(dynamic value, {double fallback = 0}) {
  if (value is int) return value.toDouble();
  if (value is double) return value;
  if (value is String) return double.tryParse(value) ?? fallback;
  return fallback;
}

DateTime? _readDate(dynamic value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
