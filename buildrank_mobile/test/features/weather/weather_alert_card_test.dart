import 'package:buildrank_mobile/features/weather/data/weather_model.dart';
import 'package:buildrank_mobile/features/weather/data/weather_service.dart';
import 'package:buildrank_mobile/features/weather/presentation/widgets/weather_alert_card.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_localized.dart';

void main() {
  testWidgets('WeatherAlertCard renderitza dades meteorologiques', (
    tester,
  ) async {
    await pumpLocalizedWidget(
      tester,
      WeatherAlertCard(onDismiss: () {}, service: FakeWeatherService()),
    );

    expect(find.textContaining('Carregant'), findsOneWidget);

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('Barcelona'), findsOneWidget);
    expect(find.textContaining('21'), findsOneWidget);
  });

  testWidgets('WeatherAlertCard renderitza estat error', (tester) async {
    await pumpLocalizedWidget(
      tester,
      WeatherAlertCard(
        onDismiss: () {},
        service: FakeWeatherService(shouldThrow: true),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Error fake de meteorologia'), findsOneWidget);
  });
}

class FakeWeatherService extends WeatherService {
  final bool shouldThrow;

  FakeWeatherService({this.shouldThrow = false});

  @override
  Future<WeatherCurrentModel> getCurrentWeather({
    String city = 'Barcelona',
  }) async {
    if (shouldThrow) {
      throw const WeatherApiException('Error fake de meteorologia');
    }
    return const WeatherCurrentModel(
      city: 'Barcelona',
      temperature: 21,
      precipitation: 0,
      solarIrradiance: 620,
    );
  }
}
