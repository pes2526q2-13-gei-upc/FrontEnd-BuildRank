import 'package:buildrank_mobile/features/auth/data/auth_service.dart';
import 'package:buildrank_mobile/features/formBuilding/data/building_service.dart';
import 'package:buildrank_mobile/features/notifications/data/notifications_service.dart';
import 'package:buildrank_mobile/features/profile/presentation/screens/profile_screen.dart';
import 'package:buildrank_mobile/features/weather/data/weather_model.dart';
import 'package:buildrank_mobile/features/weather/data/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_localized.dart';

void main() {
  testWidgets('ProfileScreen renderitza perfil carregat i estat buit', (
    tester,
  ) async {
    await pumpLocalizedWidget(
      tester,
      ProfileScreen(
        authService: FakeAuthService(role: 'admin'),
        buildingService: FakeBuildingService(),
        notificacionsService: FakeNotificacionsService(),
        weatherService: FakeWeatherService(),
      ),
      size: const Size(900, 1000),
    );

    expect(find.byType(CircularProgressIndicator), findsWidgets);

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Laia Pons'), findsOneWidget);
    expect(find.text('laia@example.com'), findsOneWidget);
    expect(find.text('Administrador de finca'), findsOneWidget);
    expect(find.textContaining('Mapa'), findsWidgets);
    expect(find.textContaining('Barcelona'), findsOneWidget);
    expect(find.textContaining('Encara no tens cap edifici'), findsOneWidget);
    expect(find.textContaining('Informes'), findsNothing);
    expect(find.textContaining('reinici'), findsNothing);
    expect(find.text('Els meus xats'), findsOneWidget);
  });

  testWidgets('ProfileScreen mostra estat error si falla el perfil', (
    tester,
  ) async {
    await pumpLocalizedWidget(
      tester,
      ProfileScreen(
        authService: FakeAuthService(shouldThrow: true),
        buildingService: FakeBuildingService(),
        notificacionsService: FakeNotificacionsService(),
        weatherService: FakeWeatherService(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Error fake de perfil'), findsOneWidget);
    expect(find.text('Torna-ho a provar'), findsOneWidget);
  });
}

class FakeAuthService extends AuthService {
  final bool shouldThrow;
  final String role;

  FakeAuthService({this.shouldThrow = false, this.role = 'owner'});

  @override
  Future<Map<String, dynamic>> getMe() async {
    if (shouldThrow) throw Exception('Error fake de perfil');
    return {
      'first_name': 'Laia',
      'last_name': 'Pons',
      'email': 'laia@example.com',
      'role': role,
    };
  }

  @override
  Future<void> logout() async {}
}

class FakeBuildingService extends BuildingService {
  @override
  Future<List<Map<String, dynamic>>> getMyBuildings() async => [];
}

class FakeNotificacionsService extends NotificacionsService {
  @override
  Future<int> getNoLlegides() async => 2;
}

class FakeWeatherService extends WeatherService {
  @override
  Future<WeatherCurrentModel> getCurrentWeather({
    String city = 'Barcelona',
  }) async {
    return const WeatherCurrentModel(
      city: 'Barcelona',
      temperature: 21,
      precipitation: 0,
      solarIrradiance: 620,
    );
  }
}
