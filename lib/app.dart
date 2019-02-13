import 'package:flutter/material.dart';

import 'pages/home.dart';
import 'pages/friends.dart';
import 'pages/my.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
  
}

class MyAppState extends State<MyApp> {
  int Current = 0;

  Widget _getPage() {
    if (Current == 0) {
      return new Home();
    } else if (Current == 1) {
      return new Friends();
    } else if (Current == 2) {
      return new My();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        body: _getPage(),
        bottomNavigationBar: new Material(
          color: Colors.blue,
          child: new FancyBottomNavigation(
            onTabChangedListener: (position) {
              setState(() {
                setState(() {
                  Current = position;
                });
                print(Current);
              });
            },
            tabs: [
              TabData(iconData: Icons.home, title: "首页"),
              TabData(iconData: Icons.people, title: "好友"),
              TabData(iconData: Icons.account_circle, title: "我的")
            ],
          ),
        ),
      ),
    );
  }
}
