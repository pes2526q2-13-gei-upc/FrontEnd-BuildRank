import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buildrank_mobile/features/buildingRequests/presentation/screens/pending_building_requests_screen.dart';
import 'package:buildrank_mobile/features/buildingRequests/data/pending_building_requests_service.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';

void main() {
  Widget buildTestable({required String userRole}) {
    return MaterialApp(
      locale: const Locale('ca'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: PendingBuildingRequestsScreen(
        idEdifici: 1,
        buildingTitle: 'Edifici test',
        userRole: userRole,
        requestsService: FakePendingBuildingRequestsService(),
      ),
    );
  }

  group('PendingBuildingRequestsScreen', () {
    testWidgets('si no és admin mostra estat de permís denegat', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestable(userRole: 'owner'));
      await tester.pump();

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
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

class FakePendingBuildingRequestsService
    extends PendingBuildingRequestsService {
  FakePendingBuildingRequestsService();

  final List<PendingBuildingRequestItem> items = [
    PendingBuildingRequestItem(
      id: 101,
      requesterName: 'Laia Pons',
      requesterEmail: 'laia.pons@mail.com',
      refCadastral: '1234567DF3813A0001AB',
      planta: '2',
      porta: '1',
      superficie: 86.5,
      submittedAt: DateTime(2026, 1, 1, 10, 30),
    ),
    PendingBuildingRequestItem(
      id: 102,
      requesterName: 'Marc Serra',
      requesterEmail: 'marc.serra@mail.com',
      refCadastral: '1234567DF3813A0002CD',
      planta: '3',
      porta: '2',
      superficie: 79.0,
      submittedAt: DateTime(2026, 1, 2, 11, 0),
    ),
  ];

  @override
  Future<List<PendingBuildingRequestItem>> getPendingRequests({
    required int idEdifici,
  }) async {
    return List<PendingBuildingRequestItem>.from(items);
  }

  @override
  Future<void> validateRequest({
    required String referenciaCadastral,
    required bool accepted,
  }) async {
    items.removeWhere((item) => item.refCadastral == referenciaCadastral);
  }
}
