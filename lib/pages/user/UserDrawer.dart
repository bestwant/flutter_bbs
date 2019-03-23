import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bbs/dialog.dart';
import 'package:flutter_bbs/network/json/user.dart';

import 'package:flutter_bbs/utils/user_cacahe_util.dart' as user_cache;

import 'package:cached_network_image/cached_network_image.dart';

///create by sgh    2019-20-17
/// 用户信息的界面
class UserDrawer {
  //返回侧拉抽屉的drawer布局
  static Widget getGrawer() {
    return _UserPageWidget();
  }

  /*
 *  注销登录  的点击事件
 */
  static Future<int> _logout() async {
    await user_cache.clear();
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return 1;
  }
}

class _UserPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserPageWidgetState();
  }
}

class _UserPageWidgetState extends State<_UserPageWidget> {
  User sourceData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: user_cache.finalUser(),
      builder: (context, snaphot) {
        if (!snaphot.hasData) return Center(child: CircularProgressIndicator());
        sourceData = snaphot.data;
        return ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            //_drawHeader()
            DrawerHeader(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.blue),
              child: _drawMyHeader(),
            ),
            ListTile(
                leading: Icon(
                  Icons.favorite,
                  color: Colors.grey,
                  size: 24,
                ),
                title: Text(
                  '我的收藏',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () => Navigator.of(context, rootNavigator: true)
                    .pushNamed('user/userCollection')),
            ListTile(
                leading: Icon(
                  Icons.content_paste,
                  color: Colors.grey,
                  size: 24,
                ),
                title: Text(
                  '我的发表',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () => Navigator.of(context, rootNavigator: true)
                    .pushNamed('user/userPost')),
            ListTile(
                leading: Icon(
                  Icons.business_center,
                  color: Colors.grey,
                  size: 24,
                ),
                title: Text(
                  '河畔商城',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("该功能尚未开放"),
                    duration: Duration(milliseconds: 1500),
                  ));
                  Navigator.pop(context);
                }),
            ListTile(
              leading: Icon(
                Icons.people,
                color: Colors.grey,
                size: 24,
              ),
              title: Text(
                '我的好友',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () => Navigator.of(context, rootNavigator: true)
                  .pushNamed('user/userFriends'),
            ),
            ListTile(
              leading: Icon(
                Icons.help,
                color: Colors.grey,
                size: 24,
              ),
              title: Text(
                '关于',
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("该功能尚未开放"),
                  duration: Duration(milliseconds: 1500),
                ));
                Navigator.pop(context);
              },
            ),
            Container(
                padding: EdgeInsets.only(left: 12, right: 12),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: RaisedButton(
                            child: Text('注销'),
                            color: Colors.redAccent,
                            textColor: Colors.white,
                            onPressed: logout))
                  ],
                ))
          ],
        );
      },
    );
  }

  //绘制Drawer的DrawHeader部分
  Widget _drawMyHeader() {
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 20),
          child: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(sourceData.avatar),
            radius: 48,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 6),
              child: Text(
                sourceData.userName,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 3, bottom: 4),
              child: Text(
                '等级: ${sourceData.userTitle}',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 3, bottom: 4),
              child: Text(
                '积分: ${sourceData.creditShowList[0].data}',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 3, bottom: 4),
              child: Text(
                '水滴: ${sourceData.creditShowList[1].data}',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        )
      ],
    );
  }

  logout() {
    var dialog = ShowAwait<int>(UserDrawer._logout());
    showDialog(context: context,
        builder: (c) => dialog
    );
  }
}
