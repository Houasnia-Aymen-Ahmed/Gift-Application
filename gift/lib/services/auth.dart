// ignore_for_file: unused_import
import 'package:gift/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gift/services/database.dart';
import 'package:gift/services/notif.dart';
import '../models/user_of_gift.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // create user object based on firebaseUser
  UserHandler _userFromFirebaseUser(User? user) {
    return UserHandler(uid: user!.uid);
  }

  // auth change user stream
  User? get currentUsr {
    return _auth.currentUser;
  }

  Stream<UserHandler> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      return null;
    }
  }

  // sign in with email & password
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
      // Create a doc for the user
      await DatabaseService(uid: user?.uid).updateUserData(
        userName: userName,
        age: 0,
        nickName: 'nickName',
        imagePath:
            'https://firebasestorage.googleapis.com/v0/b/gift-present-app.appspot.com/o/files%2FdefaultAvatarImage.png?alt=media&token=708309f5-0873-4f6c-9198-c2b1a690bbe5',
        giftRecieved: 0,
        giftSent: 0,
        usrUid: user!.uid,
        friend: '',
      );
      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  // Sign out
  Future signOutAnon() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
