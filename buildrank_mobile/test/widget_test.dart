// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:buildrank_mobile/app/app.dart';
import 'package:buildrank_mobile/core/localization/locale_controller.dart';

void main() {
  testWidgets('BuildRankApp loads correctly', (WidgetTester tester) async {
    final localeController = LocaleController();

    await tester.pumpWidget(BuildRankApp(localeController: localeController));

    expect(find.byType(BuildRankApp), findsOneWidget);
  });
}
