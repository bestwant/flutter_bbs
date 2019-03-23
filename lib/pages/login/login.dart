import 'dart:convert' as convert;

import 'package:flutter_bbs/dialog.dart';
import 'package:flutter_bbs/network/clients/client_login.dart';
import 'package:flutter_bbs/network/json/user.dart';
import 'package:flutter_bbs/return_type.dart';
import 'package:flutter_bbs/utils/user_cacahe_util.dart' as user_cache;
import 'package:flutter_bbs/utils/constant.dart' as const_util;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


///create by sgh    2019-2-16
/// 登录界面的UI

class LoginPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageWidgetState();
  }
}

class LoginPageWidgetState extends State<LoginPageWidget> {
  var mContext;    //负责弹出SnackBar的BuildContext对象
  var user;

  final TextEditingController nameController =
      TextEditingController(); //username输入框的控制器
  final TextEditingController passController =
      TextEditingController(); //password输入框的控制器

  @override
  void initState() {
    super.initState();
    user = user_cache.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        mContext = context;
        return Container(
            padding: EdgeInsets.only(left: 40, right: 60, top: 80, bottom: 65),
            child: Container(
                child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 120.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        '清水河畔',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 34,
                            color: Colors.blue),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 8),
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                            labelText: '用户名', icon: Icon(Icons.person)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 18),
                      child: TextField(
                        obscureText: true,
                        controller: passController,
                        decoration: InputDecoration(
                            labelText: '密码', icon: Icon(Icons.lock)),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: RaisedButton(
                                onPressed: login,
                                child: Text('登录'),
                                color: Theme.of(context).buttonColor,
                                textColor: Colors.white,
                              ))
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: RaisedButton(
                                onPressed: null,
                                child: Text('注册'),
                                textColor: Colors.white,
                              ))
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));
      }),
    );
  }

  login() {
    var dialog = ShowAwait<ReturnType>(_onLoginPressed());
    showDialog<ReturnType>(context: context,
        builder: (c) => dialog
    ).then((onvalue){
      // 返回1代表请求成功
      if (onvalue.type == 1)
        Navigator.of(mContext).pushNamed(onvalue.content);
      else
        showToast(onvalue.content);
    });

  }

  //发起登陆的事件
  // 最后返回0还是1，都是为了在dialog中处理
  // 返回1代表成功
  Future<ReturnType> _onLoginPressed() async {
    var name = nameController.text.trim();
    var pass = passController.text.trim();
    if (name == "" || name == null || pass == "" || pass == null) {
      ReturnType type = ReturnType(0, content: "姓名或者密码不能为空");
      return type;
    }

    final response =
        await LoginClient.login(type: 'login', username: name, password: pass);
    if (response.statusCode == 200) {
      User mUser = await compute(_getBody, response.data);
      // 代表密码账户都正确
      if (mUser.head.errCode == const_util.success) {
        user_cache.storeUser(mUser);
        ReturnType type = ReturnType(1, content: "main/mainPage");
        return type;
      } else {
        // 说明是参数错误
        ReturnType type = ReturnType(0, content: "${mUser.head.errCode} : ${mUser.head.errInfo}");
        return type;
      }
    } else {
      // 说明是http错误
      ReturnType type = ReturnType(0, content: "Http error : ${response.statusCode}");
      return type;
    }
  }

  void _onRegasitorPressed() async {
    var hash = await user_cache.getAppHash();
  }

  //根据传入的内容返回一个SnackBar
  SnackBar showToast(content) {
    return SnackBar(
      content: Text("${content}"),
      duration: Duration(milliseconds: 1500),
    );
  }
}

//通过compute内部调用该方法实现后台解析Json
User _getBody(body) {
  return User.fromJson(convert.jsonDecode(body));
}
