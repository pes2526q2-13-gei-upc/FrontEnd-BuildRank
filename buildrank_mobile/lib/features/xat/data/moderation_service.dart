import 'dart:convert';

import 'package:buildrank_mobile/core/config/api_config.dart';
import 'package:buildrank_mobile/features/auth/data/token_storage.dart';
import 'package:http/http.dart' as http;

class ModerationService {
  static Future<Map<String, String>> _headers() async {
    final token = await TokenStorage.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static void _checkResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    final data = response.body.isNotEmpty
        ? jsonDecode(response.body) as Map<String, dynamic>
        : <String, dynamic>{};
    throw Exception(
      data['detail'] ?? 'Error de moderació (${response.statusCode})',
    );
  }

  static Future<void> _post(String url, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(url),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    _checkResponse(response);
  }

  static Future<void> _delete(String url, Map<String, dynamic> body) async {
    final request = http.Request('DELETE', Uri.parse(url));
    request.headers.addAll(await _headers());
    request.body = jsonEncode(body);
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    _checkResponse(response);
  }

  // ── Message actions ────────────────────────────────────────────────────────

  static Future<void> flagMessage(
    String messageId,
    String channelId, {
    String? reason,
  }) => _post(ApiConfig.moderationFlagMessage(messageId), {
    'channel_id': channelId,
    if (reason != null && reason.isNotEmpty) 'reason': reason,
  });

  static Future<void> hideMessage(
    String messageId,
    String channelId, {
    String? reason,
  }) => _post(ApiConfig.moderationHideMessage(messageId), {
    'channel_id': channelId,
    if (reason != null && reason.isNotEmpty) 'reason': reason,
  });

  static Future<void> deleteMessage(
    String messageId,
    String channelId, {
    bool isOwn = true,
    String? reason,
  }) => _delete(ApiConfig.moderationDeleteMessage(messageId), {
    'channel_id': channelId,
    'is_own': isOwn,
    if (reason != null && reason.isNotEmpty) 'reason': reason,
  });

  static Future<void> restoreMessage(
    String messageId,
    String channelId, {
    String? reason,
  }) => _post(ApiConfig.moderationRestoreMessage(messageId), {
    'channel_id': channelId,
    if (reason != null && reason.isNotEmpty) 'reason': reason,
  });

  static Future<void> dismissFlag(
    String messageId,
    String channelId, {
    String? reason,
  }) => _post(ApiConfig.moderationDismissFlag(messageId), {
    'channel_id': channelId,
    if (reason != null && reason.isNotEmpty) 'reason': reason,
  });

  // ── User actions ───────────────────────────────────────────────────────────

  static Future<void> warnUser(
    int userId,
    String channelId, {
    String? reason,
  }) => _post(ApiConfig.moderationWarnUser(userId), {
    'channel_id': channelId,
    if (reason != null && reason.isNotEmpty) 'reason': reason,
  });

  static Future<void> muteUser(
    int userId,
    String channelId, {
    int? timeout,
    String? reason,
  }) => _post(ApiConfig.moderationMuteUser(userId), {
    'channel_id': channelId,
    'timeout': ?timeout,
    if (reason != null && reason.isNotEmpty) 'reason': reason,
  });

  static Future<void> unmuteUser(int userId, String channelId) =>
      _post(ApiConfig.moderationUnmuteUser(userId), {'channel_id': channelId});

  static Future<void> banUser(
    int userId,
    String channelId, {
    int? timeout,
    String? reason,
  }) => _post(ApiConfig.moderationBanUser(userId), {
    'channel_id': channelId,
    'timeout': ?timeout,
    if (reason != null && reason.isNotEmpty) 'reason': reason,
  });

  static Future<void> unbanUser(int userId, String channelId) =>
      _post(ApiConfig.moderationUnbanUser(userId), {'channel_id': channelId});

  // Superuser only
  static Future<void> globalBanUser(
    int userId, {
    String? reason,
    int? timeout,
  }) => _post(ApiConfig.moderationGlobalBanUser(userId), {
    if (reason != null && reason.isNotEmpty) 'reason': reason,
    'timeout': ?timeout,
  });

  static Future<void> globalUnbanUser(int userId, {String? reason}) => _post(
    ApiConfig.moderationGlobalUnbanUser(userId),
    {if (reason != null && reason.isNotEmpty) 'reason': reason},
  );

  static Future<void> shadowBanUser(int userId, {String? reason}) => _post(
    ApiConfig.moderationShadowBanUser(userId),
    {if (reason != null && reason.isNotEmpty) 'reason': reason},
  );

  static Future<void> shadowUnbanUser(int userId) =>
      _post(ApiConfig.moderationShadowUnbanUser(userId), {});
}
