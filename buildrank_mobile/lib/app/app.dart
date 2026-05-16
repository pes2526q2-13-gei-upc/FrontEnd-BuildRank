import 'package:buildrank_mobile/core/services/stream_service.dart';
import 'package:buildrank_mobile/features/auth/presentation/screens/session_gate_screen.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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
      builder: (context, child) => StreamChat(
        client: StreamService.client,
        streamChatThemeData: StreamChatThemeData(
          colorTheme: StreamColorTheme.light(accentPrimary: Colors.green),
          ownMessageTheme: StreamMessageThemeData(
            messageBackgroundColor: Colors.green,
            messageTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            createdAtStyle: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
            reactionsBackgroundColor: Colors.green.shade700,
          ),
          otherMessageTheme: StreamMessageThemeData(
            messageBackgroundColor: Colors.white,
            messageTextStyle: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
            ),
            messageAuthorStyle: TextStyle(
              color: Colors.green.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            createdAtStyle: const TextStyle(
              color: Colors.black45,
              fontSize: 11,
            ),
          ),
        ),
        child: child!,
      ),
      home: const SessionGateScreen(),
    );
  }
}
