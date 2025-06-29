import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
class NotificationService {
  // Singleton pattern with lazy initialization
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const String _basicChannelId = 'basic_channel';
  static const String _scheduledChannelId = 'scheduled_channel';
  static const String _dailyChannelId = 'daily_channel';
  static const String _repeatedChannelId = 'repeated_channel';

  late final FlutterLocalNotificationsPlugin _plugin;
  late final StreamController<NotificationResponse> _streamController;
  bool _isInitialized = false;

  Stream<NotificationResponse> get onNotificationTap => _streamController.stream;

  Future<void> init() async {
    if (_isInitialized) return;

    _plugin = FlutterLocalNotificationsPlugin();
    _streamController = StreamController<NotificationResponse>.broadcast();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final settings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onTap,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Initialize timezone
    tz.initializeTimeZones();
    final timeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));

    _isInitialized = true;
  }

  void _onTap(NotificationResponse response) {
    log("Tapped notification: ${response.payload}", name: 'NotificationService');
    _streamController.add(response);
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await init();
    }
  }

  Future<void> showBasic({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? sound,
    String? channelName,
    String? channelDescription,
  }) async {
    await _ensureInitialized();

    try {
      final android = AndroidNotificationDetails(
        channelName ?? _basicChannelId,
        channelDescription ?? 'Basic Notifications',
        importance: Importance.max,
        priority: Priority.high,
        sound: sound != null ? RawResourceAndroidNotificationSound(sound) : null,
        enableVibration: true,
        playSound: true,
      );

      final ios = DarwinNotificationDetails(
        sound: sound != null ? '$sound.caf' : null, // .caf for iOS
      );

      final details = NotificationDetails(
        android: android,
        iOS: ios,
      );

      await _plugin.show(id, title, body, details, payload: payload);
    } catch (e) {
      log('Error showing notification: $e');
      // Fallback to notification without sound
      final android = AndroidNotificationDetails(
        channelName ?? _basicChannelId,
        channelDescription ?? 'Basic Notifications',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
      );

      final details = NotificationDetails(android: android);
      await _plugin.show(id, title, body, details, payload: payload);
    }
  }
  Future<void> showScheduled({
    required int id,
    required String title,
    required String body,
    required Duration delay,
    String? payload,
    String? channelName,
    String? channelDescription,
  }) async {
    await _ensureInitialized();

    final android = AndroidNotificationDetails(
      channelName ?? _scheduledChannelId,
      channelDescription ?? 'Scheduled Notifications',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
    );

    final scheduledTime = tz.TZDateTime.now(tz.local).add(delay);
    final details = NotificationDetails(android: android);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTime,
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> showDaily({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    String? payload,
    String? channelName,
    String? channelDescription,
  }) async {
    await _ensureInitialized();

    final android = AndroidNotificationDetails(
      channelName ?? _dailyChannelId,
      channelDescription ?? 'Daily Notifications',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
    );

    var now = tz.TZDateTime.now(tz.local);
    var scheduleTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduleTime.isBefore(now)) {
      scheduleTime = scheduleTime.add(const Duration(days: 1));
    }

    final details = NotificationDetails(android: android);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduleTime,
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> showRepeated({
    required int id,
    required String title,
    required String body,
    RepeatInterval interval = RepeatInterval.daily,
    String? payload,
    String? channelName,
    String? channelDescription,
  }) async {
    await _ensureInitialized();

    final android = AndroidNotificationDetails(
      channelName ?? _repeatedChannelId,
      channelDescription ?? 'Repeated Notifications',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
    );

    final details = NotificationDetails(android: android);

    await _plugin.periodicallyShow(
      id,
      title,
      body,
      interval,
      details,
      payload: payload,
    );
  }

  Future<void> cancel(int id) async {
    await _ensureInitialized();
    await _plugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await _ensureInitialized();
    await _plugin.cancelAll();
  }

  Future<void> dispose() async {
    await _streamController.close();
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  debugPrint(
    'Background notification tapped: ${notificationResponse.payload}',
    wrapWidth: 1024,
  );
}