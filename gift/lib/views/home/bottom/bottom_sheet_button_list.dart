import 'package:flutter/material.dart';
import 'bottom_sheet_button.dart';

List<Widget> generateListButtons({
  required StateSetter setState,
  required int selectedButtonIndex,
  required Function(int) onButtonTap,
  required Function(int) onUpdate,
}) =>
    [
      BottomSheetButton.buildButton(0, Icons.home_rounded, setState,
          onButtonTap, selectedButtonIndex, onUpdate),
      BottomSheetButton.buildButton(1, Icons.people_rounded, setState,
          onButtonTap, selectedButtonIndex, onUpdate),
      BottomSheetButton.buildButton(2, Icons.qr_code_rounded, setState,
          onButtonTap, selectedButtonIndex, onUpdate),
      BottomSheetButton.buildButton(3, Icons.settings, setState, onButtonTap,
          selectedButtonIndex, onUpdate),
    ];
