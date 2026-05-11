import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buildrank_mobile/features/buildingRequests/presentation/screens/pending_building_requests_screen.dart';

void main() {
  Widget buildTestable({required String userRole}) {
    return MaterialApp(
      home: PendingBuildingRequestsScreen(
        idEdifici: 1,
        buildingTitle: 'Edifici Aragó 120',
        userRole: userRole,
      ),
    );
  }

  group('PendingBuildingRequestsScreen', () {
    testWidgets('si no és admin mostra estat de permís denegat', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestable(userRole: 'owner'));
      await tester.pump();

      expect(
        find.text(
          'Només l’administrador de finca pot gestionar les sol·licituds pendents.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('si és admin carrega la pantalla de sol·licituds pendents', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestable(userRole: 'admin'));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      expect(find.text('Sol·licituds pendents'), findsWidgets);
      expect(find.widgetWithText(ElevatedButton, 'Acceptar'), findsWidgets);
      expect(find.widgetWithText(OutlinedButton, 'Rebutjar'), findsWidgets);
    });

    testWidgets(
      'acceptar una sol·licitud elimina la primera sol·licitud visible',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildTestable(userRole: 'admin'));
        await tester.pump(const Duration(milliseconds: 600));
        await tester.pumpAndSettle();

        expect(find.text('Laia Pons'), findsOneWidget);

        await tester.tap(find.widgetWithText(ElevatedButton, 'Acceptar').first);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));
        await tester.pumpAndSettle();

        expect(find.text('Laia Pons'), findsNothing);
      },
    );

    testWidgets(
      'rebutjar una sol·licitud elimina la primera sol·licitud visible',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildTestable(userRole: 'admin'));
        await tester.pump(const Duration(milliseconds: 600));
        await tester.pumpAndSettle();

        expect(find.text('Laia Pons'), findsOneWidget);

        await tester.tap(find.widgetWithText(OutlinedButton, 'Rebutjar').first);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));
        await tester.pumpAndSettle();

        expect(find.text('Laia Pons'), findsNothing);
      },
    );
  });
}

Matcher findsFewerThan(int previousCount) {
  return predicate<Finder>((finder) {
    return finder.evaluate().length < previousCount;
  });
}
