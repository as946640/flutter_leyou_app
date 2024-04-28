import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/automatic_keep_alive/automatic_keep_alive.dart';
import 'package:mall_community/components/avatar/avatar.dart';
import 'package:mall_community/components/Loading/Loading.dart';
import 'package:mall_community/pages/home/msg_list_page/controller/msg_list_module.dart';

///好友列表
class FriendList extends StatelessWidget {
  FriendList({super.key});
  final MsgListModule msgListModule = Get.find();

  @override
  Widget build(BuildContext context) {
    return ExtendedVisibilityDetector(
      uniqueKey: const Key('friendList'),
      child: MyAutomaticKeepAlive(
        child: LoadingPage(
          fetch: msgListModule.getFriends,
          empty: '快去广场添加您的心仪好友吧~',
          child: Obx(
            () => ListView.builder(
              itemExtent: 70,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              itemCount: msgListModule.friends.length,
              itemBuilder: (context, i) => buildItem(i),
            ),
          ),
        ),
      ),
    );
  }

  buildItem(int i) {
    FullUserInfo userInfo = msgListModule.friends[i];
    return Container(
      alignment: Alignment.center,
      height: 70,
      child: ListTile(
        onTap: () {
          // msgListModule.toChat(msg);
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: MyAvatar(
          src: userInfo.faceURL,
          radius: 50.r,
          size: 50.r,
        ),
        title: Text(
          "${userInfo.nickname}",
          style: tx18.copyWith(
            color: HexThemColor(primaryTextC, direction: 2),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
