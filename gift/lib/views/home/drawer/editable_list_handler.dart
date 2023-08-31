import 'package:flutter/material.dart';
import 'package:gift/models/user_of_gift.dart';
import 'package:gift/constants/constants.dart';
import '../../../services/database.dart';

class EditableListHandler {
  final UserOfGift user;
  final UserOfGift friend;
  final DatabaseService _databaseService = DatabaseService();
  final StateSetter setState;

  EditableListHandler(this.user, this.friend, this.setState);

  void _updateFieldInDatabase(String field, String newValue) {
    setState(() {
      if (field == 'Username') {
        _databaseService.updateUserSpecificData(
            username: newValue, uid: user.uid);
      } else if (field == 'Age') {
        _databaseService.updateUserSpecificData(
            age: int.tryParse(newValue), uid: user.uid);
      } else if (field == 'Nickname') {
        _databaseService.updateUserSpecificData(
          addFriend: friend.uid,
          addNickname: newValue,
          uid: user.uid,
        );
      }
    });
  }

  List<Widget> editableListView() {
    return [
      editableListTile(
        user.userName,
        'Username',
        true,
        Icons.person,
        (field, newValue) => _updateFieldInDatabase,
      ),
      editableListTile(
        user.nicknames[friend.uid],
        'Nickname',
        true,
        Icons.label_rounded,
        (field, newValue) => _updateFieldInDatabase,
      ),
      editableListTile(
        user.age.toString(),
        'Age',
        true,
        Icons.calendar_month_rounded,
        (field, newValue) => _updateFieldInDatabase,
      ),
      editableListTile(
        user.giftSent.toString(),
        'Sent Gifts',
        false,
        Icons.card_giftcard_rounded,
        (field, newValue) => _updateFieldInDatabase,
      ),
    ];
  }
}
