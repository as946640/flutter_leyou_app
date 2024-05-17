import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mall_community/common/comm_style.dart';

class ChatSetting extends StatelessWidget {
  const ChatSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("聊天详情"),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            cellItem("查找聊天记录", trailingText: "图片、文件、视频等"),
            const SizedBox(height: 10),
            cellItem("置顶", trailingText: "nihao"),
            cellItem("消息免打扰", trailingText: "nihao"),
            cellItem("删除聊天记录"),
          ],
        ),
      ),
    );
  }

  // Widget cell(){
  //   return 
  // }

  Widget cellItem(String title,
      {Widget? leading, String? trailingText, Widget? trailing}) {
    return ListTile(
      leading: leading,
      onTap: () {},
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(title),
      trailing: trailing ??
          SizedBox(
            width: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (trailingText != null)
                  Text(trailingText,
                      style: tx14.copyWith(color: secondaryTextC)),
                const SizedBox(width: 10),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: secondaryTextC, size: 14),
              ],
            ),
          ),
    );
  }
}
