import 'package:flutter/material.dart';
import 'package:buildrank_mobile/features/auth/data/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  bool _isLoading = true;
  String? _errorText;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final data = await _authService.getMe();

      if (!mounted) return;

      setState(() {
        _userData = data;
      });
    } catch (e) {
      if (!mounted) return;

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

  String _roleLabel(String? role) {
    switch (role) {
      case 'admin':
        return 'Administrador del sistema';
      case 'owner':
        return 'Administrador/a de finca';
      case 'tenant':
        return 'Resident / propietari / llogater';
      default:
        return 'Rol no disponible';
    }
  }

  String _initials() {
    final firstName = (_userData?['first_name'] ?? '').toString().trim();
    final lastName = (_userData?['last_name'] ?? '').toString().trim();

    final firstInitial = firstName.isNotEmpty ? firstName[0] : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0] : '';

    final initials = '$firstInitial$lastInitial'.trim();
    return initials.isEmpty ? 'BR' : initials.toUpperCase();
  }

  String _fullName() {
    final firstName = (_userData?['first_name'] ?? '').toString().trim();
    final lastName = (_userData?['last_name'] ?? '').toString().trim();
    final fullName = '$firstName $lastName'.trim();
    return fullName.isEmpty ? 'Usuari BuildRank' : fullName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil'), centerTitle: true),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorText != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 56,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorText!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loadProfile,
                        child: const Text('Torna-ho a provar'),
                      ),
                    ],
                  ),
                ),
              )
            : ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const SizedBox(height: 8),
                  Center(
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.green.shade100,
                      child: Text(
                        _initials(),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _fullName(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (_userData?['email'] ?? '').toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 28),
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
                      children: [
                        _ProfileRow(
                          icon: Icons.person_outline,
                          label: 'Nom',
                          value: (_userData?['first_name'] ?? '').toString(),
                        ),
                        const SizedBox(height: 16),
                        _ProfileRow(
                          icon: Icons.badge_outlined,
                          label: 'Cognoms',
                          value: (_userData?['last_name'] ?? '').toString(),
                        ),
                        const SizedBox(height: 16),
                        _ProfileRow(
                          icon: Icons.email_outlined,
                          label: 'Correu electrònic',
                          value: (_userData?['email'] ?? '').toString(),
                        ),
                        const SizedBox(height: 16),
                        _ProfileRow(
                          icon: Icons.groups_outlined,
                          label: 'Rol',
                          value: _roleLabel(
                            (_userData?['role'] ?? '').toString(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 54,
                    child: OutlinedButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Editar perfil (pròximament)'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.green),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 4),
              Text(
                value.isEmpty ? 'No disponible' : value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
