import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Palette {
  static Color get twilight => const Color(0xEBEBDDE4);
  static Color get londonHue =>
      !Get.isDarkMode ? const Color(0xFFC0ABC2) : const Color(0xFF4C3D68);
  static Color get dividerColor =>
      !Get.isDarkMode ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
  static Color get seagull =>
      !Get.isDarkMode ? const Color(0xFF86BAEB) : const Color(0xFF55709E);
  static Color get pinkyPink =>
      !Get.isDarkMode ? const Color(0xFFf39cb5) : const Color(0xFF2F2452);
  static Color get semiPink =>
      !Get.isDarkMode ? const Color(0xFFee7e9d) : const Color(0xFF533272);
  static Color get boldPink =>
      !Get.isDarkMode ? const Color(0xFFdf496f) : const Color(0xFF9C7FC7);
  static Color get lightPink =>
      !Get.isDarkMode ? const Color(0xFFfad3dd) : const Color(0xFF160B29);
  static Color get textColor =>
      !Get.isDarkMode ? const Color(0xFF10002b) : const Color(0xFFfad3dd);
  static Color get textMessageColor =>
      !Get.isDarkMode ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
  static Color get iconColor =>
      !Get.isDarkMode ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
  static Color get bodyTextColor =>
      !Get.isDarkMode ? Colors.black : Colors.white;
  static AssetImage getBgImage(bool isDarkMode) {
    return !isDarkMode
        ? const AssetImage("assets/images/home_background.png")
        : const AssetImage("assets/images/login_register.png");
  }
}
