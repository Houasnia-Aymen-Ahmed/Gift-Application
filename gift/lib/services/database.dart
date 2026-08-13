import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/friend_request.dart';
import '../models/conversation_message.dart';
import '../models/user_of_gift.dart';
import 'auth.dart';

class DatabaseService {
  final AuthService _auth = AuthService();
  final String? uid;
  DatabaseService({this.uid});

  CollectionReference userColl =
      FirebaseFirestore.instance.collection("UserCollection");

  CollectionReference friendRequestColl =
      FirebaseFirestore.instance.collection("FriendRequests");

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
      "widgetFriends": FieldValue.arrayRemove([itemToRemove]),
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
    }..removeWhere((key, value) => value == null);

    if (map.isNotEmpty) {
      await userColl.doc(usrUid).update(map);
    }
  }

  /// An empty `widgetFriends` means "every friend is in widget rotation"
  /// (see WidgetService.eligibleFriendUids) — so turning one friend off
  /// from that implicit-all state has to first materialize the full list
  /// before removing them, otherwise there'd be nothing to distinguish
  /// "never customized" from "explicitly chose nobody".
  Future<void> setWidgetFriend(
      UserOfGift user, String friendUid, bool include) async {
    List<String> current = user.widgetFriends.cast<String>().toList();
    if (current.isEmpty) {
      current = user.friendList.cast<String>().toList();
    }
    if (include) {
      if (!current.contains(friendUid)) current.add(friendUid);
    } else {
      current.remove(friendUid);
    }
    await userColl.doc(user.uid).update({"widgetFriends": current});
  }

  Future<void> incrementGiftSent(String uid) async {
    await userColl.doc(uid).update({
      "giftSent": FieldValue.increment(1),
    });
  }

  Future<void> incrementGiftReceived(String uid) async {
    await userColl.doc(uid).update({
      "giftRecieved": FieldValue.increment(1),
    });
  }

  UserOfGift _currentUserFromSnapshots(DocumentSnapshot snapshot) {
    if (snapshot.exists) {
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
        exists: true,
        widgetFriends: doc["widgetFriends"] ?? [],
      );
    } else {
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
        exists: false,
        widgetFriends: [],
      );
    }
  }

  Stream<UserOfGift> getUserDataStream(String userId) {
    return userColl.doc(userId).snapshots().map(_currentUserFromSnapshots);
  }

  Future<UserOfGift?> getUserDataOnce(String userId) async {
    final snapshot = await userColl.doc(userId).get();
    if (!snapshot.exists) return null;
    return _currentUserFromSnapshots(snapshot);
  }

  Stream<QuerySnapshot> get users {
    return userColl.snapshots();
  }

  String conversationId(String uidA, String uidB) {
    final sorted = [uidA, uidB]..sort();
    return sorted.join('_');
  }

  CollectionReference _messagesColl(String pairId) => FirebaseFirestore
      .instance
      .collection("Conversations")
      .doc(pairId)
      .collection("messages");

  Future<void> sendConversationMessage({
    required String otherUid,
    required String text,
    String kind = 'message',
  }) async {
    final myUid = _auth.currentUsr!.uid;
    final pairId = conversationId(myUid, otherUid);
    await _messagesColl(pairId).add({
      'from': myUid,
      'to': otherUid,
      'text': text,
      'kind': kind,
      'sentAt': FieldValue.serverTimestamp(),
    });
  }

  Future<ConversationMessage?> latestMessageOnce(String otherUid) async {
    final myUid = _auth.currentUsr!.uid;
    final pairId = conversationId(myUid, otherUid);
    final snap = await _messagesColl(pairId)
        .orderBy('sentAt', descending: true)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    final doc = snap.docs.first;
    final data = doc.data() as Map<String, dynamic>;
    return ConversationMessage(
      id: doc.id,
      from: data['from'] ?? '',
      to: data['to'] ?? '',
      text: data['text'] ?? '',
      kind: data['kind'] ?? 'message',
      sentAt: (data['sentAt'] as Timestamp?)?.toDate(),
    );
  }

  Stream<ConversationMessage?> latestMessageStream(String otherUid) {
    final myUid = _auth.currentUsr!.uid;
    final pairId = conversationId(myUid, otherUid);
    return _messagesColl(pairId)
        .orderBy('sentAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snap) {
      if (snap.docs.isEmpty) return null;
      final doc = snap.docs.first;
      final data = doc.data() as Map<String, dynamic>;
      return ConversationMessage(
        id: doc.id,
        from: data['from'] ?? '',
        to: data['to'] ?? '',
        text: data['text'] ?? '',
        kind: data['kind'] ?? 'message',
        sentAt: (data['sentAt'] as Timestamp?)?.toDate(),
      );
    });
  }

  Stream<int> giftCountStream(String otherUid) {
    final myUid = _auth.currentUsr!.uid;
    final pairId = conversationId(myUid, otherUid);
    return _messagesColl(pairId)
        .where('kind', isEqualTo: 'gift')
        .snapshots()
        .map((snap) => snap.docs.length);
  }

  Future<void> sendFriendRequest(String toUid) async {
    final myUid = _auth.currentUsr!.uid;
    await friendRequestColl.add({
      'from': myUid,
      'to': toUid,
      'status': 'pending',
    });
  }

  List<FriendRequest> _toFriendRequests(QuerySnapshot snap) {
    return snap.docs.map((d) {
      final data = d.data() as Map<String, dynamic>;
      return FriendRequest(
        id: d.id,
        from: data['from'] ?? '',
        to: data['to'] ?? '',
        status: data['status'] ?? '',
      );
    }).toList();
  }

  Stream<List<FriendRequest>> incomingFriendRequests() {
    final myUid = _auth.currentUsr!.uid;
    return friendRequestColl
        .where('to', isEqualTo: myUid)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map(_toFriendRequests);
  }

  Stream<List<FriendRequest>> acceptedOutgoingRequests() {
    final myUid = _auth.currentUsr!.uid;
    return friendRequestColl
        .where('from', isEqualTo: myUid)
        .where('status', isEqualTo: 'accepted')
        .snapshots()
        .map(_toFriendRequests);
  }

  Future<void> acceptFriendRequest(FriendRequest request) async {
    await updateUserSpecificData(
        uid: request.to, friend: request.from, addFriend: request.from);
    await friendRequestColl.doc(request.id).update({'status': 'accepted'});
  }

  Future<void> declineFriendRequest(String requestId) async {
    await friendRequestColl.doc(requestId).update({'status': 'declined'});
  }

  Future<void> completeOutgoingFriendRequest(FriendRequest request) async {
    await updateUserSpecificData(
        uid: request.from, friend: request.to, addFriend: request.to);
    await friendRequestColl.doc(request.id).update({'status': 'completed'});
  }
}
