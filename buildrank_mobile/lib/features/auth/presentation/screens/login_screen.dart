import 'dart:async';

import 'package:buildrank_mobile/features/auth/data/auth_service.dart';
import 'package:buildrank_mobile/features/auth/data/google_signin_web_button.dart';
import 'package:buildrank_mobile/features/xat/data/chat_service.dart';
import 'package:buildrank_mobile/features/profile/presentation/screens/profile_screen.dart';
import 'package:buildrank_mobile/features/admin/presentation/screens/system_admin_home_screen.dart';
import 'package:buildrank_mobile/features/auth/presentation/screens/password_reset_screen.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  String? _errorText;

  // Stream subscription per al flux de Google Sign-In en Web. El plugin
  // emet un esdeveniment quan l'usuari clica el botó oficial de GIS.
  StreamSubscription<GoogleSignInAuthenticationEvent>? _googleAuthSub;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _setupWebGoogleSignIn();
    }
  }

  Future<void> _setupWebGoogleSignIn() async {
    try {
      await _authService.ensureGoogleSignInReady();
    } catch (_) {
      // Si la inicialització falla, el botó no servirà però la pantalla
      // segueix funcionant amb login per email/contrasenya.
      return;
    }
    if (!mounted) return;
    _googleAuthSub = GoogleSignIn.instance.authenticationEvents.listen(
      _handleWebGoogleEvent,
    );
  }

  Future<void> _handleWebGoogleEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    if (event is! GoogleSignInAuthenticationEventSignIn) return;

    final idToken = event.user.authentication.idToken;
    if (idToken == null || idToken.isEmpty) {
      if (mounted) {
        setState(() => _errorText = 'Google no ha retornat cap id_token.');
      }
      return;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      await _authService.exchangeGoogleIdToken(idToken: idToken);
      if (!mounted) return;
      await _finishAuthenticatedNavigation();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorText = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleLogin() async {
    final l10n = AppLocalizations.of(context);
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorText = l10n.loginMissingFieldsError;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      await _authService.login(email: email, password: password);
      await _finishAuthenticatedNavigation();
    } catch (e) {
      setState(() {
        _errorText = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      await _authService.loginWithGoogle();
      await _finishAuthenticatedNavigation();
    } catch (e) {
      setState(() {
        _errorText = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _finishAuthenticatedNavigation() async {
    final me = await _authService.getMe();
    final isSystemAdmin = me['is_system_admin'] == true;

    // Connecta el xat en segon pla: la handshake amb GetStream pot trigar
    // 20-30s i no ha de bloquejar la navegació post-login.
    final userName = '${me['first_name'] ?? ''} ${me['last_name'] ?? ''}'
        .trim();
    ChatService.startSessionInBackground(
      userName: userName.isNotEmpty ? userName : null,
    );

    if (!mounted) return;

    if (isSystemAdmin) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AdminPanelScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );
    }
  }

  @override
  void dispose() {
    _googleAuthSub?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          children: [
            const SizedBox(height: 10),
            Text(
              l10n.loginWelcomeTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.loginWelcomeSubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 18,
                    offset: Offset(0, 8),
                    color: Color.fromRGBO(0, 0, 0, 0.06),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.loginCardTitle,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.loginCardSubtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: l10n.emailLabel,
                      hintText: l10n.emailHint,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: l10n.passwordLabel,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const PasswordResetScreen(),
                                ),
                              );
                            },
                      child: Text(l10n.loginForgotPassword),
                    ),
                  ),
                  if (_errorText != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ],
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      child: _isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              l10n.loginButton,
                              style: const TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // En Web, `google_sign_in` 7.x requereix renderitzar el
                  // botó oficial de Google Identity Services (no accepta
                  // crida imperativa). El resultat arriba pel stream
                  // `authenticationEvents`, gestionat a `_handleWebGoogleEvent`.
                  if (kIsWeb)
                    Center(child: renderGoogleSignInWebButton())
                  else
                    OutlinedButton.icon(
                      onPressed: _isLoading ? null : _handleGoogleLogin,
                      icon: const Icon(Icons.g_mobiledata),
                      label: Text(l10n.loginGoogleButton),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
