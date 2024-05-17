import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/automatic_keep_alive/automatic_keep_alive.dart';
import 'package:mall_community/components/avatar/avatar.dart';
import 'package:mall_community/components/custom_badge/custom_badge.dart';
import 'package:mall_community/components/easy_refresh_diy/easy_refresh_diy.dart';
import 'package:mall_community/components/loading/loading.dart';
import 'package:mall_community/pages/home/msg_list_page/controller/msg_list_module.dart';
import 'package:mall_community/utils/time_util.dart';

///好友消息列表
class FirendMsgList extends StatelessWidget {
  FirendMsgList({super.key});
  final MsgListModule msgListModule = Get.find();

  @override
  Widget build(BuildContext context) {
    return ExtendedVisibilityDetector(
      uniqueKey: const Key('msgList'),
      child: MyAutomaticKeepAlive(
        child: EasyRefresh(
            onLoad: () {
              msgListModule.getMore();
            },
            footer: footerLoading,
            controller: msgListModule.easyRefreshController,
            child: Obx(
              () => LoadingPage(
                fetch: msgListModule.getMsgList,
                empty: '还没有人给你发消息呢~',
                stream: msgListModule.streamController.stream,
                child: ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  itemCount: msgListModule.msgList.length,
                  itemBuilder: (ctx, i) => buildItem(i),
                ),
              ),
            )),
      ),
    );
  }

  buildItem(int i) {
    ConversationInfo msg = msgListModule.msgList[i];

    return SwipeActionCell(
      key: ValueKey(i),
      trailingActions: getCellNav(i),
      child: ListTile(
        onTap: () {
          msgListModule.toChat(
            msg.conversationID,
            msg.userID!,
            avatar: msg.faceURL,
            title: msg.showName,
          );
        },
        leading: MyAvatar(
          src: "${msg.faceURL}",
          radius: 50,
          size: 50.r,
        ),
        title: Text(
          msg.showName ?? "",
          style: tx14.copyWith(
            color: primaryTextC,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Text(
                msg.latestMsg?.textElem?.content ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: tx12.copyWith(
                  color: HexThemColor(primaryTextC, direction: 2),
                ),
              ),
            ),
            Text(
              TimeUtil.formatTime(msg.latestMsgSendTime),
              style: tx12.copyWith(
                color: HexThemColor(primaryTextC, direction: 2),
              ),
            ),
          ],
        ),
        trailing: MyBadge(value: msg.unreadCount),
      ),
    );
  }

  List<SwipeAction> getCellNav(i) {
    return [
      SwipeAction(
        title: "删除",
        onTap: (CompletionHandler handler) async {
          await handler(true);
          // msgList.removeAt(i);
          // setState(() {});
        },
        color: errorColor,
      ),
      SwipeAction(
        title: "置顶",
        onTap: (CompletionHandler handler) async {
          await handler(false);
        },
        color: warningColor,
      ),
    ];
  }
}
