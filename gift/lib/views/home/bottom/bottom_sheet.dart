import 'package:flutter/material.dart';
import 'package:gift/models/settings_list.dart';
import 'package:gift/constants/constants.dart';
import 'package:gift/constants/bottom_sheet_constants.dart';
import 'package:gift/views/home/bottom/bottom_sheet_content.dart';
import 'package:gift/views/home/bottom/bottom_sheet_button_list.dart';
import '../../../models/user_of_gift.dart';
import '../../../shared/pallete.dart';

class BottomSheetHelper {
  static int _selectedButtonIndex = 0;
  static String imageAsset = GiftImage.giftCard;
  static bool isDone = false;
  static bool isEnabled = false;
  static List<SettingList> items = itemsFromConstants;

  static void show(
      BuildContext context, UserOfGift user, Function(int) onButtonTap,
      {int preSelected = 0}) {
    _showBottomSheet(context, user, onButtonTap, preSelected);
  }

  static void _showBottomSheet(BuildContext context, UserOfGift user,
      Function(int) onButtonTap, int preSelected) {
    imageAsset = GiftImage.giftCard;
    _selectedButtonIndex = preSelected;
    isEnabled = user.enableNotif;
    showModalBottomSheet(
      context: context,
      backgroundColor: Palette.pinkyPink,
      enableDrag: true,
      showDragHandle: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(35),
        ),
      ),
      builder: (BuildContext context) {
        Size screenSize = MediaQuery.of(context).size;
        return StatefulBuilder(
          builder: (context, StateSetter setState) => Container(
            constraints: BoxConstraints(maxHeight: screenSize.height * 0.45),
            height: screenSize.height * 0.4,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: BottomSheetContent.buildBottomSheetContent(
                    setState,
                    user,
                    screenSize,
                    context,
                    _selectedButtonIndex,
                    ((index) => setState(
                          () => _selectedButtonIndex = index,
                        )),
                  ),
                ),
                Container(
                  constraints:
                      BoxConstraints(maxWidth: screenSize.width * 0.75),
                  width: screenSize.width * 0.6,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Palette.lightPink,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ...generateListButtons(
                        setState: setState,
                        selectedButtonIndex: _selectedButtonIndex,
                        onButtonTap: onButtonTap,
                        onUpdate: ((index) {
                          _selectedButtonIndex = index;
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
