import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/avatar/avatar.dart';
import 'package:mall_community/components/button/button.dart';
import 'package:mall_community/pages/chat/controller/chat_controller.dart';
import 'package:mall_community/pages/chat/module/message_module.dart';
import 'package:mall_community/utils/overlay_manager/overlay_manager.dart';
import 'package:mall_community/utils/socket/socket_event.dart';

/// 来电通知浮窗
class RingCallPop extends StatelessWidget {
  const RingCallPop({super.key, required this.data, required this.uniK});

  final CallVideoMsg data;
  final UniqueKey uniK;

  reject() {
    Map msg = CallVideoMsg({
      "toUserId": data.fromUser.userId,
      "status": SocketEvent.rejectPhone
    }).toMap();
    OverlayManager().removeOverlay(uniK);
    ChatController controller = Get.find<ChatController>();
    // controller.sendMsg(jsonEncode(msg), type: MessageType.callPhone);
    // controller.socket.sendMessage(SocketEvent.rejectPhone, data: msg);
  }

  answer() {
    OverlayManager().removeOverlay(uniK);
    Get.toNamed('/chat/call_video', arguments: {
      "sdpInfoData": data,
      "friendId": data.fromUser.userId,
      "avatar": data.fromUser.avatar,
      "userName": data.fromUser.nickNmae
    });
  }

  @override
  Widget build(BuildContext context) {
    CallVideoUser user = data.fromUser;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 14,
          ),
          margin: const EdgeInsets.only(
            top: 100,
            left: 20,
            right: 20,
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: primaryColor,
                  offset: const Offset(0, 10),
                  blurRadius: 40.0,
                  spreadRadius: 0.0,
                )
              ]),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MyAvatar(
                size: 50,
                radius: 50,
                src: user.avatar,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    user.nickNmae,
                    style: tx16.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Button(
                onPressed: reject,
                circle: true,
                size: const Size(44, 44),
                color: HexThemColor(errorColor),
                icon: const Icon(
                  IconData(0xe7d3, fontFamily: 'micon'),
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              Button(
                onPressed: answer,
                circle: true,
                size: const Size(44, 44),
                color: HexThemColor(successColor),
                icon: const Icon(
                  IconData(0xe676, fontFamily: 'micon'),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
