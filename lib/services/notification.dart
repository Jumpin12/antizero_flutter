import 'dart:async';
import 'dart:io';

import 'package:antizero_jumpin/models/notification.dart';
import 'package:antizero_jumpin/utils/locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  // StreamSubscription iOSsubscription;

  // save FCM token
  Future<void> saveFCMTokenToFirestore(String id, {String fetchedToken}) async {
    if (Platform.isIOS) {
      await fcm.requestPermission();
      await fcm.setForegroundNotificationPresentationOptions(
        alert: false,
        badge: false,
        sound: false,
      );

      String token = await fcm.getToken();

      await userServ.saveDeviceToken(id, fetchedToken ?? token);

      // iOSsubscription = fcm.onIosSettingsRegistered.listen((data) async {
      //   print(data);
      //   String fcmToken = await fcm.getToken();
      //   await userServ.saveDeviceToken(id, fcmToken);
      // });
      // fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      String fcmToken = await fcm.getToken();
      print(fcmToken);
      debugPrint('Device token $fcmToken');
      await userServ.saveDeviceToken(id, fetchedToken ?? fcmToken);
    }
    // if (iOSsubscription != null) iOSsubscription.cancel();
  }

  // backgroundNotificationHandler(RemoteMessage message) {
  //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //       FlutterLocalNotificationsPlugin();
  //   flutterLocalNotificationsPlugin.show(, message., body, notificationDetails)
  // }

  // send notification
  sendNotificationToFirestore(
      {@required UserNotification notification,
      @required String userId}) async {
    try {
      await userServ.userRef
          .doc(userId)
          .collection('notification')
          .doc(notification.id)
          .set(notification.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  // check if user has notification
  Future<bool> getNotificationsFromFirestore(String userId) async {
    try {
      var snaps =
          await userServ.userRef.doc(userId).collection('notification').get();
      if (snaps.docs.length > 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
