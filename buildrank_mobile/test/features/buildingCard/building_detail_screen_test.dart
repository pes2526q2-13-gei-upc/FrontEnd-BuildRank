import 'dart:typed_data';

import 'package:buildrank_mobile/features/buildingCard/presentation/screens/building_card_screen.dart';
import 'package:buildrank_mobile/features/formBuilding/data/building_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_localized.dart';

void main() {
  testWidgets('BuildingDetailScreen renderitza detall basic carregat', (
    tester,
  ) async {
    await pumpLocalizedWidget(
      tester,
      BuildingDetailScreen(
        idEdifici: 1,
        building: _building,
        userRole: 'owner',
        title: 'Edifici Test',
        address: 'Carrer Test, 1',
        score: 72,
        buildingService: FakeBuildingService(),
        avatarImage: MemoryImage(_transparentImage),
      ),
      size: const Size(900, 1200),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Carrer Test, 1'), findsOneWidget);
    expect(find.text('72'), findsOneWidget);
    expect(find.text('RENDIMENT'), findsOneWidget);
    expect(find.textContaining('INS'), findsOneWidget);
    expect(find.textContaining('Informe'), findsNothing);
    expect(find.textContaining('Silver'), findsNothing);
    expect(find.textContaining('League'), findsNothing);
    expect(find.textContaining('revis'), findsNothing);
    expect(find.textContaining('habitatge'), findsWidgets);
  });
}

class FakeBuildingService extends BuildingService {
  @override
  Future<Map<String, dynamic>> getBuildingDetail(int idEdifici) async {
    return _building;
  }

  @override
  Future<BuildingBadgesResponse> getBuildingBadges(int idEdifici) async {
    return const BuildingBadgesResponse(badges: [], summary: [], total: 0);
  }
}

final _building = {
  'idEdifici': 1,
  'nom': 'Edifici Test',
  'puntuacio': 72,
  'superficieTotal': 1250,
  'nombrePlantes': 6,
  'orientacioPrincipal': 'Sud',
  'actiu': true,
  'localitzacio': {
    'carrer': 'Carrer Test',
    'numero': 1,
    'barri': 'Eixample',
    'codiPostal': '08001',
    'zonaClimatica': 'C2',
  },
};

final Uint8List _transparentImage = Uint8List.fromList([
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);
