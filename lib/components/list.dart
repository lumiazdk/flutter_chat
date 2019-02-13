import 'package:flutter/material.dart';
import '../pages/PostDetail.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart';

class PostList extends StatefulWidget {
  var categoryId;

  PostList({Key key, @required this.categoryId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new PostListState(categoryId: this.categoryId);
  }
}

class PostListState extends State<PostList> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();
  ScrollController _scrollController = new ScrollController();
  List list = []; //列表要展示的数据
  var categoryId;
  int page = 1;
  int pageSize = 10;
  bool isPerformingRequest = false;
  PostListState({Key key, this.categoryId}) {}
//  PostListState({Key key, this.title}) : super(key: key);
//  final String title;
  void getData(type) async {
    if (type == 'up') {
      setState(() {
        page = 1;
      });
    } else {
      setState(() {
        page = page++;
        isPerformingRequest = true;
      });
    }
    var url = 'http://192.168.0.10/getPost/';
    Dio dio = new Dio();
    var data;
    if (categoryId == -1) {
      data = {"page": page, "pageSize": pageSize, 'where': {}};
    } else {
      data = {
        "page": page,
        "pageSize": pageSize,
        'where': {"cid": widget.categoryId}
      };
    }
    var response = await dio.post(url, data: data);
    if (response.statusCode == 200) {
      var res = json.decode(response.toString());
      if (res['code'] == 1) {
        if (!mounted) {
          return;
        }
        if (type == 'up') {
          setState(() {
            list = res['result']['result'];
          });
        } else {
          var arr = list;

          arr.addAll(res['result']['result']);
          setState(() {
            list = arr;
            isPerformingRequest = false;
          });
        }
      } else {
        print("error");
        setState(() {
          isPerformingRequest = false;
        });
      }
    }
  }
  static SlideTransition createTransition(
      Animation<double> animation, Widget child) {
    return new SlideTransition(
      position: new Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: const Offset(0.0, 0.0),
      ).animate(animation),
      child: child,
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData('up');
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getData('down');
      }
    });
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: new EasyRefresh(
          key: _easyRefreshKey,
          refreshHeader: BezierCircleHeader(
            key: _headerKey,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          refreshFooter: BezierBounceFooter(
            key: _footerKey,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: new ListView.builder(
              //ListView的Item
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return _renderRow(index);
              }),
          onRefresh: () async {
            await new Future.delayed(const Duration(seconds: 1), () {
              getData('up');
            });
          },
          loadMore: () async {
            await new Future.delayed(const Duration(seconds: 1), () {
              getData('down');
            });
          },
        ),
        decoration: BoxDecoration(color: Colors.black12),
      ),
    );
  }

  Widget _renderRow(int index) {
    var data = list[index];
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 30),
            child: Card(
              elevation: 10.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      child: Image.network(
                        data['background'],
                        fit: BoxFit.fitWidth,
                        width: MediaQuery.of(context).size.width,
                        height: 211,
                      ),
                    ),
                    onTap: () {
                      print('BUtton was tapped');
                      Navigator.push<String>(
                          context,
                          new PageRouteBuilder(pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) {
                            // 跳转的路由对象
                            return new PostDetail(id: data['id']);
                          }, transitionsBuilder: (
                              BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation,
                              Widget child,
                              ) {
                            return PostListState
                                .createTransition(animation, child);
                          }));
//                      Navigator.of(context)
//                          .push(new MaterialPageRoute(builder: (_) {
//                        return new PostDetail(id: data['id']);
//                      }));
                    },
                  ),
                  ListTile(
                    title: Text(
                      '${data['title']}',
                      style: TextStyle(height: 2),
                    ),
                    subtitle: Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        '${data['describes']}',
                      ),
                    ),
                  ),
                ],
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
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          )
        ],
      ),
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
    );
  }
}
