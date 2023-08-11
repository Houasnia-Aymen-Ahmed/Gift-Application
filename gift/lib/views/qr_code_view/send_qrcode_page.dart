import 'package:flutter/material.dart';
import 'package:gift/services/auth.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CreateQRCode extends StatefulWidget {
  const CreateQRCode({super.key});

  @override
  State<CreateQRCode> createState() => _CreateQRCodeState();
}

class _CreateQRCodeState extends State<CreateQRCode> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          QrImageView(
            data: AuthService().currentUsr!.uid,
            size: 250,
            version: QrVersions.auto,
            backgroundColor: Colors.transparent,
            dataModuleStyle: const QrDataModuleStyle(
              color: Colors.white,
              dataModuleShape: QrDataModuleShape.square,
            ),
            eyeStyle: const QrEyeStyle(
              color: Colors.white,
              eyeShape: QrEyeShape.square,
            ),
          )
        ],
      ),
    );
  }
}
