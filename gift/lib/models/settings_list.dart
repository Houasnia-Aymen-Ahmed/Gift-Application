import 'package:flutter/material.dart';

class SettingList {
  final String title;
  final IconData icon;
  bool isEnabled;

  SettingList({
    required this.title,
    required this.icon,
    this.isEnabled = false,
  });
}
