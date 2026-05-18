import 'package:flutter/material.dart';

import 'package:buildrank_mobile/features/auth/data/auth_service.dart';
import 'package:buildrank_mobile/core/services/stream_service.dart';
import 'package:buildrank_mobile/features/admin/presentation/screens/system_admin_home_screen.dart';
import 'package:buildrank_mobile/features/profile/presentation/screens/profile_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class RegisterScreen extends StatefulWidget {
  final void Function(String email)? onRegisterSuccess;

  const RegisterScreen({super.key, this.onRegisterSuccess});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();

  String _selectedRole = 'tenant';
  bool _acceptedTerms = false;
  bool _isLoading = false;
  String? _errorText;
  String? _successText;

  Future<void> _handleRegister() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      setState(() {
        _errorText = 'Has d’omplir tots els camps.';
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

    if (!_acceptedTerms) {
      setState(() {
        _errorText = 'Has d’acceptar els termes i condicions.';
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
      await _authService.register(
        email: email,
        password: password,
        passwordConfirm: confirmPassword,
        role: _selectedRole,
        firstName: firstName,
        lastName: lastName,
      );

      if (!mounted) return;

      _firstNameController.clear();
      _lastNameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      setState(() {
        _selectedRole = 'tenant';
        _acceptedTerms = false;
        _successText = 'Compte creat correctament. Ara ja pots iniciar sessió.';
      });

      if (widget.onRegisterSuccess != null) {
        widget.onRegisterSuccess!(email);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registre completat correctament.')),
        );
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

  Future<void> _finishAuthenticatedNavigation() async {
    final me = await _authService.getMe();
    final isSystemAdmin = me['is_system_admin'] == true;

    try {
      final userId = 'user_${me['id']}';
      final userName = '${me['first_name'] ?? ''} ${me['last_name'] ?? ''}'
          .trim();

      await StreamService.connectUser(
        userId: userId,
        userName: userName.isNotEmpty ? userName : userId,
      );

      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) await StreamService.registerFcmToken(token);
    } catch (_) {}

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

  Future<void> _handleGoogleRegister() async {
    if (!_acceptedTerms) {
      setState(() {
        _errorText = 'Has d’acceptar els termes i condicions.';
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
      await _authService.loginWithGoogle(role: _selectedRole);
      await _finishAuthenticatedNavigation();
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

  Widget _buildRoleCard(String role, IconData icon, String label) {
    final isSelected = _selectedRole == role;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedRole = role;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEAF7EE) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? Colors.green : Colors.black12,
              width: isSelected ? 1.8 : 1.1,
            ),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Color.fromRGBO(76, 175, 80, 0.10),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.green : Colors.black54),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.green.shade800 : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermsBlock() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _acceptedTerms = !_acceptedTerms;
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            margin: const EdgeInsets.only(top: 2),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: _acceptedTerms ? Colors.green : Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _acceptedTerms ? Colors.green : Colors.grey.shade400,
                width: 1.4,
              ),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: _acceptedTerms
                  ? const Icon(
                      Icons.check,
                      key: ValueKey('check'),
                      size: 16,
                      color: Colors.white,
                    )
                  : const SizedBox(key: ValueKey('empty')),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text.rich(
              TextSpan(
                text: 'Accepto els ',
                style: TextStyle(fontSize: 14, color: Colors.black87),
                children: [
                  TextSpan(
                    text: 'Termes del Servei',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: ' i la '),
                  TextSpan(
                    text: 'Política de Privacitat',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: '.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          children: [
            const SizedBox(height: 10),
            const Text(
              'Crea un compte',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Comença el seguiment del teu edifici avui',
              textAlign: TextAlign.center,
              style: TextStyle(
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
                  const Text(
                    'Registra’t',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Crea el teu compte per començar a gestionar edificis.',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'SELECCIONA EL TEU ROL',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildRoleCard(
                        'admin',
                        Icons.business_center_outlined,
                        'Admin.\nfinca',
                      ),
                      const SizedBox(width: 8),
                      _buildRoleCard(
                        'owner',
                        Icons.apartment_outlined,
                        'Propietari',
                      ),
                      const SizedBox(width: 8),
                      _buildRoleCard(
                        'tenant',
                        Icons.person_outline,
                        'Llogater',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Cognoms',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Contrasenya',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar contrasenya',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTermsBlock(),
                  if (_errorText != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ],
                  if (_successText != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _successText!,
                      style: const TextStyle(color: Colors.green, fontSize: 13),
                    ),
                  ],
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: (_isLoading || !_acceptedTerms)
                          ? null
                          : _handleRegister,
                      child: _isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Crea el compte de BuildRank',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: (_isLoading || !_acceptedTerms)
                        ? null
                        : _handleGoogleRegister,
                    icon: const Icon(Icons.g_mobiledata),
                    label: const Text('Crear compte amb Google'),
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
