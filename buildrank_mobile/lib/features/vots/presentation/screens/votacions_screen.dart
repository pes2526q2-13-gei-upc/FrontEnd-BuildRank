import 'package:flutter/material.dart';

class VotacionsScreen extends StatefulWidget {
  const VotacionsScreen({super.key});

  @override
  State<VotacionsScreen> createState() => _VotacionsScreenState();
}

class _VotacionsScreenState extends State<VotacionsScreen> {
  //int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Votacions en desenvolupament",
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
      ),
    );
  }
}
