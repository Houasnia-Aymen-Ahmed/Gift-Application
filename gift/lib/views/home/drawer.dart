import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gift/services/auth.dart';
import 'package:gift/services/database.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_of_gift.dart';
import '../../services/notif.dart';
import 'list_tile.dart';
import 'package:image_picker/image_picker.dart';

class BuildDrawer extends StatefulWidget {
  final UserOfGift user;
  final UserOfGift friend;
  const BuildDrawer({
    super.key,
    required this.user,
    required this.friend,
  });

  @override
  State<BuildDrawer> createState() => _BuildDrawerState();
}

class _BuildDrawerState extends State<BuildDrawer> {
  final AuthService _auth = AuthService();
  NotificationServices notifServices = NotificationServices();
  final DatabaseService _databaseService = DatabaseService();
  final storage = FirebaseStorage.instance;
  String imgName = '';

  void _updateFieldInDatabase(String field, String newValue) {
    // Update the specified field in the database using _databaseService
    setState(() {
      if (field == 'username') {
        _databaseService.updateUserSpecificData(username: newValue);
      } else if (field == 'age') {
        _databaseService.updateUserSpecificData(age: int.tryParse(newValue));
      } else if (field == 'nickname') {
        _databaseService.updateUserSpecificData(
            nickname: newValue, uid: widget.friend.uid);
      }
    });
  }

  Future<XFile?> selectFile() async {
    final result = await ImagePicker().pickImage(source: ImageSource.gallery);
    return result;
  }

  Future uploadFile() async {
    //pickedImage = await selectFile();
    XFile? pickedImage = await selectFile();

    if (pickedImage != null) {
      imgName = pickedImage.name;
      final path = 'files/$imgName';
      final ref = storage.ref().child(path);
      final UploadTask uploadTask = ref.putFile(File(pickedImage.path));
      final snapshot = await uploadTask.whenComplete(() => null);
      final url = await snapshot.ref.getDownloadURL();
      _databaseService.updateUserSpecificData(
          uid: widget.user.uid, imagepath: url);
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xF2191622).withOpacity(0.95),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                      color: const Color(0xF2191622).withOpacity(0.5),
                      boxShadow: const [BoxShadow(color: Colors.black)]),
                  accountName: Text(widget.user.userName),
                  accountEmail: Text(_auth.currentUsr!.email.toString()),
                  currentAccountPicture: GestureDetector(
                    onLongPress: () => uploadFile(),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(widget.user.imagePath)),
                  ),
                ),
                EditableListTile(
                    text: widget.user.userName,
                    fieldToUpdate: 'username',
                    iconLeading: Icons.person,
                    fieldLength: 20,
                    onUpdate: _updateFieldInDatabase),
                EditableListTile(
                    text: widget.friend.nickName,
                    fieldToUpdate: 'nickname',
                    iconLeading: Icons.person_pin_rounded,
                    fieldLength: 20,
                    onUpdate: _updateFieldInDatabase),
                EditableListTile(
                    text: widget.user.age.toString(),
                    fieldToUpdate: 'age',
                    iconLeading: Icons.calendar_month_rounded,
                    fieldLength: 20,
                    onUpdate: _updateFieldInDatabase),
                EditableListTile(
                  text: widget.user.giftSent.toString(),
                  fieldToUpdate: 'Sent Gifts',
                  iconLeading: Icons.card_giftcard,
                  fieldLength: 20,
                  onUpdate: _updateFieldInDatabase,
                  isEditable: false,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                  "Houasnia-Aymen-Ahmed\n© 2023-${DateTime.now().year} All rights reserved",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                  )),
            ),
          )
        ],
      ),
    );
  }
}
