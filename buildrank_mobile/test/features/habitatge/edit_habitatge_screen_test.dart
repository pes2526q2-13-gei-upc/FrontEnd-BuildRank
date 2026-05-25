import 'package:buildrank_mobile/features/habitatge/presentation/screens/edit_habitatge_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_localized.dart';

void main() {
  testWidgets('EditHabitatgeScreen renderitza formulari amb dades inicials', (
    tester,
  ) async {
    await pumpLocalizedWidget(
      tester,
      const EditHabitatgeScreen(
        idEdifici: 1,
        buildingTitle: 'Edifici Test',
        initialHabitatge: {
          'referenciaCadastral': '1234567DF3813A0001AB',
          'planta': '2',
          'porta': '1',
          'superficie': 86.5,
          'anyReforma': 2020,
        },
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Edifici Test'), findsOneWidget);
    expect(find.textContaining('Dades de'), findsWidgets);
    expect(find.text('1234567DF3813A0001AB'), findsOneWidget);
    expect(find.byType(TextFormField), findsWidgets);
  });
}
