import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buildrank_mobile/features/profile/presentation/screens/add_existing_building_screen.dart';
import 'package:buildrank_mobile/features/profile/data/add_existing_building_service.dart';
import 'package:buildrank_mobile/features/verification/data/admin_verification_service.dart';

void main() {
  Widget buildTestable({required String userRole}) {
    return MaterialApp(
      home: AddExistingBuildingScreen(
        userRole: userRole,
        service: const FakeAddExistingBuildingService(),
      ),
    );
  }

  Future<void> searchBuilding(WidgetTester tester, String query) async {
    await tester.enterText(find.byType(TextField).first, query);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1100));
    await tester.pumpAndSettle();
  }

  Future<void> selectBuildingByText(WidgetTester tester, String title) async {
    final textFinder = find.text(title);
    expect(textFinder, findsOneWidget);

    await tester.ensureVisible(textFinder);
    await tester.tap(textFinder);
    await tester.pump();
    await tester.pumpAndSettle();
  }

  Future<void> scrollDown(WidgetTester tester) async {
    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
  }

  Finder textFieldByLabel(String label) {
    return find.byWidgetPredicate(
      (widget) => widget is TextField && widget.decoration?.labelText == label,
    );
  }

  group('AddExistingBuildingScreen', () {
    testWidgets('mostra ajuda inicial de cerca', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestable(userRole: 'owner'));

      expect(
        find.text('Introdueix almenys 3 caràcters per començar la cerca.'),
        findsOneWidget,
      );
      expect(find.text('Enviar sol·licitud'), findsOneWidget);
    });

    testWidgets(
      'si selecciona un edifici que accepta sol·licituds, mostra formulari d’habitatge',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildTestable(userRole: 'owner'));

        await searchBuilding(tester, 'arag');
        await selectBuildingByText(tester, 'Edifici Aragó 120');

        expect(find.textContaining('Seleccionat:'), findsOneWidget);

        await scrollDown(tester);

        expect(find.text('Dades de l’habitatge'), findsOneWidget);
        expect(
          find.textContaining('Completa les dades del teu habitatge'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'si selecciona un edifici que no accepta sol·licituds, mostra avís i no mostra formulari',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildTestable(userRole: 'owner'));

        await searchBuilding(tester, 'mall');
        await selectBuildingByText(tester, 'Casa Mallorca 210');

        expect(find.textContaining('Seleccionat:'), findsOneWidget);

        await scrollDown(tester);

        expect(
          find.textContaining(
            'Aquest edifici no admet noves sol·licituds d’unió',
          ),
          findsOneWidget,
        );
        expect(find.text('Dades de l’habitatge'), findsNothing);
      },
    );

    testWidgets('el botó només s’activa quan el formulari és vàlid', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestable(userRole: 'owner'));

      await searchBuilding(tester, 'arag');
      await selectBuildingByText(tester, 'Edifici Aragó 120');
      await scrollDown(tester);

      expect(find.text('Dades de l’habitatge'), findsOneWidget);

      final buttonFinder = find.widgetWithText(
        ElevatedButton,
        'Enviar sol·licitud',
      );

      ElevatedButton button() => tester.widget<ElevatedButton>(buttonFinder);

      expect(button().onPressed, isNull);

      await tester.enterText(
        textFieldByLabel('Referència cadastral'),
        '1234567DF3813A0001AB',
      );
      await tester.pump();
      expect(button().onPressed, isNull);

      final plantaFinder = textFieldByLabel('Planta');
      final portaFinder = textFieldByLabel('Porta');

      if (plantaFinder.evaluate().isNotEmpty) {
        await tester.enterText(plantaFinder, '2');
        await tester.pump();
        expect(button().onPressed, isNull);
      }

      if (portaFinder.evaluate().isNotEmpty) {
        await tester.enterText(portaFinder, '1');
        await tester.pump();
        expect(button().onPressed, isNull);
      }

      await tester.enterText(textFieldByLabel('Superfície (m²)'), '86.5');
      await tester.pump();

      expect(button().onPressed, isNotNull);
    });

    testWidgets('mostra text específic per admin a la descripció', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestable(userRole: 'admin'));

      expect(
        find.textContaining(
          's\'enviarà una sol·licitud per vincular-te com a administrador de finca',
        ),
        findsOneWidget,
      );
    });
  });
}

class FakeAddExistingBuildingService extends AddExistingBuildingService {
  const FakeAddExistingBuildingService();

  @override
  Future<List<ExistingBuildingItem>> searchBuildings(String query) async {
    final normalized = query.trim().toLowerCase();

    final allBuildings = <ExistingBuildingItem>[
      const ExistingBuildingItem(
        id: 1,
        name: 'Edifici Aragó 120',
        address: 'Carrer d\'Aragó, 120',
        city: 'Barcelona',
        acceptsNewRequests: true,
        isBlock: true,
      ),
      const ExistingBuildingItem(
        id: 2,
        name: 'Edifici Balmes 44',
        address: 'Carrer de Balmes, 44',
        city: 'Barcelona',
        acceptsNewRequests: true,
        isBlock: true,
      ),
      const ExistingBuildingItem(
        id: 3,
        name: 'Casa Mallorca 210',
        address: 'Carrer de Mallorca, 210',
        city: 'Barcelona',
        acceptsNewRequests: false,
        isBlock: false,
      ),
    ];

    return allBuildings.where((building) {
      return building.name.toLowerCase().contains(normalized) ||
          building.address.toLowerCase().contains(normalized) ||
          (building.city?.toLowerCase().contains(normalized) ?? false);
    }).toList();
  }

  @override
  Future<void> createJoinRequest({
    required ExistingBuildingItem building,
    required String userRole,
    required Map<String, dynamic> habitatgePayload,
    List<AdminVerificationDocumentInput> verificationDocuments = const [],
  }) async {}
}
