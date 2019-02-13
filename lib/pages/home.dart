import 'package:flutter/material.dart';
import '../components/list.dart';
import 'dart:convert';
import 'package:dio/dio.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {
  List AllCategory = [
    {'name': '全部', 'categoryId': -1},
  ];

  void getData() async {
    var url = 'http://192.168.0.10/getAllCategory/';
    Dio dio = new Dio();
    var response = await dio.post(url);
    if (response.statusCode == 200) {
      var res = json.decode(response.toString());
      if (res['code'] == 1) {
        if (!mounted) {
          return;
        }
        var arr=AllCategory;
        arr.addAll(res['result']['data']);
        setState(() {
          AllCategory = arr;
        });
      } else {
        print("error");
      }
    }
  }

  @override
  void initState() {
    getData();
  }

//内容
  buildGrid() {
    List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    for (var item in AllCategory) {
      tiles.add(new PostList(categoryId:item['categoryId']) );
    }
    return tiles;
  }

  tabs() {
    List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    for (var item in AllCategory) {
      tiles.add(new Row(children: <Widget>[new Text(item['name'])]));
    }
    return tiles;
  }

//  Widget ExampleWidget = buildGrid();
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 10,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("首页"),
          bottom: new TabBar(
            tabs: tabs(),
            isScrollable: true,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: Colors.white,
            labelStyle: new TextStyle(fontSize: 16.0),
            unselectedLabelColor: Colors.black,
            unselectedLabelStyle: new TextStyle(fontSize: 12.0),
          ),
        ),
        body: new TabBarView(
          children: buildGrid(),
        ),
      ),
    );
  }
}
