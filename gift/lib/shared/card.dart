import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gift/models/user_of_gift.dart';

class CostumeCard extends StatefulWidget {
  final int count;
  final UserOfGift? user;
  const CostumeCard({Key? key, required this.count, this.user})
      : super(key: key);

  @override
  State<CostumeCard> createState() => _CostumeCardState();
}

class _CostumeCardState extends State<CostumeCard> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Card(
            elevation: 1,
            margin: const EdgeInsets.all(0),
            shadowColor: Colors.black.withOpacity(0.5),
            color: Colors.transparent,
            child: ExpansionTile(
              title: Text(widget.user!.userName),
              subtitle: Text(widget.user!.nickName),
              maintainState: false,
              iconColor: Colors.white,
              textColor: Colors.white,
              onExpansionChanged: (value) {
                _showDetails = !_showDetails;
                setState(() {});
              },
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: _showDetails ? Colors.white : Colors.deepPurple[400],
              ),
              
              backgroundColor: Colors.black.withOpacity(0.5),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Total:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${widget.count} Gifts",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    )
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
