import 'dart:typed_data';

import 'package:buildrank_mobile/features/simulation/data/implemented_improvement_model.dart';
import 'package:buildrank_mobile/features/simulation/data/improvement_model.dart';
import 'package:buildrank_mobile/features/simulation/data/saved_simulation_model.dart';
import 'package:buildrank_mobile/features/simulation/data/simulation_result_model.dart';
import 'package:buildrank_mobile/features/simulation/data/simulation_service.dart';
import 'package:buildrank_mobile/features/simulation/presentation/screens/alternativa_simulation_screen.dart';
import 'package:buildrank_mobile/features/simulation/presentation/screens/simulation_screen.dart';
import 'package:buildrank_mobile/features/vots/data/votation_model.dart';
import 'package:buildrank_mobile/features/vots/data/votation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_localized.dart';

void main() {
  testWidgets('SimulationScreen renderitza cataleg buit amb fakes', (
    tester,
  ) async {
    await pumpLocalizedWidget(
      tester,
      SimulationScreen(
        idEdifici: 1,
        userRole: 'owner',
        buildingName: 'Edifici Test',
        currentPoints: 42,
        simulationService: FakeSimulationService(),
        votationService: FakeVotationService(),
        avatarImage: MemoryImage(_transparentImage),
      ),
    );

    expect(find.text('Simulador de millores'), findsOneWidget);

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.textContaining('millores actives'), findsOneWidget);
  });

  testWidgets('AlternativaSimulationScreen mostra simulacio estatica', (
    tester,
  ) async {
    await pumpLocalizedWidget(
      tester,
      const AlternativaSimulationScreen(
        userRole: 'admin',
        buildingName: 'Edifici Test',
        currentPoints: 42,
      ),
      size: const Size(700, 900),
    );

    expect(find.text('Rendiment previst'), findsOneWidget);
    expect(find.text('0 seleccionades'), findsOneWidget);
    expect(find.textContaining('Presentar'), findsOneWidget);
  });
}

class FakeSimulationService extends SimulationService {
  @override
  Future<List<ImprovementModel>> getImprovements() async => [];

  @override
  Future<List<SavedSimulationModel>> getSavedSimulations(int idEdifici) async {
    return [];
  }

  @override
  Future<List<ImplementedImprovementModel>> getImplementedImprovements(
    int idEdifici,
  ) async {
    return [];
  }

  @override
  Future<SimulationResultModel> previewSimulation({
    required int idEdifici,
    required String descripcio,
    required List<Map<String, dynamic>> millores,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<SimulationResultModel> saveSimulation({
    required int idEdifici,
    required String descripcio,
    required List<Map<String, dynamic>> millores,
  }) {
    throw UnimplementedError();
  }
}

class FakeVotationService extends VotationService {
  @override
  Future<List<VotationModel>> getVotacions(int idEdifici) async => [];
}

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
