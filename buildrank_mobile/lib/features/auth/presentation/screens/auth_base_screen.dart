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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Compte creat correctament. Ara pots iniciar sessió amb $email.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildTabButton('Inicia sessió', 0),
                  const SizedBox(width: 10),
                  _buildTabButton("Registra't", 1),
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
