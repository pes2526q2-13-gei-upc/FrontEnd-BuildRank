import 'package:buildrank_mobile/core/services/api_client.dart';
import 'package:buildrank_mobile/core/services/stream_service.dart';
import 'package:buildrank_mobile/core/localization/locale_controller.dart';
import 'package:buildrank_mobile/features/auth/presentation/screens/account_blocked_screen.dart';
import 'package:buildrank_mobile/features/auth/presentation/screens/account_suspended_screen.dart';
import 'package:buildrank_mobile/features/auth/presentation/screens/auth_base_screen.dart';
import 'package:buildrank_mobile/features/auth/presentation/screens/session_gate_screen.dart';
import 'package:buildrank_mobile/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class BuildRankApp extends StatelessWidget {
  final LocaleController localeController;

  const BuildRankApp({super.key, required this.localeController});

  static final _navigatorKey = GlobalKey<NavigatorState>();

  static Locale _streamChatDateLocale(Locale appLocale) {
    return switch (appLocale.languageCode) {
      'ca' || 'es' => const Locale('es'),
      'en' => const Locale('en'),
      _ => const Locale('en'),
    };
  }

  @override
  Widget build(BuildContext context) {
    ApiClient.onSessionExpired = () {
      _navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthBaseScreen()),
        (route) => false,
      );
    };

    ApiClient.onAccountBlocked = () {
      _navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AccountBlockedScreen()),
        (route) => false,
      );
    };

    ApiClient.onAccountSuspended = () {
      _navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AccountSuspendedScreen()),
        (route) => false,
      );
    };

    return LocaleControllerScope(
      controller: localeController,
      child: AnimatedBuilder(
        animation: localeController,
        builder: (context, _) {
          return MaterialApp(
            title: 'BuildRank',
            debugShowCheckedModeBanner: false,
            navigatorKey: _navigatorKey,
            locale: localeController.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            ),
            builder: (context, child) => Localizations.override(
              context: context,
              locale: _streamChatDateLocale(localeController.locale),
              child: StreamChat(
                client: StreamService.client,
                streamChatThemeData: StreamChatThemeData(
                  colorTheme: StreamColorTheme.light(
                    accentPrimary: Colors.green,
                  ),
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
                child: Localizations.override(
                  context: context,
                  locale: localeController.locale,
                  child: child!,
                ),
              ),
            ),
            home: const SessionGateScreen(),
          );
        },
      ),
    );
  }
}
