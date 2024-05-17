import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mall_community/common/comm_style.dart';

class ImFileProgress extends StatefulWidget {
  final double progress;
  final Message item;

  const ImFileProgress({super.key, required this.progress, required this.item});

  @override
  State<ImFileProgress> createState() => _ImFileProgressState();
}

class _ImFileProgressState extends State<ImFileProgress> {
  double _progress = 0;

  /// 监听 progress 变化
  @override
  void didUpdateWidget(covariant ImFileProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      setState(() {
        _progress = widget.progress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = jsonDecode(widget.item.customElem?.data ?? "{}");
    String filePath = data['filePath'] ?? "";
    String fileName = data['fileName'] ?? '';
    return Container(
        constraints: BoxConstraints(
          maxWidth: 160.r,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // if (fileName.isEmpty) Image.asset(filePath),
            buildBackdropFilter(),
          ],
        ));
  }

  BackdropFilter buildBackdropFilter() {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 2,
        sigmaY: 2,
      ),
      child: Container(
          padding: const EdgeInsets.all(10),
          constraints: BoxConstraints(
            maxWidth: 160.r,
          ),
          alignment: Alignment.center,
          child: Column(
            children: [
              CircularProgressIndicator(
                strokeWidth: 4,
                value: _progress,
                strokeCap: StrokeCap.round,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              Text(
                widget.item.customElem?.description ?? "",
                style: tx14.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          )),
    );
  }
}
