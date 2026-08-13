import 'package:flutter/material.dart';
import 'package:gift/models/user_of_gift.dart';
import 'package:gift/services/database.dart';
import 'package:gift/services/widget_service.dart';
import 'package:gift/shared/pallete.dart';
import 'package:gift/constants/constants.dart';

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
  final DatabaseService _databaseService = DatabaseService();
  final WidgetService _widgetService = WidgetService();
  late bool _isInWidget;

  @override
  void initState() {
    super.initState();
    _isInWidget = _widgetService
        .eligibleFriendUids(widget.user)
        .contains(widget.friendUser.uid);
  }

  @override
  Widget build(BuildContext context) => ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.sm),
        tileColor: Palette.semiPink,
        style: ListTileStyle.drawer,
        iconColor: Palette.lightPink,
        splashColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xs),
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
          widget.user.nicknames[widget.friendUser.uid] ?? 'nickname',
          style: const TextStyle(fontSize: 20),
        ),
        trailing: IconButton(
          tooltip: _isInWidget ? 'Showing on widget' : 'Not on widget',
          icon: Icon(
            _isInWidget ? Icons.widgets_rounded : Icons.widgets_outlined,
            color: _isInWidget ? Palette.boldPink : Palette.lightPink,
          ),
          onPressed: () {
            final newValue = !_isInWidget;
            setState(() => _isInWidget = newValue);
            _databaseService.setWidgetFriend(
                widget.user, widget.friendUser.uid, newValue);
          },
        ),
      );
}
