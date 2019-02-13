import 'package:flutter/material.dart';

class My extends StatefulWidget {
  @override
  MyState createState() => new MyState();
}

class MyState extends State<My> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: new Text("我的"),
          ),
          body: Column(
            children: <Widget>[
              Stack(
                alignment: const FractionalOffset(0.5, 0.5), //方法一
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      'images/lake.jpg',
                      height: 200,
                      fit: BoxFit.fitWidth,
                    ),
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Positioned(
                      child: Column(
                    children: <Widget>[
                      new ClipOval(
                        child: new FadeInImage.assetNetwork(
                          placeholder: "images/lake.jpg", //预览图
                          fit: BoxFit.fill,
                          image:
                              "http://47.244.57.219/upload_d141c4f829b5d3580515ecb0c7ef1cc7.jpeg",
                          width: 60.0,
                          height: 60.0,
                        ),
                      ),
                      Container(
                        child: Text(
                          "Dingkun",
                          style: TextStyle( fontSize: 16.0,color: Colors.white),
                        ),
                      ),
                    ],
                  ))
                ],
              ),
              Card(
                elevation: 5.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
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
                  ],
                ),
              )
            ],
          )),
    );
  }
}
