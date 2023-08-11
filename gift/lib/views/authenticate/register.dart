import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gift/shared/constants.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/auth.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  const SignUp({super.key, required this.toggleView});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  // Text field state
  String _email = "";
  String _password = "";
  String _error = "";

  void buttonController() async {
    if (_formKey.currentState!.validate()) {
      dynamic result =
          await _auth.signUpWithEmailAndPassword(_email, _password);
      if (result == null) {
        setState(() {
          _error =
              "Couldn't Register with those Credientials, Please try again";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/pic1.jpg"), fit: BoxFit.cover),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: SingleChildScrollView(
              child: Container(
                height: screenHeight * 0.6,
                width: 350,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      colors: [const Color(0xF2191622).withOpacity(0.1), const Color(0xF2191622).withOpacity(1)]),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    width: 2,
                    color: Colors.white30,
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Spacer(
                        flex: 2,
                      ),
                      Text(
                        "Sign Up",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                        ),
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(35, 10, 35, 10),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 275),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            enableSuggestions: false,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter an Email";
                              } else if (!val.contains('@')) {
                                return "Please enter a valid Email";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              setState(() => _email = val);
                            },
                            decoration:
                                textInputDecoation.copyWith(hintText: "Email"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(35, 10, 35, 10),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 275),
                          child: TextFormField(
                            obscureText: true,
                            autocorrect: false,
                            enableSuggestions: false,
                            validator: (val) {
                              return val!.length < 6
                                  ? "The password must be at least 6 characters long"
                                  : null;
                            },
                            onChanged: (val) {
                              setState(() => _password = val);
                            },
                            decoration: textInputDecoation.copyWith(
                                hintText: "Password"),
                          ),
                        ),
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                      ElevatedButton(
                        style: elevatedBtnStyle,
                        onPressed: () {
                          buttonController();
                        },
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                          child: Text(
                            "Sign Up",
                            style: txt,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: GoogleFonts.poppins(),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                  Colors.white.withOpacity(0.1)),
                            ),
                            onPressed: () {
                              widget.toggleView();
                            },
                            child: Text(
                              "Sign In",
                              style: txt.copyWith(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 275),
                        child: Text(
                          _error,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              
                              color: Colors.red[900],
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
