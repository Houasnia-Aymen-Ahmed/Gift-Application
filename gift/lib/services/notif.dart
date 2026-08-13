// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gift/models/conversation_message.dart';
import 'package:gift/models/user_of_gift.dart';
import 'package:gift/views/home/home.dart';
import 'database.dart';

/// No Cloud Function is deployed for this project (requires the Blaze
/// plan), so there is no server-side push delivery. Everything here is a
/// same-device fallback: it only fires while this app process is alive
/// (foreground or backgrounded), never when the app is killed or on a
/// friend's other device. FCM token registration is still kept so that
/// deploying `functions/` later needs no client changes.
class NotificationServices {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;
  static const String _channelId = 'high_importance_channel';

  void initialize(BuildContext context) {
    if (_initialized) return;
    _initialized = true;
    requestNotificationPermission();
    isTokenRefresh();
    getDeviceToken().then((value) {});
    _initLocalNotifications(context);
    firebaseInit();
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

  Future<void> _initLocalNotifications(BuildContext context) async {
    var androidInit =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initSettings = InitializationSettings(android: androidInit);
    await _flutterLocalNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        Future.microtask(
          () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          ),
        );
      },
    );
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  // Kept so a real push still displays correctly if functions/ ever gets
  // deployed — currently nothing sends one, so this listener stays idle.
  void firebaseInit() {
    FirebaseMessaging.onMessage.listen(showNotif);
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleNotificationTap(context, event);
    });
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

  Future<void> showNotif(RemoteMessage message) async {
    await _showLocalNotification(
      message.notification?.title ?? 'Gift',
      message.notification?.body ?? '',
    );
  }

  Future<void> _showLocalNotification(String title, String body) async {
    const androidNotificationDetails = AndroidNotificationDetails(
      _channelId,
      'High Importance Notification',
      channelDescription: '',
      importance: Importance.high,
      priority: Priority.high,
      ticker: '',
    );
    const notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.show(
      id: 0,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }

  Future<void> notifyConversationMessage(
      UserOfGift sender, ConversationMessage message) async {
    final body = message.kind == 'gift'
        ? '${sender.userName} sent you a gift 🎁'
        : '${sender.userName} sent you a message 📩';
    await _showLocalNotification('Gift', body);
  }

  Future<void> notifyFriendRequest(UserOfGift sender) async {
    await _showLocalNotification(
        'Gift', '${sender.userName} wants to be your friend 😀');
  }
}
