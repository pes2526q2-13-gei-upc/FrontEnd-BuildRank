class WeatherCurrentModel {
  final String city;
  final double? temperature;
  final double? precipitation;
  final double? solarIrradiance;

  const WeatherCurrentModel({
    required this.city,
    this.temperature,
    this.precipitation,
    this.solarIrradiance,
  });

  factory WeatherCurrentModel.fromJson(Map<String, dynamic> json) {
    return WeatherCurrentModel(
      city: _readString(json['city']) ?? 'Barcelona',
      temperature: _readDouble(json['temperature']),
      precipitation: _readDouble(json['precipitation']),
      solarIrradiance: _readDouble(json['solarIrradiance']),
    );
  }

  String get temperatureSummary {
    final value = temperature;
    if (value == null) return 'Temperatura no disponible';

    return 'Temperatura actual: ${_formatNumber(value)}°C';
  }

  String get precipitationSummary {
    final value = precipitation;
    if (value == null) return 'Precipitació no disponible';

    return 'Precipitació: ${_formatNumber(value)} mm';
  }

  String get solarSummary {
    final value = solarIrradiance;
    if (value == null) return 'Irradiància solar no disponible';

    return 'Irradiància solar: ${_formatNumber(value)} W/m²';
  }
}

String _formatNumber(double value) {
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }

  return value.toStringAsFixed(1);
}

String? _readString(dynamic value) {
  if (value == null) return null;

  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

double? _readDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    return double.tryParse(value.trim().replaceAll(',', '.'));
  }

  return null;
}
