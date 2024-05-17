import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/pages/chat/controller/chat_controller.dart';
import 'package:mall_community/pages/chat/pages/message/components/bottom_input/bottom_input.dart';
import 'package:mall_community/pages/chat/pages/message/components/list.dart';
import 'package:mall_community/pages/chat/pages/message/components/to_bottom_pop.dart';

///好友聊天页面
class MessageListPage extends StatelessWidget {
  MessageListPage({super.key});
  final ChatController chatController = Get.put(ChatController());
  final MsgBotInputModule botInputModule = MsgBotInputModule();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(
          title: Obx(() => Text(chatController.title.value)),
          actions: [
            IconButton(
              onPressed: chatController.toSetting,
              icon: const Icon(Icons.more_horiz_rounded),
            )
          ]),
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [const MessageList(), ToBottomPop()],
            ),
          ),
          MsgBotInput(key: MsgBotInputModule.bottomKey),
        ],
      ),
    );
  }

  Widget filterWidget({
    Widget? child,
    double sigmaX = 80,
    double sigmaY = 200,
  }) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: sigmaX,
          sigmaY: sigmaY,
        ),
        child: child,
      ),
    );
  }

  PreferredSizeWidget getAppBar({
    double appHeight = 50,
    Widget? title,
    Widget? leading,
    List<Widget>? actions,
    PreferredSize? bottom,
  }) {
    if (actions != null) {
      actions.add(const SizedBox(width: 8));
    }
    return PreferredSize(
      preferredSize: Size.fromHeight(appHeight),
      child: filterWidget(
        child: AppBar(
          title: title,
          toolbarHeight: appHeight,
          leading: leading,
          leadingWidth: 80,
          actions: actions,
          bottom: bottom,
          elevation: 0,
          iconTheme: IconThemeData(color: primaryTextC),
          titleTextStyle: TextStyle(
            color: primaryTextC,
          ),
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          //bottom: getTitle(),
        ),
      ),
    );
  }
}
