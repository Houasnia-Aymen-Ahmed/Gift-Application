import 'package:flutter/material.dart';
import 'package:gift/shared/pallete.dart';
import 'package:gift/views/home/bottom/index_views.dart';
import '../../../models/settings_list.dart';
import '../../../models/user_of_gift.dart';
import 'settings_list_tile.dart';
import '../../qr_code_view/qrcode_page.dart';
import '../../../constants/bottom_sheet_constants.dart';

class BottomSheetContent {
  static Widget buildBottomSheetContent(
    StateSetter setStat,
    UserOfGift user,
    Size screenSize,
    BuildContext context,
    int selectedButtonIndex,
    Function(int) updateSelectedIndex,
  ) {
    List<SettingList> items = OtherConstants.items;
    if (selectedButtonIndex == 0) {
      return const FirstIndexView();
    } else if (selectedButtonIndex == 1) {
      return SecondIndexView(user: user, screenSize: screenSize);
    } else if (selectedButtonIndex == 2) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRCodePage(user: user),
          ),
        ),
      );
      Future.delayed(const Duration(milliseconds: 50),
          () => setStat(() => updateSelectedIndex(0)));
      return Center(
        child: Icon(
          Icons.qr_code_rounded,
          size: 75,
          color: Palette.boldPink,
          shadows: [
            BoxShadow(
              color: Palette.pinkyPink,
              blurRadius: 15,
              spreadRadius: 15,
            )
          ],
        ),
      );
    } else if (selectedButtonIndex == 3) {
      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final SettingList item = items[index];
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: SettingListTile(
              item: item,
              user: user,
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
