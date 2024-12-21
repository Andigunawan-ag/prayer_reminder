import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    // Hapus pengaturan iOS karena tidak dibutuhkan untuk Android
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'prayer_reminder',
      'Prayer Times',
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await notificationsPlugin.schedule(
      id,
      title,
      body,
      scheduledTime,
      notificationDetails,
    );
  }
}