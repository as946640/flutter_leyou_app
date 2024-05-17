import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/sound_pop/sound_pop.dart';
import 'package:mall_community/controller/open_im_controller.dart';
import 'package:mall_community/pages/chat/controller/chat_controller.dart';
import 'package:mall_community/pages/chat/module/message_module.dart';
import 'package:mall_community/pages/chat/pages/message/components/bottom_input/waveforms.dart';
import 'package:mall_community/utils/overlay_manager/overlay_manager.dart';
import 'package:mall_community/utils/sound_recording/sound_recording.dart';
import 'package:mall_community/utils/toast/toast.dart';
import 'package:mall_community/utils/tx_cos/tx_cos.dart';

class SoundInput extends StatefulWidget {
  const SoundInput({
    super.key,
    required this.chatController,
    required this.setInputType,
  });
  final ChatController chatController;
  final Function setInputType;
  @override
  State<SoundInput> createState() => _SoundInputState();
}

class _SoundInputState extends State<SoundInput> {
  double dy = 0;
  UniqueKey key = UniqueKey();
  OverlayEntry? overlayEntry;
  WaveformsModule? waveformsModule;

  // 是否取消
  final isCancel = false.obs;
  // 录音秒数
  final RxInt second = 0.obs;

  /// 显示录音widget 并且开始录音
  startSound() {
    OverlayManager().showOverlay(
      SoundPop(isCancel: isCancel, second: second),
      key,
      isAnimate: false,
    );
    Timer(const Duration(seconds: 1), () {
      waveformsModule = Get.find<WaveformsModule>();
    });
    SoundRecording().startRecording((e, err, state) {
      if (state == PlayerStatus.run && e != null) {
        waveformsModule?.add(e.decibels ?? 4);
        second.value = e.duration.inSeconds;
      }
      if (state == PlayerStatus.error) {
        ToastUtils.showToast('录音失败$err');
        moveEnd();
      } else if (state == PlayerStatus.arrivalTime) {
        moveEnd();
      }
    });
  }

  ///滑动结束
  moveEnd() async {
    waveformsModule?.clear();
    OverlayManager().removeOverlay(key);
    SoundResuelt? resuelt = await SoundRecording().stopRecording();
    if (isCancel.value) {
      isCancel.value = false;
      return;
    }
    isCancel.value = false;
    second.value = 0;
    if (resuelt != null) {
      send(resuelt);
    }
  }

  /// 上滑
  moveUpdate(y) {
    dy = y;
    if (dy <= -40) {
      if (isCancel.value == false) {
        isCancel.value = true;
      }
    } else {
      if (isCancel.value == true) {
        isCancel.value = false;
      }
    }
  }

  send(SoundResuelt? soundResuelt) async {
    // 先追加
    if (soundResuelt != null) {
      if (soundResuelt.second <= 1) {
        return ToastUtils.showToast('说话时间太短了', type: 'error');
      }

      String remotePath = "/chat/${widget.chatController.params['friendId']}";

      try {
        // 创建语音消息发送提示
        double progress = 0.0;
        Message progressMsg =
            await OpenImController.msgManager.createCustomMessage(
          data: json.encode({
            "progress": progress,
            'fileName': soundResuelt.url,
            "filePath": soundResuelt.url,
            "type": CusMessageType.process,
          }),
          extension: "",
          description: "语音上传中",
        );
        widget.chatController.addMsg(progressMsg);

        // 上传完再发送
        String resultUrl = await UploadDio.upload(
          soundResuelt.url,
          remotePath: remotePath,
          progressCallback: (count, total) {
            progress = (count / total);
            var newMsg = progressMsg;
            newMsg.customElem!.data = json.encode({
              "progress": progress,
              'filePath': soundResuelt.url,
              'fileName': soundResuelt.url,
              "type": CusMessageType.process,
            });
            widget.chatController.setMsgStatus(
              progressMsg,
              MessageStatus.succeeded,
              newMsg: newMsg,
            );
          },
        );

        Message msg = await OpenImController.msgManager.createSoundMessageByURL(
            soundElem: SoundElem(
          soundPath: soundResuelt.url,
          sourceUrl: resultUrl,
          duration: soundResuelt.second,
        ));
        await widget.chatController.sendMsg(msg, progressMsg: progressMsg);
      } catch (e) {}
      // var data = SendMsgModule({
      //   'content': soundResuelt.toJson(),
      //   'userId': UserInfo.user['userId'],
      //   'friendId': widget.chatController.params['friendId'],
      //   'messageType': MessageType.voice,
      // });
      // widget.chatController.newMsgList.add(data);
      // widget.chatController.toBottom();

      // var content = jsonDecode(data.content);
      // content['url'] = result['url'];
      // data.content = jsonEncode(content);
      // widget.chatController.socket
      //     .sendMessage(SocketEvent.friendMessage, data: data.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        startSound();
      },
      onLongPressEnd: (details) {
        moveEnd();
      },
      onLongPressMoveUpdate: (details) {
        if (details.localPosition.dy < 0) {
          moveUpdate(details.localPosition.dy);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        constraints: BoxConstraints(maxHeight: 120.h, minHeight: 48.h),
        padding: EdgeInsets.only(right: 10.w),
        decoration: BoxDecoration(
          color: HexThemColor(primaryColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                widget.setInputType(true);
              },
              child: SizedBox(
                height: 48.h,
                width: 40.w,
                child: const Icon(
                  IconData(0xe68d, fontFamily: 'micon'),
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: (1.sw / 2 - 50.w - 50)),
            const Text(
              '长按开始说话',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
