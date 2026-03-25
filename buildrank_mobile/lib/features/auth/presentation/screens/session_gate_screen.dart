import 'package:flutter/material.dart';

import 'package:buildrank_mobile/features/auth/data/auth_service.dart';
import 'package:buildrank_mobile/features/auth/data/token_storage.dart';
import 'package:buildrank_mobile/features/auth/presentation/screens/auth_base_screen.dart';
import 'package:buildrank_mobile/features/profile/presentation/screens/profile_screen.dart';

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

      await authService.getMe();
      return const ProfileScreen();
    } catch (_) {
      await TokenStorage.clearTokens();
      return const AuthBaseScreen();
    }
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
