// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class LocalNotificationService {
//   static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   static onTap(NotificationResponse notificationResponse) {}
//
//   static Future init() async {
//     InitializationSettings settings = InitializationSettings(
//       android: AndroidInitializationSettings("@mipmap/ic_launcher"),
//     );
//     flutterLocalNotificationsPlugin.initialize(
//       settings,
//       onDidReceiveNotificationResponse: onTap,
//       onDidReceiveBackgroundNotificationResponse: onTap,
//     );
//   }
//
//   static void showBasicNotification() async {
//     NotificationDetails notificationDetails = NotificationDetails(
//       android: AndroidNotificationDetails(
//         '1',
//         'channel_name',
//         importance: Importance.max,
//         priority: Priority.high,
//       ),
//     );
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'Basic Notification',
//       'with custom sound',
//       notificationDetails,
//     );
//   }
//
//   //showRepeatedNotification
//   static void showRepeatedNotification() async {
//     const AndroidNotificationDetails android = AndroidNotificationDetails(
//       '2',
//       'repeated notification',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     NotificationDetails details = const NotificationDetails(android: android);
//     await flutterLocalNotificationsPlugin.periodicallyShow(
//       1,
//       'repeated title',
//       'repeated body',
//       RepeatInterval.weekly,
//       details,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//     );
//   }
//
//   static void showScheduledNotification() async {
//   }
//   static void cancelNotification( dynamic id) async {
//     await flutterLocalNotificationsPlugin.cancel(id);
//   }
//
// }
