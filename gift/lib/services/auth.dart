import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gift/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gift/services/database.dart';
import '../constants/constants.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserHandler _userFromFirebaseUser(User? user) => UserHandler(uid: user!.uid);

  User? get currentUsr => _auth.currentUser;

  Stream<UserHandler> get user =>
      _auth.authStateChanges().map(_userFromFirebaseUser);

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      return null;
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      String? userName = user?.email?.split('@')[0] ?? '';

      await DatabaseService(uid: user?.uid).updateUserData(
          userName: userName,
          age: 0,
          nickName: 'nickName',
          imagePath: '',
          giftRecieved: 0,
          giftSent: 0,
          usrUid: user!.uid,
          friend: '',
          friendMessage: '',
          friendList: [],
          enableNotif: true,
          nicknames: {});
      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
      Get.back();
      snackBar(
        "Error\nLogging out",
        const Duration(milliseconds: 2500),
        icon: Icons.close_rounded,
        width: 350.0,
      );
    }
    Get.back();
    snackBar(
      "Successfully logged out",
      const Duration(milliseconds: 1500),
      icon: Icons.check_circle_rounded,
      width: 350.0,
      overlayBlur: 0.1,
      isDissmissible: false,
      hasShadow: false,
    );
  }
}
