import 'package:flutter/material.dart';
import 'package:gift/models/user_of_gift.dart';
import 'package:gift/services/auth.dart';
import 'package:gift/shared/loading.dart';
import 'package:gift/views/home/home.dart';
import 'package:gift/views/qr_code_view/qrcode_page.dart';
import '../../models/user.dart';
import '../../services/database.dart';

class QRCodeWrapper extends StatefulWidget {
  final UserHandler user;
  const QRCodeWrapper({
    super.key,
    required this.user,
  });

  @override
  State<QRCodeWrapper> createState() => _QRCodeWrapperState();
}

class _QRCodeWrapperState extends State<QRCodeWrapper> {
  late final DatabaseService _dataService;
  late final AuthService _auth;

  @override
  void initState() {
    super.initState();
    _dataService = DatabaseService();
    _auth = AuthService();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<UserOfGift>(
      stream: _dataService.getUserDataStream(_auth.currentUsr!.uid),
      builder: (context, snapshot) {
        return _buildContent(snapshot);        
      },
    );

  Widget _buildContent(AsyncSnapshot<dynamic> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Loading();
    } else if (snapshot.hasError) {
      return Text('An error occurred while loading data: ${snapshot.error}');
    } else if (!snapshot.hasData) {
      return const Text('No user data available');
    } else {
      final UserOfGift user = snapshot.data!;
      return user.friend == '' ? QRCodePage(user: user) : const Home();
    }
  }
}
