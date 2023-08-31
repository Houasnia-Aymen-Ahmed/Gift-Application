import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../../models/user_of_gift.dart';
import '../../shared/pallete.dart';
import '../../shared/show_logout_dialog_box.dart';
import '../../theme/theme_controller.dart';
import 'body/build_no_data_body.dart';
import 'drawer/drawer.dart';

class NoFriendHome extends StatelessWidget {
  final UserOfGift myUser;
  const NoFriendHome({super.key, required this.myUser});

  @override
  Widget build(BuildContext context) => GetBuilder<ThemeController>(
      init: ThemeController(),
      builder: (themeController) => Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Palette.getBgImage(themeController.isDarkMode.value),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            actions: <Widget>[
              TextButton.icon(
                style: ButtonStyle(
                  iconSize: const MaterialStatePropertyAll(22.5),
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
                onPressed: () =>
                    LogoutDialogHandler().showLogoutConfirmationDialog(context),
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
            user: myUser,
            friend: myUser,
          ),
          body: BuildNoDataBody(
            user: myUser,
          ),
        ),
      ),
    );
}
