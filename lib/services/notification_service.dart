// lib/services/notification_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _channelId = 'jagdish_foods_channel';
  static const _channelName = 'Jagdish Foods';
  static const _channelDesc = 'Order updates, offers, and more';

  Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@drawable/ic_notification');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Create Android notification channel
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _onNotificationTap(NotificationResponse response) {
    // Handle notification tap — navigate to appropriate screen
    final payload = response.payload;
    if (payload != null) {
      // Parse and route
      debugPrint('Notification tapped: $payload');
    }
  }

  Future<void> showOrderUpdate({
    required String orderId,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@drawable/ic_notification',
      color: Color(0xFF0083BC),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
        android: androidDetails, iOS: iosDetails);

    await _plugin.show(
      orderId.hashCode,
      title,
      body,
      details,
      payload: 'order:$orderId',
    );
  }

  Future<void> showOffer({
    required String id,
    required String title,
    required String body,
    required String couponCode,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@drawable/ic_notification',
      color: Color(0xFFF4A300),
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      id.hashCode,
      title,
      body,
      details,
      payload: 'offer:$couponCode',
    );
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
