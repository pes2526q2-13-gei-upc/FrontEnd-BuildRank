import 'package:buildrank_mobile/features/auth/presentation/screens/account_blocked_screen.dart';
import 'package:buildrank_mobile/features/auth/presentation/screens/account_suspended_screen.dart';
import 'package:buildrank_mobile/features/auth/presentation/screens/auth_base_screen.dart';
import 'package:buildrank_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:buildrank_mobile/features/auth/presentation/screens/password_reset_screen.dart';
import 'package:buildrank_mobile/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_localized.dart';

void main() {
  group('Auth screens', () {
    testWidgets('LoginScreen renderitza el formulari bàsic', (tester) async {
      await pumpLocalizedWidget(tester, const LoginScreen());

      expect(find.text('Benvingut a BuildRank'), findsOneWidget);
      expect(find.text('Inicia sessió'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Continuar amb Google'), findsOneWidget);
    });

    testWidgets('RegisterScreen renderitza camps i rols principals', (
      tester,
    ) async {
      await pumpLocalizedWidget(tester, const RegisterScreen());

      expect(find.text('Crea un compte'), findsOneWidget);
      expect(find.text('Admin.\nfinca'), findsOneWidget);
      expect(find.text('Propietari'), findsOneWidget);
      expect(find.text('Llogater'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(5));
    });

    testWidgets('PasswordResetScreen mostra pas inicial de recuperació', (
      tester,
    ) async {
      await pumpLocalizedWidget(tester, const PasswordResetScreen());

      expect(find.text('Recupera la contrasenya'), findsOneWidget);
      expect(find.text('Enviar instruccions'), findsOneWidget);
      expect(find.text("Ja tens l'enllaç?"), findsOneWidget);
    });

    testWidgets('AuthBaseScreen comença amb pestanya de login', (tester) async {
      await pumpLocalizedWidget(tester, const AuthBaseScreen());
      await tester.pump();

      expect(find.text('Inicia sessió'), findsWidgets);
      expect(find.text("Registra't"), findsOneWidget);
      expect(find.byType(DropdownButton<Locale>), findsOneWidget);
    });

    testWidgets('AccountBlockedScreen mostra estat bloquejat', (tester) async {
      await pumpLocalizedWidget(tester, const AccountBlockedScreen());

      expect(find.byIcon(Icons.block_rounded), findsOneWidget);
      expect(find.text('Compte bloquejat'), findsOneWidget);
      expect(find.text("Torna a l'inici de sessió"), findsOneWidget);
    });

    testWidgets('AccountSuspendedScreen mostra estat suspès', (tester) async {
      await pumpLocalizedWidget(tester, const AccountSuspendedScreen());

      expect(find.byIcon(Icons.pause_circle_outline_rounded), findsOneWidget);
      expect(find.text('Compte suspès'), findsOneWidget);
      expect(find.text("Torna a l'inici de sessió"), findsOneWidget);
    });
  });
}
