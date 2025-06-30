import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:maps/services/local.dart';

@pragma('vm:entry-point')
class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  static Future initialize() async {
    await messaging.requestPermission();
    await messaging.getToken().then((value) {
      sendTokenToServer(value!);
    });
    await messaging.onTokenRefresh.listen((value) {
      sendTokenToServer(value);
    });
    log('FCM Token: $token');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    handelForgroundMessage();
  }

  static void handelForgroundMessage() {
    FirebaseMessaging.onMessage.listen((message) {
      //show local notification
      LocalNotificationService.showBasicNotification(message);
      log('onMessage: ${message.notification?.title ?? "no title"}');
    });
  }

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log('onBackgroundMessage: ${message.notification?.title ?? "no title"}');
  }

  static sendTokenToServer(String token) async {
    try {
      // TODO: Replace with your actual API endpoint and method
      // final response = await http.post(
      //   Uri.parse('YOUR_API_ENDPOINT'),
      //   body: {'token': token},
      //   headers: {'Content-Type': 'application/json'},
      // );
      PushNotificationsService.token = token;
      log('FCM Token sent to server successfully: $token');
    } catch (e) {
      log('Error sending FCM token to server: $e');
    }
  }
}
