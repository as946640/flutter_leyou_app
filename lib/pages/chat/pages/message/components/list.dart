import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/common/theme.dart';
import 'package:mall_community/components/loading/loading.dart';
import 'package:mall_community/modules/user_module.dart' as user;
import 'package:mall_community/pages/chat/controller/chat_controller.dart';
import 'package:mall_community/pages/chat/pages/message/components/bottom_input/bottom_input.dart';
import 'package:mall_community/pages/chat/pages/message/components/msg_type_widget/message_box.dart';
import 'package:mall_community/utils/overlay_manager/overlay_manager.dart';

///好友聊天消息列表
class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  ChatController chatController = Get.find();
  GlobalKey centerKey = GlobalKey();
  UniqueKey visKey = UniqueKey();
  late Worker everCallBack;

  // 首次监听消息列表渲染完毕
  _msgNextTick() {
    if (chatController.lastMinSeq == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        chatController.checkListExceed();
      });
    }
  }

  // 消息区域点击
  _listClick() {
    chatController.textSelectFocusNode.unfocus();
    OverlayManager().removeOverlay(chatController.toolBarKey);
    MsgBotInputModule.hideBootoMenu();
  }

  @override
  void initState() {
    super.initState();

    everCallBack = ever(chatController.msgHistoryList, (list) {
      _msgNextTick();
      everCallBack.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragDown: (de) {
        _listClick();
      },
      child: Container(
        key: chatController.listKey,
        color: AppTheme.mode == ThemeMode.dark ? null : cF1f1f1,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        alignment: Alignment.topCenter,
        child: Obx(
          () => CustomScrollView(
            controller: chatController.scrollControll,
            center: centerKey,
            cacheExtent: 1.5.sh,
            anchor: chatController.offSet.value > 1
                ? 1
                : chatController.offSet.value,
            slivers: [
              if (chatController.loading.value)
                const SliverToBoxAdapter(child: LoadingText()),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    return buildItem(chatController.msgHistoryList[i], i: i);
                  },
                  childCount: chatController.msgHistoryList.length,
                ),
              ),
              SliverPadding(padding: EdgeInsets.zero, key: centerKey),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    return buildItem(chatController.newMsgList[i]);
                  },
                  childCount: chatController.newMsgList.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(Message item, {int? i}) {
    bool isMy = chatController.isMy(item.sendID!);
    return MessageBox(
      isMy: isMy,
      avatar:
          isMy ? user.UserInfo.user['avatar'] : chatController.params['avatar'],
      item: item,
      toolBarKey: chatController.toolBarKey,
    );
  }
}
