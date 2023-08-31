import 'package:flutter/material.dart';
import 'package:gift/models/user_of_gift.dart';
import 'package:gift/shared/pallete.dart';

class FriendListTile extends StatefulWidget {
  final UserOfGift user;
  final UserOfGift friendUser;

  const FriendListTile({
    super.key,
    required this.friendUser,
    required this.user,
  });

  @override
  State<FriendListTile> createState() => _FriendListTileState();
}

class _FriendListTileState extends State<FriendListTile> {
  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        tileColor: Palette.semiPink,
        style: ListTileStyle.drawer,
        iconColor: Palette.lightPink,
        splashColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Palette.boldPink),
        ),
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: widget.friendUser.imagePath != ""
                  ? NetworkImage(widget.friendUser.imagePath)
                  : const AssetImage("assets/images/defaultAvatarImage.png")
                      as ImageProvider,
            ),
          ),
        ),
        titleAlignment: ListTileTitleAlignment.center,
        title: Text(
          widget.friendUser.userName,
          style: const TextStyle(fontSize: 20),
        ),
        subtitle: Text(
          widget.user.nicknames[widget.friendUser.uid],
          style: const TextStyle(fontSize: 20),
        ),
      );
}
