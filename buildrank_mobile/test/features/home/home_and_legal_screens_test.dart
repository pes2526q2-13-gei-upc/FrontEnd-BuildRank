import 'package:buildrank_mobile/features/home/presentation/screens/home_screen.dart';
import 'package:buildrank_mobile/features/legal/presentation/screens/legal_document_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_localized.dart';

void main() {
  testWidgets('HomeScreen renderitza el dashboard demo', (tester) async {
    await pumpLocalizedWidget(tester, const HomeScreen());

    expect(find.text('BuildRank'), findsOneWidget);
    expect(find.text('Resum del teu edifici'), findsOneWidget);
    expect(find.text('Indicadors clau'), findsOneWidget);
  });

  testWidgets('LegalDocumentScreen renderitza termes del servei', (
    tester,
  ) async {
    await pumpLocalizedWidget(
      tester,
      const LegalDocumentScreen(type: LegalDocumentType.terms),
    );

    expect(find.text('Termes del Servei'), findsWidgets);
    expect(find.text('1. Finalitat del servei'), findsOneWidget);
  });

  testWidgets('LegalDocumentScreen renderitza política de privacitat', (
    tester,
  ) async {
    await pumpLocalizedWidget(
      tester,
      const LegalDocumentScreen(type: LegalDocumentType.privacy),
    );

    expect(find.text('Política de Privacitat'), findsWidgets);
    expect(find.text('1. Dades tractades'), findsOneWidget);
  });
}
