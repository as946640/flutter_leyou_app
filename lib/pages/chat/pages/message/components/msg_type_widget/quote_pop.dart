import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/pages/chat/controller/chat_controller.dart';

class QuotePop extends StatelessWidget {
  QuotePop({super.key});
  final ChatController chatController = Get.find();

  close() {
    chatController.quoteMsg.value = null;
  }

  String getQuoteMsg() {
    Message? quoteMsg = chatController.quoteMsg.value;
    if (quoteMsg != null) {
      switch (quoteMsg.contentType) {
        case MessageType.file:
          return "[文件消息]";
        case MessageType.picture:
          return "[图片消息]";
        case MessageType.video:
          return "[视频消息]";
        case MessageType.voice:
          return "[语音消息]";
        default:
          return quoteMsg.textElem?.content ?? "";
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (chatController.quoteMsg.value != null) {
        return Container(
          width: 300.w,
          height: 40,
          margin: EdgeInsets.symmetric(horizontal: 50.w),
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  getQuoteMsg(),
                  maxLines: 1,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  close();
                },
                icon: const Icon(Icons.close_rounded),
              )
            ],
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
