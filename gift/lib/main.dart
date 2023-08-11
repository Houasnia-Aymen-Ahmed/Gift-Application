import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gift/models/user.dart';
import 'package:gift/services/auth.dart';
import 'package:gift/shared/pallete.dart';
import 'package:gift/views/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_flutterMessagingBackgroundHandler);
  runApp(const GiftApp());
}

Future<void> _flutterMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class GiftApp extends StatelessWidget {
  const GiftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserHandler?>.value(
      value: AuthService().user,
      initialData: null,
      catchError: (context, error) {
        debugPrint("Error in Stream");
        return null;
      },
      child: MaterialApp(
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Pallete.backgroundColor,
          ),
          home: const Wrapper()),
    );
  }
}
