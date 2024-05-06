import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/components/new_work_image_widget/new_work_image_widget.dart';
import 'package:mall_community/pages/chat/controller/chat_controller.dart';

class ImageMsg extends StatelessWidget {
  ImageMsg({
    super.key,
    required this.isMy,
    required this.item,
  });

  final Message item;
  final bool isMy;
  final UniqueKey uniqueKey = UniqueKey();

  tap(url) async {
    ChatController chatC = Get.find();
    await chatC.previewImage(url);
  }

  @override
  Widget build(BuildContext context) {
    PictureElem fileMsgInfo = item.pictureElem!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      constraints: BoxConstraints(
        maxWidth: 160.w,
        maxHeight: 246.h,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: () {
          // tap(fileMsgInfo.content);
        },
        child: Hero(
          tag: "key_${item.clientMsgID}",
          placeholderBuilder: (context, heroSize, child) {
            return child;
          },
          child: NetWorkImg(
            fileMsgInfo.snapshotPicture?.url ?? "",
            fit: BoxFit.contain,
            raduis: 10,
          ),
        ),
      ),
    );
  }
}
