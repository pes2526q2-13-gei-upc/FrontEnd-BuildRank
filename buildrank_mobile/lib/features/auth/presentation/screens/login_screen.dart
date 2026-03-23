import 'package:flutter/material.dart';
import 'package:buildrank_mobile/features/auth/data/auth_service.dart';
import 'package:buildrank_mobile/features/main/presentation/screens/building_main_screen.dart';
import 'package:buildrank_mobile/features/auth/presentation/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorText;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _errorText = null;
    });

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorText = 'Has d’omplir el correu i la contrasenya.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.login(email: email, password: password);

      if (!mounted) return;

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          children: [
            const SizedBox(height: 24),
            Center(
              child: Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.energy_savings_leaf,
                  size: 46,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Benvingut a BuildRank',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Gestiona el teu edifici, consulta el rànquing energètic i segueix la teva evolució des d’un únic lloc.',
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
                    'Inicia sessió',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Accedeix amb el teu compte per veure la informació del teu edifici.',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
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
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: null,
                      child: const Text('Has oblidat la contrasenya?'),
                    ),
                  ),
                  if (_errorText != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        _errorText!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ] else
                    const SizedBox(height: 8),
                  SizedBox(
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin,
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Entrar',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.person_outline),
                    label: const Text('Continuar amb un altre mètode'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Encara no tens compte?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text('Registra’t'),
            ),
          ],
        ),
      ),
    );
  }
}
