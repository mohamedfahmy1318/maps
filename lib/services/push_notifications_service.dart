import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
@pragma('vm:entry-point')

class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;

  static Future initialize() async {
    await messaging.requestPermission(

    );
    token = await messaging.getToken();
    log('FCM Token: $token');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log('onBackgroundMessage: ${message.notification?.title ?? "no title"}');
  }
}
