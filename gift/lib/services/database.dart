import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_of_gift.dart';
import 'auth.dart';

class DatabaseService {
  final AuthService _auth = AuthService();
  final String? uid;
  bool isDataExist = true;
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

  Future updateUserData({
    required String userName,
    required String nickName,
    required int age,
    String message = '',
    required String imagePath,
    required int giftRecieved,
    required int giftSent,
    required String friend,
    required String friendMessage,
    required List friendList,
    String token = '',
    required String usrUid,
    required bool enableNotif,
    required Map<String, String> nicknames,
  }) async {
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
      'friendMessage': friendMessage,
      'friendList': friendList,
      'token': token,
      'enableNotif': enableNotif,
      'nicknames': nicknames,
    });
  }

  Future<void> deleteFriendFromList(String itemToRemove) async {
    await userColl.doc(_auth.currentUsr!.uid).update({
      "friendList": FieldValue.arrayRemove([itemToRemove]),
    });
    await userColl.doc(_auth.currentUsr!.uid).update({
      "nicknames.$itemToRemove": FieldValue.delete(),
    });
  }

  Future updateUserSpecificData({
    String? username,
    String? nickname,
    int? age,
    String? friend,
    String? friendMessage,
    String? addFriend,
    String? imagepath,
    int? giftRecieved,
    int? giftSent,
    String? message,
    String? token,
    String? uid,
    bool? enableNotif,
    String? addNickname,
  }) async {
    String usrUid = uid ?? _auth.currentUsr!.uid;

    if (addFriend != null) {
      await userColl.doc(usrUid).update({
        "friendList": FieldValue.arrayUnion([addFriend]),
      });
      final userDoc = userColl.doc(usrUid);
      final userData = await userDoc.get();
      final currentNicknames =
          Map<String, String>.from(userData.get("nicknames") ?? {});

      currentNicknames[addFriend] = 'nickname';
      await userDoc.update({
        "nicknames": currentNicknames,
      });
    }

    if (addNickname != null && addFriend != null) {
      final userDoc = userColl.doc(usrUid);
      final currentNicknames = Map<String, String>.from(
          (await userDoc.get()).get("nicknames") ?? {});

      currentNicknames[addFriend] = addNickname;
      await userDoc.update({
        "nicknames": currentNicknames,
      });
    }

    Map<String, dynamic> map = {
      "username": username,
      "nickname": nickname,
      "age": age,
      "friend": friend,
      "friendMessage": friendMessage,
      "enableNotif": enableNotif,
      "imagepath": imagepath,
      "giftRecieved": giftRecieved,
      "giftSent": giftSent,
      "message": message,
      "token": token,
    };
    for (var entry in map.entries) {
      if (entry.value != null) {
        await userColl.doc(usrUid).update({
          entry.key.toString(): entry.value,
        });
      }
    }
  }

  UserOfGift _currentUserFromSnapshots(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      isDataExist = true;
      Map<String, dynamic> doc = snapshot.data() as Map<String, dynamic>;
      return UserOfGift(
        userName: doc["username"] ?? '',
        nickName: doc["nickname"] ?? '',
        age: doc["age"] ?? 0,
        imagePath: doc["imagepath"] ?? '',
        giftRecieved: doc["giftRecieved"] ?? 0,
        giftSent: doc["giftSent"] ?? 0,
        message: doc["message"] ?? '',
        token: doc["token"] ?? '',
        friend: doc["friend"] ?? '',
        friendMessage: doc["friendMessage"] ?? '',
        friendList: doc["friendList"] ?? [],
        uid: doc["uid"] ?? '',
        enableNotif: doc["enableNotif"] ?? true,
        nicknames: Map<String, String>.from(doc["nicknames"] ?? {}),
      );
    } else {
      isDataExist = false;
      return UserOfGift(
        userName: 'userName',
        age: 0,
        nickName: 'nickName',
        imagePath: '',
        giftRecieved: 0,
        giftSent: 0,
        message: '',
        token: '',
        friend: '',
        friendMessage: '',
        friendList: [],
        uid: '',
        enableNotif: true,
        nicknames: {},
      );
    }
  }

  Stream<UserOfGift> getUserDataStream(String userId) {
    return userColl.doc(userId).snapshots().map(_currentUserFromSnapshots);
  }

  Stream<QuerySnapshot> get users {
    return userColl.snapshots();
  }
}
