import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FriendsList extends StatefulWidget {
  @override
  FriendsListState createState() => new FriendsListState();
}

class FriendsListState extends State<FriendsList> {
  List list = [
    {"name": 'zdk', "create_time": '123344', "last_message": 'qwer'},
  ]; //列表要展示的数据
  final SlidableController slidableController = new SlidableController();
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Slidable(
            key: new Key('22'),
            controller: slidableController,
            delegate: new SlidableDrawerDelegate(),
            actionExtentRatio: 0.25,
            child: new Container(
              color: Colors.white,
              child: new ListTile(
                leading: new CircleAvatar(
                  backgroundColor: Colors.indigoAccent,
                  child: new Text('p'),
                  foregroundColor: Colors.white,
                ),
                title: new Text('小猪'),
                subtitle: new Text('哼哼'),
              ),
            ),
            actions: <Widget>[],
            secondaryActions: <Widget>[
              new IconSlideAction(
                caption: '删除',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => {},
              ),
            ],
          ),
          new Slidable(
            key: new Key('223'),
            controller: slidableController,
            delegate: new SlidableDrawerDelegate(),
            actionExtentRatio: 0.25,
            child: new Container(
              color: Colors.white,
              child: new ListTile(
                leading: new CircleAvatar(
                  backgroundColor: Colors.indigoAccent,
                  child: new Text('d'),
                  foregroundColor: Colors.white,
                ),
                title: new Text('小狗'),
                subtitle: new Text('汪汪'),
              ),
            ),
            actions: <Widget>[],
            secondaryActions: <Widget>[
              new IconSlideAction(
                caption: '删除',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => {},
              ),
            ],
          )
        ],
      ),
    );
  }

  /**
   * 下拉刷新方法,为list重新赋值
   */
  Future<Null> _onRefresh() async {}
}
