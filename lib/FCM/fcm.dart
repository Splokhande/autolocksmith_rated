import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FCMConfig extends ChangeNotifier {
  FirebaseMessaging fcm = FirebaseMessaging.instance;
  FCMConfig();

  initialize(context) async {
    fcm.setAutoInitEnabled(true);
    fcm.isAutoInitEnabled;
    await FirebaseMessaging.instance.getInitialMessage();

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    SharedPreferences sp = await SharedPreferences.getInstance();
    int? count = sp.getInt("count");
    count ??= 0;
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      if (kDebugMode) print('Got a message whilst in the background!');
      if (count != null && count > 0) {
        FlutterAppBadger.updateBadgeCount(count + 1);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) print('Got a message whilst in the foreground!');
      if (count != null && count > 0) {
        FlutterAppBadger.updateBadgeCount(count + 1);
      }
    });
  }
}
