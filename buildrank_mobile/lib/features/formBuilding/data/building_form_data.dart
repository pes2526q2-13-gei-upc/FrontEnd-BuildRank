class BuildingFormData {
  final String carrer;
  final int numero;
  final String codiPostal;
  final String barri;
  final double? latitud;
  final double? longitud;
  final String? zonaClimatica;

  final String tipologia;
  final int anyConstruccio;
  final double superficieTotal;
  final int nombrePlantes;
  final String reglament;
  final String orientacioPrincipal;

  const BuildingFormData({
    required this.carrer,
    required this.numero,
    required this.codiPostal,
    required this.barri,
    this.latitud,
    this.longitud,
    this.zonaClimatica,
    required this.tipologia,
    required this.anyConstruccio,
    required this.superficieTotal,
    required this.nombrePlantes,
    required this.reglament,
    required this.orientacioPrincipal,
  });

  Map<String, dynamic> toLocalitzacioJson() {
    return {
      'carrer': carrer,
      'numero': numero,
      'codiPostal': codiPostal,
      'barri': barri,
      'latitud': latitud,
      'longitud': longitud,
      'zonaClimatica': zonaClimatica,
    };
  }

  Map<String, dynamic> toEdificiJson() {
    return {
      'anyConstruccio': anyConstruccio,
      'tipologia': tipologia,
      'superficieTotal': superficieTotal,
      'nombrePlantes': nombrePlantes,
      'reglament': reglament,
      'orientacioPrincipal': orientacioPrincipal,
    };
  }
}
