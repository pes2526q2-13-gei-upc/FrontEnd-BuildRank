import 'package:buildrank_mobile/features/auth/data/auth_service.dart';
import 'package:buildrank_mobile/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_localized.dart';

void main() {
  testWidgets('EditProfileScreen renderitza dades inicials sense rol', (
    tester,
  ) async {
    await pumpLocalizedWidget(
      tester,
      const EditProfileScreen(
        initialFullName: 'Laia Pons',
        initialEmail: 'laia@example.com',
      ),
    );

    expect(find.text('Editar perfil'), findsOneWidget);
    expect(find.text('Dades personals'), findsOneWidget);
    expect(find.text('Laia'), findsOneWidget);
    expect(find.text('Pons'), findsOneWidget);
    expect(find.text('laia@example.com'), findsOneWidget);
    expect(find.text('Propietari'), findsNothing);
    expect(find.textContaining('Rol'), findsNothing);
  });

  testWidgets('EditProfileScreen desa nomes dades personals', (tester) async {
    final fake = FakeAuthService();

    await pumpLocalizedWidget(
      tester,
      EditProfileScreen(
        initialFullName: 'Laia Pons',
        initialEmail: 'laia@example.com',
        authService: fake,
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), 'Mar');
    await tester.enterText(find.byType(TextField).at(1), 'Serra');
    await tester.enterText(find.byType(TextField).at(2), 'mar@example.com');

    final saveButton = find.widgetWithText(ElevatedButton, 'Guardar canvis');

    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();

    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    await tester.pump();
    await tester.pumpAndSettle();

    expect(fake.updateCalls, 1);
    expect(fake.lastFirstName, 'Mar');
    expect(fake.lastLastName, 'Serra');
    expect(fake.lastEmail, 'mar@example.com');
  });
}

class FakeAuthService extends AuthService {
  int updateCalls = 0;
  String? lastFirstName;
  String? lastLastName;
  String? lastEmail;

  @override
  Future<Map<String, dynamic>> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    updateCalls++;
    lastFirstName = firstName;
    lastLastName = lastName;
    lastEmail = email;

    return {'first_name': firstName, 'last_name': lastName, 'email': email};
  }
}
