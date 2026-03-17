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

  final List<Widget> _pages = const [LoginScreen(), RegisterScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // 🔹 LOGO
            Image.asset("assets/images/logoBuildRank.png"),

            const SizedBox(height: 20),

            // 🔹 BOTONS (tabs)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildTabButton("Inicia sessió", 0),
                  const SizedBox(width: 10),
                  _buildTabButton("Registra't", 1),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 CONTINGUT DINÀMIC
            Expanded(child: _pages[_selectedIndex]),
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
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
