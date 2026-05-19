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
      final data = await _authService.requestPasswordReset(email: email);

      final uid = data['uid']?.toString();
      final token = data['token']?.toString();

      if (uid != null && uid.isNotEmpty && token != null && token.isNotEmpty) {
        setState(() {
          _uid = uid;
          _token = token;
          _successText = 'Compte trobat. Introdueix la nova contrasenya.';
        });
      } else {
        setState(() {
          _successText =
              'Si el correu existeix, s’han generat instruccions per restablir la contrasenya.';
        });
      }
    } catch (e) {
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

  @override
  void dispose() {
    _emailController.dispose();
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
        : 'Escriu el correu associat al teu compte de BuildRank.';

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
                                'Continuar',
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
