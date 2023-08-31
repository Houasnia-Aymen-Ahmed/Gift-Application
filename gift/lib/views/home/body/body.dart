import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gift/shared/card.dart';
import 'package:gift/shared/pallete.dart';
import 'package:gift/views/home/bottom/bottom_sheet.dart';
import '../../../models/user_of_gift.dart';
import '../../../services/database.dart';
import '../../../services/notif.dart';
import '../../../constants/constants.dart';

class BuildBody extends StatefulWidget {
  final UserOfGift user;
  final UserOfGift friend;
  const BuildBody({
    super.key,
    required this.user,
    required this.friend,
  });

  @override
  State<BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends State<BuildBody> {
  final NotificationServices notifServices = NotificationServices();
  final DatabaseService _databaseService = DatabaseService();
  final messageController = TextEditingController();
  static const int maxCharacterCount = 50;
  final txtFieldkey = GlobalKey();
  String msgContent = "";
  bool isShown = true;

  @override
  void initState() {
    super.initState();
    notifServices.initialize(context);
  }

  Future<void> _incrementGiftCounts(
      UserOfGift myUser, UserOfGift friendUser) async {
    final updatedUserGiftSent = myUser.giftSent + 1;
    final updatedFriendserGiftReceived = friendUser.giftRecieved + 1;

    await _databaseService.updateUserSpecificData(
      uid: myUser.uid,
      giftSent: updatedUserGiftSent,
    );
    await _databaseService.updateUserSpecificData(
      uid: friendUser.uid,
      giftRecieved: updatedFriendserGiftReceived,
    );
    await notifServices.sendNotif(
      friendUser.token,
      myUser,
      'gift',
      "",
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final txtFieldPos = screenSize.height * 0.025;

    void messageAction(UserOfGift myUser, UserOfGift friendUser) {
      setState(() => msgContent = messageController.text);
      notifServices.sendNotif(friendUser.token, myUser, 'message', msgContent);
      _databaseService.updateUserSpecificData(
          uid: myUser.uid, message: msgContent);
      _databaseService.updateUserSpecificData(
          uid: friendUser.uid, friendMessage: msgContent);
      messageController.clear();
      msgContent = "";
    }

    return Center(
      child: SizedBox(
        height: screenSize.height,
        width: screenSize.width,
        child: GestureDetector(
          onHorizontalDragEnd: (details) => setState(() {
            if (details.primaryVelocity! > 0) {
              isShown = false;
            } else if (details.primaryVelocity! < 0) {
              isShown = true;
            }
          }),
          onVerticalDragEnd: (details) => setState(
              () => BottomSheetHelper.show(context, widget.user, (index) {})),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              CustomCard(
                user: widget.user,
                friend: widget.friend,
                isShown: isShown,
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: 150,
                        maxWidth: 250,
                      ),
                      decoration: BoxDecoration(
                        color: Palette.londonHue.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          width: 1,
                          color: Palette.pinkyPink,
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: widget.friend.message != ""
                              ? Text(
                                  widget.friend.message,
                                  style: txt().copyWith(
                                    fontSize: 25.0,
                                    color: Palette.textMessageColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              : textDisabled,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: txtFieldPos,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: TextFormField(
                    controller: messageController,
                    key: txtFieldkey,
                    maxLength: maxCharacterCount,
                    style: TextStyle(color: Palette.iconColor),
                    decoration: inputDecoration().copyWith(
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
                                      10.0, 10.0, 7.5, 10.0),
                                  side: BorderSide(color: Palette.iconColor),
                                ),
                                onPressed: () async {
                                  if (msgContent == "") {
                                    await _incrementGiftCounts(
                                        widget.user, widget.friend);
                                  } else {
                                    messageAction(widget.user, widget.friend);
                                  }
                                },
                                child: Icon(
                                  Icons.send_rounded,
                                  color: Palette.iconColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    autocorrect: true,
                    validator: (val) => val!.length > maxCharacterCount
                        ? "Your message shouldn't pass $maxCharacterCount characters"
                        : null,
                    onChanged: (value) => msgContent = value,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
