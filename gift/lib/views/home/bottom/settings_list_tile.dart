import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gift/models/user_of_gift.dart';
import 'package:gift/constants/about_content_text.dart';
import 'package:gift/shared/pallete.dart';
import 'package:gift/theme/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/settings_list.dart';
import '../../../constants/constants.dart';

class SettingListTile extends StatefulWidget {
  final SettingList item;
  final UserOfGift user;
  const SettingListTile({
    super.key,
    required this.item,
    required this.user,
  });

  @override
  State<SettingListTile> createState() => _SettingListTileState();
}

class _SettingListTileState extends State<SettingListTile> {
  final controller = Get.put(ThemeController());
  late MaterialStateProperty<Icon?> thumbIcon;
  late bool isNotificationEnabled = false;
  late bool isDarkModeEnabled = false;
  late Color? trackOutlineColor = Palette.boldPink;

  @override
  void initState() {
    super.initState();
    _loadPreference().then(
      (values) => setState(
        () {
          isDarkModeEnabled = values['isDarkModeEnabled']!;
          isNotificationEnabled = values['isNotificationEnabled']!;
        },
      ),
    );
  }

  Future<Map<String, bool>> _loadPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'isDarkModeEnabled': prefs.getBool('isDarkModeEnabled') ?? false,
      'isNotificationEnabled': prefs.getBool('isNotificationEnabled') ?? false,
    };
  }

  Future<void> _saveDarkModePreference(bool value, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    switch (index) {
      case 0:
        await prefs.setBool('isNotificationEnabled', value);
        break;
      case 1:
        await prefs.setBool('isDarkModeEnabled', value);
        break;
      default:
        break;
    }
  }

  void _toggleNotifications(bool newValue) {
    setState(() {
      isNotificationEnabled = newValue;
      isNotificationEnabled
          ? trackOutlineColor = Palette.boldPink
          : trackOutlineColor = Palette.lightPink;
    });
    _saveDarkModePreference(newValue, 0);
  }

  void _toggleDarkMode(bool newValue) {
    setState(() {
      isDarkModeEnabled = newValue;
      controller.changeTheme();
    });
    _saveDarkModePreference(newValue, 1);
  }

  Color _thumbColor() {
    if (widget.item.title == 'Notifications') {
      return isNotificationEnabled ? Palette.boldPink : Palette.lightPink;
    } else {
      return isDarkModeEnabled ? Palette.boldPink : Palette.lightPink;
    }
  }

  Icon _thumbIcon() {
    if (widget.item.title == 'Notifications') {
      return isNotificationEnabled
          ? Icon(
              Icons.notifications_active_rounded,
              color: Palette.lightPink,
            )
          : Icon(
              Icons.notifications_off_rounded,
              color: Palette.boldPink,
            );
    } else {
      return isDarkModeEnabled
          ? Icon(
              Icons.light_mode_rounded,
              color: Palette.lightPink,
            )
          : Icon(
              Icons.light_mode_rounded,
              color: Palette.boldPink,
            );
    }
  }

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(
          widget.item.icon,
          size: 35,
        ),
        title: Text(
          widget.item.title,
          style: txt().copyWith(fontSize: 18.0, color: Palette.lightPink),
        ),
        iconColor: Palette.lightPink,
        titleAlignment: ListTileTitleAlignment.center,
        tileColor: Palette.semiPink,
        splashColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Palette.boldPink),
        ),
        trailing: widget.item.title == "About"
            ? null
            : SizedBox(
                child: Transform.scale(
                  scale: 1.125,
                  child: GetBuilder<ThemeController>(
                    init: ThemeController(),
                    builder: (controller) => Switch(
                      trackOutlineColor: MaterialStateProperty.resolveWith(
                          (states) => trackOutlineColor),
                      trackOutlineWidth: const MaterialStatePropertyAll(2),
                      activeTrackColor: Palette.lightPink,
                      inactiveTrackColor: Palette.boldPink,
                      thumbColor: MaterialStateProperty.all(_thumbColor()),
                      thumbIcon: MaterialStateProperty.all(_thumbIcon()),
                      value: widget.item.title == 'Notifications'
                          ? isNotificationEnabled
                          : (controller.isDarkMode.value),
                      onChanged: (newValue) =>
                          widget.item.title == 'Notifications'
                              ? _toggleNotifications(newValue)
                              : _toggleDarkMode(newValue),
                    ),
                  ),
                ),
              ),
        onTap: widget.item.title == "About"
            ? () => showDialog(
                  context: context,
                  builder: (context) => const CupertinoPopupSurface(
                    isSurfacePainted: false,
                    child: AboutContent(),
                  ),
                )
            : null,
      );
}
