import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './register.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../app.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  var leftRightPadding = 40.0;
  var topBottomPadding = 4.0;
  var textTips = new TextStyle(fontSize: 16.0, color: Colors.black);
  var hintTips = new TextStyle(fontSize: 15.0, color: Colors.black26);
  static const LOGO = "images/lake.jpg";

  var _userPassController = new TextEditingController();
  var _userNameController = new TextEditingController();
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _name;
  String _password;
  _back() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/MyApp', (Route<dynamic> route) => false);
  }

  void _forSubmitted() async {
    var _form = _formKey.currentState;
    print(_name);
    print(_password);
    if (_form.validate()) {
      _form.save();
      print(_name);
      print(_password);
      var url = 'http://192.168.0.10/login/';
      Dio dio = new Dio();
      var data;
      data = {"user_telephone_number": _name, "user_password": _password};
      var response = await dio.post(url, data: data);
      if (response.statusCode == 200) {
        var res = json.decode(response.toString());
        if (res['code'] == 1) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          print(res);
          await prefs.setString('token', res['result']['token'].toString());
          await prefs.setString('user_telephone_number',res['result']['userInfo']['user_telephone_number'].toString());
          await prefs.setString('user_name',res['result']['userInfo']['user_name'].toString());
          await prefs.setString('motto',res['result']['userInfo']['motto'].toString());
          await prefs.setString('user_profile_photo',res['result']['userInfo']['user_profile_photo'].toString());
          if (!mounted) {
            return;
          }
          Alert(
            context: context,
            type: AlertType.success,
            title: "${res['message']}",
            buttons: [
              DialogButton(
                child: Text(
                  "确定",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => _back(),
                width: 120,
              )
            ],
          ).show();
        } else if (res['code'] == 0) {
          Alert(
            context: context,
            type: AlertType.warning,
            title: "${res['message']}",
            buttons: [
              DialogButton(
                child: Text(
                  "确定",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              )
            ],
          ).show();
        } else {
          print(res);
          Alert(
            context: context,
            type: AlertType.error,
            title: "未知错误",
            buttons: [
              DialogButton(
                child: Text(
                  "确定",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              )
            ],
          ).show();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          leading: IconButton(
              icon: Container(
                child: Icon(Icons.keyboard_arrow_down),
              ),
              onPressed: _back),
          title: Text('登陆'),
          iconTheme: new IconThemeData(color: Colors.white),
        ),
        body: ListView(
          children: <Widget>[
            new Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Container(
                  child: new Image.asset(LOGO,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity),
                  height: 200,
                ),
                new Padding(
                    padding: new EdgeInsets.fromLTRB(leftRightPadding, 30.0,
                        leftRightPadding, topBottomPadding),
                    child: new Form(
                      key: _formKey,
                      child: new Column(
                        children: <Widget>[
                          new TextFormField(
                            decoration: new InputDecoration(
                              labelText: '请输入手机号',
                            ),
                            validator: (val) {
                              return val == '' ? "请输入手机号" : null;
                            },
                            onSaved: (val) {
                              _name = val;
                            },
                          ),
                          new TextFormField(
                            decoration: new InputDecoration(
                              labelText: '请输入用户密码',
                            ),
                            obscureText: true,
                            validator: (val) {
//                              return val.length <  ? "密码长度错误" : null;
                            },
                            onSaved: (val) {
                              _password = val;
                            },
                          ),
                        ],
                      ),
                    )),
                new InkWell(
                  child: new Container(
                      alignment: Alignment.centerRight,
                      child: new Text(
                        '没有账号？马上注册',
                        style: hintTips,
                      ),
                      padding: new EdgeInsets.fromLTRB(
                          leftRightPadding, 10.0, leftRightPadding, 0.0)),
                  onTap: (() {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => new RegisterPage()));
                  }),
                ),
                new Container(
                  width: 360.0,
                  margin: new EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
                  padding: new EdgeInsets.fromLTRB(leftRightPadding,
                      topBottomPadding, leftRightPadding, topBottomPadding),
                  child: new Card(
                    color: Color(0xFF63CA6C),
                    elevation: 6.0,
                    child: new FlatButton(
                        onPressed: _forSubmitted,
                        child: new Padding(
                          padding: new EdgeInsets.all(10.0),
                          child: new Text(
                            '马上登录',
                            style: new TextStyle(
                                color: Colors.white, fontSize: 16.0),
                          ),
                        )),
                  ),
                )
              ],
            )
          ],
        ));
  }

  _postLogin(String userName, String userPassword) {
    print(userName);
  }
}
