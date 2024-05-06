import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:mall_community/controller/global_base_socket.dart';
import 'package:mall_community/modules/user_module.dart';
import 'package:mall_community/pages/chat/module/message_module.dart';
import 'package:mall_community/pages/chat/module/message_module.dart'
    as MsgType;
import 'package:mall_community/pages/chat/pages/call_video/components/scale_call_video.dart';
import 'package:mall_community/utils/event_bus/event_bus.dart';
import 'package:mall_community/utils/log/log.dart';
import 'package:mall_community/utils/overlay_manager/overlay_manager.dart';
import 'package:mall_community/utils/socket/socket_event.dart';
import 'package:mall_community/utils/toast/toast.dart';
import 'package:mall_community/utils/web_rtc/web_rtc_controller.dart';

/// 音视频通话界面控制器
class CallVideoController extends GetxController {
  late BaseSocket chatController;
  late dynamic params;
  late String callTimeTx = "";
  bool isConnect = false;
  late CallVideoUser friendInfo;
  late WebRtcController webRtcController;

  /// 本地 WebRtcView
  String viewId = UniqueKey().toString();
  WebRtcView? view;

  ///好友 WebRtcView
  String toViewId = UniqueKey().toString();
  WebRtcView? toView;
  UniqueKey popId = UniqueKey();

  void startWebRtc(BuildContext context) async {
    try {
      params = Get.arguments;
      if (params == null || params['friendId'] == null) {
        return;
      }
      friendInfo = CallVideoUser({
        "nickName": params["userName"],
        "userId": params["friendId"],
        "avatar": params["avatar"],
      });
      chatController = Get.find<BaseSocket>();
      view = await webRtcController.createdView(viewId, true);
      view!.isVideoEnabled.value = true;
      toView = await webRtcController.createdView(toViewId, false);
      update();
      initSocket();

      // 手动拨打才发信息
      if (params['sdpInfoData'] == null) {
        msgSend(
            CallVideoMsg({
              "toUserId": params['friendId'],
              "status": SocketEvent.callPhone,
            }).toMap(),
            SocketEvent.callPhone);
      } else {
        // 接听放告诉对方 我已经接听 可以开始 链接
        msgSend(
          CallVideoMsg({"toUserId": params['friendId']}).toMap(),
          SocketEvent.answerPhone,
        );
      }
    } catch (e) {
      ToastUtils.showToast("创建音视频错误：${e.toString()}");
      Log.error("创建音视频错误", e);
    }
  }

  /// 结束通话
  void stopWebRtc({bool manual = true}) {
    toView!.viewRenderer.srcObject = null;
    view!.viewRenderer.srcObject = null;
    webRtcController.dispose();
    closeEvent();
    if (manual) {
      Map msg = CallVideoMsg({
        "toUserId": params['friendId'],
        "time": callTimeTx,
        "status": SocketEvent.hangUpPhone,
      }).toMap();
      msgSend(msg, SocketEvent.hangUpPhone);
      chatController.sendMsg(
        jsonEncode(msg),
        toUserId: params['friendId'],
        // type: CusMessageType.,
      );
    }
    Get.back();
  }

  /// 视频画面关闭
  void sendCameraClose(bool isVideoEnabled) {
    CallVideoMsg msg = CallVideoMsg({
      'toUserId': params['friendId'],
      "viewId": viewId,
      "isVideoEnabled": isVideoEnabled
    });
    msgSend(msg.toMap(), SocketEvent.cameraClose);
  }

  /// 创建 offer 发送
  void _createOffer() async {
    try {
      RTCSessionDescription s = await webRtcController.createOffer(view!.pc!);
      // 发送 offer
      msgSend({
        'toUserId': params['friendId'],
        'nickName': UserInfo.user['userName'],
        'description': {'sdp': s.sdp, 'type': s.type},
      }, SocketEvent.rtcOffer);
    } catch (e) {
      Log.error("创建 webrtc offer 错误 $e");
    }
  }

  /// 创建 answer 发送
  void _createAnswer() async {
    try {
      RTCSessionDescription s = await webRtcController.createAnswer(view!.pc!);
      msgSend({
        'toUserId': params["friendId"],
        'nickName': UserInfo.user['userName'],
        'description': {'sdp': s.sdp, 'type': s.type},
      }, SocketEvent.rtcAnswer);
    } catch (e) {
      Log.error("创建 webrtc answer 错误 $e");
    }
  }

  /// 消息发送
  void msgSend(Map params, String msgType) {
    chatController.socket.sendMessage(msgType, data: params);
  }

  /// 对方发送 offer
  offerEvent(data) async {
    Map msg = data['data'];
    if (UserInfo.isMy(msg["toUserId"])) {
      var des = msg['description'];
      await webRtcController.createPreConnect(view!);
      await view?.pc?.setRemoteDescription(
          RTCSessionDescription(des['sdp'], des['type']));
      if (view?.remoteCandidates != null && view!.remoteCandidates.isNotEmpty) {
        for (var candidate in view!.remoteCandidates) {
          await view!.pc!.addCandidate(candidate);
        }
        view!.remoteCandidates.clear();
      }
      // 同时发送 answer 给对方
      _createAnswer();
    }
  }

  ///对方发送 answer
  answerEvent(data) {
    Map msg = data['data'];
    if (UserInfo.isMy(msg["toUserId"])) {
      var des = msg['description'];
      view?.pc?.setRemoteDescription(
          RTCSessionDescription(des['sdp'], des['type']));
    }
  }

  ///对方发送 ice 候选人
  onIceCandidateEvent(data) async {
    Map msg = data['data'];
    if (UserInfo.isMy(msg["toUserId"])) {
      var candidateMap = msg['candidate'];
      RTCIceCandidate candidate = RTCIceCandidate(candidateMap['candidate'],
          candidateMap['sdpMid'], candidateMap['sdpMLineIndex']);
      if (view?.pc != null) {
        await view?.pc?.addCandidate(candidate);
      } else {
        view?.remoteCandidates.add(candidate);
      }
    }
  }

  /// 对方接听电话
  answerPhoneEvent(data) {
    // 延迟一下发送 offer 对方进入页面需要花时间
    CallVideoMsg msg = CallVideoMsg(data['data']);
    if (msg.toUserId == UserInfo.user['userId']) {
      Future.delayed(const Duration(seconds: 1), () {
        _createOffer();
      });
    }
    isConnect = true;
    update();
  }

  /// 对方拒接
  void rejectPhoneEvent(data) {
    stopWebRtc(manual: false);
  }

  // 电话挂断
  hangUpPhoneEvent(data) {
    if (UserInfo.isMy(data['toUserId'])) {
      stopWebRtc(manual: false);
    }
  }

  /// 对方关闭摄像头 通过 传递的 viewId 更新
  void cameraCloseEvent(data) {
    CallVideoMsg msg = CallVideoMsg(data['data']);
    if (UserInfo.isMy(msg.toUserId)) {
      WebRtcView? view = webRtcController.getView(msg.viewId);
      if (view != null) {
        view.isVideoEnabled.value = msg.isVideoEnabled;
      }
    }
  }

  void initSocket() {
    chatController.socket.subscribe(SocketEvent.answerPhone, answerPhoneEvent);
    chatController.socket.subscribe(SocketEvent.rejectPhone, rejectPhoneEvent);
    chatController.socket.subscribe(SocketEvent.rtcAnswer, answerEvent);
    chatController.socket.subscribe(SocketEvent.rtcOffer, offerEvent);
    chatController.socket.subscribe(SocketEvent.cameraClose, cameraCloseEvent);
    chatController.socket
        .subscribe(SocketEvent.iceCandidate, onIceCandidateEvent);
    EventBus.on(SocketEvent.hangUpPhone, hangUpPhoneEvent);
  }

  void closeEvent() {
    chatController.socket.unSubscribe(SocketEvent.answerPhone);
    chatController.socket.unSubscribe(SocketEvent.rejectPhone);
    chatController.socket.unSubscribe(SocketEvent.iceCandidate);
    chatController.socket.unSubscribe(SocketEvent.rtcOffer);
    chatController.socket.unSubscribe(SocketEvent.rtcAnswer);
    chatController.socket.unSubscribe(SocketEvent.cameraClose);
    EventBus.off(SocketEvent.hangUpPhone, hangUpPhoneEvent);
  }

  /// webrtc ice 候选人回调
  void onIceCandidate(RTCIceCandidate candidate) {
    msgSend({
      'toUserId': params["friendId"],
      'nickName': UserInfo.user['userName'],
      'candidate': {
        'sdpMLineIndex': candidate.sdpMLineIndex,
        'sdpMid': candidate.sdpMid,
        'candidate': candidate.candidate,
      },
    }, SocketEvent.iceCandidate);
  }

  /// 远程视频可用
  void onRemoteAddStream(MediaStream stream) {
    toView?.viewRenderer.srcObject = stream;
    update();
  }

  /// 远程视频不可用
  void onRemoveStream(MediaStream stream) {
    toView?.pc?.dispose();
    toView?.viewRenderer.srcObject = null;
    toView = null;
  }

  /// 重新赋值 控制器 数据
  /// 比如从别的地方跳转回来 此时需要通过 update 刷新
  void setConnteroll(CallVideoController ctx) {
    update();
  }

  ///缩放展示
  scalelVideo() {
    OverlayManager().showOverlay(
      ScaleCallVideo(
        popKey: popId,
        callVideoController: this,
      ),
      popId,
    );
    Get.back(result: null);
  }
}
