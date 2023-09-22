import 'package:flutter/material.dart';
import 'package:gift/models/user_of_gift.dart';
import 'package:gift/constants/constants.dart';
import 'package:gift/views/qr_code_view/scan_qrcode.dart';
import 'package:gift/views/qr_code_view/send_qrcode_page.dart';
import '../../services/notif.dart';
import '../../shared/show_logout_dialog_box.dart';

class QRCodePage extends StatefulWidget {
  final UserOfGift user;
  const QRCodePage({
    super.key,
    required this.user,
  });

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  final NotificationServices notifServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    notifServices.initialize(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double qrCodePos = (screenHeight / 2) - 175;
    double qrCodeTxtPos = qrCodePos - 50;
    double qrBtnPos = screenHeight / 9;
    double qrBtnTxtPos = qrBtnPos + 50;

    return Scaffold(
      backgroundColor: const Color(0xFF191622),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2F2452),
        actions: <Widget>[
          TextButton.icon(
            style: ButtonStyle(
              iconSize: const MaterialStatePropertyAll(22.5),
              foregroundColor: MaterialStateProperty.all(
                Colors.white,
              ),
            ),
            icon: const Icon(Icons.logout_rounded),
            label: const Text(
              "Logout",
              style: TextStyle(
                fontSize: 22.5,
              ),
            ),
            onPressed: () =>
                LogoutDialogHandler().showLogoutConfirmationDialog(context),
          ),
        ],
        title: const Text(
          'QR Code',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.5,
          ),
        ),
      ),
      body: _buildQRCodeBody(qrCodePos, qrCodeTxtPos, qrBtnPos, qrBtnTxtPos),
    );
  }

  Widget _buildQRCodeBody(
    double qrCodePos,
    double qrCodeTxtPos,
    double qrBtnPos,
    double qrBtnTxtPos,
  ) =>
      Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: qrCodePos,
            child: CreateQRCode(
              user: widget.user,
            ),
          ),
          Positioned(
            top: qrCodeTxtPos,
            child: Text(
              "Your QR Code",
              style: txt().copyWith(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
          ),
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
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScanQRCode(
                    myUser: widget.user,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Transform.scale(
                  scale: 1.5,
                  child: const Icon(Icons.qr_code_scanner_rounded),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: qrBtnTxtPos - 85,
            child: Text(
              "Or Scan your friend's QR ",
              style: txt().copyWith(
                color: Colors.white,
              ),
            ),
          )
        ],
      );
}
