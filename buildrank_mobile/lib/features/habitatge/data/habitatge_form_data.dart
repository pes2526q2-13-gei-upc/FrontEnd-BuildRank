class HabitatgeFormData {
  final int idEdifici;
  final String referenciaCadastral;
  final String planta;
  final String porta;
  final double superficie;
  final int? anyReforma;
  final DadesEnergetiquesFormData? dadesEnergetiques;

  const HabitatgeFormData({
    required this.idEdifici,
    required this.referenciaCadastral,
    required this.planta,
    required this.porta,
    required this.superficie,
    this.anyReforma,
    this.dadesEnergetiques,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'idEdifici': idEdifici,
      'referenciaCadastral': referenciaCadastral,
      'planta': planta,
      'porta': porta,
      'superficie': superficie,
      'anyReforma': anyReforma,
    };

    if (dadesEnergetiques != null) {
      json['dadesEnergetiques'] = dadesEnergetiques!.toJson();
    }

    return json;
  }
}

class DadesEnergetiquesFormData {
  final String? qualificacioGlobal;

  final double consumEnergiaPrimaria;
  final double consumEnergiaFinal;
  final double emissionsCO2;
  final double costAnualEnergia;

  final double energiaCalefaccio;
  final double energiaRefrigeracio;
  final double energiaACS;
  final double energiaEnllumenament;

  final double emissionsCalefaccio;
  final double emissionsRefrigeracio;
  final double emissionsACS;
  final double emissionsEnllumenament;

  final double aillamentTermic;
  final double valorFinestres;
  final String normativa;
  final String einaCertificacio;
  final String motiuCertificacio;

  final bool rehabilitacioEnergetica;
  final DateTime dataEntrada;

  const DadesEnergetiquesFormData({
    this.qualificacioGlobal,
    required this.consumEnergiaPrimaria,
    required this.consumEnergiaFinal,
    required this.emissionsCO2,
    required this.costAnualEnergia,
    required this.energiaCalefaccio,
    required this.energiaRefrigeracio,
    required this.energiaACS,
    required this.energiaEnllumenament,
    required this.emissionsCalefaccio,
    required this.emissionsRefrigeracio,
    required this.emissionsACS,
    required this.emissionsEnllumenament,
    required this.aillamentTermic,
    required this.valorFinestres,
    required this.normativa,
    required this.einaCertificacio,
    required this.motiuCertificacio,
    required this.rehabilitacioEnergetica,
    required this.dataEntrada,
  });

  Map<String, dynamic> toJson() {
    return {
      'qualificacioGlobal': qualificacioGlobal,
      'consumEnergiaPrimaria': consumEnergiaPrimaria,
      'consumEnergiaFinal': consumEnergiaFinal,
      'emissionsCO2': emissionsCO2,
      'costAnualEnergia': costAnualEnergia,
      'energiaCalefaccio': energiaCalefaccio,
      'energiaRefrigeracio': energiaRefrigeracio,
      'energiaACS': energiaACS,
      'energiaEnllumenament': energiaEnllumenament,
      'emissionsCalefaccio': emissionsCalefaccio,
      'emissionsRefrigeracio': emissionsRefrigeracio,
      'emissionsACS': emissionsACS,
      'emissionsEnllumenament': emissionsEnllumenament,
      'aillamentTermic': aillamentTermic,
      'valorFinestres': valorFinestres,
      'normativa': normativa,
      'einaCertificacio': einaCertificacio,
      'motiuCertificacio': motiuCertificacio,
      'rehabilitacioEnergetica': rehabilitacioEnergetica,
      'dataEntrada': _formatDateForApi(dataEntrada),
    };
  }

  String _formatDateForApi(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)}';
  }
}
