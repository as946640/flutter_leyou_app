import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart' as im;
import 'package:get/get.dart';
import 'package:mall_community/components/drag_bottom_dismiss/drag_bottom_dismiss_dialog.dart';
import 'package:mall_community/controller/im_callback.dart';
import 'package:mall_community/controller/open_im_controller.dart';
import 'package:mall_community/modules/user_module.dart';
import 'package:mall_community/pages/chat/controller/msg_controller.dart';
import 'package:mall_community/pages/preview_image/preview_image.dart';
import 'package:mall_community/utils/log/log.dart';

/// 前端自己维护的消息状态
enum CustomMsgStatus {
  /// 发送中
  sending,

  /// 发送成功
  success,

  /// 发送失败
  fail,
}

class ChatController extends GetxController {
  late ChatMsgController msgController;
  ScrollController scrollControll = ScrollController();
  // 工具栏key
  UniqueKey toolBarKey = UniqueKey();
  // 发送框聚焦
  FocusNode textFocusNode = FocusNode();
  // 文本选择聚焦
  FocusNode textSelectFocusNode = FocusNode();
  // 标题
  final title = ''.obs;
  // 是否处于底部
  RxBool isBottom = true.obs;
  // 消息是否超出一屏
  RxBool listRxceed = false.obs;
  // 来电通知key
  UniqueKey callPopKey = UniqueKey();
  // 历史消息
  RxList<im.Message> msgHistoryList = RxList([]);
  Map params = {};
  int lastMinSeq = 0;
  bool isEnd = false;
  final loading = false.obs;

  /// 获取历史消息
  getHistoryMsg() async {
    try {
      loading.value = true;
      im.AdvancedMessage data = await msgController.getHistoryMsg(
        params['sesId'],
        startMsg: msgHistoryList.isEmpty ? null : msgHistoryList.first,
        lastMinSeq: lastMinSeq,
      );
      msgHistoryList.addAll(data.messageList?.reversed ?? []);
      isEnd = data.isEnd ?? false;
      lastMinSeq = data.lastMinSeq ?? 0;
      loading.value = false;
    } finally {
      loading.value = false;
    }
  }

  // 新消息数组
  RxList<im.Message> newMsgList = <im.Message>[].obs;
  // 新消息数量
  RxInt newMsgNums = 0.obs;
  // 引用消息回复消息
  Rx<im.Message?> quoteMsg = Rx<im.Message?>(null);

  /// 发送消息
  Future sendMsg(im.Message msg, {im.Message? progressMsg}) async {
    bool isFileMsg = msg.contentType == im.MessageType.picture ||
        msg.contentType == im.MessageType.video ||
        msg.contentType == im.MessageType.file ||
        msg.contentType == im.MessageType.voice;
    try {
      im.Message newMsg;
      // 是否是文件类消息 文件消息直接替换进度条消息即可
      if (isFileMsg) {
        String type = msg.contentType == im.MessageType.picture ? '图片' : '视频';
        newMsg = await OpenImController.msgManager.sendMessageNotOss(
          message: msg,
          userID: params['friendId'],
          offlinePushInfo: im.OfflinePushInfo(
            title: "$type消息",
            desc: "对方给你发送了$type",
          ),
        );
        setFileMsgStatus(msg, im.MessageStatus.succeeded, progressMsg!);
      } else {
        addMsg(msg);
        newMsg = await msgController.send(msg, params['friendId']);
        setMsgStatus(msg, im.MessageStatus.succeeded, newMsg: newMsg);
      }
    } catch (e) {
      Log.error('发送消息失败$e');
      if (isFileMsg) {
        setFileMsgStatus(msg, im.MessageStatus.failed, progressMsg!);
      } else {
        setMsgStatus(msg, im.MessageStatus.failed, e: e);
      }
    }
  }

  /// 发送文本消息 因为要在很多地方使用到，所以提取出来
  void createTextMsg(String t) async {
    im.Message msg =
        await OpenImController.msgManager.createTextMessage(text: t);
    sendMsg(msg);
  }

  /// 追加消息
  void addMsg(im.Message data) {
    newMsgList.add(data);
    if (isBottom.value) {
      toBottom();
    } else {
      newMsgNums.value += 1;
    }
  }

  /// 消息错误处理

  /// 设置消息状态
  setMsgStatus(
    im.Message message,
    status, {
    Object? e,
    im.Message? newMsg,
  }) async {
    message.status = status;
    if (newMsg != null) {
      message.update(newMsg);
    }
    if (e != null) {
      if (e is PlatformException) {
        int code = int.tryParse(e.code) ?? 0;
        final hintMessage = (await msgController.createHitMessage(code))
          ..status = 2
          ..isRead = true;
        newMsgList.add(hintMessage);
        await msgController.insertLocalMessage(hintMessage, params['friendId']);
      }
    }
    newMsgList.refresh();
  }

  /// 设置文件消息状态 比如图片视频那些
  /// 上传成功 根据消息id 直接替换文件消息
  /// 上传失败 直接更新状态即可
  setFileMsgStatus(im.Message message, status, im.Message progressMsg) {
    int inx = newMsgList
        .indexWhere((item) => item.clientMsgID == progressMsg.clientMsgID);
    im.Message proressMsg = newMsgList[inx];
    if (status == im.MessageStatus.succeeded) {
      if (inx != -1) {
        message.status = status;
        newMsgList[inx] = message;
      }
    } else {
      proressMsg.status = status;
    }
  }

  /// 唤起键盘并且聚焦
  showInput() {
    SystemChannels.textInput.invokeMethod("TextInput.show");
    textFocusNode.requestFocus();
  }

  /// 预览图片
  previewImage(url) async {
    List<Pics> imgs = [];
    List<im.Message> msgList = [...newMsgList, ...msgHistoryList];
    for (var i = 0; i < msgList.length; i++) {
      var item = msgList[i];
      if (item.contentType == im.MessageType.picture) {
        im.PictureElem? imgMsg = item.pictureElem;
        if (imgMsg != null) {
          imgs.add(Pics({
            "url": imgMsg.bigPicture?.url ?? "",
            'key': "${item.clientMsgID}${item.createTime}",
          }));
        }
      }
    }
    int inx = imgs.indexWhere((item) => item.url == url);
    await Navigator.push(
      Get.context!,
      DragBottomDismissDialog(
        builder: (context) {
          return PreviewImage(
            pics: imgs,
            current: inx == -1 ? 0 : inx,
          );
        },
      ),
    );
  }

  onRecvNewMessage(im.Message msg) {
    if (msg.sendID == params['friendId']) {
      addMsg(msg);
    }
  }

  onSyncStatusChanged(IMSdkStatus status) {
    switch (status) {
      case IMSdkStatus.syncStart:
        debugPrint('开始同步');
        break;
      case IMSdkStatus.syncEnded:
        debugPrint('同步结束');
        newMsgList.refresh();
        break;
      case IMSdkStatus.syncFailed:
        debugPrint('同步失败');
        break;
      default:
    }
  }

  initEvent() {
    msgController = ChatMsgController(
      onRecvNewMessage: onRecvNewMessage,
      onSyncStatusChanged: onSyncStatusChanged,
    );
  }

  void closeEvent() {
    msgController.close();
  }

  ///是否是自己
  bool isMy(String userId) {
    return userId == UserInfo.user['userId'];
  }

  /// 滚动到底部
  void toBottom({bool isNext = true}) {
    if (isNext) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        double height = scrollControll.position.maxScrollExtent;
        scrollControll.animateTo(
          height,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    } else {
      double height = scrollControll.position.maxScrollExtent;
      scrollControll.animateTo(
        height,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linearToEaseOut,
      );
    }
  }

  /// 键盘检测
  late StreamSubscription<bool> keyboardSubscription;

  GlobalKey key2 = GlobalKey();

  RxDouble offSet = 0.0.obs;
  GlobalKey listKey = GlobalKey();

  /// 消息列表超出屏幕检测
  checkListExceed() {
    double extentInside = scrollControll.position.extentInside;
    offSet.value = (scrollControll.position.extentBefore) / extentInside;
  }

  /// 列表滚动监听
  _scrollListener() {
    double extentAfter = scrollControll.position.extentAfter;
    double extentBefore = scrollControll.position.extentBefore;
    if (extentBefore == 0) {
      if (!loading.value && lastMinSeq > 0 && !isEnd) {
        getHistoryMsg();
      }
    }

    if (extentAfter > 800 && isBottom.value) {
      isBottom.value = false;
    }
    if (extentAfter <= 0 && !isBottom.value) {
      isBottom.value = true;
    }
  }

  @override
  void onInit() async {
    super.onInit();
    scrollControll.addListener(_scrollListener);
    params = Get.arguments;
    title.value = params['title'];
    initEvent();
    await getHistoryMsg();
  }

  @override
  void onClose() {
    scrollControll.removeListener(_scrollListener);
    closeEvent();
    super.onClose();
  }
}
