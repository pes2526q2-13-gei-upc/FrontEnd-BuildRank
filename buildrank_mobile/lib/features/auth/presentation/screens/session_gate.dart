import 'package:flutter/material.dart';
import 'package:buildrank_mobile/features/auth/data/auth_service.dart';
import 'package:buildrank_mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:buildrank_mobile/features/main/presentation/screens/building_main_screen.dart';

class SessionGate extends StatefulWidget {
  const SessionGate({super.key});

  @override
  State<SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<SessionGate> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    try {
      await _authService.getMe();

      if (!mounted) return;

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
    } catch (_) {
      if (!mounted) return;

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
