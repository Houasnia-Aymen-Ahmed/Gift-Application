import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gift/services/database.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/user_of_gift.dart';
import '../../../constants/constants.dart';
import '../../../shared/pallete.dart';
import 'friend_list_tile.dart';
import '../../../constants/bottom_sheet_constants.dart';

/* ================================================== First View Builder ================================================== */

class FirstIndexView extends StatefulWidget {
  const FirstIndexView({super.key});

  @override
  State<FirstIndexView> createState() => _FirstIndexViewState();
}

class _FirstIndexViewState extends State<FirstIndexView> {
  String imageAsset = GiftImage.giftCard;
  List<TyperAnimatedText> typer = [
    buildTyper('Happy Birthday to'),
    buildTyper('The most beautifull'),
    buildTyper('Person in the world'),
  ];

  void onNextTyper(int index, bool isLast) {
    if (isLast) {
      setState(() => imageAsset = GiftImage.giftCard);
    } else if (index == 0) {
      setState(() => imageAsset = GiftImage.butterfly);
    } else if (index == 1) {
      setState(() => imageAsset = GiftImage.squareHeart);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...quote(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DefaultTextStyle(
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    shadows: [
                      const BoxShadow(
                          color: Colors.black,
                          blurRadius: 2.5,
                          offset: Offset(1.5, 1.5))
                    ],
                  ),
                  child: buildGradientText(typer, onNextTyper),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildGradientImage(imageAsset),
                )
              ],
            ),
          ),
        ],
      );
}

/* ================================================== Second View Builder ================================================== */

class SecondIndexView extends StatefulWidget {
  final UserOfGift user;
  final Size screenSize;
  const SecondIndexView({
    super.key,
    required this.user,
    required this.screenSize,
  });

  @override
  State<SecondIndexView> createState() => _SecondIndexViewState();
}

class _SecondIndexViewState extends State<SecondIndexView> {
  final DatabaseService _databaseService = DatabaseService();
  List friendList = [];

  @override
  void initState() {
    super.initState();
    friendList = widget.user.friendList;
  }

  void deleteFriend(String friendUid) {
    setState(() => friendList.remove(friendUid));
    if (widget.user.friend == friendUid) {
      _databaseService.updateUserSpecificData(friend: "0");
      _databaseService.deleteFriendFromList(friendUid);
    } else {
      _databaseService.deleteFriendFromList(friendUid);
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        constraints: BoxConstraints(maxHeight: widget.screenSize.height * 0.35),
        height: widget.screenSize.height * 0.3,
        child: ListView.builder(
          itemCount: widget.user.friendList.length,
          itemBuilder: (context, index) {
            String friendUid = friendList[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: _databaseService.getUserDataStream(friendUid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    UserOfGift friendFromList = snapshot.data!;
                    final item = friendFromList;
                    return Slidable(
                      key: ObjectKey(item),
                      startActionPane: ActionPane(
                        extentRatio: 0.3,
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            autoClose: true,
                            borderRadius: BorderRadius.circular(10),
                            onPressed: (context) =>
                                _databaseService.updateUserSpecificData(
                                    friend: friendFromList.uid),
                            padding: const EdgeInsets.all(5.0),
                            backgroundColor: Palette.boldPink,
                            foregroundColor: Colors.white,
                            icon: Icons.favorite_rounded,
                            label: "Make favorite",
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        extentRatio: 0.3,
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            autoClose: true,
                            borderRadius: BorderRadius.circular(10),
                            onPressed: (context) =>
                                deleteFriend(friendFromList.uid),
                            backgroundColor: const Color(0xFFB71C1C),
                            foregroundColor: Colors.white,
                            icon: Icons.delete_rounded,
                            label: "Delete Friend",
                          ),
                        ],
                      ),
                      child: FriendListTile(
                        user: widget.user,
                        friendUser: friendFromList,
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            );
          },
        ),
      );
}
