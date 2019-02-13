import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_html_view/flutter_html_view.dart';

class PostDetail extends StatefulWidget {
  int id;
  PostDetail({Key key, @required this.id}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new PostDetailState(id: this.id);
  }
}

class PostDetailState extends State<PostDetail> {
  int id;
  var data;
  Widget content = new HtmlView(data: '<div></div>');

  /**
   * 构造器接收（MovieList）数据
   */
  PostDetailState({Key key, this.id}) {}
  void getData() async {
    var url = 'http://192.168.0.10/getPost/';
    Dio dio = new Dio();

    var response = await dio.post(url, data: {
      "page": 1,
      "pageSize": 10,
      'where': {"id": widget.id}
    });
    print(response.toString());
    if (response.statusCode == 200) {
      var res = json.decode(response.toString());
      if (res['code'] == 1) {
        if (!mounted) {
          return;
        }
        print(res['result']['result']);

        setState(() {
          data = res['result']['result'][0];
        });
//        var pcontent=new HtmlView(data: res['result']['result'][0]['content']);

        new Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            content = new HtmlView(data: res['result']['result'][0]['content']);
          });
        });
      } else {
        print("error");
      }
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  _back() {
    Navigator.pop(context, 'Yep!');
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: IconButton(
              icon: Container(
                child: Icon(Icons.arrow_back_ios),
              ),
              onPressed: _back),
        ),
        endDrawer: new Drawer(
          //New added
          child: Container(
            child: Column(
              children: <Widget>[
                new UserAccountsDrawerHeader(
                  accountName: Text("朱定坤"),
                  accountEmail: Text("18715039796"),
                  currentAccountPicture: new GestureDetector(
                    child: new CircleAvatar(
                      backgroundImage: new ExactAssetImage("images/lake.jpg"),
                    ),
                  ),
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new ExactAssetImage("images/lake.jpg"),
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.favorite,
                              color: Colors.blueGrey,
                            ),
                            Text(
                              '(35)',
                              style: TextStyle(color: Colors.blueGrey),
                            )
                          ],
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.remove_red_eye,
                              color: Colors.blueGrey,
                            ),
                            Text(
                              '(35)',
                              style: TextStyle(color: Colors.blueGrey),
                            )
                          ],
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.comment,
                              color: Colors.blueGrey,
                            ),
                            Text(
                              '(35)',
                              style: TextStyle(color: Colors.blueGrey),
                            )
                          ],
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.reply,
                              color: Colors.blueGrey,
                            ),
                            Text(
                              '(35)',
                              style: TextStyle(color: Colors.blueGrey),
                            )
                          ],
                        ),
                        flex: 1,
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.black12)),
                  ),
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                )
              ],
            ),
          ), //New added
        ),
        body: new Center(
          child: content,
        ),
      ),
    );
  }
}
