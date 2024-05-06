import 'dart:convert';
import 'dart:math';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:mall_community/controller/im_callback.dart';
import 'package:mall_community/controller/open_im_controller.dart';
import 'package:mall_community/utils/event_bus/event_bus.dart';

/// 好友聊天消息控制器
class ChatMsgController {
  ChatMsgController({
    required Function(Message message) onRecvNewMessage,
    Function(String msgId, int progress)? onMsgSendProgress,
    required Function onSyncStatusChanged,
  }) {
    /// 接收到新消息
    OpenImController().onRecvNewMessage = onRecvNewMessage;

    /// 发送消息进度
    OpenImController().onMsgSendProgress = onMsgSendProgress;

    /// 同步会话状态变更
    _onSyncStatusChanged = onSyncStatusChanged;
    EventBus.on(ImCallbackEvent.imSdkStatus, _onSyncStatusChanged);
  }

  /// 消息发送 userId 为接收方id
  send(Message msg, String userId) async {
    return OpenImController.msgManager.sendMessage(
      message: msg,
      userID: userId,
      offlinePushInfo: OfflinePushInfo(
        desc: '您有一条新消息',
        title: '新消息',
      ),
    );
  }

  /// 创建hit消息
  Future<Message> createHitMessage(
    int code, {
    String extension = "",
    String description = "",
  }) async {
    return OpenImController.msgManager.createCustomMessage(
      data: json.encode({
        'code': code,
        'data': {},
      }),
      extension: extension,
      description: description,
    );
  }

  /// 获取历史消息
  Future<AdvancedMessage> getHistoryMsg(
    String conversationID, {
    Message? startMsg,
    int? lastMinSeq,
    int? count = 15,
    String? operationID,
  }) async {
    return await OpenImController.iMManager.messageManager
        .getAdvancedHistoryMessageList(
      conversationID: conversationID,
      startMsg: startMsg,
      lastMinSeq: lastMinSeq,
      count: count,
      operationID: operationID,
    );
  }

  /// 本地插入一条消息
  Future<Message> insertLocalMessage(Message msg, receiverID) async {
    return OpenImController.msgManager.insertSingleMessageToLocalStorage(
      message: msg,
      receiverID: receiverID,
      senderID: OpenImController.iMManager.userID,
    );
  }

  late Function _onSyncStatusChanged;

  close() {
    EventBus.off(ImCallbackEvent.imSdkStatus, _onSyncStatusChanged);
  }
}
