import 'package:flutter_bbs/network/json/bbs_response.dart';

///Board界面获取板块列表的Json
class ForumListModel {
  List<_Data> list;
  int online_user_num;
  int td_visitors;
  int rs;
  String errcode;
  Head head;

  ForumListModel.fromJson(Map<String, dynamic> json)
      : this.online_user_num = json['online_user_num'],
        this.td_visitors = json['td_visitors'],
        this.rs = json['rs'],
        this.errcode = json['errcode'],
        this.head = Head.fromJson(json['head']){

    var results = <_Data>[];
    for(int i = 0; i < json['list'].length; i++) {
      var item = _Data.fromJson(json['list'][i]);
      results.add(item);
    }
    this.list = results;
  }
}

///ForumListModel的内部元素
class _Data {
  List<_BoardList> board_list;
  int board_category_id;
  String board_category_name;
  int board_category_type;

  _Data.fromJson(Map<String, dynamic> json)
      : this.board_category_id = json['board_category_id'],
        this.board_category_name = json['board_category_name'],
        this.board_category_type = json['board_category_type']{

    var _item = <_BoardList>[];
    for (int i = 0; i < json['board_list'].length; i++) {
      var item0 = _BoardList.fromJson(json['board_list'][i]);
      _item.add(item0);
    }
    this.board_list = _item;
  }
}

///Data的内部元素
/// 代表“就业创业”这种每个板块的信息
class _BoardList {
  int board_id;
  String board_name;
  String description;
  int board_child;
  String board_img;
  String last_posts_date;
  int board_content;
  String forumRedirect;
  int favNum;
  int td_posts_num;
  int topic_total_num;
  int posts_total_num;
  int is_focus;

  _BoardList.fromJson(Map<String, dynamic> json)
      : this.board_id = json['board_id'],
        this.board_name = json['board_name'],
        this.description = json['description'],
        this.board_child = json['board_child'],
        this.board_img = json['board_img'],
        this.board_content = json['board_content'],
        this.last_posts_date = json ['last_posts_date'],
        this.forumRedirect = json['forumRedirect'],
        this.favNum = json['favNum'],
        this.td_posts_num = json['td_posts_num'],
        this.topic_total_num = json['topic_total_num'],
        this.posts_total_num = json['posts_total_num'],
        this.is_focus = json['is_focus'];
}

/// 该类是点击板块列表中的板块的时候
/// 每个板块及其下面的子板块的信息
/// 该类封装在BBSResponse下
class Board {
  int board_category_id;
  String board_category_name;
  List<ChildBoard> board_list;

  Board.fromJson(Map<String, dynamic> json)
      : this.board_category_id = json['board_category_id'],
        this.board_category_name = json['board_category_name'] {

    var result = <ChildBoard>[];
    for (int i = 0; i < json['board_list'].length; i ++) {
      var item = ChildBoard.fromJson(json['board_list'][i]);
      result.add(item);
    }
    this.board_list = result;
  }
}

/// 子版块的信息
class ChildBoard {
  int board_id;
  String board_name;

  ChildBoard.fromJson(Map<String, dynamic> json)
      : this.board_id = json['board_id'],
        this.board_name = json['board_name'];
}
