import 'package:buildrank_mobile/features/formBuilding/presentation/screens/form_building_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_localized.dart';

void main() {
  testWidgets('BuildingFormScreen renderitza el primer pas del formulari', (
    tester,
  ) async {
    await pumpLocalizedWidget(tester, const BuildingFormScreen());
    await tester.pump();

    expect(find.text("Registra l'edifici"), findsOneWidget);
    expect(find.textContaining('ubicaci'), findsOneWidget);
    expect(find.byType(TextField), findsWidgets);
  });
}
