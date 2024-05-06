import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/pages/chat/controller/chat_controller.dart';
import 'package:mall_community/pages/chat/module/message_module.dart';
import 'package:mall_community/utils/overlay_manager/overlay_manager.dart';
import 'package:mall_community/utils/time_util.dart';
import 'package:mall_community/utils/toast/toast.dart';

/// 消息工具栏
class MsgToolBar extends StatefulWidget {
  const MsgToolBar({
    super.key,
    required this.isMy,
    required this.item,
    required this.toolBarKey,
    required this.copyText,
  });

  final bool isMy;
  final UniqueKey toolBarKey;
  final Message item;
  final Function copyText;

  @override
  State<MsgToolBar> createState() => _MsgToolBarState();
}

class _MsgToolBarState extends State<MsgToolBar> {
  List<Map> list = [
    {'title': '复制', "icon": const IconData(0xe604, fontFamily: 'micon')},
    {'title': '引用', "icon": const IconData(0xe7f6, fontFamily: 'micon')},
  ];

  // 文本复制
  copyText() async {
    widget.copyText.call();
  }

  msgQuote() {
    // if (widget.item.messageType == MessageType.reply) {
    //   ToastUtils.showToast('回复消息不支持再次引用', position: 'bottom');
    //   return;
    // }
    // ChatController chatC = Get.find();
    // chatC.quoteMsg.value = widget.item;
    // chatC.showInput();
    // OverlayManager().removeOverlay(widget.toolBarKey);
  }

  msgRevoke() {
    OverlayManager().removeOverlay(widget.toolBarKey);
  }

  itemClick(String title) {
    switch (title) {
      case "引用":
        msgQuote();
        break;
      case "撤回":
        msgRevoke();
        break;
      default:
        copyText();
    }
  }

  @override
  void initState() {
    if (widget.isMy &&
        TimeUtil.timeDiffer(widget.item.sendTime).inMinutes < 3) {
      list.add(
          {'title': '撤回', "icon": const IconData(0xe60f, fontFamily: 'micon')});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 40.h,
          constraints: BoxConstraints(
            maxWidth: 0.6.sw,
            minWidth: 50.w,
          ),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            scrollDirection: Axis.horizontal,
            children: List.generate(list.length, (i) => buildItem(i)),
          ),
        ),
      ],
    );
  }

  buildItem(int i) {
    return GestureDetector(
      onTap: () {
        itemClick(list[i]['title']);
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              list[i]['icon'],
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              list[i]['title'],
              style: tx12.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
