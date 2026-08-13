import 'package:get/get.dart';
import 'package:gift/services/network_controller.dart';
import 'package:gift/theme/theme_controller.dart';

class DependencyInjection {
  static void init() {
    Get.put<NetworkController>(NetworkController(), permanent: true);
    Get.put<ThemeController>(ThemeController(), permanent: true);
  }
}
