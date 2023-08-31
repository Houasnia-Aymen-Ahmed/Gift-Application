import 'package:flutter/material.dart';
import '../shared/pallete.dart';

ThemeData lightTheme = ThemeData.light().copyWith(
  appBarTheme: AppBarTheme(
    backgroundColor: Palette.londonHue.withOpacity(0.5),
    shadowColor: Colors.black,
    elevation: 20,
  ),
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  appBarTheme: AppBarTheme(
      backgroundColor: Palette.londonHue.withOpacity(0.5),
      shadowColor: Colors.black,
      elevation: 20),
);
