class UserOfGift {
  String userName;
  String nickName;
  int age;
  String imagePath;
  int giftRecieved;
  int giftSent;
  String token;
  String friend;
  String message;
  String uid;

  UserOfGift(
      {this.userName = "username",
      this.age = 0,
      this.nickName = "nickname",
      this.imagePath = "imagepath",
      this.giftRecieved = 0,
      this.giftSent = 0,
      this.message = "",
      this.token = "token",
      this.friend = "",
      this.uid = "uid",});
}
