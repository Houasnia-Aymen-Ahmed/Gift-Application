import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gift/services/auth.dart';
import 'package:gift/shared/constants.dart';
import 'package:gift/shared/loading.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // Text field state
  String _email = "";
  String _password = "";
  String _error = "";

  void buttonController() async {
    if (_formKey.currentState!.validate()) {
      setState(() => loading = true);
      dynamic result =
          await _auth.signInWithEmailAndPassword(_email, _password);
      if (result == null) {
        setState(() {
          loading = false;
          _error = "Couldn't sign in with those credentials";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return loading
        ? const Loading()
        : Scaffold(
            body: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/pic1.jpg"),
                    fit: BoxFit.cover),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: SingleChildScrollView(
                    child: Container(
                      height: screenHeight *0.6,
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
                              const Spacer(flex: 2,),
                              Text(
                                "Sign In",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50,
                                ),
                              ),
                              const Spacer(flex: 2,),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(35, 10, 35, 10),
                                child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 275),
                                  child: TextFormField(
                                    decoration: textInputDecoation.copyWith(
                                        hintText: "Email"),
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
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(35, 10, 35, 10),
                                child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 275),
                                  child: TextFormField(
                                    decoration: textInputDecoation.copyWith(
                                        hintText: "Password"),
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
                                  ),
                                ),
                              ),
                              const Spacer(flex: 2,),
                              
                              
                              ElevatedButton(
                                style: elevatedBtnStyle,
                                onPressed: () async {
                                  buttonController();
                                },
                                child: BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                                  child: Text(
                                    "Sign In",
                                    style: txt,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "You don't have an account?",
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
                                      "Create one",
                                      style: txt.copyWith(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(flex: 2,),
                              Text(
                                _error,
                                style: TextStyle(
                                  color: Colors.red[900],
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              const Spacer(flex: 2,),
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
