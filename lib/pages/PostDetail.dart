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
  var content="<div></div>";
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
          content=res['result']['result'][0]['content'];
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
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("我的"),
        ),
        body: new Center(
          child: new HtmlView(
            data:content
          ),
        ),
      ),
    );
  }
}
