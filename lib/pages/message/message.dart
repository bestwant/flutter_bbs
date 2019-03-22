
import 'package:flutter_bbs/pages/message/message_stateful/reply_stateful.dart';
import 'package:flutter_bbs/pages/message/message_stateful/atme_stateful.dart';
import 'package:flutter_bbs/pages/message/message_stateful/private_stateful.dart';
import 'package:flutter_bbs/pages/message/message_stateful/system_stateful.dart';

import 'package:flutter/material.dart';

///created by sgh     2019-2-28
/// 构建消息界面的Widget
class MessagePageWidget extends StatelessWidget {

  TabController controller;
  MessagePageWidget({this.controller});
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      children: <Widget>[
        MessageReplyWidget(),
        MessageAtmeWidget(),
        MessagePrivateWidget(),
        MessageSystemWidget(),
      ],
    );
  }
}