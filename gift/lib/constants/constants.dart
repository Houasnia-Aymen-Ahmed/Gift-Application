import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gift/services/database.dart';
import 'package:gift/shared/pallete.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/settings_list.dart';
import '../models/user_of_gift.dart';
import '../views/home/drawer/list_tile.dart';

const textInputDecoation = InputDecoration(
  contentPadding: EdgeInsets.fromLTRB(27, 20, 27, 20),
  hintText: "Email",
  hintStyle: TextStyle(
    color: Colors.white54,
  ),
  fillColor: Colors.transparent,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white38,
      width: 2,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white,
      width: 2,
    ),
  ),
);

const drawerTextDecoration = InputDecoration(
  contentPadding: EdgeInsets.all(0),
  counterStyle: TextStyle(
    color: Colors.white70,
  ),
  fillColor: Colors.transparent,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
      width: 2,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.transparent,
      width: 1,
    ),
  ),
);

txt() {
  return GoogleFonts.poppins(
    color: Palette.bodyTextColor,
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );
}

final elevatedBtnStyle = ElevatedButton.styleFrom(
  shadowColor: Colors.white.withOpacity(0.1),
  backgroundColor: Colors.transparent,
  elevation: 1,
  fixedSize: const Size(100, 50),
);

final textDisabled = Text(
  "Your friend's Message",
  style: txt().copyWith(fontSize: 25.0, color: Colors.grey),
  textAlign: TextAlign.center,
);

outlineBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(
      color: Palette.boldPink,
      width: 1,
      style: BorderStyle.solid,
    ),
  );
}

inputDecoration() {
  return InputDecoration(
    filled: true,
    fillColor: Palette.londonHue.withOpacity(0.5),
    contentPadding: const EdgeInsets.fromLTRB(27, 20, 27, 20),
    hintText: "Send a message",
    hintStyle: TextStyle(
      color: Palette.iconColor,
    ),
    counterStyle: TextStyle(
      color: Palette.boldPink,
      fontWeight: FontWeight.bold,
    ),
    border: outlineBorder(),
    enabledBorder: outlineBorder(),
    focusedBorder: outlineBorder(),
  );
}

buildGradientImage(String assetPath) {
  return ShaderMask(
    shaderCallback: (Rect bounds) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Palette.boldPink,
          Palette.seagull,
        ],
        stops: const [0.0, 1.0],
      ).createShader(bounds);
    },
    blendMode: BlendMode.srcATop,
    child: Image.asset(
      assetPath,
      scale: 10,
    ),
  );
}

buildGradientText(
    List<TyperAnimatedText> typer, Function(int, bool) onNextTyper) {
  return ShaderMask(
    shaderCallback: (bounds) => LinearGradient(colors: [
      Palette.boldPink,
      Palette.londonHue,
      Palette.lightPink,
    ]).createShader(
      Rect.fromLTWH(
        0,
        0,
        bounds.width,
        bounds.height,
      ),
    ),
    child: AnimatedTextKit(
      animatedTexts: typer,
      onNext: onNextTyper,
      repeatForever: true,
    ),
  );
}

buildTyper(String str) {
  return TyperAnimatedText(
    str,
    speed: const Duration(milliseconds: 100),
    textStyle: const TextStyle(),
  );
}

List<SettingList> itemsFromConstants = [
  SettingList(
    title: "Notifications",
    icon: Icons.edit_notifications_rounded,
  ),
  SettingList(
    title: "Dark Mode",
    icon: Icons.mode_night,
  ),
  SettingList(
    title: "About",
    icon: Icons.phone_iphone_rounded,
  ),
];

Widget editableListTile(
    String text,
    String field,
    bool isEditable,
    IconData iconData,
    Function Function(String field, String newValue) updateFieldInDatabase) {
  return EditableListTile(
    text: text,
    fieldToUpdate: field,
    iconLeading: iconData,
    fieldLength: 20,
    onUpdate: updateFieldInDatabase,
    isEditable: isEditable,
  );
}

dynamic snackBar(
  String messageText,
  Duration duration, {
  IconData icon = Icons.signal_wifi_statusbar_connected_no_internet_4_rounded,
  double width = 200.0,
  double overlayBlur = 5.0,
  bool isDissmissible = false,
  bool hasShadow = true,
}) {
  return Get.rawSnackbar(
    backgroundColor: Palette.seagull,
    isDismissible: isDissmissible,
    boxShadows: [
      if (hasShadow)
        const BoxShadow(
          color: Colors.black,
          offset: Offset(0, 5),
          blurRadius: 15,
        ),
    ],
    borderRadius: 10,
    margin: const EdgeInsets.all(25),
    messageText: Text(
      messageText,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Palette.textColor,
      ),
    ),
    snackPosition: SnackPosition.TOP,
    icon: Icon(
      icon,
      color: Palette.iconColor,
    ),
    shouldIconPulse: true,
    maxWidth: width,
    duration: duration,
    overlayBlur: overlayBlur,
    overlayColor: Colors.black.withOpacity(0.5),
    padding: const EdgeInsets.all(18),
  );
}

const aboutSubTitleStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);

List<Text> quote() {
  return [
    Text(
      "\" Fait les bon choix en silence et laisse ton succès faire le bruit. \"",
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
      ),
    ),
    Text(
      "- Frank Ocean -",
      textAlign: TextAlign.center,
      style: GoogleFonts.poppins(
        fontSize: 20,
        color: Palette.lightPink,
        fontWeight: FontWeight.bold,
      ),
    ),
  ];
}

String capitalizeFirst(String? input) {
  if (input == null) {
    return "text";
  }

  if (input.length <= 1) {
    return input;
  }
  return input[0].toUpperCase() + input.substring(1);
}

List<Widget> generateListTiles({
  required UserOfGift user,
  required UserOfGift friend,
  required Function(String, String) onUpdate,
}) {
  return [
    EditableListTile(
      text: capitalizeFirst(user.userName),
      fieldToUpdate: 'Username',
      iconLeading: Icons.person,
      fieldLength: 20,
      onUpdate: onUpdate,
    ),
    DatabaseService().isDataExist
        ? EditableListTile(
            text: capitalizeFirst(user.nicknames[friend.uid]),
            fieldToUpdate: 'Nickname',
            iconLeading: Icons.person_pin_rounded,
            fieldLength: 20,
            onUpdate: onUpdate,
          )
        : EditableListTile(
            text: capitalizeFirst("Nickname"),
            fieldToUpdate: 'Nickname',
            iconLeading: Icons.person_pin_rounded,
            fieldLength: 20,
            onUpdate: (preVal, nxtVal) {},
          ),
    EditableListTile(
      text: user.age.toString(),
      fieldToUpdate: 'age',
      iconLeading: Icons.calendar_month_rounded,
      fieldLength: 20,
      onUpdate: onUpdate,
    ),
    EditableListTile(
      text: user.giftSent.toString(),
      fieldToUpdate: 'Sent Gifts',
      iconLeading: Icons.card_giftcard,
      fieldLength: 20,
      onUpdate: onUpdate,
      isEditable: false,
    ),
  ];
}
