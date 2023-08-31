import 'package:flutter/material.dart';
import 'build_view.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  const SignUp({
    super.key,
    required this.toggleView,
  });

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return BuildView(
      title: "Sign Up",
      toggleView: widget.toggleView,
    );
  }
}
