import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_firebase/ui/notification_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class LocalNotificationService{
 // inside class create instance of FlutterLocalNotificationsPlugin see below

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  //after this create a method initialize to initialize  localnotification

  static void initialize(BuildContext context) {
  // initializationSettings  for Android
  const InitializationSettings initializationSettings =
  InitializationSettings(
  android: AndroidInitializationSettings("@mipmap/ic_launcher"),
  );

  _notificationsPlugin.initialize(
  initializationSettings,
  onDidReceiveNotificationResponse: (NotificationResponse id) {
  print("onSelectNotification");
 // if (id.notificationResponseType.name.isNotEmpty) {
  print("Router Value1234 $id");

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => Application(),
    ),
  );


 // }
  },
  );
  }


 // after initialize we create channel in createanddisplaynotification method


  static void createanddisplaynotification(RemoteMessage message) async {
  try {
  final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  const NotificationDetails notificationDetails = NotificationDetails(
  android: AndroidNotificationDetails(
  "pushnotificationapp",
  "pushnotificationappchannel",
  importance: Importance.max,
  priority: Priority.high,
  ),
  );

  await _notificationsPlugin.show(
  id,
  message.notification!.title,
  message.notification!.body,
  notificationDetails,
  payload: message.data['_id'],
  );
  } on Exception catch (e) {
  print(e);
  }
  }


}