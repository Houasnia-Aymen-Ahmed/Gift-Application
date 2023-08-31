import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gift/services/auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/user_of_gift.dart';
import '../../../services/database.dart';
import '../../../constants/constants.dart';
import '../../../shared/pallete.dart';

class BuildDrawerContent extends StatefulWidget {
  final UserOfGift user;
  final UserOfGift friend;
  const BuildDrawerContent({
    super.key,
    required this.user,
    required this.friend,
  });

  @override
  State<BuildDrawerContent> createState() => _BuildDrawerContentState();
}

class _BuildDrawerContentState extends State<BuildDrawerContent> {
  final AuthService _auth = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  final storage = FirebaseStorage.instance;
  String imgName = '';
  late ImageProvider image;
  @override
  void initState() {
    super.initState();
    image = widget.user.imagePath != ""
        ? NetworkImage(widget.user.imagePath)
        : const AssetImage("assets/images/defaultAvatarImage.png")
            as ImageProvider;
  }

  void _updateFieldInDatabase(String field, String newValue) {
    setState(() {
      if (field == 'Username') {
        _databaseService.updateUserSpecificData(username: newValue);
      } else if (field == 'Age') {
        _databaseService.updateUserSpecificData(age: int.tryParse(newValue));
      } else if (field == 'Nickname') {
        _databaseService.updateUserSpecificData(
          addFriend: widget.friend.uid,
          addNickname: newValue,
          uid: widget.user.uid,
        );
      }
    });
  }

  Future<XFile?> selectFile() async {
    final result = await ImagePicker().pickImage(source: ImageSource.gallery);
    return result;
  }

  Future uploadFile() async {
    XFile? pickedImage = await selectFile();
    if (pickedImage != null) {
      imgName = pickedImage.name;
      final path = 'files/$imgName';
      final ref = storage.ref().child(path);
      final UploadTask uploadTask = ref.putFile(File(pickedImage.path));
      final snapshot = await uploadTask.whenComplete(() => null);
      final url = await snapshot.ref.getDownloadURL();
      _databaseService.updateUserSpecificData(
        uid: widget.user.uid,
        imagepath: url,
      );
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Palette.semiPink, Palette.twilight],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: Palette.pinkyPink,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: -15,
                      blurRadius: 25,
                      offset: Offset(0, 20),
                    ),
                  ],
                ),
                accountName: Text(
                  widget.user.userName,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                accountEmail: Text(
                  _auth.currentUsr!.email.toString(),
                  style: const TextStyle(fontSize: 18),
                ),
                currentAccountPicture: GestureDetector(
                  onLongPress: () => uploadFile(),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: widget.user.imagePath != ""
                        ? NetworkImage(widget.user.imagePath)
                        : const AssetImage(
                                "assets/images/defaultAvatarImage.png")
                            as ImageProvider,
                  ),
                ),
              ),
              ...generateListTiles(
                user: widget.user,
                friend: widget.friend,
                onUpdate: _updateFieldInDatabase,
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
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
