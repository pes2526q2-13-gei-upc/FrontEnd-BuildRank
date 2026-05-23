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
      dataInici: _readDate(json['data_inici'] ?? json['dataInici']),
      dataFi: _readDate(json['data_fi'] ?? json['dataFi']),
      quorumPercent: _readDouble(
        json['quorum_percent'] ?? json['quorumPercent'],
        fallback: 75,
      ),
      majoriaPercent: _readDouble(
        json['majoria_percent'] ?? json['majoriaPercent'],
        fallback: 50,
      ),
      estat: json['estat']?.toString() ?? 'activa',
      totalVots: _readInt(json['total_vots'] ?? json['totalVots']),
      votsFavor: _readInt(json['vots_favor'] ?? json['votsFavor']),
      votsContra: _readInt(json['vots_contra'] ?? json['votsContra']),
      participacioPercent: _readDouble(
        json['participacio_percent'] ?? json['participacioPercent'],
      ),
      favorPercent: _readDouble(json['favor_percent'] ?? json['favorPercent']),
      potVotar: json['pot_votar'] == true || json['potVotar'] == true,
      elMeuVot: (json['el_meu_vot'] ?? json['elMeuVot'])?.toString(),
    );
  }

  String get normalizedEstat {
    return estat
        .trim()
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('-', '_')
        .replaceAll('ó', 'o')
        .replaceAll('ò', 'o')
        .replaceAll('à', 'a')
        .replaceAll('è', 'e')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ï', 'i')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u');
  }

  bool get hasReachedQuorum => participacioPercent >= quorumPercent;

  bool get isApprovedByVotes =>
      hasReachedQuorum && favorPercent >= majoriaPercent;

  bool get isRejectedByVotes =>
      hasReachedQuorum && favorPercent < majoriaPercent;

  String get effectiveNormalizedEstat {
    final value = normalizedEstat;

    final backendSaysActive =
        value == 'activa' ||
        value == 'actiu' ||
        value == 'active' ||
        value == 'oberta' ||
        value == 'open' ||
        value == 'en_curs' ||
        value == 'en_votacio';

    if (backendSaysActive && hasReachedQuorum) {
      return isApprovedByVotes ? 'aprovada' : 'rebutjada';
    }

    return value;
  }

  bool get isActive {
    final value = effectiveNormalizedEstat;

    return value == 'activa' ||
        value == 'actiu' ||
        value == 'active' ||
        value == 'oberta' ||
        value == 'open' ||
        value == 'en_curs' ||
        value == 'en_votacio';
  }

  bool get isCompleted => !isActive;

  bool get hasVoted => elMeuVot != null && elMeuVot!.isNotEmpty;

  int? get diesRestants {
    if (dataFi == null) return null;
    final diff = dataFi!.difference(DateTime.now());
    if (diff.isNegative) return 0;
    return diff.inDays + (diff.inHours % 24 > 0 ? 1 : 0);
  }

  String get estatLabel {
    switch (effectiveNormalizedEstat) {
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
      estatAplicacio:
          (json['estat_aplicacio'] ?? json['estatAplicacio'])?.toString() ?? '',
      costEstimat: _readDouble(json['cost_estimat'] ?? json['costEstimat']),
      estalviAnual: _readDouble(json['estalvi_anual'] ?? json['estalviAnual']),
      reduccioConsumPrevista: _readDouble(
        json['reduccio_consum_prevista'] ?? json['reduccioConsumPrevista'],
      ),
      reduccioEmissionsPrevista: _readDouble(
        json['reduccio_emissions_prevista'] ??
            json['reduccioEmissionsPrevista'],
      ),
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
      costEstimat: _readDouble(json['cost_estimat'] ?? json['costEstimat']),
      impactePunts: _readDouble(json['impacte_punts'] ?? json['impactePunts']),
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
