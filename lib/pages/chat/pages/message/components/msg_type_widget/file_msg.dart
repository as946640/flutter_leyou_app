import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/file_icon/file_icon.dart';

class FileMsg extends StatelessWidget {
  const FileMsg({super.key, required this.item, required this.isMy});

  final Message item;
  final bool isMy;

  getIcon(String name) {}

  String fileSize(int? fileSize) {
    if (fileSize == null) return '0kb';
    return '${(fileSize / 1000 * 0.0009766).round() == 0 ? 1 : (fileSize / 1000 * 0.0009766).round()} MB';
  }

  String fileIconName(String? name) {
    String? suffix = name?.split('.').last;
    if (suffix == '' || suffix == null) return 'icon_未知格式';
    if (suffix == 'docx') suffix = 'doc';
    return 'icon_$suffix';
  }

  @override
  Widget build(BuildContext context) {
    FileElem fileMsgInfo = item.fileElem!;
    return Container(
      width: 200.w,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${fileMsgInfo.fileName}",
                  maxLines: 2,
                  style: const TextStyle(height: 1.1),
                ),
                const SizedBox(height: 6),
                Text(
                  fileSize(fileMsgInfo.fileSize),
                  style: TextStyle(
                    color: HexThemColor(secondaryTextC),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          FileIcon(
            name: fileIconName(fileMsgInfo.fileName),
            size: 40.0,
          )
        ],
      ),
    );
  }
}
