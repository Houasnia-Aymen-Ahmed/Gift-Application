import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gift/services/auth.dart';

class LogoutDialogHandler {
  final AuthService _auth = AuthService();
  Future<void> showLogoutConfirmationDialog(BuildContext context) async =>
      await showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.5),
        builder: (context) => CupertinoAlertDialog(
          title: const Text(
            "Confirmation",
            style: TextStyle(
              color: Color(0xFFFF0000),
              fontWeight: FontWeight.w700,
            ),
          ),
          content: const Text(
            "Are you sure you want to Logout ?",
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {},
              child: ElevatedButton.icon(
                onPressed: () {
                  _auth.logout();
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.5),
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: Color(0xFF333333),
                ),
                label: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {},
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.5),
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons.cancel_rounded,
                  color: Color(0xFF333333),
                ),
                label: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Color(0xFF333333),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
