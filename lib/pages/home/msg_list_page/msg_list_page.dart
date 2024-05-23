import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/pages/home/msg_list_page/components/friends.dart';
import 'package:mall_community/pages/home/msg_list_page/components/groups.dart';
import 'package:mall_community/pages/home/msg_list_page/components/top_bar.dart';
import 'package:mall_community/pages/home/msg_list_page/controller/msg_list_module.dart';
import 'package:mall_community/pages/home/msg_list_page/components/msg_list.dart';

///用户消息列表
class MsgListPage extends StatefulWidget {
  const MsgListPage({super.key});

  @override
  State<MsgListPage> createState() => _MsgListPageState();
}

class _MsgListPageState extends State<MsgListPage>
    with TickerProviderStateMixin {
  final MsgListModule chatController = Get.put(MsgListModule());
  late TabController tabController;
  final tabs = [
    {'text': "消息"},
    {'text': '联系人'},
    {'text': '我的群'}
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
    chatController.easyRefreshController = EasyRefreshController(
      controlFinishLoad: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            TopBar(tabController: tabController, tabs: tabs),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  FirendMsgList(),
                  FriendList(),
                  GroupList(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    tabController.removeListener(() {});
    super.dispose();
  }
}
