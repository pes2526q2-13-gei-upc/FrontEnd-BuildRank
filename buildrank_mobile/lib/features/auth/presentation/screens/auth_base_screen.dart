import 'package:buildrank_mobile/core/localization/locale_controller.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'register_screen.dart';

class AuthBaseScreen extends StatefulWidget {
  const AuthBaseScreen({super.key});

  @override
  State<AuthBaseScreen> createState() => _AuthBaseScreenState();
}

class _AuthBaseScreenState extends State<AuthBaseScreen> {
  int _selectedIndex = 0;

  void _goToLoginAfterRegister(String email) {
    setState(() {
      _selectedIndex = 0;
    });

    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.authRegisterSuccessWithEmail(email))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = [
      const LoginScreen(),
      RegisterScreen(onRegisterSuccess: _goToLoginAfterRegister),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),

            Image.asset(
              'assets/images/logoBuildRank.png',
              height: 95,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 12),

            _LanguageSelector(l10n: l10n),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildTabButton(l10n.authLoginTab, 0),
                  const SizedBox(width: 10),
                  _buildTabButton(l10n.authRegisterTab, 1),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(child: pages[_selectedIndex]),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  final AppLocalizations l10n;

  const _LanguageSelector({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final localeController = LocaleControllerScope.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerRight,
        child: DropdownButton<Locale>(
          value: localeController.locale,
          underline: const SizedBox.shrink(),
          icon: const Icon(Icons.language),
          onChanged: (locale) {
            if (locale != null) {
              localeController.setLocale(locale);
            }
          },
          items: [
            DropdownMenuItem(
              value: const Locale('ca'),
              child: Text(
                '${l10n.authLanguageLabel}: ${l10n.authLanguageCatalan}',
              ),
            ),
            DropdownMenuItem(
              value: const Locale('es'),
              child: Text(
                '${l10n.authLanguageLabel}: ${l10n.authLanguageSpanish}',
              ),
            ),
            DropdownMenuItem(
              value: const Locale('en'),
              child: Text(
                '${l10n.authLanguageLabel}: ${l10n.authLanguageEnglish}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
