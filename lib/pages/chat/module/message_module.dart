import 'dart:convert';
import 'dart:io';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart' as im;
import 'package:mall_community/modules/user_module.dart';
import 'package:mall_community/pages/chat/controller/chat_controller.dart';

/// Im消息 module
class SendMsgModule {
  /// 消息体
  late String content;

  /// 好友ID
  late String friendId;

  /// 用户ID
  late String userId;

  /// 发送者用户名
  late String userName;

  /// 消息类型
  late String messageType;

  /// 当前时间戳
  int? time;

  /// 消息状态-前端自己维护不上传-用于消息发送状态效果
  CustomMsgStatus? status;

  SendMsgModule(Map json, {SendMsgModule? quote}) {
    messageType = json['messageType'];
    content =
        json['content'] is Map ? jsonEncode(json['content']) : json['content'];
    if (quote != null) {
      content = jsonEncode({'content': content, 'quote': quote.toJson()});
      // messageType = CusMessageType.quote;
    }
    friendId = json['friendId'];
    userId = json['userId'] ?? "";
    userName = json['userName'] ?? "";
    time = json['time'] ?? DateTime.now().millisecondsSinceEpoch;
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'friendId': friendId,
      'userId': userId,
      'messageType': messageType,
      'time': time,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

/// 文件消息信息
class FileMsgInfo {
  /// 文件名
  String? fileName;

  /// 文件大小|录音时长
  late int fileSize;

  ///视频封面
  late String cover;

  ///文件内容或者地址
  late String content;

  FileMsgInfo(dynamic json) {
    if (json is String) {
      content = json;
    } else {
      fileName = json['fileName'] ?? "";
      fileSize = json['fileSize'] ?? json['second'] ?? 0;
      content = json['content'] ?? json['url'] ?? '';
      cover = json['cover'] ?? '';
    }
  }

  toJsonString() {
    return jsonEncode({
      'fileName': fileName,
      'fileSize': fileSize,
      'content': content,
      'cover': cover,
    });
  }
}

/// 引用消息DTO
class QuoteMsgDto extends SendMsgModule {
  late SendMsgModule quote;

  QuoteMsgDto(Map json) : super(json) {
    Map textData = jsonDecode(json['content']);
    content = textData['content'] ?? '';
    quote = SendMsgModule(textData['quote']);
    // messageType = im.MessageType.quote;
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['quote'] = quote.toJson();
    return json;
  }
}

/// 音视频消息
class CallVideoMsg {
  CallVideoMsg(dynamic json) {
    time = json['time'] ?? "";
    status = json['status'] ?? "";
    fromUser = CallVideoUser(
      json["fromUser"] ??
          {
            "nickNmae": UserInfo.user['userName'],
            "avatar": UserInfo.user['avatar'],
            "userId": UserInfo.user['userId'],
          },
    );
    toUserId = json['toUserId'];
    sdpInfo = json['sdpInfo'] ?? "";
    viewId = json['viewId'] ?? "";
    isVideoEnabled = json["isVideoEnabled"] ?? true;
  }

  /// 通话时长
  /// 空代表未接通
  /// 用于通话中挂断电话场景
  late String time;

  /// 通话状态
  late String status;

  /// 发送者信息
  late CallVideoUser fromUser;

  /// 接受者 userId
  late String toUserId;

  /// 音视频 sdp 交换信息
  /// 需要json格式化传递
  late String sdpInfo;

  /// webrtcView id
  late String viewId;

  /// 发送者的视频画面状态
  /// false 关闭
  /// true 开启
  late bool isVideoEnabled;

  Map toMap() {
    return {
      'time': time,
      'status': status,
      'fromUser': fromUser.toMap(),
      'toUserId': toUserId,
      'sdpInfo': sdpInfo,
      'viewId': viewId,
      'isVideoEnabled': isVideoEnabled,
    };
  }
}

class CallVideoUser {
  CallVideoUser(dynamic json) {
    nickNmae = json['nickNmae'] ?? "";
    avatar = json['avatar'] ?? "";
    userId = json['userId'] ?? "";
  }
  late String nickNmae;
  late String avatar;
  late String userId;

  toMap() {
    return {
      "nickNmae": nickNmae,
      "avatar": avatar,
      "userId": userId,
    };
  }
}

/// 音视频ICE候选人交换信息
class CallIceCandidate {
  CallIceCandidate(Map map) {
    toUserId = map['toUserId'] ?? "";
    candidate = map['iceData'] ?? "";
  }

  /// 接听方 userId
  late String toUserId;

  /// ice 信息 json处理过
  late String candidate;

  toMap() {
    return {"toUserId": toUserId, "candidate": candidate};
  }
}

/// IM 自定义消息类型
class CusMessageType {
  // 自定义消息 进度条消息
  static const process = 200;
}
