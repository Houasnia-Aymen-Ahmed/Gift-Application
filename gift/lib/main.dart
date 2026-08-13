import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';
import 'package:gift/models/user.dart';
import 'package:gift/services/auth.dart';
import 'package:gift/services/database.dart';
import 'package:gift/services/dependency_injection.dart';
import 'package:gift/services/widget_service.dart';
import 'package:gift/constants/theme_constants.dart';
import 'package:gift/theme/theme_controller.dart';
import 'package:gift/views/authenticate/authenticate.dart';
import 'package:gift/views/home/home.dart';
import 'package:gift/views/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_flutterMessagingBackgroundHandler);
  await HomeWidget.registerInteractivityCallback(_widgetInteractivityCallback);
  DependencyInjection.init();
  await GetStorage.init();
  runApp(
    const GiftApp(),
  );
}

/// Runs in a background isolate when a push arrives while the app is
/// backgrounded or fully closed. Only touches the widget if the push is
/// from whichever friend the widget is currently pinned to — otherwise an
/// unrelated friend's message would silently hijack the display.
@pragma('vm:entry-point')
Future<void> _flutterMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final senderUid = message.data['from'];
  if (senderUid == null || senderUid.isEmpty) return;
  await WidgetService().refreshIfPinned(senderUid);
}

/// Runs in a background isolate when the widget's prev/next button is
/// tapped, via the `gift://widget_next` / `gift://widget_prev` broadcast
/// intents fired from AppWidgetProvider.kt.
@pragma('vm:entry-point')
Future<void> _widgetInteractivityCallback(Uri? uri) async {
  if (uri == null) return;
  await Firebase.initializeApp();

  final myUid = AuthService().currentUsr?.uid;
  if (myUid == null) return;

  final me = await DatabaseService().getUserDataOnce(myUid);
  if (me == null) return;

  if (uri.host == 'widget_next') {
    await WidgetService().cyclePin(me, 1);
  } else if (uri.host == 'widget_prev') {
    await WidgetService().cyclePin(me, -1);
  }
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
    final themeController = Get.find<ThemeController>();
    return StreamProvider<UserHandler?>.value(
      value: AuthService().user,
      initialData: null,
      catchError: (context, error) {
        return null;
      },
      child: Obx(
        () => GetMaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode:
              themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
          home: const Wrapper(),
          debugShowCheckedModeBanner: false,
          routes: {
            '/home': (context) => const Home(),
            '/auth': (context) => const Authenticate(),
            // other routes...
          },
        ),
      ),
    );
  }
}
