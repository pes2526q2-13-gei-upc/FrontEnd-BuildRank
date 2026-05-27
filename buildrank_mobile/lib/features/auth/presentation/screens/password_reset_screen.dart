import 'package:buildrank_mobile/features/auth/data/auth_service.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        _errorText = l10n.passwordResetEmailRequiredError;
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
        _successText = l10n.passwordResetRequestSuccess;
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
    final l10n = AppLocalizations.of(context);
    final rawLink = _resetLinkController.text.trim();

    if (rawLink.isEmpty) {
      setState(() {
        _errorText = l10n.passwordResetLinkRequiredError;
        _successText = null;
      });
      return;
    }

    final credentials = _extractCredentialsFromLink(rawLink);

    if (credentials == null) {
      setState(() {
        _errorText = l10n.passwordResetInvalidLinkError;
        _successText = null;
      });
      return;
    }

    setState(() {
      _uid = credentials.uid;
      _token = credentials.token;
      _errorText = null;
      _successText = l10n.passwordResetLinkValidatedSuccess;
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
    final l10n = AppLocalizations.of(context);
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorText = l10n.passwordResetPasswordRequiredError;
        _successText = null;
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _errorText = l10n.registerPasswordsMismatchError;
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
        SnackBar(content: Text(l10n.passwordResetSuccessSnackBar)),
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
    final l10n = AppLocalizations.of(context);
    final title = _isConfirmStep
        ? l10n.passwordResetConfirmTitle
        : l10n.passwordResetRequestTitle;

    final subtitle = _isConfirmStep
        ? l10n.passwordResetConfirmSubtitle
        : l10n.passwordResetRequestSubtitle;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7F2),
        elevation: 0,
        title: Text(l10n.passwordResetAppBarTitle),
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
                      decoration: InputDecoration(
                        labelText: l10n.emailLabel,
                        hintText: l10n.emailHint,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.email_outlined),
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
                            : Text(
                                l10n.passwordResetSendInstructions,
                                style: const TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(
                      l10n.passwordResetHaveLinkTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.passwordResetHaveLinkBody,
                      style: const TextStyle(
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
                      decoration: InputDecoration(
                        labelText: l10n.passwordResetLinkLabel,
                        hintText: l10n.passwordResetLinkHint,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.link),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 54,
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : _continueWithResetLink,
                        child: Text(
                          l10n.passwordResetContinueWithLink,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ] else ...[
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: l10n.newPasswordLabel,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock_outline),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: l10n.confirmNewPasswordLabel,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock_outline),
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
                            : Text(
                                l10n.passwordResetSubmit,
                                style: const TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _isLoading ? null : _backToEmailStep,
                      child: Text(l10n.passwordResetPasteAnotherLink),
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
