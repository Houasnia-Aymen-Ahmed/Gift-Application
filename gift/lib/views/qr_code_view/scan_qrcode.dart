import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gift/services/notif.dart';
import 'package:gift/constants/constants.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../models/user_of_gift.dart';
import '../../services/database.dart';

class ScanQRCode extends StatefulWidget {
  final UserOfGift myUser;
  const ScanQRCode({
    super.key,
    required this.myUser,
  });

  @override
  State<ScanQRCode> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode> {
  final qrKey = GlobalKey(debugLabel: "QR");
  final DatabaseService _databaseService = DatabaseService();
  late Stream<UserOfGift> userStream;
  late UserOfGift? myUserData;
  late UserOfGift? friendUserData;
  Barcode? code;
  QRViewController? controller;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    userStream = _databaseService.getUserDataStream(widget.myUser.uid);
    userStream.listen((user) {
      setState(() {
        myUserData = user;
      });
    });
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen(
      (code) => setState(
        () {
          this.code = code;
          _handleScannedUser(code.code!);
        },
      ),
    );
  }

  void _handleScannedUser(String scannedCode) {
    _databaseService.getUserDataStream(scannedCode).listen((user) {
      friendUserData = user;
      if (mounted) {
        onQRScanSuccess();
      }
    });
  }

  void onQRScanSuccess() {
    if (friendUserData != null) {
      NotificationServices()
          .sendNotif(friendUserData!.token, myUserData!, 'friend', "");

      String usrUid = myUserData!.uid;
      String friendUid = friendUserData!.uid;
      _databaseService.updateUserSpecificData(
          uid: myUserData!.uid, friend: friendUid, addFriend: friendUid);
      _databaseService.updateUserSpecificData(
          uid: friendUserData?.uid, friend: usrUid, addFriend: usrUid);
    }
  }

  @override
  void reassemble() async {
    if (!_isDisposed) {
      super.reassemble();
      if (Platform.isAndroid) {
        await controller!.pauseCamera();
      }
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    if (mounted) {
      super.dispose();
      _isDisposed = true;
      controller?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            buildQrView(context),
            Positioned(
              bottom: 50,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xF2191622).withOpacity(0.75),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  code != null ? ":${code!.code}" : "Result not found",
                  maxLines: 3,
                  style: txt().copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 75,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xF2191622).withOpacity(0.75),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () async {
                        await controller?.toggleFlash();
                        setState(() {});
                      },
                      icon: FutureBuilder<bool?>(
                        future: controller?.getFlashStatus(),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return Icon(
                              snapshot.data!
                                  ? Icons.flash_on_rounded
                                  : Icons.flash_off_rounded,
                              color: Colors.white,
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await controller?.flipCamera();
                        setState(() {});
                      },
                      icon: FutureBuilder(
                        future: controller?.getCameraInfo(),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return const Icon(
                              Icons.flip_camera_android_rounded,
                              color: Colors.white,
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderRadius: 25,
          borderColor: const Color(0xF2191622).withOpacity(1),
          overlayColor: const Color(0xF2191622).withOpacity(0.5),
          borderLength: 50,
          borderWidth: 20,
          cutOutSize: MediaQuery.of(context).size.width * 0.75,
        ),
      );
}
