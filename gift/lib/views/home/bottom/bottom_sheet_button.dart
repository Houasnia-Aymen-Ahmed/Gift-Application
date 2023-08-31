import 'package:flutter/material.dart';
import '../../../shared/pallete.dart';

class BottomSheetButton {
  static Widget buildButton(
    int index,
    IconData icon,
    StateSetter setState,
    Function(int) onButtonTap,
    int selectedButtonIndex,
    Function(int) updateSelectedIndex,
  ) {
    final isSelected = index == selectedButtonIndex;
    final containerColor = isSelected ? Palette.boldPink : Palette.lightPink;
    final iconColor = !isSelected ? Palette.boldPink : Palette.lightPink;
    final List<IconData> icons = [
      Icons.home_rounded,
      Icons.people_rounded,
      Icons.qr_code_rounded,
      Icons.settings,
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: containerColor,
      ),
      child: IconButton(
        icon: Icon(icons[index]),
        color: iconColor,
        iconSize: 27.5,
        onPressed: () {
          setState(() => updateSelectedIndex(index));
          onButtonTap(index);
        },
      ),
    );
  }
}
