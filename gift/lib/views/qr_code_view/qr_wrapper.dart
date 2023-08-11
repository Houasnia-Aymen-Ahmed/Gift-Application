import 'package:flutter/material.dart';
import 'package:gift/services/auth.dart';
import 'package:gift/shared/loading.dart';
import 'package:gift/views/home/home.dart';
import 'package:gift/views/qr_code_view/qrcode_page.dart';
import '../../models/user.dart';
import '../../services/database.dart';

class QRCodeWrapper extends StatefulWidget {
  final UserHandler user;
  const QRCodeWrapper({super.key, required this.user});
  @override
  State<QRCodeWrapper> createState() => _QRCodeWrapperState();
}

class _QRCodeWrapperState extends State<QRCodeWrapper> {
  final DatabaseService _dataService = DatabaseService();
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _dataService.getUserDataStream(_auth.currentUsr!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loading();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text('No user data available');
        } else {
          final user = snapshot.data!;
          if (user.friend == '') {
            return QRCodePage(user: user);
          } else {
            return const Home();
          }
        }
        
      },
    );
  }
}
