import 'package:flutter/material.dart';
import '../pages/PostDetail.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class FriendsList extends StatefulWidget {
  @override
  FriendsListState createState() => new FriendsListState();
}

class FriendsListState extends State<FriendsList> {
  List list = [
    {"name": 'zdk', "create_time": '123344', "last_message": 'qwer'},
    {"name": 'zdk', "create_time": '123344', "last_message": 'qwer'},
    {"name": 'zdk', "create_time": '123344', "last_message": 'qwer'},
    {"name": 'zdk', "create_time": '123344', "last_message": 'qwer'},
    {"name": 'zdk', "create_time": '123344', "last_message": 'qwer'},
    {"name": 'zdk', "create_time": '123344', "last_message": 'qwer'},
    {"name": 'zdk', "create_time": '123344', "last_message": 'qwer'},
    {"name": 'zdk', "create_time": '123344', "last_message": 'qwer'},
    {"name": 'zdk', "create_time": '123344', "last_message": 'qwer'},
    {"name": 'zdk', "create_time": '123344', "last_message": 'qwer'}
  ]; //列表要展示的数据
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemBuilder: (BuildContext context, int position) {
            return _renderRow(position);
          },
          itemCount: list.length,
        ),
      ),
    );
  }

  Widget _renderRow(int index) {
    var data = list[index];
    return Container(
      child: Card(
        elevation: 5.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Row(
                children: <Widget>[
                  ClipOval(
                    child: new FadeInImage.assetNetwork(
                      placeholder: "images/lake.jpg", //预览图
                      fit: BoxFit.fill,
                      image:
                          "http://47.244.57.219/upload_d141c4f829b5d3580515ecb0c7ef1cc7.jpeg",
                      width: 30.0,
                      height: 30.0,
                    ),
                  ),
                  new Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Container(
                          padding:
                              const EdgeInsets.only(bottom: 8.0, left: 8.0),
                          child: new Text(
                            'Oeschinen Lake Campground',
                            style: new TextStyle(),
                          ),
                        ),
                        new Container(
                          padding:
                              const EdgeInsets.only(bottom: 5.0, left: 8.0),
                          child: new Text(
                            'Kandersteg, Switzerland',
                            style: new TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '12:34',
                    style: new TextStyle(
                      color: Colors.grey[400],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /**
   * 下拉刷新方法,为list重新赋值
   */
  Future<Null> _onRefresh() async {}
}
