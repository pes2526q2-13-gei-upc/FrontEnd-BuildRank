import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamService {
  static const String _apiKey = 'ssrynm46c43z';

  static final StreamChatClient client = StreamChatClient(
    _apiKey,
    logLevel: Level.INFO,
  );

  static Future<void> connectUser({
    required String userId,
    required String userName,
    required String token,
  }) async {
    // Ja connectat com el mateix usuari i amb el mateix nom
    if (client.state.currentUser?.id == userId &&
        client.wsConnectionStatus == ConnectionStatus.connected) {
      return;
    }

    // Connectat com un altre usuari — desconnectar primer
    if (client.state.currentUser != null) {
      await client.disconnectUser();
    }

    await client.connectUser(User(id: userId, name: userName), token);
  }

  static Future<void> registerFcmToken(String token) async {
    await client.addDevice(
      token,
      PushProvider.firebase,
      pushProviderName: 'buildrank-push',
    );
  }

  static Future<void> disconnectUser() async {
    await client.disconnectUser();
  }
}
