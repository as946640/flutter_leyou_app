import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:images_picker/images_picker.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/controller/open_im_controller.dart';
import 'package:mall_community/pages/chat/controller/chat_controller.dart';
import 'package:mall_community/pages/chat/module/message_module.dart';
import 'package:mall_community/utils/file_picker/file_picker.dart';
import 'package:mall_community/utils/image_picker/image_picker.dart';
import 'package:mall_community/utils/log/log.dart';
import 'package:mall_community/utils/tx_cos/tx_cos.dart';
import 'package:mall_community/utils/utils.dart';

/// 聊天底部菜单
class ChatBottomMenu extends StatelessWidget {
  ChatBottomMenu({super.key});
  final ChatController chatController = Get.find();
  final List menus = [
    {
      'title': '相册',
      'icon': const Icon(IconData(0xe7e4, fontFamily: 'micon'), size: 32),
    },
    {
      'title': '拍摄',
      'icon': const Icon(IconData(0xe61b, fontFamily: 'micon'), size: 32),
    },
    {
      'title': '文件',
      'icon': const Icon(IconData(0xe601, fontFamily: 'micon'), size: 34),
    },
    {
      'title': '定位',
      'icon': const Icon(IconData(0xe620, fontFamily: 'micon'), size: 32),
    },
    {
      'title': '视频通话',
      'icon': const Icon(IconData(0xe689, fontFamily: 'micon'), size: 32),
    },
  ];

  itemClick(String name) {
    switch (name) {
      case '拍摄':
        shoot();
        break;
      case '文件':
        filePicker();
        break;
      case '定位':
        location();
        break;
      case '视频通话':
        toCall();
        break;
      default:
        imageMsg();
    }
  }

  imageMsg() async {
    List<Map<String, dynamic>> list = [
      {'title': '选择视频', 'type': 'video'},
      {'title': '选择照片', 'type': 'image'}
    ];
    showBottomMenu(list, (Map? item) async {
      if (item == null) return;
      if (item['type'] == 'video') {
        List<Media>? result = await ImagePicker.pickVideo();
        if (result == null) return;
        PictureInfo sourcePicture = PictureInfo(
          url: result[0].path,
          size: result[0].size.toInt(),
        );
        String cosUrl = await UploadDio.upload(result[0].path);
        PictureInfo bigPicture = PictureInfo(
          url: cosUrl,
          size: result[0].size.toInt(),
        );
        String coverUrl = await UploadDio.upload(result[0].thumbPath!);
        PictureInfo snapshotPicture = PictureInfo(
          url: coverUrl,
          size: result[0].size.toInt(),
        );
        Message msg = await OpenImController.msgManager.createImageMessageByURL(
          sourcePicture: sourcePicture,
          bigPicture: bigPicture,
          snapshotPicture: snapshotPicture,
        );
        await chatController.sendMsg(msg);
      } else {
        List<Media>? list = await ImagePicker.pickImages();
        if (list == null) return;
        sendImgOrVideo(list);
      }
    });
  }

  // 上传图片或者视频 个人觉得直传比较快和省带宽
  sendImgOrVideo(List<Media> list, {type = 'image'}) async {
    for (var item in list) {
      // 创建一个自定本地进度条展示消息
      double progress = 0.0;
      Message progressMsg =
          await OpenImController.msgManager.createCustomMessage(
        data: json.encode({
          "progress": progress,
          'filePath': item.thumbPath,
          "type": CusMessageType.process,
        }),
        extension: "",
        description: "文件上传中",
      );
      chatController.addMsg(progressMsg);
      late Message msg;
      String cosUrl = await UploadDio.upload(
        item.path,
        progressCallback: (int sent, int total) {
          progress = ((sent / total) / 2);
          var newMsg = progressMsg;
          newMsg.customElem!.data = json.encode({
            "progress": progress,
            'filePath': item.thumbPath,
            "type": CusMessageType.process,
          });
          chatController.setMsgStatus(
            progressMsg,
            MessageStatus.succeeded,
            newMsg: newMsg,
          );
        },
      );
      PictureInfo bigPicture = PictureInfo(
        url: cosUrl,
        size: item.size.toInt(),
      );
      String coverUrl = await UploadDio.upload(
        item.thumbPath!,
        progressCallback: (sent, total) {
          progress +=
              double.tryParse(((sent / total) / 2).toStringAsFixed(2)) ?? 0.0;
          var newMsg = progressMsg;
          newMsg.customElem!.data = json.encode({
            "progress": progress,
            'filePath': item.thumbPath,
            "type": CusMessageType.process,
          });
          chatController.setMsgStatus(
            progressMsg,
            MessageStatus.succeeded,
            newMsg: newMsg,
          );
        },
      );
      PictureInfo snapshotPicture = PictureInfo(
        url: coverUrl,
        size: item.size.toInt(),
      );
      if (type == 'image') {
        PictureInfo sourcePicture = PictureInfo(
          url: cosUrl,
          size: item.size.toInt(),
        );
        msg = await OpenImController.msgManager.createImageMessageByURL(
          sourcePath: item.path,
          sourcePicture: sourcePicture,
          bigPicture: bigPicture,
          snapshotPicture: snapshotPicture,
        );
      } else {
        VideoElem vidoe = VideoElem(
          videoUrl: cosUrl,
          videoSize: item.size.toInt(),
          snapshotUrl: coverUrl,
          snapshotSize: item.size.toInt(),
        );
        msg = await OpenImController.msgManager
            .createVideoMessageByURL(videoElem: vidoe);
      }
      progress = 0.0;
      var newMsg = progressMsg;
      newMsg.customElem!.data = json.encode({
        "progress": 1.0,
        'filePath': item.thumbPath,
        "type": CusMessageType.process,
      });
      newMsg.customElem?.description = "文件发送中";
      chatController.setMsgStatus(
        progressMsg,
        MessageStatus.succeeded,
        newMsg: newMsg,
      );
      await chatController.sendMsg(msg, progressMsg: progressMsg);
    }
  }

  shoot() {
    List<Map<String, dynamic>> list = [
      {'title': '拍摄视频', 'type': 'video'},
      {'title': '拍摄照片', 'type': 'image'}
    ];
    showBottomMenu(list, (Map? item) async {
      if (item == null) return;
      List<Media>? list = await ImagePicker.takePhotos(item['type']);
      if (list == null) return;
      sendImgOrVideo(list, type: item['type']);
    });
  }

  filePicker() async {
    FilePickerResult? result = await AppFilePicker.pickFile();
    if (result == null) return null;
    double progress = 0.0;
    Message progressMsg = await OpenImController.msgManager.createCustomMessage(
      data: json.encode({
        "progress": progress,
        'filePath': result.files[0].path,
        'fileName': result.files[0].name,
        'fileSize': result.files[0].size,
        "type": CusMessageType.process,
      }),
      extension: "",
      description: "文件上传中",
    );
    chatController.addMsg(progressMsg);
    String fileUrl = await UploadDio.upload(
      result.files[0].path!,
      progressCallback: (sent, total) {
        progress +=
            double.tryParse(((sent / total) / 2).toStringAsFixed(2)) ?? 0.0;
        var newMsg = progressMsg;
        newMsg.customElem!.data = json.encode({
          "progress": progress,
          'filePath': result.files[0].path,
          'fileName': result.files[0].name,
          'fileSize': result.files[0].size,
          "type": CusMessageType.process,
        });
        chatController.setMsgStatus(
          progressMsg,
          MessageStatus.succeeded,
          newMsg: newMsg,
        );
      },
    );
    FileElem file = FileElem(
        fileName: result.files[0].name,
        filePath: fileUrl,
        fileSize: result.files[0].size);

    Message msg = await OpenImController.msgManager
        .createFileMessageByURL(fileElem: file);
    await chatController.sendMsg(msg, progressMsg: progressMsg);
  }

  location() async {
    BMFPoiInfo? result = await Get.toNamed('/map') as BMFPoiInfo?;
    if (result != null) {
      Message msg = await OpenImController.msgManager.createLocationMessage(
        latitude: result.pt?.latitude ?? 0.0,
        longitude: result.pt?.longitude ?? 0.0,
        description: result.address ?? result.direction ?? "未知地址信息",
      );
      chatController.sendMsg(msg);
    }
  }

  toCall() async {
    await Get.toNamed('/chat/call_video', arguments: chatController.params);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: 1.sw,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 10,
          runSpacing: 20,
          alignment: WrapAlignment.spaceBetween,
          clipBehavior: Clip.hardEdge,
          children: List.generate(menus.length, (i) => buildItem(menus[i])),
        ),
      ),
    );
  }

  Widget buildItem(Map item) {
    return GestureDetector(
      onTap: () {
        itemClick(item['title']);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: HexThemColor(cF1f1f1),
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.only(bottom: 10),
            child: item['icon'],
          ),
          Text(
            item['title'],
          )
        ],
      ),
    );
  }
}
