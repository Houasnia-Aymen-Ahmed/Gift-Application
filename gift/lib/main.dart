import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gift/models/user.dart';
import 'package:gift/services/auth.dart';
import 'package:gift/services/dependency_injection.dart';
import 'package:gift/constants/theme_constants.dart';
import 'package:gift/theme/theme_controller.dart';
import 'package:gift/views/authenticate/authenticate.dart';
import 'package:gift/views/home/home.dart';
import 'package:gift/views/wrapper.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_flutterMessagingBackgroundHandler);
  DependencyInjection.init();
  await GetStorage.init();
  runApp(
    const GiftApp(),
  );
}

Future<void> _flutterMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  String? friendMessage = message.data['message'];

  await Firebase.initializeApp();
  await HomeWidget.saveWidgetData<String>(
    '_textContent',
    friendMessage ?? "",
  );
  await HomeWidget.updateWidget(
    name: 'AppWidgetProvider',
    iOSName: 'AppWidgetProvider',
  );
}

class GiftApp extends StatefulWidget {
  const GiftApp({super.key});

  @override
  State<GiftApp> createState() => _GiftAppState();
}

class _GiftAppState extends State<GiftApp> {
  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    final isDarkMode = themeController.isDarkMode.value;
    return StreamProvider<UserHandler?>.value(
      value: AuthService().user,
      initialData: null,
      catchError: (context, error) {
        return null;
      },
      child: GetMaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: const Wrapper(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (context) => const Home(),
          '/auth': (context) => const Authenticate(),
          // other routes...
        },
      ),
    );
  }
}
