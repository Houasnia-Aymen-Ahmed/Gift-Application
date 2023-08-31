import 'package:flutter/material.dart';
import 'package:gift/models/user.dart';
import 'package:gift/views/authenticate/authenticate.dart';
import 'package:gift/views/qr_code_view/qr_wrapper.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserHandler?>(
      builder: (context, user, _){
        if (user == null) {
          return const Authenticate();
        } else {
          return QRCodeWrapper(
            user: user,
          );
        }
      }
    ) ;    
  }
}
