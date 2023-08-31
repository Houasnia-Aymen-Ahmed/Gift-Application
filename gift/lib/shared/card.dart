import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gift/models/user_of_gift.dart';
import 'package:gift/shared/pallete.dart';
import '../constants/constants.dart';

class CustomCard extends StatefulWidget {
  final UserOfGift user;
  final UserOfGift friend;
  final bool isShown;
  const CustomCard(
      {super.key,
      required this.user,
      required this.friend,
      required this.isShown});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final containerSize = screenSize.width * 0.9;
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      top: screenSize.height * 0.05,
      left: widget.isShown
          ? ((screenSize.width * 0.5) - (containerSize * 0.5))
          : containerSize,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            constraints: BoxConstraints(maxWidth: screenSize.width),
            width: containerSize,
            height: screenSize.height * 0.21,
            decoration: BoxDecoration(
              color: widget.isShown
                  ? Palette.londonHue.withOpacity(0.25)
                  : Palette.londonHue.withOpacity(0.75),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 1,
                color: Palette.pinkyPink,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (!widget.isShown)
                  Container(
                    width: 4,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Palette.dividerColor,
                    ),
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: screenSize.width * 0.26,
                      height: screenSize.height * 0.115,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: widget.friend.imagePath != ""
                              ? NetworkImage(
                                  widget.friend.imagePath,
                                )
                              : const AssetImage(
                                      "assets/images/defaultAvatarImage.png")
                                  as ImageProvider,
                        ),
                      ),
                    ),
                    Text(
                      capitalizeFirst(widget.friend.userName),
                      style: txt().copyWith(fontSize: 24.0),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      capitalizeFirst(widget.user.nicknames[widget.friend.uid]),
                      style: txt().copyWith(
                        fontSize: 20.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                VerticalDivider(
                  color: Palette.dividerColor.withOpacity(0.5),
                  thickness: 2,
                  endIndent: 55,
                  indent: 55,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${widget.user.giftRecieved}",
                      style: txt().copyWith(
                        fontSize: 30.0,
                        color: Palette.bodyTextColor,
                      ),
                    ),
                    Text(
                      "Gifts",
                      style: txt().copyWith(
                        fontSize: 30.0,
                        color: Palette.bodyTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
