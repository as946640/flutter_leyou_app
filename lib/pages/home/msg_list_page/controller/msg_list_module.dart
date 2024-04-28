import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:mall_community/api/chat/chat.dart';
import 'package:mall_community/components/not_data/not_data.dart';
import 'package:mall_community/controller/im_callback.dart';
import 'package:mall_community/controller/open_im_controller.dart';
import 'package:mall_community/utils/event_bus/event_bus.dart';

/// 好友和群数据module
class MsgListModule extends GetxController {
  final StreamController streamController = StreamController();
  final loading = false.obs;

  Future<int> getData(Future<int> Function() fetch) async {
    if (OpenImController.status == IMSdkStatus.connectionSucceeded) {
      return await fetch();
    } else if (OpenImController.status == IMSdkStatus.connectionFailed) {
      return NetWorkDataStatus.notError;
    } else {
      return NetWorkDataStatus.notLoading;
    }
  }

  ///好友消息列表
  RxList<ConversationInfo> msgList = RxList<ConversationInfo>([]);
  Map<String, dynamic> params = {'page': 0};
  Future<int> getMsgList() async {
    return getData(() async {
      List<ConversationInfo> list = await OpenImController.getConversationList(
        page: params['page'],
      );
      if (list.isEmpty) {
        return NetWorkDataStatus.notMoreData;
      }
      msgList.addAll(list);
      return NetWorkDataStatus.loadingOK;
    });
  }

  ///好友列表
  RxList<FullUserInfo> friends = RxList();
  Future<int> getFriends() async {
    return getData(() async {
      List<FullUserInfo> list = await OpenImController.getFriendList();
      if (list.isEmpty) {
        return NetWorkDataStatus.notData;
      }
      friends.addAll(list);
      return NetWorkDataStatus.loadingOK;
    });
  }

  ///群列表
  RxList<GroupInfo> groups = RxList<GroupInfo>();
  Future<int> getGroups() async {
    return getData(() async {
      List<GroupInfo> list = await OpenImController.getJoinedGroupList();
      if (list.isEmpty) {
        return NetWorkDataStatus.notData;
      }
      groups.addAll(list);
      return NetWorkDataStatus.loadingOK;
    });
  }

  // 加载更多
  late EasyRefreshController easyRefreshController;
  getMore() async {
    // if (result.data['list'].length == 0 || result.data['list'].length < 10) {
    //   easyRefreshController.finishLoad(IndicatorResult.noMore);
    // } else {
    //   easyRefreshController.finishLoad(IndicatorResult.success);
    // }
  }

  toChat(user) {
    Get.toNamed('/chat', arguments: {
      'userId': user['userId'],
      'avatar': user['avatar'],
      'userName': user['userName'],
    });
  }

  // im sdk状态
  imStatusChange(status) {
    if (status == IMSdkStatus.connectionSucceeded) {
      streamController.add('refresh');
    }
  }

  // 会话更新
  onConversationChanged(List<ConversationInfo> list) {
    for (var item in list) {
      int inx = msgList.indexWhere(
        (element) => element.conversationID == item.conversationID,
      );
      if (inx != -1) {
        msgList[inx] = item;
      } else {
        msgList.add(item);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    EventBus.on(ImCallbackEvent.imSdkStatus, imStatusChange);
    EventBus.on(ImCallbackEvent.conversationChanged, onConversationChanged);
  }

  @override
  void onClose() {
    streamController.close();
    EventBus.off(ImCallbackEvent.imSdkStatus, imStatusChange);
    EventBus.off(ImCallbackEvent.imSdkStatus, onConversationChanged);
    super.onClose();
  }
}
