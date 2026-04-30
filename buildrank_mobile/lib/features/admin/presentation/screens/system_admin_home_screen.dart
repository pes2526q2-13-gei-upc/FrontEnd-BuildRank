import 'package:flutter/material.dart';

class SystemAdminHomeScreen extends StatelessWidget {
  const SystemAdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Panell d’administrador de sistema',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
