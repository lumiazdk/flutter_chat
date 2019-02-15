import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../app.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SettingState();
  }
}

class _SettingState extends State<Setting> {
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
  File _image = null;
  _back() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/MyApp', (Route<dynamic> route) => false);
  }

  Widget defaultImage = Stack(
    children: <Widget>[
      Align(
        // 默认头像图片放在左上方。
        alignment: Alignment.topLeft,
        child: ClipOval(
          child: Image.asset(
            'images/touxiang.png',
            fit: BoxFit.contain,
            height: 130.0,
            width: 135.0,
          ),
        ),
      ),
      Align(
        // 编辑头像图片放在右下方。
        alignment: Alignment.bottomRight,
        child: ClipOval(
          child: Image.asset(
            'images/edit.png',
            fit: BoxFit.fill,
            height: 48.0,
            width: 48.0,
          ),
        ),
      ),
    ],
  );
  Widget ovalImage(File image) {
    return Stack(
      children: <Widget>[
        Align(
          // 默认头像图片放在左上方。
          alignment: Alignment.topLeft,
          child: ClipOval(
            child: Image.file(
              image,
              fit: BoxFit.fill,
              height: 130.0,
              width: 135.0,
            ),
          ),
        ),
        Align(
          // 编辑头像图片放在右下方。
          alignment: Alignment.bottomRight,
          child: ClipOval(
            child: Image.asset(
              'images/edit.png',
              fit: BoxFit.fill,
              height: 48.0,
              width: 48.0,
            ),
          ),
        ),
      ],
    );
  }

//   getImage() async {
//
//     var image = await ImagePicker.pickImage(source: ImageSource.gallery);
//  }
  /// 打开系统相册并选择一张照片。
  Future getImage() async {
    // Flutter团队开发的图片选择器（`image_picker`）插件。
    // 适用于iOS和Android的Flutter插件，用于从图像库中拾取图像，并使用相机拍摄新照片。
    // https://pub.dartlang.org/packages/image_picker
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      // 更新用作头像的照片。
      _image = image;
    });
  }

  void _forSubmitted() async {
    var _form = _formKey.currentState;
    print(_name);
    print(_password);
    if (_form.validate()) {
      _form.save();
      print(_name);
      print(_password);
      var url = 'http://192.168.0.10/register/';
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
          await prefs.setString(
              'userInfo', res['result']['userInfo'].toString());
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
          title: Text('资料设置'),
          iconTheme: new IconThemeData(color: Colors.white),
        ),
        body: ListView(
          children: <Widget>[
            new Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  // 主轴对齐（`mainAxisAlignment`）属性，如何将子组件放在主轴上。
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: getImage,
                      child: Container(
                        width: 130.0,
                        height: 135.0,
                        child:
                            _image == null ? defaultImage : ovalImage(_image),
                      ),
                    ),
                  ],
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
                              labelText: '请输入姓名',
                            ),
                            validator: (val) {
                              return val == '' ? "请输入姓名" : null;
                            },
                            onSaved: (val) {
                              _name = val;
                            },
                          ),
                          new TextFormField(
                            decoration: new InputDecoration(
                              labelText: '请输入用户昵称',
                            ),
                            obscureText: true,
                            onSaved: (val) {
                              _password = val;
                            },
                          ),
                        ],
                      ),
                    )),
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
                            '马上设置',
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
