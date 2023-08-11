import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_of_gift.dart';
import 'auth.dart';

class DatabaseService {
  final AuthService _auth = AuthService();
  final String? uid;
  DatabaseService({this.uid});

  CollectionReference userColl =
      FirebaseFirestore.instance.collection("UserCollection");

  bool hasFriend(UserOfGift user) {
    try {
      if (user.friend != "") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future updateUserData(
      {required String userName,
      required String nickName,
      required int age,
      String message = '',
      required String imagePath,
      required int giftRecieved,
      required int giftSent,
      required String friend,
      String token = '',
      required String usrUid}) async {
    return await userColl.doc(uid).set({
      'username': userName,
      'nickname': nickName,
      'age': age,
      'imagepath': imagePath,
      'giftRecieved': giftRecieved,
      'giftSent': giftSent,
      'uid': usrUid,
      'message': message,
      'friend': friend,
      'token': token
    });
  }

  Future updateUserSpecificData(
      {String? username,
      String? nickname,
      int? age,
      String? friend,
      String? imagepath,
      int? giftRecieved,
      int? giftSent,
      String? message,
      String? token,
      String? uid}) async {
    //List changes = [username, nickname, age, imagepath, total, token];
    Map<String, dynamic> map = {
      "username": username,
      "nickname": nickname,
      "age": age,
      "friend": friend,
      "imagepath": imagepath,
      "giftRecieved": giftRecieved,
      "giftSent": giftSent,
      "message": message,
      "token": token,
    };
    String usrUid = uid ?? _auth.currentUsr!.uid;
    for (var entry in map.entries) {
      if (entry.value != null) {
        return await userColl.doc(usrUid).update({
          entry.key.toString(): entry.value,
        });
      }
    }
  }

  UserOfGift _currentUserFromSnapshots(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      Map<String, dynamic> doc = snapshot.data() as Map<String, dynamic>;
      return UserOfGift(
          userName: doc["username"] ?? '',
          nickName: doc["nickname"] ?? '',
          age: doc["age"] ?? 0,
          imagePath: doc["imagepath"] ??
              'https://firebasestorage.googleapis.com/v0/b/gift-present-app.appspot.com/o/files%2FdefaultAvatarImage.png?alt=media&token=708309f5-0873-4f6c-9198-c2b1a690bbe5',
          giftRecieved: doc["giftRecieved"] ?? 0,
          giftSent: doc["giftSent"] ?? 0,
          message: doc["message"] ?? '',
          token: doc["token"] ?? '',
          friend: doc["friend"] ?? '',
          uid: doc["uid"] ?? '');
    } else {
      return UserOfGift(
          userName: 'userName',
          age: 0,
          nickName: 'nickName',
          imagePath:
              'https://firebasestorage.googleapis.com/v0/b/gift-present-app.appspot.com/o/files%2FdefaultAvatarImage.png?alt=media&token=708309f5-0873-4f6c-9198-c2b1a690bbe5',
          giftRecieved: 0,
          giftSent: 0,
          message: '',
          token: '',
          friend: '',
          uid: '');
    }
  }

  Stream<UserOfGift> getUserDataStream(String userId) {
    return userColl.doc(userId).snapshots().map(_currentUserFromSnapshots);
  }
}
