import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gift/models/user_of_gift.dart';
import 'package:gift/services/auth.dart';
import 'package:gift/services/database.dart';
import 'package:gift/shared/loading.dart';
import 'package:gift/shared/pallete.dart';
import 'package:gift/shared/show_logout_dialog_box.dart';
import 'package:gift/theme/theme_controller.dart';
import 'package:gift/views/home/no_friend_home.dart';
import 'package:home_widget/home_widget.dart';

import 'body/body.dart';
import 'drawer/drawer.dart';

class Home extends StatefulWidget {
  const Home ({Key? key}) : super(key:key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  final ThemeController _themeController = Get.put(ThemeController());
  UserOfGift? myUser;
  UserOfGift? friendUser;

  Future<void> updateAppWidget() async {
    if (myUser != null) {
      await HomeWidget.saveWidgetData<String>(
        '_textContent',
        friendUser!.message,
      );
      await HomeWidget.updateWidget(
        name: 'AppWidgetProvider',
        iOSName: 'AppWidgetProvider',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _themeController.isDarkMode.value = Get.isDarkMode;
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<UserOfGift>(
        stream: _databaseService.getUserDataStream(_auth.currentUsr!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("No User Data Found in Home"),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error When Fetching User Data: ${snapshot.error}",
                style: TextStyle(
                  color: Colors.red[900],
                ),
              ),
            );
          } else {
            myUser = snapshot.data;
            return StreamBuilder<UserOfGift>(
              stream: _databaseService.getUserDataStream(myUser!.friend),
              builder: (context, snapshot) {
                if (!_databaseService.isDataExist) {
                  return NoFriendHome(myUser: myUser!);
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Loading();
                } else if (!snapshot.hasData) {
                  return const Center(
                    child: Text("No Friend Data Found in Home"),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error When Fetching Friend Data: ${snapshot.error}",
                      style: TextStyle(
                        color: Colors.red[900],
                      ),
                    ),
                  );
                } else {
                  friendUser = snapshot.data;
                  updateAppWidget();
                  return GetBuilder<ThemeController>(
                    init: ThemeController(),
                    builder: (themeController) {
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: Palette.getBgImage(
                                themeController.isDarkMode.value),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Scaffold(
                          backgroundColor: Colors.transparent,
                          appBar: AppBar(
                            actions: <Widget>[
                              TextButton.icon(
                                style: ButtonStyle(
                                  iconSize:
                                      const MaterialStatePropertyAll(22.5),
                                  foregroundColor: MaterialStateProperty.all(
                                    Colors.white,
                                  ),
                                ),
                                icon: const Icon(Icons.logout_rounded),
                                label: const Text(
                                  "Logout",
                                  style: TextStyle(
                                    fontSize: 22.5,
                                  ),
                                ),
                                onPressed: () => LogoutDialogHandler()
                                    .showLogoutConfirmationDialog(context),
                              ),
                            ],
                            title: const Text(
                              'Home',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.5,
                              ),
                            ),
                          ),
                          drawer: BuildDrawer(
                            user: myUser!,
                            friend: friendUser!,
                          ),
                          body: BuildBody(
                            user: myUser!,
                            friend: friendUser!,
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      );
}
