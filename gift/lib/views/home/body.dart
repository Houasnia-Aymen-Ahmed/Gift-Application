import 'dart:ui';
import 'package:flutter/material.dart';
import '../../models/user_of_gift.dart';
import '../../services/database.dart';
import '../../services/notif.dart';
import '../../shared/constants.dart';

class BuildBody extends StatefulWidget {
  final UserOfGift user;
  final UserOfGift friend;
  final VoidCallback onWidgetClick;
  const BuildBody(
      {super.key,
      required this.user,
      required this.friend,
      required this.onWidgetClick});

  @override
  State<BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends State<BuildBody> {
  NotificationServices notifServices = NotificationServices();
  final DatabaseService _databaseService = DatabaseService();
  final messageController = TextEditingController();
  static const int maxCharacterCount = 50;

  @override
  void initState() {
    super.initState();
    notifServices.requestNotificationPermission();
    notifServices.isTokentRefresh();
    notifServices.getDeviceToken().then((value) {});
    notifServices.fireaseInit(context);
    notifServices.setupInteractMessage(context);
  }

  Future<void> _incrementGiftCounts(
      UserOfGift myUser, UserOfGift friendUser) async {
    // Increment values
    final updatedUserGiftSent = myUser.giftSent + 1;
    final updatedFriendserGiftReceived = friendUser.giftRecieved + 1;

    // Update data
    await _databaseService.updateUserSpecificData(
      uid: myUser.uid,
      giftSent: updatedUserGiftSent,
    );

    // Update other user's data
    await _databaseService.updateUserSpecificData(
      uid: friendUser.uid,
      giftRecieved: updatedFriendserGiftReceived,
    );
    await notifServices.sendNotif(friendUser.token, myUser, 'gift');
  }

  Future<void> handleWidgetClick() async {
    _incrementGiftCounts(widget.user, widget.friend);
    widget.onWidgetClick();
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final txtFieldPos = screenSize.height * 0.025;
    String msgContent = "";
    final txtFieldkey = GlobalKey();

    void messageAction(UserOfGift myUser, UserOfGift friendUser) {
      setState(() {
        msgContent = messageController.text;
      });
      notifServices.sendNotif(friendUser.token, myUser, 'message');
      _databaseService.updateUserSpecificData(
          uid: myUser.uid, message: msgContent);
      messageController.clear();
      msgContent = "";
    }

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          //(flex: 30),
          Positioned(
            top: screenSize.height * 0.0475,
            left: screenSize.width * 0.05,
            child: Column(
              children: [
                Container(
                  width: 100, // Adjust this value to zoom in or out
                  height: 100, // Adjust this value to zoom in or out
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.friend.imagePath)
                    ),
                  ),
                ),
                Text(
                  widget.friend.userName,
                  style: txt.copyWith(fontSize: 20),
                ),
                Text(
                  widget.friend.nickName,
                  style: txt.copyWith(fontSize: 15),
                ),
              ],
            ),
          ),
          //(flex: 10),

          //(flex: 50),
          Positioned(
            top: screenSize.height * 0.05,
            right: screenSize.height * 0.02,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  height: 125,
                  width: 125,
                  decoration: BoxDecoration(
                    color: Colors.transparent.withOpacity(0),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      width: 1,
                      color: Colors.white30,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${widget.user.giftRecieved}",
                        style: txt.copyWith(fontSize: 30),
                      ),
                      Text(
                        "Gifts",
                        style: txt.copyWith(fontSize: 30),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  constraints:
                      const BoxConstraints(maxHeight: 150, maxWidth: 250),
                  decoration: BoxDecoration(
                    color: Colors.transparent.withOpacity(0),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      width: 1,
                      color: Colors.white30,
                    ),
                  ),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: widget.friend.message != ""
                        ? Text(
                            widget.friend.message,
                            style: txt.copyWith(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          )
                        : textDisabled,
                  )),
                ),
              ),
            ),
          ),
          //(flex: 100),
          //(flex: 20),
          Positioned(
            bottom: txtFieldPos,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 350),
              child: TextFormField(
                controller: messageController,
                key: txtFieldkey,
                maxLength: maxCharacterCount,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(27, 20, 27, 20),
                  hintText: "Send a message",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
                  suffixIcon: IntrinsicWidth(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                elevation: 0,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.fromLTRB(
                                  10.0,
                                  10.0,
                                  7.5,
                                  10.0,
                                ),
                                side: const BorderSide(color: Colors.white)),
                            onPressed: () async {
                              if (msgContent == "") {
                                await _incrementGiftCounts(
                                    widget.user, widget.friend);
                              } else {
                                messageAction(widget.user, widget.friend);
                              }
                            },
                            child: const Icon(Icons.send_rounded,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                autocorrect: true,
                validator: (val) {
                  return val!.length > maxCharacterCount
                      ? "Your message shouldn't pass 100 characters"
                      : null;
                },
                onChanged: (value) => msgContent = value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
