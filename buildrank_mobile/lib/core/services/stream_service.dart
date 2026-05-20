import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamService {
  static const String _apiKey = 'ssrynm46c43z';

  static final StreamChatClient client = StreamChatClient(
    _apiKey,
    logLevel: Level.INFO,
  );

  static String? _lastUserId;
  static String? _lastUserName;
  static String? _lastToken;

  static String? get lastUserName => _lastUserName;

  static Future<void> connectUser({
    required String userId,
    required String userName,
    String? token,
  }) async {
    _lastUserId = userId;
    _lastUserName = userName;
    if (token != null) _lastToken = token;

    // Ja connectat com el mateix usuari i amb el mateix nom
    if (client.state.currentUser?.id == userId &&
        client.state.currentUser?.name == userName &&
        client.wsConnectionStatus == ConnectionStatus.connected) {
      return;
    }

    // Connectat com un altre usuari — desconnectar primer
    if (client.state.currentUser != null) {
      await client.disconnectUser();
    }

    await client.connectUser(
      User(id: userId, name: userName),
      token ?? _lastToken ?? client.devToken(userId).rawValue,
    );
  }

  static Future<void> reconnect() async {
    if (_lastUserId == null) return;
    await connectUser(
      userId: _lastUserId!,
      userName: _lastUserName!,
      token: _lastToken,
    );
  }

  static Future<void> registerFcmToken(String token) async {
    await client.addDevice(
      token,
      PushProvider.firebase,
      pushProviderName: 'buildrank-push',
    );
  }

  static Future<void> disconnectUser() async {
    _lastUserId = null;
    _lastUserName = null;
    _lastToken = null;
    await client.disconnectUser();
  }
}
