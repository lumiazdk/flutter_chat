import 'package:flutter/material.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class My extends StatefulWidget {
  @override
  MyState createState() => new MyState();
}

class MyState extends State<My> {
  @override
  Widget build(BuildContext context) {
    double media = ((MediaQuery.of(context).size.width - 100) / 2);
    return new MaterialApp(
      home: new Scaffold(body: new Builder(builder: (context) {
        return new SliverFab(
          floatingWidget: Container(
            height: 100,
            width: 100,
            margin: EdgeInsets.only(left: 15.0),
            child: ClipOval(
              child: Image.asset(
                "images/lake.jpg",
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
                background: Image.asset(
                  "images/lake.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  child: new Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return ClipRRect(
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(20)),
                        child: new Image.asset(
                          'images/lake.jpg',
                          fit: BoxFit.fill,
                        ),
                      );
                    },
                    itemCount: 10,
                    itemWidth: 500.0,
                    itemHeight: 400.0,
                    layout: SwiperLayout.TINDER,
                  ),
                ),
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
                ListTile(
                  title: Row(
                    children: <Widget>[
                      const FlutterLogo(),
                      const Expanded(
                        child: Text('我的消息'),
                      ),
                      const Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
                ListTile(
                  title: Row(
                    children: <Widget>[
                      const FlutterLogo(),
                      const Expanded(
                        child: Text('收到的评论'),
                      ),
                      const Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        );
      })),
    );
  }
}
