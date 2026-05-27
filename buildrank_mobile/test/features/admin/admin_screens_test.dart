import 'package:buildrank_mobile/features/admin/data/admin_user.dart';
import 'package:buildrank_mobile/features/admin/data/audit_log.dart';
import 'package:buildrank_mobile/features/admin/data/audit_log_service.dart';
import 'package:buildrank_mobile/features/admin/data/user_management_service.dart';
import 'package:buildrank_mobile/features/admin/presentation/screens/audit_logs_screen.dart';
import 'package:buildrank_mobile/features/admin/presentation/screens/user_management_screen.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_localized.dart';

void main() {
  testWidgets('AuditLogsScreen mostra estat buit', (tester) async {
    await pumpLocalizedWidget(
      tester,
      AuditLogsScreen(service: FakeAuditLogService()),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text("Registre d'auditoria"), findsOneWidget);
    expect(find.text('Cap registre trobat.'), findsOneWidget);
    expect(find.text('Aplicar filtres'), findsOneWidget);
  });

  testWidgets('UserManagementScreen mostra usuaris carregats', (tester) async {
    await pumpLocalizedWidget(
      tester,
      UserManagementScreen(service: FakeUserManagementService()),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text("Gestió d'usuaris"), findsWidgets);
    expect(find.text('laia@example.com'), findsOneWidget);
    expect(find.textContaining('Propietari'), findsOneWidget);
  });
}

class FakeAuditLogService extends AuditLogService {
  @override
  Future<AuditLogPage> getLogs({
    int? userId,
    String? method,
    String? resourceType,
    int? statusCode,
    String? fromDate,
    String? toDate,
    int page = 1,
  }) async {
    return const AuditLogPage(count: 0, results: []);
  }
}

class FakeUserManagementService extends UserManagementService {
  @override
  Future<List<AdminUser>> getUsers() async {
    return const [
      AdminUser(
        id: 1,
        email: 'laia@example.com',
        firstName: 'Laia',
        lastName: 'Pons',
        isActive: true,
        isSuperuser: false,
        dateJoined: '2026-01-01',
        role: 'owner',
        accountStatus: 'active',
        suspensionReason: '',
      ),
    ];
  }
}
