import 'package:buildrank_mobile/features/admin/data/user_management_service.dart';
import 'package:buildrank_mobile/features/admin/presentation/screens/users_panel.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class UserManagementScreen extends StatelessWidget {
  final UserManagementService? service;

  const UserManagementScreen({super.key, this.service});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F2),
      appBar: AppBar(
        title: Text(
          l10n.adminUserManagementTitle,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        backgroundColor: const Color(0xFFF6F7F2),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: UsersPanel(service: service),
      ),
    );
  }
}
