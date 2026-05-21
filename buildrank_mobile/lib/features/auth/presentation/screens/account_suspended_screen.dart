import 'package:buildrank_mobile/features/auth/presentation/screens/auth_base_screen.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AccountSuspendedScreen extends StatelessWidget {
  const AccountSuspendedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F2),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(
                    Icons.pause_circle_outline_rounded,
                    size: 44,
                    color: Color(0xFFD97706),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.accountSuspendedTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF14181F),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.accountSuspendedBody,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const AuthBaseScreen(),
                        ),
                        (_) => false,
                      );
                    },
                    child: Text(l10n.accountBackToLogin),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
