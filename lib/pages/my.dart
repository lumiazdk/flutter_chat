import 'package:flutter/material.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import './login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import './setting.dart';
import 'package:fluwx/fluwx.dart';
class My extends StatefulWidget {
  @override
  MyState createState() => new MyState();
}

class MyState extends State<My> {
  var _isLofin = false;
  var userInfo = '';
  var user_telephone_number = '';
  var user_name = '';
  var user_profile_photo = '';
  var motto = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserInfo();
  }

  _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token'));
    print(prefs.getString('userInfo'));
    if (prefs.getString('token') != null) {
      if (!mounted) {
        return;
      }
      ;
      setState(() {
        _isLofin = true;
        user_telephone_number = prefs.getString('user_telephone_number');
        user_name = prefs.getString('user_name');
        user_profile_photo = prefs.getString('user_profile_photo');
        motto = prefs.getString('motto');
      });
    } else {
      setState(() {
        _isLofin = false;
      });
    }
  }

  _getList() {
    if (_isLofin == true) {
      return [
        Container(
          child: new Swiper(
            itemBuilder: (BuildContext context, int index) {
              return _getpicture(index);
            },
            itemCount: 3,
            itemWidth: 500.0,
            itemHeight: 400.0,
            layout: SwiperLayout.TINDER,
          ),
        ),
        GestureDetector(
          child: ListTile(
            title: Row(
              children: <Widget>[
                const FlutterLogo(),
                const Expanded(
                  child: Text('资料设置'),
                ),
                const Icon(Icons.keyboard_arrow_right),
              ],
            ),
          ),
          onTap: (){
            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
              return new Setting();
            }));
          },
        ),
        ListTile(
          title: Row(
            children: <Widget>[
              const FlutterLogo(),
              const Expanded(
                child: Text('退出登录'),
              ),
              const Icon(Icons.keyboard_arrow_right),
            ],
          ),
        ),
        GestureDetector(
          child: ListTile(
            title: Row(
              children: <Widget>[
                const FlutterLogo(),
                const Expanded(
                  child: Text('登陆'),
                ),
                const Icon(Icons.keyboard_arrow_right),
              ],
            ),
          ),
          onTap: _goToLogin,
        )
      ];
    } else {
      return [
        GestureDetector(
          child: ListTile(
            title: Row(
              children: <Widget>[
                const FlutterLogo(),
                const Expanded(
                  child: Text('登陆'),
                ),
                const Icon(Icons.keyboard_arrow_right),
              ],
            ),
          ),
          onTap: _goToLogin,
        )
      ];
    }
  }

  _goToLogin() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
      return new LoginPage();
    }));
  }

  _getpicture(index) {
    print(index);
    return ClipRRect(
      borderRadius: new BorderRadius.all(new Radius.circular(20)),
      child: new Image.asset(
        'images/bg${index}.jpg',
        fit: BoxFit.fill,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double media = ((MediaQuery.of(context).size.width - 100) / 2);
    print(user_profile_photo);
    return new MaterialApp(
      home: new Scaffold(body: new Builder(builder: (context) {
        return new SliverFab(
          floatingWidget: Container(
            height: 100,
            width: 100,
            margin: EdgeInsets.only(left: 15.0),
            child: ClipOval(
              child: Image.network(
                user_profile_photo,
                fit: BoxFit.fill,
              ),
            ),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.7),
              shape: BoxShape.circle,
              border: Border.all(
                color: Color.fromRGBO(255, 255, 255, 0.1),
                width: 8.0,
              ),
            ),
          ),
          floatingPosition: FloatingPosition(left: media - 10, top: -22),
          expandedHeight: 256.0,
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 256.0,
              pinned: true,
              title: Text("我的"),
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  user_profile_photo,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(_getList()),
            ),
          ],
        );
      })),
    );
  }
}
