import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'core/localization/locale_controller.dart';
import 'firebase_options.dart';
import 'app/app.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (message.data['sender'] == 'stream.chat') {
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    final androidPlugin = plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        'stream_chat_notifications',
        'Notificacions de xat',
        importance: Importance.high,
      ),
    );
    await plugin.show(
      message.hashCode,
      _notificationTitle(message.data),
      _notificationBody(message.data),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'stream_chat_notifications',
          'Notificacions de xat',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }
}

String _notificationTitle(Map<String, dynamic> data) {
  final channelName = data['channel_name'] as String?;
  if (channelName != null && channelName.isNotEmpty) return channelName;
  return 'BuildRank';
}

String _notificationBody(Map<String, dynamic> data) {
  // v2 format uses 'sender_name' and 'message'; legacy uses 'message_sender_name' and 'message_text'
  final sender =
      data['sender_name'] as String? ?? data['message_sender_name'] as String?;
  final text =
      data['message'] as String? ?? data['message_text'] as String? ?? '';
  if (sender != null && sender.isNotEmpty && text.isNotEmpty) {
    return '$sender: $text';
  }
  if (text.isNotEmpty) return text;
  return 'Has rebut un missatge nou';
}

const AndroidNotificationChannel _channel = AndroidNotificationChannel(
  'buildrank_messages',
  'Missatges BuildRank',
  description: 'Notificacions de nous missatges al xat',
  importance: Importance.high,
);

const AndroidNotificationChannel _streamChannel = AndroidNotificationChannel(
  'stream_chat_notifications',
  'Notificacions de xat',
  importance: Importance.high,
);

const AndroidNotificationChannel _fcmDefaultChannel =
    AndroidNotificationChannel(
      'fcm_fallback_notification_channel',
      'Notificacions generals',
      importance: Importance.high,
    );

final FlutterLocalNotificationsPlugin _localNotifications =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await _localNotifications.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
  );

  final androidPlugin = _localNotifications
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
  await androidPlugin?.createNotificationChannel(_channel);
  await androidPlugin?.createNotificationChannel(_streamChannel);
  await androidPlugin?.createNotificationChannel(_fcmDefaultChannel);

  final localeController = LocaleController();
  await localeController.load();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    } else if (message.data['sender'] == 'stream.chat') {
      _localNotifications.show(
        message.hashCode,
        _notificationTitle(message.data),
        _notificationBody(message.data),
        NotificationDetails(
          android: AndroidNotificationDetails(
            _streamChannel.id,
            _streamChannel.name,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  });

  runApp(BuildRankApp(localeController: localeController));
}
