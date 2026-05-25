import 'package:buildrank_mobile/features/auth/data/auth_service.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialFullName;
  final String initialEmail;
  final AuthService? authService;

  const EditProfileScreen({
    super.key,
    required this.initialFullName,
    required this.initialEmail,
    this.authService,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final AuthService _authService;

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? AuthService();

    final parts = widget.initialFullName.trim().split(RegExp(r'\s+'));
    final firstName = parts.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    _firstNameController = TextEditingController(text: firstName);
    _lastNameController = TextEditingController(text: lastName);
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final l10n = AppLocalizations.of(context);
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();

    if (firstName.isEmpty) {
      _showMessage(l10n.editProfileFirstNameRequired);
      return;
    }

    if (lastName.isEmpty) {
      _showMessage(l10n.editProfileLastNameRequired);
      return;
    }

    if (email.isEmpty) {
      _showMessage(l10n.editProfileEmailRequired);
      return;
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      _showMessage(l10n.editProfileEmailInvalid);
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _authService.updateProfile(
        firstName: firstName,
        lastName: lastName,
        email: email,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.editProfileSuccess)));

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      _showMessage(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F2),
      appBar: AppBar(
        title: Text(l10n.editProfileTitle),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
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
                  l10n.editProfilePersonalDataTitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.editProfilePersonalDataSubtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _firstNameController,
                  enabled: !_isSaving,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.firstNameLabel,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _lastNameController,
                  enabled: !_isSaving,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: l10n.lastNameLabel,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  enabled: !_isSaving,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: l10n.emailLabel,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveProfile,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(
                      _isSaving
                          ? l10n.editProfileSaving
                          : l10n.editProfileSaveChanges,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: _isSaving ? null : () => Navigator.pop(context),
                  child: Text(l10n.commonCancel),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
