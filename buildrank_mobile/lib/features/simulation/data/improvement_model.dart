class ImprovementModel {
  final int idMillora;
  final String? slug;
  final String nom;
  final String descripcio;
  final String categoria;
  final String unitatBase;
  final double costEstimatBase;
  final double estalviEnergeticEstimat;
  final double impactePunts;
  final String nivellConfianca;
  final bool activa;
  final bool requereixAcordComunitat;
  final bool requereixLlicenciaMunicipal;
  final bool requereixTecnicCompetent;

  const ImprovementModel({
    required this.idMillora,
    required this.slug,
    required this.nom,
    required this.descripcio,
    required this.categoria,
    required this.unitatBase,
    required this.costEstimatBase,
    required this.estalviEnergeticEstimat,
    required this.impactePunts,
    required this.nivellConfianca,
    required this.activa,
    required this.requereixAcordComunitat,
    required this.requereixLlicenciaMunicipal,
    required this.requereixTecnicCompetent,
  });

  factory ImprovementModel.fromJson(Map<String, dynamic> json) {
    return ImprovementModel(
      idMillora: _readInt(json['idMillora']),
      slug: json['slug']?.toString(),
      nom: json['nom']?.toString() ?? 'Millora sense nom',
      descripcio: json['descripcio']?.toString() ?? '',
      categoria: json['categoria']?.toString() ?? 'altres',
      unitatBase: json['unitatBase']?.toString() ?? 'edifici',
      costEstimatBase: _readDouble(json['costEstimatBase']),
      estalviEnergeticEstimat: _readDouble(json['estalviEnergeticEstimat']),
      impactePunts: _readDouble(json['impactePunts']),
      nivellConfianca: json['nivellConfianca']?.toString() ?? 'Mig',
      activa: json['activa'] != false,
      requereixAcordComunitat: json['requereixAcordComunitat'] == true,
      requereixLlicenciaMunicipal: json['requereixLlicenciaMunicipal'] == true,
      requereixTecnicCompetent: json['requereixTecnicCompetent'] == true,
    );
  }

  String get categoriaLabel {
    switch (categoria) {
      case 'envolupant':
        return 'Envolupant';
      case 'instal_lacio_termica':
        return 'Instal·lació tèrmica';
      case 'renovables':
        return 'Renovables';
      case 'electricitat':
        return 'Electricitat';
      case 'mobilitat':
        return 'Mobilitat';
      case 'control_i_monitoratge':
        return 'Control i monitoratge';
      default:
        return categoria;
    }
  }

  String get unitatLabel {
    switch (unitatBase) {
      case 'm2':
        return '€/m²';
      case 'kwp':
        return '€/kWp';
      case 'unitat':
        return '€/unitat';
      case 'habitatge':
        return '€/habitatge';
      case 'edifici':
        return '€/edifici';
      default:
        return unitatBase;
    }
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
