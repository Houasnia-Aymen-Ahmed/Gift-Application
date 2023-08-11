import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

final txt = GoogleFonts.poppins(
    color: Colors.white,
    fontSize: 15,
    fontWeight: FontWeight.bold
  );


final elevatedBtnStyle = ElevatedButton.styleFrom(
  shadowColor: Colors.white.withOpacity(0.1),
  backgroundColor: Colors.transparent,
  elevation: 1,
  fixedSize: const Size(100, 50),
);

final textDisabled = Text(
  "Your friend's Message",
  style: txt.copyWith(fontSize: 25, color: Colors.grey),
  textAlign: TextAlign.center,
);
