import 'package:flutter/material.dart';
import '../features/auth/presentation/screens/login_screen.dart';

class BuildRankApp extends StatelessWidget {
  const BuildRankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BuildRank',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const LoginScreen(),
    );
  }
}