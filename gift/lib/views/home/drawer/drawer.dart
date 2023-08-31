import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gift/views/home/drawer/drawer_content.dart';
import '../../../models/user_of_gift.dart';
import '../../../shared/pallete.dart';

class BuildDrawer extends StatelessWidget {
  final UserOfGift user;
  final UserOfGift friend;
  const BuildDrawer({
    super.key,
    required this.user,
    required this.friend,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Drawer(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          backgroundColor: Palette.pinkyPink.withOpacity(0.5),
          elevation: 10,
          surfaceTintColor: Palette.londonHue,
          child: BuildDrawerContent(user: user, friend: friend),
        ),
      ),
    );
  }
}
