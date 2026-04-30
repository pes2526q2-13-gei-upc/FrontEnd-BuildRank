import 'package:flutter/material.dart';

import 'package:buildrank_mobile/features/weather/data/weather_model.dart';
import 'package:buildrank_mobile/features/weather/data/weather_service.dart';

class WeatherAlertCard extends StatefulWidget {
  final VoidCallback onDismiss;

  const WeatherAlertCard({super.key, required this.onDismiss});

  @override
  State<WeatherAlertCard> createState() => _WeatherAlertCardState();
}

class _WeatherAlertCardState extends State<WeatherAlertCard> {
  final WeatherService _weatherService = WeatherService();

  bool _isLoading = true;
  String? _errorText;
  WeatherCurrentModel? _weather;

  @override
  void initState() {
    super.initState();
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
        _errorText = 'No s’ha pogut carregar la meteorologia.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _WeatherCardContainer(
        onDismiss: widget.onDismiss,
        child: const Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Carregant dades meteorològiques de Barcelona...',
                style: TextStyle(fontWeight: FontWeight.w600),
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
              tooltip: 'Reintentar',
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
                  'Temps actual a ${weather.city}',
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
            weather.temperatureSummary,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            weather.precipitationSummary,
            style: const TextStyle(color: Colors.black54, height: 1.35),
          ),
          const SizedBox(height: 4),
          Text(
            weather.solarSummary,
            style: const TextStyle(color: Colors.black54, height: 1.35),
          ),
          const SizedBox(height: 8),
          const Text(
            'Dades meteorològiques actualitzades pel servei XEMA.',
            style: TextStyle(color: Colors.black45, fontSize: 12),
          ),
        ],
      ),
    );
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
            tooltip: 'Amagar durant aquesta sessió',
            onPressed: onDismiss,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
