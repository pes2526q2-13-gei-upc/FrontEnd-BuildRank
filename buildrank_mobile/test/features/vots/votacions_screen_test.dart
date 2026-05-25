import 'package:buildrank_mobile/features/vots/data/votacions_model.dart';
import 'package:buildrank_mobile/features/vots/data/votacions_service.dart';
import 'package:buildrank_mobile/features/vots/data/votation_model.dart';
import 'package:buildrank_mobile/features/vots/data/votation_service.dart';
import 'package:buildrank_mobile/features/vots/presentation/screens/votacions_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_localized.dart';

void main() {
  testWidgets('VotacionsScreen mostra estat buit amb serveis fake', (
    tester,
  ) async {
    await pumpLocalizedWidget(
      tester,
      VotacionsScreen(
        idEdifici: 1,
        userRole: 'owner',
        buildingName: 'Edifici Test',
        service: FakeVotationService(),
        legacyService: FakeVotacionsService(),
      ),
      size: const Size(430, 900),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Votació interna'), findsOneWidget);
    expect(find.textContaining('Edifici Test'), findsOneWidget);
    expect(find.textContaining('No hi ha votacions'), findsOneWidget);
  });

  testWidgets('VotacionsScreen mostra FAB per admin', (tester) async {
    await pumpLocalizedWidget(
      tester,
      VotacionsScreen(
        idEdifici: 1,
        userRole: 'admin',
        buildingName: 'Edifici Test',
        service: FakeVotationService(),
        legacyService: FakeVotacionsService(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}

class FakeVotationService extends VotationService {
  @override
  Future<List<VotationModel>> getVotacions(int idEdifici) async => [];
}

class FakeVotacionsService extends VotacionsService {
  @override
  Future<List<VotacioResumModel>> getVotacions({required int idEdifici}) async {
    return [];
  }
}
