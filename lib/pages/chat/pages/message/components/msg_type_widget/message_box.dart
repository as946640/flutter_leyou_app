import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/avatar/avatar.dart';
import 'package:mall_community/components/pop_menu/pop_menu.dart';
import 'package:mall_community/components/text_span/text_span.dart';
// import 'package:mall_community/pages/chat/module/message_module.dart';
import 'package:mall_community/pages/chat/controller/chat_controller.dart';
import 'package:mall_community/pages/chat/module/message_module.dart';
import 'package:mall_community/pages/chat/pages/message/components/msg_type_widget/file_%20progress.dart';
import 'package:mall_community/pages/chat/pages/message/components/msg_type_widget/call_video.dart';
import 'package:mall_community/pages/chat/pages/message/components/msg_type_widget/file_msg.dart';
import 'package:mall_community/pages/chat/pages/message/components/msg_type_widget/image_msg.dart';
import 'package:mall_community/pages/chat/pages/message/components/msg_type_widget/location_msg.dart';
import 'package:mall_community/pages/chat/pages/message/components/msg_tool_bar.dart';
import 'package:mall_community/pages/chat/pages/message/components/msg_type_widget/reply_msg.dart';
import 'package:mall_community/pages/chat/pages/message/components/msg_type_widget/video_msg.dart';
import 'package:mall_community/pages/chat/pages/message/components/msg_type_widget/voice_msg.dart';
import 'package:mall_community/utils/overlay_manager/overlay_manager.dart';
import 'package:mall_community/utils/toast/toast.dart';
import 'package:mall_community/utils/utils.dart';

/// 消息 item
class MessageBox extends StatelessWidget {
  MessageBox({
    super.key,
    required this.item,
    required this.isMy,
    required this.avatar,
    required this.toolBarKey,
  });

  final Message item;
  final String avatar;
  final bool isMy;
  final UniqueKey toolBarKey;
  final GlobalKey msgKey = GlobalKey();
  final GlobalKey textSpanEmojiKey = GlobalKey();
  final ChatController chatController = Get.find();
  Timer? timer;
  SelectedContent? textSelection;
  SelectionChangedCause? selectCause;

  onLongPress() {
    Rect? targetRect = getRect(msgKey);
    if (targetRect != null) {
      OverlayManager().showOverlay(
        CustomPopup(
          targetRect: targetRect,
          backgroundColor: routineTextC,
          child: MsgToolBar(
            isMy: isMy,
            item: item,
            toolBarKey: toolBarKey,
            copyText: copyText,
          ),
        ),
        toolBarKey,
        isAnimate: false,
      );
    }
  }

  // 文本消息选择回调
  msgTextSelectChange(SelectedContent? selectedContent, FocusNode f) {
    textSelection = selectedContent;
    chatController.textSelectFocusNode = f;
    if (timer != null) {
      timer!.cancel();
      timer = null;
      OverlayManager().removeOverlay(toolBarKey);
    }
    timer = Timer(const Duration(milliseconds: 600), () {
      onLongPress();
      timer = null;
    });
  }

  // 文本复制
  void copyText() async {
    if (item.contentType == MessageType.text) {
      // 文本是否有选中的
      if (textSelection != null) {
        await Clipboard.setData(
            ClipboardData(text: textSelection?.plainText ?? ''));
      } else {
        await Clipboard.setData(
            ClipboardData(text: item.textElem?.content ?? ""));
      }
      OverlayManager().removeOverlay(toolBarKey);
      closeFocusNode();
    } else {
      ToastUtils.showToast('只有文本才支持复制', position: 'top');
    }
  }

  ///取消选择 当用户点击其他地方时取消选择
  closeFocusNode() {
    chatController.textSelectFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (de) {
        onLongPress();
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        constraints: BoxConstraints(minHeight: 40.h),
        margin: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMy) MyAvatar(src: avatar),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment:
                    isMy ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (item.status == MessageStatus.sending)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  if (item.status == MessageStatus.failed)
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          '重发',
                          style: tx14.copyWith(color: HexThemColor(errorColor)),
                        )),
                  msgWidget(),
                ],
              ),
            ),
            if (isMy) MyAvatar(src: avatar)
          ],
        ),
      ),
    );
  }

  /// 文本消息盒子
  Widget msgBox(Widget child, key) {
    return Container(
      key: key,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      constraints: BoxConstraints(
        minHeight: 40.h,
        maxWidth: 0.6.sw,
      ),
      decoration: BoxDecoration(
        color: isMy ? HexThemColor(primaryColor) : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }

  msgWidget() {
    if (item.contentType == MessageType.text) {
      return msgBox(
        TextSpanEmoji(
          text: item.textElem?.content ?? '',
          key: textSpanEmojiKey,
          style: tx14.copyWith(
            color: isMy ? Colors.white : Colors.black87,
          ),
          onSelectionChanged: (SelectedContent? selectedContent, FocusNode f) {
            if (selectedContent != null) {
              msgTextSelectChange(selectedContent, f);
            }
          },
        ),
        msgKey,
      );
    } else {
      return MsgTypeWidget(item: item, msgKey: msgKey, isMy: isMy);
    }
  }
}

class MsgTypeWidget extends StatelessWidget {
  MsgTypeWidget({
    super.key,
    required this.item,
    required this.isMy,
    required this.msgKey,
  });
  final Message item;
  final bool isMy;
  final GlobalKey msgKey;
  final GlobalKey textSpanEmojiKey = GlobalKey();

  final Map<String, Widget Function(Message, bool, GlobalKey)> msgTypeWidget = {
    MessageType.picture.toString(): (item, isMy, key) => ImageMsg(
          item: item,
          isMy: isMy,
          key: key,
        ),
    MessageType.file.toString(): (item, isMy, key) =>
        FileMsg(item: item, isMy: isMy, key: key),
    MessageType.voice.toString(): (item, isMy, key) =>
        VoiceMsg(isMy: isMy, item: item, key: key),
    MessageType.location.toString(): (item, isMy, key) =>
        LocationMsg(item: item, key: key),
    MessageType.quote.toString(): (item, isMy, key) =>
        ReplyMsg(item: item, isMy: isMy, msgKey: key),
    MessageType.video.toString(): (item, isMy, key) => VideoMsg(
          item: item,
          isMy: isMy,
          key: key,
        ),
    CusMessageType.process.toString(): (item, isMy, key) => ImFileProgress(
          item: item,
          progress:
              json.decode(item.customElem?.data ?? "{}")['progress'] ?? 0.0,
        ),
  };

  @override
  Widget build(BuildContext context) {
    String type = item.contentType.toString();
    if (item.contentType == MessageType.custom) {
      type = json.decode(item.customElem!.data ?? "{}")['type'].toString();
    }
    Widget Function(Message p1, bool p2, GlobalKey<State<StatefulWidget>> p3)?
        fun = msgTypeWidget[type];
    if (fun != null && type.isNotEmpty) {
      return fun.call(item, isMy, msgKey);
    }
    return const SizedBox();
  }
}
