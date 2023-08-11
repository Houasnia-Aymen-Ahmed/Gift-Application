import 'package:flutter/material.dart';
import 'package:gift/models/user_of_gift.dart';
import 'package:gift/services/auth.dart';
import 'package:gift/services/database.dart';
import 'package:gift/views/home/body.dart';
import 'package:gift/views/home/drawer.dart';
import 'package:home_widget/home_widget.dart';

import '../../shared/loading.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  UserOfGift? myUser;
  UserOfGift? friendUser;

  @override
  void initState() {
    super.initState();
    HomeWidget.widgetClicked.listen((Uri? uri) => updateAppWidget());
  }

  Future<void> updateAppWidget() async {
    if (myUser != null) {
      await HomeWidget.saveWidgetData<String>('_textContent', friendUser!.message);
      await HomeWidget.updateWidget(
          name: 'AppWidgetProvider', iOSName: 'AppWidgetProvider');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _databaseService.getUserDataStream(_auth.currentUsr!.uid),
        builder: (context, snaphot) {
          if (snaphot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else if (!snaphot.hasData) {
            return const Center(
              child: Text("Not User Data Found in Home"),
            );
          } else if (snaphot.hasError) {
            return Center(
              child: Text(
                "Error When Fetchind User Data: ${snaphot.error}",
                style: TextStyle(color: Colors.red[900]),
              ),
            );
          } else {
            myUser = snaphot.data;
            return StreamBuilder(
                stream: _databaseService.getUserDataStream(myUser!.friend),
                builder: (context, snaphot) {
                  if (snaphot.connectionState == ConnectionState.waiting) {
                    return const Loading();
                  } else if (!snaphot.hasData) {
                    return const Center(
                      child: Text("Not Friend Data Found in Home"),
                    );
                  } else if (snaphot.hasError) {
                    return Center(
                      child: Text(
                        "Error When Fetchind Friend Data: ${snaphot.error}",
                        style: TextStyle(color: Colors.red[900]),
                      ),
                    );
                  } else {
                    friendUser = snaphot.data;
                    updateAppWidget();
                    return Container(
                      alignment: Alignment.center,
                      color: const Color(0xF2191622).withOpacity(1),
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        appBar: AppBar(
                          backgroundColor: Colors.black.withOpacity(0.1),
                          elevation: 20,
                          shadowColor: Colors.black,
                          actions: <Widget>[
                            TextButton.icon(
                              style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all(
                                const Color(0xF06B5F92),
                              )),
                              icon: const Icon(Icons.logout_rounded),
                              label: const Text("Logout"),
                              onPressed: () async {
                                await _auth.signOutAnon();
                              },
                            )
                          ],
                          title: const Text(
                            'Home',
                            style: TextStyle(color: Color(0xF06B5F92)),
                          ),
                        ),
                        drawer: BuildDrawer(
                          user: myUser!,
                          friend: friendUser!,
                        ),
                        body: BuildBody(user: myUser!, friend: friendUser!, onWidgetClick: () {},),
                      ),
                    );
                  }
                });
          }
        });
  }
}
