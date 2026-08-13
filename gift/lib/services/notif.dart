// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gift/views/home/home.dart';
import 'database.dart';

class NotificationServices {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  void initialize(BuildContext context) {
    if (_initialized) return;
    _initialized = true;
    requestNotificationPermission();
    isTokenRefresh();
    getDeviceToken().then((value) {});
    firebaseInit(context);
    setupInteractMessage(context);
  }

  void requestNotificationPermission() async {
    await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
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
    await _flutterLocalNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(context, message);
      },
    );
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
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

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'friend') {
      Future.microtask(
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        ),
      );
    }
  }

  Future<void> handleNotificationTap(
      BuildContext context, RemoteMessage data) async {
    if (data.data['type'] == 'friend_request') {
      showDialog(
        context: context,
        builder: (context) => const Home(),
      );
    }
  }

  static const String _channelId = 'high_importance_channel';

  Future<void> showNotif(RemoteMessage message) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      _channelId,
      'High Importance Notification',
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
        id: 0,
        title: message.notification!.title.toString(),
        body: message.notification!.body.toString(),
        notificationDetails: notificationDetails,
      );
    });
  }
}
