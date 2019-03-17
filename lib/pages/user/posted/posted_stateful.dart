
import 'package:flutter_bbs/mvp/model.dart';
import 'package:flutter_bbs/mvp/presenter.dart';
import 'package:flutter_bbs/mvp/view.dart';
import 'package:flutter_bbs/network/json/user.dart';
import 'package:flutter_bbs/pages/user/model.dart';
import 'package:flutter_bbs/pages/user/presenter.dart';
import 'package:flutter_bbs/utils/constant.dart' as const_util;
import 'package:flutter_bbs/utils/user_cacahe_util.dart' as user_cache;

import 'package:flutter/material.dart';

///created by sgh    2019-2-23
/// User界面“我的发表”的UI
class PostedWidget extends StatefulWidget {

  UserPresenterImpl _presenter;
  UserModelImpl _model;
  _UserViewImpl _view;

  PostedWidget() : this._presenter = UserPresenterImpl(), this._model = UserModelImpl();

  @override
  State<StatefulWidget> createState() {
    _view = _UserViewImpl();
    _presenter.bindModel(_model);
    _presenter.bindView(_view);
    _view.setPresenter(_presenter);
    return _view;
  }
}

class _UserViewImpl extends State<PostedWidget> implements IBaseView {
  UserPresenterImpl _presenter;

  List<UserPublish> sourceData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: toGetNetData(),
      builder: (context, snaphot) {
        //正在进行网络请求
        if (!snaphot.hasData) {
          return Center(child: CircularProgressIndicator(),);
        }

        if (snaphot.hasData) {
          //网络出错
          if (snaphot.data.runtimeType == String)
            return Text('error');
          //成功得到数据
          else {
            sourceData = snaphot.data.list;
            return ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.only(top: 6, bottom: 6, left: 10, right: 8),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2.0, color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  margin: const EdgeInsets.only(left: 2, right: 2, top: 2, bottom: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 10, right: 12),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(sourceData[index].userAvatar),
                          radius: 30,
                        ),
                      ),
                      Flexible(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(sourceData[index].user_nick_name, style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                              Text(sourceData[index].board_name,
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                                textAlign: TextAlign.right,),
                            ],
                          ),
                          Container(
                              padding: EdgeInsets.only(top: 2),
                              child: Text(sourceData[index].last_reply_date,
                                  style: TextStyle(fontSize: 12, color: Colors.grey))
                          ),
                          Container(
                              padding: EdgeInsets.only(top: 4, bottom: 4),
                              child: Text(sourceData[index].subject,
                                style: TextStyle(fontSize: 18, color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: true,)
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(Icons.remove_red_eye, size: 18, color: Colors.grey,),
                              Container(
                                margin: const EdgeInsets.only(left: 6, right: 6),
                                child: Text(sourceData[index].hits.toString(),
                                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ),
                              Icon(Icons.chat_bubble_outline, size: 18,
                                color: Colors.grey,),
                              Container(
                                margin: const EdgeInsets.only(left: 6),
                                child: Text(sourceData[index].replies.toString(),
                                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ),
                            ],
                          )
                        ],
                      ),)
                    ],
                  ),
                );
              },
              itemCount: sourceData.length,
            );
          }
        }
      },
    );
  }

  @override
  bindData(sourcedata) {
    return null;
  }

  @override
  IBasePresenter<IBaseView, IBaseModel> get presenter => _presenter;

  @override
  void setPresenter(presenter) {
    _presenter = presenter;
  }

  @override
  void showToast(content) {
  }

  @override
  toGetMoreNetData() {
    return null;
  }

  @override
  Future toGetNetData() async {
    User finalUser = await user_cache.finalUser();
    var data = presenter.loadNetData(type: const_util.user_publish,query: {"type" : const_util.userPublishType,
      "uid" : finalUser.uid,
      "apphash" : await user_cache.getAppHash(),
      "accessToken" : finalUser.token,
      "accessSecret" : finalUser.secret,
      "page" : 1,
      "sdkVersion" : const_util.sdkVersion
    });
    return data;
  }

  @override
  toRefresh() {
    return null;
  }
}