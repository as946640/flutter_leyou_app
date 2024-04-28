import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:mall_community/common/app_config.dart';
import 'package:mall_community/pages/chat/api/auth.dart';
import 'package:mall_community/utils/log/log.dart';
import 'package:mall_community/utils/request/dio_response.dart';
import 'package:mall_community/utils/storage.dart';
import 'package:path_provider/path_provider.dart';
import './im_callback.dart';

/// openim 第三方sdk控制器
class OpenImController extends IMCallback {
  static OpenImController? _instance;

  factory OpenImController() {
    _instance ??= OpenImController._internal();
    return _instance!;
  }

  OpenImController._internal();

  /// sdk 初始化状态
  static IMSdkStatus status = IMSdkStatus.connecting;

  ///初始化
  Future<dynamic> init() async {
    if (kDebugMode) {
      unInitSDK();
    }
    String path = (await getApplicationDocumentsDirectory()).path;
    final success = await OpenIM.iMManager.initSDK(
      platformID: _getPlatformID(),
      apiAddr: AppConfig.openApi,
      wsAddr: AppConfig.openChatWss,
      dataDir: path, // 数据存储路径
      logFilePath: path,
      listener: OnConnectListener(
        onConnectSuccess: () {
          Log.debug("ImServer 连接成功");
          imSdkStatus(IMSdkStatus.connectionSucceeded);
        },
        onConnecting: () {
          Log.debug("ImServer  正在连接到服务器");
          imSdkStatus(IMSdkStatus.connecting);
        },
        onConnectFailed: (code, errorMsg) {
          Log.debug("ImServer  连接服务器失败");
          imSdkStatus(IMSdkStatus.connectionFailed);
        },
        onKickedOffline: kickedOffline,
        onUserTokenExpired: userTokenExpired,
      ),
    );
    Log.debug("im init $success");
    if (success) {
      OpenIM.iMManager
        ..userManager.setUserListener(OnUserListener())
        // 消息监听
        ..messageManager.setAdvancedMsgListener(OnAdvancedMsgListener(
          onRecvC2CReadReceipt: onRecvC2CReadReceipt,
          onRecvNewMessage: onRecvNewMessage,
          onNewRecvMessageRevoked: recvMessageRevoked,
        ))
        ..messageManager.setMsgSendProgressListener(OnMsgSendProgressListener(
          onProgress: progressCallback,
        ))
        ..messageManager.setCustomBusinessListener(OnCustomBusinessListener(
          onRecvCustomBusinessMessage: recvCustomBusinessMessage,
        ))
        // 关系链监听
        ..friendshipManager.setFriendshipListener(OnFriendshipListener(
          onBlackAdded: blacklistAdded,
          onBlackDeleted: blacklistDeleted,
          onFriendApplicationAccepted: friendApplicationAccepted,
          onFriendApplicationAdded: friendApplicationAdded,
          onFriendApplicationDeleted: friendApplicationDeleted,
          onFriendApplicationRejected: friendApplicationRejected,
          onFriendInfoChanged: friendInfoChanged,
          onFriendAdded: friendAdded,
          onFriendDeleted: friendDeleted,
        ))
        // 会话监听
        ..conversationManager.setConversationListener(OnConversationListener(
          onConversationChanged: conversationChanged,
          onNewConversation: newConversation,
          onTotalUnreadMessageCountChanged: totalUnreadMsgCountChanged,
          onSyncServerFailed: () {
            // imSdkStatus(IMSdkStatus.syncFailed);
          },
          onSyncServerFinish: () {
            // imSdkStatus(IMSdkStatus.syncEnded);
          },
          onSyncServerStart: () {
            // imSdkStatus(IMSdkStatus.syncStart);
          },
        ))
        // 群组监听
        ..groupManager.setGroupListener(OnGroupListener(
          onGroupApplicationAccepted: groupApplicationAccepted,
          onGroupApplicationAdded: groupApplicationAdded,
          onGroupApplicationDeleted: groupApplicationDeleted,
          onGroupApplicationRejected: groupApplicationRejected,
          onGroupInfoChanged: groupInfoChanged,
          onGroupMemberAdded: groupMemberAdded,
          onGroupMemberDeleted: groupMemberDeleted,
          onGroupMemberInfoChanged: groupMemberInfoChanged,
          onJoinedGroupAdded: joinedGroupAdded,
          onJoinedGroupDeleted: joinedGroupDeleted,
        ));
    }
    // EventBus.fire(eventName);
    return success;
  }

  ///登录
  static Future<UserInfo?> login(String userId) async {
    try {
      ApiResponse<Map> res = await reqOpenImToken({
        'secret': AppConfig.openImSecret,
        'platformID': _getPlatformID(),
        'userID': userId,
      });
      if (res.data.containsKey('token')) {
        Storage().write('openImToken', res.data['token']);
        UserInfo userInfo = await OpenIM.iMManager.login(
          userID: userId,
          token: res.data['token'],
        );
        Log.debug("im 登录成功");
        return userInfo;
      }
      return null;
    } catch (e) {
      Log.error('im 登录错误：${e.toString()}');
      return null;
    }
  }

  /// 获取会话列表 分页形式
  static Future<List<ConversationInfo>> getConversationList({
    int page = 1,
    int size = 20,
  }) async {
    return await OpenIM.iMManager.conversationManager
        .getConversationListSplit(offset: page, count: size);
  }

  /// 获取已加入的群组
  static Future<List<GroupInfo>> getJoinedGroupList() async {
    return await OpenIM.iMManager.groupManager.getJoinedGroupList();
  }

  /// 好友列表
  static Future<List<FullUserInfo>> getFriendList() async {
    return await OpenIM.iMManager.friendshipManager.getFriendList();
  }

  /// 销毁 反初始化 这样就可以继续初始化新的链接
  static unInitSDK() {
    OpenIM.iMManager.unInitSDK();
  }

  static int _getPlatformID() {
    switch (Platform.operatingSystem) {
      case "ios":
        return IMPlatform.ios;
      default:
        return IMPlatform.android;
    }
  }
}
