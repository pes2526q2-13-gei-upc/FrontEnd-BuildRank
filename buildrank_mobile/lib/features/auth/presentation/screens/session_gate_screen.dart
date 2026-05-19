import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:buildrank_mobile/core/services/stream_service.dart';
import 'package:buildrank_mobile/features/auth/data/auth_service.dart';
import 'package:buildrank_mobile/features/xat/data/chat_service.dart';
import 'package:buildrank_mobile/features/auth/data/token_storage.dart';
import 'package:buildrank_mobile/features/auth/presentation/screens/auth_base_screen.dart';
import 'package:buildrank_mobile/features/profile/presentation/screens/profile_screen.dart';
import 'package:buildrank_mobile/features/admin/presentation/screens/system_admin_home_screen.dart';

// Decide si la app entra al auth o a la parte principal.
class SessionGateScreen extends StatefulWidget {
  const SessionGateScreen({super.key});

  @override
  State<SessionGateScreen> createState() => _SessionGateScreenState();
}

class _SessionGateScreenState extends State<SessionGateScreen> {
  late final Future<Widget> _initialScreen;

  @override
  void initState() {
    super.initState();
    _initialScreen = _resolveInitialScreen();
  }

  // Comprueba si hay token y si el backend aún reconoce la sesión.
  Future<Widget> _resolveInitialScreen() async {
    final authService = AuthService();

    try {
      final hasSession = await authService.hasSession();

      if (!hasSession) {
        return const AuthBaseScreen();
      }

      final me = await authService.getMe();
      final isSystemAdmin = me['is_system_admin'] == true;

      try {
        await _connectStreamUser(me);
      } catch (_) {}

      if (isSystemAdmin) {
        return const AdminPanelScreen();
      }

      return const ProfileScreen();
    } catch (_) {
      await TokenStorage.clearTokens();
      return const AuthBaseScreen();
    }
  }

  Future<void> _connectStreamUser(Map<String, dynamic> me) async {
    final email = me['email'] as String? ?? '';
    final userId = 'user_${me['id']}';
    final userName = email.isNotEmpty ? email.split('@').first : userId;

    await ChatService.provisionAndReconnect(userName: userName);

    try {
      await FirebaseMessaging.instance.requestPermission().timeout(
        const Duration(seconds: 5),
      );
      final token = await FirebaseMessaging.instance.getToken().timeout(
        const Duration(seconds: 5),
      );
      if (token != null) await StreamService.registerFcmToken(token);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _initialScreen,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return snapshot.data ?? const AuthBaseScreen();
      },
    );
  }
}
