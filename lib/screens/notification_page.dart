// import 'package:flutter/material.dart';
// import 'package:maps/services/all_services_local_notification.dart';
//
// class NotificationPage extends StatefulWidget {
//   const NotificationPage({super.key});
//
//   @override
//   State<NotificationPage> createState() => _NotificationPageState();
// }
//
// class _NotificationPageState extends State<NotificationPage> {
//   String? _lastPayload;
//
//   @override
//   void initState() {
//     super.initState();
//     NotificationService().onNotificationTap.listen((response) {
//       setState(() {
//         _lastPayload = response.payload;
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Tapped notification with payload: ${response.payload}')),
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Local Notifications"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: ListView(
//           children: [
//             const SizedBox(height: 10),
//             _buildButton("Basic Notification", () {
//               NotificationService().showBasic(
//                 id: 1,
//                 title: "Hello 👋",
//                 body: "This is a basic notification",
//                 payload: "basic_hello",
//               );
//             }),
//             _buildButton("Scheduled in 10s", () {
//               NotificationService().showScheduled(
//                 id: 2,
//                 title: "Reminder",
//                 body: "This shows after 10 seconds",
//                 delay: const Duration(seconds: 10),
//                 payload: "scheduled_delay",
//               );
//             }),
//             _buildButton("Daily at 8:30 PM", () {
//               NotificationService().showDaily(
//                 id: 3,
//                 title: "Time to Learn 📚",
//                 body: "Start reading for 30 minutes",
//                 time: const Time(20, 30, 0),
//                 payload: "daily_time",
//               );
//             }),
//             _buildButton("Repeated Every Day", () {
//               NotificationService().showRepeated(
//                 id: 4,
//                 title: "Check App",
//                 body: "This repeats every day!",
//               );
//             }),
//             _buildButton("Cancel All", () {
//               NotificationService().cancelAll();
//             }, color: Colors.red),
//             if (_lastPayload != null) ...[
//               const Divider(height: 32),
//               Text("🔁 Last payload: $_lastPayload", style: const TextStyle(fontSize: 16)),
//             ]
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildButton(String title, VoidCallback onPressed, {Color? color}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: color ?? Colors.teal,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         child: Text(title, style: const TextStyle(fontSize: 16)),
//       ),
//     );
//   }
// }
