import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:mall_community/utils/sound_recording/sound_recording.dart';

class VoiceMsg extends StatefulWidget {
  const VoiceMsg({super.key, required this.item, required this.isMy});

  final Message item;
  final bool isMy;

  @override
  State<VoiceMsg> createState() => _VoiceMsgState();
}

class _VoiceMsgState extends State<VoiceMsg> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final SoundElem fileMsgInfo;

  bool isPlay = false;
  play() {
    if (fileMsgInfo.sourceUrl != null) {
      if (isPlay) {
        SoundRecording().stopPlayer();
        _controller.stop();
        setState(() {
          isPlay = false;
        });
        return;
      }
      setState(() {
        isPlay = true;
      });
      _controller.repeat();
      SoundRecording().player(fileMsgInfo.sourceUrl!, (status, {position}) {
        if (status == PlayerStatus.finished) {
          _controller.stop();
          setState(() {
            isPlay = false;
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fileMsgInfo = widget.item.soundElem!;
    _controller = AnimationController(
      vsync: this,
      value: fileMsgInfo.dataSize!.toDouble(),
      duration: const Duration(seconds: 2),
      reverseDuration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      padding: const EdgeInsets.only(right: 10),
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(6)),
      child: Row(
        children: [
          IconButton(
            onPressed: play,
            icon: Icon(
              isPlay
                  ? Icons.pause_circle_filled_rounded
                  : Icons.play_circle_fill_rounded,
              size: 30,
            ),
          ),
          Container(
            width: 80,
            height: 50,
            margin: const EdgeInsets.only(right: 10),
            child: Lottie.asset(
              'lib/assets/lottie/voice.json',
              repeat: true,
              fit: BoxFit.fill,
              controller: _controller,
            ),
          ),
          Text('"${fileMsgInfo.duration}')
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    if (mounted && isPlay) {
      SoundRecording().stopPlayer();
    }
    super.dispose();
  }
}
