import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gift/models/user_of_gift.dart';
import 'package:gift/views/home/home.dart';
import 'package:http/http.dart' as http;
import 'database.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    // ignore: unused_local_variable
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    DatabaseService().updateUserSpecificData(token: token);
    return token!;
  }

  void initLocalNotification(
      BuildContext context, RemoteMessage message) async {
    var androidInit =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initSettings = InitializationSettings(android: androidInit);
    await _flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, message);
    });
  }

  void isTokentRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  void fireaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      //initLocalNotification(message);
      if (Platform.isAndroid) {
        initLocalNotification(context, message);
        showNotif(message);
      } else {
        showNotif(message);
      }
    });
  }

  RemoteMessage data = const RemoteMessage();

  Future<void> setupInteractMessage(BuildContext context) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleNotificationTap(context, data);
    }
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleNotificationTap(context, event);
    });
  }

  Future sendNotif(String token, UserOfGift user, String type) async {
    String message = '';
    if (type == 'friend') {
      message = 'Your are now friend with ${user.userName} \uD83D\uDE00';
    } else if (type == 'gift') {
      message = '${user.userName} sent you a gift \uD83C\uDF81';
    } else if (type == 'message') {
      message = '${user.userName} sent you a message \uD83D\uDCe9';
    } else {
      message = 'Notification';
    }
    var data = {
      'to': token,
      'priority': 'high',
      'notification': {
        'title': type != 'gift' ? 'Gift $type' : 'Gift',
        'body': message,
      },
      'data': {
        'type': type,
        'id': '${type.hashCode}',
      },
    };
    await http.post(
        Uri.parse(
          'https://fcm.googleapis.com/fcm/send',
        ),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
              'key= authorization'
        });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'friend') {
      Future.microtask(() => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Home())));
    }
  }

  Future<void> handleNotificationTap(
      BuildContext context, RemoteMessage data) async {
    if (data.data['type'] == 'friend_request') {
      // Show a dialog or navigate to a page for accepting/rejecting friend request
      showDialog(
        context: context,
        builder: (context) => const Home(),
      );
    }
  }

  Future<void> showNotif(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        'High Importance Notification',
        importance: Importance.max);
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: '',
      importance: Importance.high,
      priority: Priority.high,
      ticker: '',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }
}
