// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import "package:http/http.dart" as http;

class LocalNotificationService {
  static String serverKey =
      "AAAAmcYq_i4:APA91bHdHvIJblNyiw3s2TCswI5wDGpv5fnBJK_oN_85vXLZJQan45McDbNv1al1nzC-Equ2D_JEMhsYhneQKEg9Ik3kurtHtTRXLQ9H5EUSM7LIPVeKfm0LtQQKSaEb_cTTghcC0xEA";
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static void initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage message) async {
    try {
      print("In Notification method");
      // int id = DateTime.now().microsecondsSinceEpoch ~/1000000;
      Random random = Random();
      int id = random.nextInt(1000);
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "mychannel",
        "my channel",
        importance: Importance.max,
        priority: Priority.high,
      ));
      print("my id is ${id.toString()}");
      await _flutterLocalNotificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.title,
        notificationDetails,
      );
    } on Exception catch (e) {
      print('Error>>>$e');
    }
  }

  static Future<void> sendNotifications(
    String? message,
    String? title,
    String? token,
  ) async {
    print(message.toString());

    final data = {
      "click_action": "Notification click",
      "id": 1,
      "status": "done",
      "message": message
    };

    try {
      http.Response r = await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          'Content-Type': "application/json",
          "Authorization": 'key=$serverKey'
        },
        body: jsonEncode(<String, dynamic>{
          'notification': <String, dynamic>{'body': message, "title": title},
          'priority': 'high',
          'data': data,
          "to": "$token"
        }),
      );

      print(r.body);

      if (r.statusCode == 200) {
        print("done");
      } else {
        print(r.statusCode);
      }
    } catch (e) {
      print("exception $e");
    }
  }

  static storeToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(
        {"fcmToken": token},
        SetOptions(merge: true),
      );
    } catch (e) {
      print(e);
    }
  }
}
