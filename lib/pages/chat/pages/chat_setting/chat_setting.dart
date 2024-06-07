import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/avatar/avatar.dart';
import 'package:mall_community/components/button/button.dart';
import 'package:mall_community/components/cell_group/cell_group.dart';
import 'package:mall_community/components/new_work_image_widget/new_work_image_widget.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';

class ChatSetting extends StatefulWidget {
  const ChatSetting({super.key});

  @override
  State<ChatSetting> createState() => _ChatSettingState();
}

class _ChatSettingState extends State<ChatSetting> {
  // 是否置顶
  bool isTopping = false;

  // 置顶切换
  toppingSwitch(bool value) {
    setState(() {
      isTopping = value;
    });
  }

  // 好友删除
  removeFriend() {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return TDAlertDialog(
          title: "删除联系人",
          content: "将联系人“某某”删除，同时删除与该联系人的聊天记录",
          titleColor: errorColor,
          buttonStyle: TDDialogButtonStyle.text,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<CellModule> list = [
      CellModule({
        "title": "置顶",
        "trailing": CupertinoSwitch(
          value: isTopping,
          onChanged: toppingSwitch,
        )
      }),
      CellModule({
        "title": "消息免打扰",
        "trailing": CupertinoSwitch(
          value: isTopping,
          onChanged: toppingSwitch,
        )
      }),
      CellModule({"title": "删除聊天记录", "subTitle": "图片、视频、文件等"}),
    ];

    final List<CellModule> list1 = [
      CellModule({
        "title": "好友名字",
        "leading": const MyAvatar(
          src:
              "https://cdn2.jianshu.io/assets/default_avatar/8-a356878e44b45ab268a3b0bbaaadeeb7.jpg",
          radius: 44,
        )
      }),
      CellModule({
        "title": "发起群聊",
        "showArrow": false,
        "leading": Icon(
          Icons.add_circle_rounded,
          color: Colors.grey.shade300,
          size: 44,
        )
      }),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("聊天详情"),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CellGroup(list: list1),
              const SizedBox(height: 20),
              CellGroup(list: list),
              const SizedBox(height: 12),
              CellGroup(list: [
                CellModule({
                  "title": "查找聊天记录",
                }),
              ]),
              const SizedBox(height: 12),
              Button(
                color: Colors.white,
                textColor: errorColor,
                onPressed: removeFriend,
                text: "删除好友",
                radius: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
