import 'package:flutter/material.dart';
import 'package:buildrank_mobile/features/auth/data/auth_service.dart';
import 'package:buildrank_mobile/features/main/presentation/screens/building_main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorText;

  String _selectedRole = 'owner';

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final passwordConfirm = _passwordConfirmController.text.trim();

    setState(() {
      _errorText = null;
    });

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        passwordConfirm.isEmpty) {
      setState(() {
        _errorText = 'Has d’omplir tots els camps.';
      });
      return;
    }

    if (password != passwordConfirm) {
      setState(() {
        _errorText = 'Les contrasenyes no coincideixen.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.register(
        email: email,
        firstName: firstName,
        lastName: lastName,
        password: password,
        passwordConfirm: passwordConfirm,
        role: _selectedRole,
      );

      await _authService.login(email: email, password: password);

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
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
      appBar: AppBar(title: const Text('Registre')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          children: [
            const SizedBox(height: 8),
            const Text(
              'Crea el teu compte',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Registra’t per començar a utilitzar BuildRank.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 28),
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
            DropdownButtonFormField<String>(
              initialValue: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Tipus d’usuari',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.groups_outlined),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'owner',
                  child: Text('Administrador/a de finca'),
                ),
                DropdownMenuItem(
                  value: 'tenant',
                  child: Text('Resident / propietari / llogater'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedRole = value;
                });
              },
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
              controller: _passwordConfirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirma la contrasenya',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_reset_outlined),
              ),
            ),
            const SizedBox(height: 16),
            if (_errorText != null) ...[
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
              const SizedBox(height: 16),
            ],
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleRegister,
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Crear compte',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
