import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPreference();
  }

  void changeTheme() {
    Navigator.of(Get.overlayContext!).pop();
    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.light : ThemeMode.dark,
    );
    isDarkMode.value = !isDarkMode.value;
    _savePreference(isDarkMode.value);
    update();
  }

  Future<void> _loadPreference() async {
    final box = GetStorage();
    await GetStorage.init();
    isDarkMode.value = box.read('isDarkModeEnabled') ?? false;
    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
    update();
  }

  Future<void> _savePreference(bool value) async {
    final box = GetStorage();
    await box.write('isDarkModeEnabled', value);
  }
}
