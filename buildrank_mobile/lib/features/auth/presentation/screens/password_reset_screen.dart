import 'package:buildrank_mobile/features/auth/data/auth_service.dart';
import 'package:flutter/material.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _authService = AuthService();

  final _emailController = TextEditingController();
  final _resetLinkController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorText;
  String? _successText;

  String? _uid;
  String? _token;

  bool get _isConfirmStep => _uid != null && _token != null;

  Future<void> _requestReset() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _errorText = 'Introdueix el teu correu electrònic.';
        _successText = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
      _successText = null;
    });

    try {
      await _authService.requestPasswordReset(email: email);

      if (!mounted) return;

      setState(() {
        _successText =
            'Si el correu existeix, rebràs un enllaç per restablir la contrasenya. Enganxa’l aquí quan el tinguis.';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorText = e.toString().replaceFirst('Exception: ', '');
        _successText = null;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _continueWithResetLink() {
    final rawLink = _resetLinkController.text.trim();

    if (rawLink.isEmpty) {
      setState(() {
        _errorText = 'Enganxa l’enllaç de recuperació rebut per email.';
        _successText = null;
      });
      return;
    }

    final credentials = _extractCredentialsFromLink(rawLink);

    if (credentials == null) {
      setState(() {
        _errorText =
            'No s’han pogut trobar els paràmetres uid i token dins l’enllaç.';
        _successText = null;
      });
      return;
    }

    setState(() {
      _uid = credentials.uid;
      _token = credentials.token;
      _errorText = null;
      _successText = 'Enllaç validat. Introdueix la nova contrasenya.';
    });
  }

  _ResetCredentials? _extractCredentialsFromLink(String rawLink) {
    final parsed = Uri.tryParse(rawLink);

    if (parsed != null) {
      final uid = parsed.queryParameters['uid'];
      final token = parsed.queryParameters['token'];

      if (uid != null && uid.isNotEmpty && token != null && token.isNotEmpty) {
        return _ResetCredentials(uid: uid, token: token);
      }
    }

    final uidMatch = RegExp(r'uid=([^&\s]+)').firstMatch(rawLink);
    final tokenMatch = RegExp(r'token=([^&\s]+)').firstMatch(rawLink);

    final uid = uidMatch?.group(1);
    final token = tokenMatch?.group(1);

    if (uid != null && uid.isNotEmpty && token != null && token.isNotEmpty) {
      return _ResetCredentials(
        uid: Uri.decodeComponent(uid),
        token: Uri.decodeComponent(token),
      );
    }

    return null;
  }

  Future<void> _confirmReset() async {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorText = 'Introdueix i confirma la nova contrasenya.';
        _successText = null;
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _errorText = 'Les contrasenyes no coincideixen.';
        _successText = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
      _successText = null;
    });

    try {
      await _authService.confirmPasswordReset(
        uid: _uid!,
        token: _token!,
        password: password,
        passwordConfirm: confirmPassword,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contrasenya restablerta correctament.')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorText = e.toString().replaceFirst('Exception: ', '');
        _successText = null;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _backToEmailStep() {
    setState(() {
      _uid = null;
      _token = null;
      _passwordController.clear();
      _confirmPasswordController.clear();
      _errorText = null;
      _successText = null;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _resetLinkController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = _isConfirmStep
        ? 'Crea una nova contrasenya'
        : 'Recupera la contrasenya';

    final subtitle = _isConfirmStep
        ? 'Introdueix una nova contrasenya per al teu compte.'
        : 'Escriu el correu associat al teu compte i enganxa l’enllaç rebut per email.';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7F2),
        elevation: 0,
        title: const Text('Recuperar contrasenya'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          children: [
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
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
                  if (!_isConfirmStep) ...[
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Correu electrònic',
                        hintText: 'nom@exemple.com',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _requestReset,
                        child: _isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Enviar instruccions',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      'Ja tens l’enllaç?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Enganxa aquí l’enllaç rebut per email. BuildRank n’extraurà automàticament el uid i el token.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _resetLinkController,
                      minLines: 1,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Enllaç de recuperació',
                        hintText:
                            'https://.../reset-password?uid=...&token=...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.link),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 54,
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : _continueWithResetLink,
                        child: const Text(
                          'Continuar amb l’enllaç',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ] else ...[
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Nova contrasenya',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirmar nova contrasenya',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _confirmReset,
                        child: _isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Restablir contrasenya',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _isLoading ? null : _backToEmailStep,
                      child: const Text('Tornar a enganxar un altre enllaç'),
                    ),
                  ],
                  if (_errorText != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ],
                  if (_successText != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _successText!,
                      style: const TextStyle(color: Colors.green, fontSize: 13),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResetCredentials {
  final String uid;
  final String token;

  const _ResetCredentials({required this.uid, required this.token});
}
