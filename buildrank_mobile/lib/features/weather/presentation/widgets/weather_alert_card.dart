import 'package:flutter/material.dart';

import 'package:buildrank_mobile/features/weather/data/weather_model.dart';
import 'package:buildrank_mobile/features/weather/data/weather_service.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';

class WeatherAlertCard extends StatefulWidget {
  final VoidCallback onDismiss;
  final WeatherService? service;

  const WeatherAlertCard({super.key, required this.onDismiss, this.service});

  @override
  State<WeatherAlertCard> createState() => _WeatherAlertCardState();
}

class _WeatherAlertCardState extends State<WeatherAlertCard> {
  late final WeatherService _weatherService;

  bool _isLoading = true;
  String? _errorText;
  WeatherCurrentModel? _weather;

  @override
  void initState() {
    super.initState();
    _weatherService = widget.service ?? WeatherService();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final weather = await _weatherService.getCurrentWeather(
        city: 'Barcelona',
      );

      if (!mounted) return;

      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } on WeatherApiException catch (e) {
      if (!mounted) return;

      setState(() {
        _errorText = e.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _errorText = AppLocalizations.of(context).weatherLoadError;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      final l10n = AppLocalizations.of(context);

      return _WeatherCardContainer(
        onDismiss: widget.onDismiss,
        child: Row(
          children: [
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                l10n.weatherLoadingBarcelona,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    }

    if (_errorText != null) {
      return _WeatherCardContainer(
        onDismiss: widget.onDismiss,
        child: Row(
          children: [
            const Icon(Icons.cloud_off_outlined, color: Color(0xFF92400E)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _errorText!,
                style: const TextStyle(
                  color: Color(0xFF92400E),
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ),
            IconButton(
              tooltip: AppLocalizations.of(context).commonRetry,
              onPressed: _loadWeather,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
      );
    }

    final weather = _weather;

    if (weather == null) {
      return const SizedBox.shrink();
    }

    return _WeatherCardContainer(
      onDismiss: widget.onDismiss,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wb_sunny_outlined, color: Color(0xFF16A34A)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  AppLocalizations.of(
                    context,
                  ).weatherCurrentInCity(weather.city),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _temperatureSummary(context, weather),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _precipitationSummary(context, weather),
            style: const TextStyle(color: Colors.black54, height: 1.35),
          ),
          const SizedBox(height: 4),
          Text(
            _solarSummary(context, weather),
            style: const TextStyle(color: Colors.black54, height: 1.35),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).weatherUpdatedByXema,
            style: const TextStyle(color: Colors.black45, fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _temperatureSummary(
    BuildContext context,
    WeatherCurrentModel weather,
  ) {
    final value = weather.temperature;
    final l10n = AppLocalizations.of(context);
    if (value == null) return l10n.weatherTemperatureUnavailable;

    return l10n.weatherCurrentTemperature(_formatWeatherNumber(value));
  }

  String _precipitationSummary(
    BuildContext context,
    WeatherCurrentModel weather,
  ) {
    final value = weather.precipitation;
    final l10n = AppLocalizations.of(context);
    if (value == null) return l10n.weatherPrecipitationUnavailable;

    return l10n.weatherPrecipitation(_formatWeatherNumber(value));
  }

  String _solarSummary(BuildContext context, WeatherCurrentModel weather) {
    final value = weather.solarIrradiance;
    final l10n = AppLocalizations.of(context);
    if (value == null) return l10n.weatherSolarIrradianceUnavailable;

    return l10n.weatherSolarIrradiance(_formatWeatherNumber(value));
  }

  String _formatWeatherNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }

    return value.toStringAsFixed(1);
  }
}

class _WeatherCardContainer extends StatelessWidget {
  final Widget child;
  final VoidCallback onDismiss;

  const _WeatherCardContainer({required this.child, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF8EE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: child),
          IconButton(
            tooltip: AppLocalizations.of(context).commonHideForSession,
            onPressed: onDismiss,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
