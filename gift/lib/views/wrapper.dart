// ignore_for_file: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gift/models/user.dart';
import 'package:gift/services/database.dart';
import 'package:gift/views/authenticate/authenticate.dart';
import 'package:gift/views/home/home.dart';
import 'package:gift/views/qr_code_view/qr_wrapper.dart';
import 'package:gift/views/qr_code_view/qrcode_page.dart';
import 'package:provider/provider.dart';


class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserHandler?>(context);
    // return home or authenticate
    if (user == null) {
      return const Authenticate();
    } else {
      return QRCodeWrapper(user: user,);
    }
  }
}
