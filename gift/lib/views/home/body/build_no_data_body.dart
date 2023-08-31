import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gift/shared/pallete.dart';
import 'package:gift/views/home/bottom/bottom_sheet.dart';
import '../../../models/user_of_gift.dart';
import '../../../constants/constants.dart';
import '../../qr_code_view/qrcode_page.dart';

class BuildNoDataBody extends StatefulWidget {
  final UserOfGift user;
  const BuildNoDataBody({
    super.key,
    required this.user,
  });

  @override
  State<BuildNoDataBody> createState() => _BuildNoDataBodyState();
}

class _BuildNoDataBodyState extends State<BuildNoDataBody> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Center(
      child: SizedBox(
        height: screenSize.height,
        width: screenSize.width,
        child: GestureDetector(
          onVerticalDragEnd: (details) => setState(
              () => BottomSheetHelper.show(context, widget.user, (index) {})),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: screenSize.height - 125,
                        maxWidth: screenSize.width - 25,
                      ),
                      decoration: BoxDecoration(
                        color: Palette.londonHue.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1,
                          color: Palette.pinkyPink,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            const Spacer(flex: 1),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 1,
                                  color: Palette.pinkyPink,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  "No Friend Found",
                                  style: txt().copyWith(
                                    fontSize: 40.0,
                                    color: Colors.red[900],
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const Spacer(flex: 1),
                            Expanded(
                              child: Icon(
                                Icons.block_rounded,
                                size: 150,
                                color: Colors.red[900],
                              ),
                            ),
                            const Spacer(flex: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 75,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: Palette.pinkyPink,
                                    ),
                                  ),
                                  child: TextButton(
                                    onPressed: () => BottomSheetHelper.show(
                                        context, widget.user, (index) {},
                                        preSelected: 1),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        "Add a friend\nfrom list",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 75,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: Palette.pinkyPink,
                                    ),
                                  ),
                                  child: TextButton(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            QRCodePage(user: widget.user),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        "Add a friend by\nscanning QR Code",
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.black),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(flex: 1),
                          ],
                        ),
                      ),
                    ),
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
