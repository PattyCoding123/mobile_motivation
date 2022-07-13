// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class LocalNotificationService {
//   // static AndroidNotificationChannel channel = const AndroidNotificationChannel(
//   //   'high_importance_channel', // id
//   //   'High Importance Notifications', // title
//   //   description:
//   //       'This channel is used for important notifications.', // description
//   //   importance: Importance.max,
//   // );

//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static void initialize() async {
//     // await _notificationsPlugin
//     //     .resolvePlatformSpecificImplementation<
//     //         AndroidFlutterLocalNotificationsPlugin>()
//     //     ?.createNotificationChannel(channel);

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//     );

//     _notificationsPlugin.initialize(
//       initializationSettings,
//       onSelectNotification: (payload) {},
//     );
//   }

//   static void showNotificationOnForeground(RemoteMessage message) {
//     final id = DateTime.now().microsecond;
//     final title = message.notification!.title;
//     final body = message.notification!.body;
//     NotificationDetails notificationDetails = const NotificationDetails(
//       android: AndroidNotificationDetails(
//         'high_importance_channel',
//         'High Importance Notifications',
//         importance: Importance.max,
//         priority: Priority.high,
//       ),
//     );

//     _notificationsPlugin.show(id, title, body, notificationDetails);
//   }
// }
