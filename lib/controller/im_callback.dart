import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:mall_community/controller/open_im_controller.dart';
import 'package:mall_community/utils/event_bus/event_bus.dart';
import 'package:mall_community/utils/log/log.dart';

enum IMSdkStatus {
  connectionFailed,
  connecting,
  connectionSucceeded,
  syncStart,
  synchronizing,
  syncEnded,
  syncFailed,
}

class IMCallback {
  Function(RevokedInfo info)? onRecvMessageRevoked;

  /// 消息已读回执
  Function(List<ReadReceiptInfo> list)? onRecvC2CReadReceipt;

  /// 群消息已读回执
  Function(List<ReadReceiptInfo> list)? onRecvGroupReadReceipt;

  /// 收到新消息
  Function(Message msg)? onRecvNewMessage;

  /// 发送消息进度
  Function(String msgId, int progress)? onMsgSendProgress;

  /// 黑名单新增
  Function(BlacklistInfo u)? onBlacklistAdd;

  /// 黑名单删除回调
  Function(BlacklistInfo u)? onBlacklistDeleted;

  void imSdkStatus(IMSdkStatus status) {
    OpenImController.status = status;
    EventBus.fire(ImCallbackEvent.imSdkStatus, status);
  }

  ///  登录已过期
  void kickedOffline() {
    EventBus.fire(ImCallbackEvent.kickedOffline);
  }

  /// 被踢下线
  void userTokenExpired() {
    Log.info("当前用户被踢下线");
    EventBus.fire(ImCallbackEvent.userTokenExpired);
  }

  void selfInfoUpdated(UserInfo u) {}

  /// 收到的消息被撤回或自己发出的消息被撤回时，会收到此回调。
  void recvMessageRevoked(RevokedInfo info) {}

  void recvC2CMessageReadReceipt(List<ReadReceiptInfo> list) {}

  /// 自己发出的群聊消息被群成员标记为已读后，消息发送者和标记者均会收到此回调。
  void recvGroupMessageReadReceipt(List<ReadReceiptInfo> list) {
    onRecvGroupReadReceipt?.call(list);
  }

  void recvNewMessage(Message msg) {
    onRecvNewMessage?.call(msg);
  }

  ///自定义业务消息
  void recvCustomBusinessMessage(String s) {}

  void progressCallback(String msgId, int progress) {
    onMsgSendProgress?.call(msgId, progress);
  }

  /// 黑名单新增
  void blacklistAdded(BlacklistInfo u) {
    onBlacklistAdd?.call(u);
  }

  /// 黑名单删除
  void blacklistDeleted(BlacklistInfo u) {
    onBlacklistDeleted?.call(u);
  }

  void friendApplicationAccepted(FriendApplicationInfo u) {
    EventBus.fire(ImCallbackEvent.friendApplicationAccepted, u);
  }

  void friendApplicationAdded(FriendApplicationInfo u) {
    EventBus.fire(ImCallbackEvent.friendApplicationAdded, u);
  }

  void friendApplicationDeleted(FriendApplicationInfo u) {
    EventBus.fire(ImCallbackEvent.friendApplicationDeleted, u);
  }

  void friendApplicationRejected(FriendApplicationInfo u) {
    EventBus.fire(ImCallbackEvent.friendApplicationRejected, u);
  }

  void friendInfoChanged(FriendInfo u) {
    EventBus.fire(ImCallbackEvent.friendInfoChanged, u);
  }

  void friendAdded(FriendInfo u) {
    EventBus.fire(ImCallbackEvent.friendAdded, u);
  }

  void friendDeleted(FriendInfo u) {
    EventBus.fire(ImCallbackEvent.friendDeleted, u);
  }

  void conversationChanged(List<ConversationInfo> list) {
    EventBus.fire(ImCallbackEvent.conversationChanged, list);
  }

  void newConversation(List<ConversationInfo> list) {
    EventBus.fire(ImCallbackEvent.newConversation, list);
  }

  void groupApplicationAccepted(GroupApplicationInfo info) {
    EventBus.fire(ImCallbackEvent.groupApplicationAccepted, info);
  }

  void groupApplicationAdded(GroupApplicationInfo info) {
    EventBus.fire(ImCallbackEvent.groupApplicationAdded, info);
  }

  void groupApplicationDeleted(GroupApplicationInfo info) {
    EventBus.fire(ImCallbackEvent.groupApplicationDeleted, info);
  }

  void groupApplicationRejected(GroupApplicationInfo info) {
    EventBus.fire(ImCallbackEvent.groupApplicationRejected, info);
  }

  void groupInfoChanged(GroupInfo info) {
    EventBus.fire(ImCallbackEvent.groupInfoChanged, info);
  }

  void groupMemberAdded(GroupMembersInfo info) {
    EventBus.fire(ImCallbackEvent.groupMemberAdded, info);
  }

  void groupMemberDeleted(GroupMembersInfo info) {
    EventBus.fire(ImCallbackEvent.groupMemberDeleted, info);
  }

  void groupMemberInfoChanged(GroupMembersInfo info) {
    EventBus.fire(ImCallbackEvent.groupMemberInfoChanged, info);
  }

  void joinedGroupAdded(GroupInfo info) {
    EventBus.fire(ImCallbackEvent.joinedGroupAdded, info);
  }

  void joinedGroupDeleted(GroupInfo info) {
    EventBus.fire(ImCallbackEvent.joinedGroupDeleted, info);
  }

  void totalUnreadMsgCountChanged(int count) {
    EventBus.fire(ImCallbackEvent.totalUnreadMsgCountChanged, count);
  }
}

class ImCallbackEvent {
  /// 被踢下线
  static const String kickedOffline = "kickedOffline";

  /// IM SDK 状态
  static const String imSdkStatus = "imSdkStatus";

  /// 用户 Token 过期
  static const String userTokenExpired = "userTokenExpired";

  /// 自己的信息更新
  static const String selfInfoUpdated = "selfInfoUpdated";

  /// 收到撤回消息
  static const String recvMessageRevoked = "recvMessageRevoked";

  /// 收到 C2C 消息已读回执
  static const String recvC2CMessageReadReceipt = "recvC2CMessageReadReceipt";

  /// 收到群聊消息已读回执
  static const String recvGroupMessageReadReceipt =
      "recvGroupMessageReadReceipt";

  /// 收到新消息
  static const String recvNewMessage = "recvNewMessage";

  /// 收到自定义业务消息
  static const String recvCustomBusinessMessage = "recvCustomBusinessMessage";

  /// 消息发送进度回调
  static const String progressCallback = "progressCallback";

  /// 黑名单新增
  static const String blacklistAdded = "blacklistAdded";

  /// 黑名单删除
  static const String blacklistDeleted = "blacklistDeleted";

  /// 好友申请被接受
  static const String friendApplicationAccepted = "friendApplicationAccepted";

  /// 好友申请新增通知
  static const String friendApplicationAdded = "friendApplicationAdded";

  /// 好友申请被删除
  static const String friendApplicationDeleted = "friendApplicationDeleted";

  /// 好友申请被拒绝
  static const String friendApplicationRejected = "friendApplicationRejected";

  /// 好友资料变更通知
  static const String friendInfoChanged = "friendInfoChanged";

  /// 好友新增通知
  static const String friendAdded = "friendAdded";

  /// 好友删除通知
  static const String friendDeleted = "friendDeleted";

  /// 某些会话发生变化
  static const String conversationChanged = "conversationChanged";

  /// 新会话产生
  static const String newConversation = "newConversation";

  /// 入群申请被同意
  static const String groupApplicationAccepted = "groupApplicationAccepted";

  /// 入群申请新增通知
  static const String groupApplicationAdded = "groupApplicationAdded";

  /// 入群申请被删除
  static const String groupApplicationDeleted = "groupApplicationDeleted";

  /// 入群申请被拒绝
  static const String groupApplicationRejected = "groupApplicationRejected";

  /// 群组信息变更通知
  static const String groupInfoChanged = "groupInfoChanged";

  /// 群成员增加通知
  static const String groupMemberAdded = "groupMemberAdded";

  /// 群成员减少通知
  static const String groupMemberDeleted = "groupMemberDeleted";

  /// 群成员信息变更通知
  static const String groupMemberInfoChanged = "groupMemberInfoChanged";

  /// 用户所在群组数量增加
  static const String joinedGroupAdded = "joinedGroupAdded";

  /// 用户所在群组数量减少
  static const String joinedGroupDeleted = "joinedGroupDeleted";

  /// 未读消息数量发生变化
  static const String totalUnreadMsgCountChanged = "totalUnreadMsgCountChanged";
}
