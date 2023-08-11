import 'package:flutter/material.dart';
import 'package:gift/models/user_of_gift.dart';
import 'package:gift/services/auth.dart';
import 'package:gift/shared/constants.dart';
import 'package:gift/views/qr_code_view/scan_qrcode.dart';
import 'package:gift/views/qr_code_view/send_qrcode_page.dart';
import '../../services/notif.dart';

class QRCodePage extends StatefulWidget {
  final UserOfGift user;
  const QRCodePage({super.key, required this.user});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  final NotificationServices notifServices = NotificationServices();
  final AuthService _auth = AuthService();
  @override
  void initState() {
    super.initState();
    notifServices.requestNotificationPermission();
    notifServices.isTokentRefresh();
    notifServices.getDeviceToken().then((value) {});
    notifServices.fireaseInit(context);
    notifServices.setupInteractMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double qrCodePos = (screenHeight / 2) - 175;
    double qrCodeTxtPos = qrCodePos - 50;
    double qrBtnPos = screenHeight / 9;
    double qrBtnTxtPox = qrBtnPos + 50;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.1),
        elevation: 20,
        shadowColor: Colors.black,
        actions: <Widget>[
          TextButton.icon(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
              const Color(0xF06B5F92),
            )),
            icon: const Icon(Icons.logout_rounded),
            label: const Text("Logout"),
            onPressed: () async {
              await _auth.signOutAnon();
            },
          )
        ],
        title: const Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text(
            'QR Code',
            style: TextStyle(color: Color(0xF06B5F92)),
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(top: qrCodePos, child: const CreateQRCode()),
          Positioned(
              top: qrCodeTxtPos,
              child: Text("Your QR Code", style: txt.copyWith(fontSize: 20))),
          Positioned(
            bottom: qrBtnPos,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 25,
                  side: const BorderSide(
                    color: Colors.white,
                  ),
                  shadowColor: Colors.black,
                  backgroundColor: Colors.transparent.withOpacity(0),
                  fixedSize: const Size(150, 75),
                  shape: const CircleBorder(),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScanQRCode(myUser: widget.user,),
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Transform.scale(
                    scale: 1.5,
                    child: const Icon(Icons.qr_code_scanner_rounded),
                  ),
                )),
          ),
          Positioned(
              bottom: qrBtnTxtPox - 85,
              child: Text(
                "Or Scan your friend's QR ",
                style: txt,
              ))
        ],
      ),
    );
  }
}
