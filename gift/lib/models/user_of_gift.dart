class UserOfGift {
  String userName;
  String nickName;
  int age;
  String imagePath;
  int giftRecieved;
  int giftSent;
  String token;
  String friend;
  String friendMessage;
  List friendList;
  String message;
  String uid;
  bool enableNotif;
  Map nicknames;

  UserOfGift({
    this.userName = "username",
    this.age = 0,
    this.nickName = "nickname",
    this.imagePath = "",
    this.giftRecieved = 0,
    this.giftSent = 0,
    this.message = "",
    this.token = "",
    this.friend = "",
    this.friendMessage = "",
    this.friendList = const [],
    this.uid = "",
    this.enableNotif = true,
    this.nicknames = const {},
  });
}
