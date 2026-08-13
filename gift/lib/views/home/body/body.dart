import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gift/shared/card.dart';
import 'package:gift/shared/pallete.dart';
import 'package:gift/views/home/bottom/bottom_sheet.dart';
import '../../../models/conversation_message.dart';
import '../../../models/user_of_gift.dart';
import '../../../services/database.dart';
import '../../../services/notif.dart';
import '../../../services/push_worker.dart';
import '../../../constants/constants.dart';
import '../../../constants/bottom_sheet_constants.dart';

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
  StreamSubscription<ConversationMessage?>? _incomingMessageSub;
  bool _caughtUpOnHistory = false;
  String? _lastSeenMessageId;

  @override
  void initState() {
    super.initState();
    notifServices.initialize(context);
    _incomingMessageSub = _databaseService
        .latestMessageStream(widget.friend.uid)
        .listen(_handleIncomingMessage);
  }

  void _handleIncomingMessage(ConversationMessage? message) {
    if (!_caughtUpOnHistory) {
      _caughtUpOnHistory = true;
      _lastSeenMessageId = message?.id;
      return;
    }
    if (message == null || message.id == _lastSeenMessageId) return;
    _lastSeenMessageId = message.id;
    if (message.from == widget.user.uid) return;
    notifServices.notifyConversationMessage(widget.friend, message);
  }

  @override
  void dispose() {
    _incomingMessageSub?.cancel();
    messageController.dispose();
    super.dispose();
  }

  Future<void> _sendGift(
      UserOfGift myUser, UserOfGift friendUser, String giftId) async {
    await _databaseService.incrementGiftSent(myUser.uid);
    await _databaseService.incrementGiftReceived(friendUser.uid);
    await _databaseService.sendConversationMessage(
      otherUid: friendUser.uid,
      text: giftId,
      kind: 'gift',
    );
    PushWorkerService.notify(
      recipientUid: friendUser.uid,
      kind: 'gift',
      senderName: myUser.userName,
    );
  }

  Future<void> _showGiftPicker(
      UserOfGift myUser, UserOfGift friendUser) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send a gift'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: GiftCatalog.options
              .map(
                (option) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Image.asset(option.asset, width: 40, height: 40),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _sendGift(myUser, friendUser, option.id);
                      },
                    ),
                    Text(option.label),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final txtFieldPos = screenSize.height * 0.025;

    void messageAction(UserOfGift myUser, UserOfGift friendUser) {
      setState(() => msgContent = messageController.text);
      _databaseService.sendConversationMessage(
        otherUid: friendUser.uid,
        text: msgContent,
        kind: 'message',
      );
      PushWorkerService.notify(
        recipientUid: friendUser.uid,
        kind: 'message',
        senderName: myUser.userName,
      );
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
                          child: StreamBuilder<ConversationMessage?>(
                            stream: _databaseService
                                .latestMessageStream(widget.friend.uid),
                            builder: (context, snapshot) {
                              final latest = snapshot.data;
                              if (latest == null) return textDisabled;
                              if (latest.kind == 'gift') {
                                final gift = GiftCatalog.byId(latest.text);
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(gift.asset,
                                        width: 40, height: 40),
                                    Text(
                                      'Sent a ${gift.label} 🎁',
                                      style: txt().copyWith(
                                        fontSize: 18.0,
                                        color: Palette.textMessageColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                );
                              }
                              if (latest.kind != 'message') return textDisabled;
                              return Text(
                                latest.text,
                                style: txt().copyWith(
                                  fontSize: 25.0,
                                  color: Palette.textMessageColor,
                                  fontWeight: FontWeight.normal,
                                ),
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
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
                                onPressed: () =>
                                    _showGiftPicker(widget.user, widget.friend),
                                child: Icon(
                                  Icons.card_giftcard_rounded,
                                  color: Palette.iconColor,
                                ),
                              ),
                            ),
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
                                onPressed: () {
                                  if (msgContent != "") {
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
