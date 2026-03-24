import 'package:buildrank_mobile/features/auth/presentation/screens/auth_base_screen.dart';
import 'package:flutter/material.dart';

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
      home: const AuthBaseScreen(),
    );
  }
}
