import 'package:flutter/material.dart';
import 'package:gift/views/authenticate/build_view.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({
    super.key,
    required this.toggleView,
  });

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return BuildView(
      title: "Sign In",
      toggleView: widget.toggleView,
    );
  }
}
