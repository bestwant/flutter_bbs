
import 'package:flutter_bbs/network/json/post.dart';
import 'package:flutter_bbs/network/json/user.dart';

class BBSResponse<T> {
  int rs;
  String errcode;
  int page;
  int hasNext;
  int totalNum;
  _Head head;
  T list;

  BBSResponse({this.rs, this.errcode, this.page, this.hasNext, this.totalNum, this.head, this.list});
}

class _Head {
  String errCode;
  String errInfo;

  _Head({this.errCode, this.errInfo});

  _Head.fromJson(Map<String, dynamic> json)
      : errInfo = json['errInfo'],
        errCode = json['errCode'];
}

///Home界面“最新发表”“最新回复”“今日热点”
/// 返回的Json
class BBSRepListPost {
  int rs;
  String errcode;
  int page;
  int hasNext;
  int totalNum;
  _Head head;
  List<Post> list;
  BBSRepListPost({this.rs, this.errcode, this.page, this.hasNext, this.totalNum, this.head, this.list});

  BBSRepListPost.fromJson(Map<String, dynamic> json)
      : rs = json['rs'],
        errcode = json['errcode'],
        page = json['page'],
        hasNext = json['hasNext'],
        totalNum = json['totalNum'],
        head = _Head.fromJson(json['head']){

    if (json['list'] == null) {
      list = null;
    } else {
      var result = <Post>[];
      for (int i = 0; i < json['list'].length; i++) {
        var item = Post.fromJson(json['list'][i]);
        result.add(item);
      }
      this.list = result;
    }
  }
}

/// 用户信息界面返回已发帖子的json
class BBSRespListUserPub {
  int rs;
  String errcode;
  int page;
  int hasNext;
  int totalNum;
  _Head head;
  List<UserPublish> list;

  BBSRespListUserPub(this.rs, this.errcode, this.page, this.hasNext,
      this.totalNum, this.head, this.list);

  BBSRespListUserPub.fromJson(Map<String, dynamic> json)
      : this.rs = json['rs'],
        this.errcode = json['errcode'],
        this.page = json['page'],
        this.hasNext = json['hasNext'],
        this.totalNum = json['totalNum'],
        this.head = _Head.fromJson(json['head']) {

    var result = <UserPublish>[];
    for (int i = 0; i < json['list'].length; i++) {
      var item = UserPublish.fromJson(json['list'][i]);
      result.add(item);
    }
    this.list = result;
  }


}
