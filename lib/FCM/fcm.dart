
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FCMConfig extends ChangeNotifier{
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  FCMConfig();

  initialize(context)async{
    fcm.setAutoInitEnabled(true);
    fcm.isAutoInitEnabled;
    await FirebaseMessaging.instance.getInitialMessage();

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }
}