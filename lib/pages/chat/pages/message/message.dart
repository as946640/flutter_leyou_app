import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/common/theme.dart';
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
      // appBar: AppBar(
      //   title: Obx(() => Text(chatController.title.value)),
      //   centerTitle: true,
      //   elevation: 0,
      //   surfaceTintColor: Colors.transparent,
      //   backgroundColor: Colors.transparent,
      //   systemOverlayStyle: const SystemUiOverlayStyle(
      //     statusBarColor: Colors.transparent,
      //     statusBarIconBrightness: Brightness.light,
      //   ),
      //   iconTheme: IconThemeData(
      //     color:
      //         AppTheme.mode == ThemeMode.dark ? Colors.white : Colors.black87,
      //   ),
      //   titleTextStyle: TextStyle(
      //     color:
      //         AppTheme.mode == ThemeMode.dark ? Colors.white : Colors.black87,
      //   ),
      // ),
      appBar: getAppBar(
        title: Obx(() => Text(chatController.title.value)),
      ),
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
    double sigmaX = 400,
    double sigmaY = 100,
  }) {
    return ClipRect(
      //背景模糊化
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
          foregroundColor: Colors.transparent,
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
