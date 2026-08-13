import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:gift/constants/constants.dart';
import '../../models/user_of_gift.dart';
import '../../services/database.dart';
import '../../services/push_worker.dart';

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
  final DatabaseService _databaseService = DatabaseService();
  final MobileScannerController controller = MobileScannerController();
  String? lastCode;
  String? errorText;
  bool _hasScanned = false;

  Future<void> _handleDetection(BarcodeCapture capture) async {
    if (_hasScanned) return;
    final scannedCode = capture.barcodes.firstOrNull?.rawValue;
    if (scannedCode == null || scannedCode.isEmpty) return;
    if (scannedCode == widget.myUser.uid) return;

    _hasScanned = true;
    setState(() => lastCode = scannedCode);
    await controller.stop();

    final friendUserData = await _databaseService.getUserDataOnce(scannedCode);
    if (friendUserData == null) {
      setState(() => errorText = "Invalid QR code");
      _hasScanned = false;
      await controller.start();
      return;
    }

    await _databaseService.sendFriendRequest(friendUserData.uid);
    PushWorkerService.notify(
      recipientUid: friendUserData.uid,
      senderUid: widget.myUser.uid,
      kind: 'friend',
      senderName: widget.myUser.userName,
    );

    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            MobileScanner(
              controller: controller,
              onDetect: _handleDetection,
            ),
            Positioned(
              bottom: 50,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xF2191622).withOpacity(0.75),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  errorText ??
                      (lastCode != null ? ":$lastCode" : "Result not found"),
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
                      onPressed: () => controller.toggleTorch(),
                      icon: ValueListenableBuilder(
                        valueListenable: controller,
                        builder: (context, state, child) {
                          return Icon(
                            state.torchState == TorchState.on
                                ? Icons.flash_on_rounded
                                : Icons.flash_off_rounded,
                            color: Colors.white,
                          );
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () => controller.switchCamera(),
                      icon: const Icon(
                        Icons.flip_camera_android_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
}
