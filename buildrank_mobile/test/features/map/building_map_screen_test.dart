import 'package:buildrank_mobile/features/map/data/building_map_feature_model.dart';
import 'package:buildrank_mobile/features/map/data/building_map_service.dart';
import 'package:buildrank_mobile/features/map/presentation/screens/building_map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_localized.dart';

void main() {
  testWidgets('BuildingMapScreen mostra estat buit sense coordenades', (
    tester,
  ) async {
    await pumpLocalizedWidget(
      tester,
      BuildingMapScreen(service: FakeBuildingMapService()),
      size: const Size(430, 900),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text("Mapa d'edificis"), findsOneWidget);
    expect(find.text('0 edificis al mapa'), findsOneWidget);
    expect(
      find.text('No hi ha edificis amb coordenades vàlides per mostrar.'),
      findsOneWidget,
    );
  });
}

class FakeBuildingMapService extends BuildingMapService {
  @override
  Future<BuildingMapResponse> getBuildingsForMap({
    String scope = 'public',
    String? search,
    double? scoreMin,
    int limit = 500,
  }) async {
    return const BuildingMapResponse(
      count: 0,
      scope: 'public',
      limit: 500,
      truncated: false,
      features: [],
    );
  }
}
