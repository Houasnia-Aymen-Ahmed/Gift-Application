import 'package:get/get.dart';
import 'package:gift/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gift/services/database.dart';

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
        imagePath:
            '',
        giftRecieved: 0,
        giftSent: 0,
        usrUid: user!.uid,
        friend: '',
        friendMessage: '',
        friendList: [],
        enableNotif: true,
        nicknames: {}
        
      );
      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  Future<void> logout(SnackbarController snackbarController) async {
    try {
      await _auth.signOut();
      Get.back();
    } catch (e) {
      snackbarController;
    }
  }
}
