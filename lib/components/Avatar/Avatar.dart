import 'package:flutter/material.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/new_work_image_widget/new_work_image_widget.dart';

/// 头显组件 src 和 srcs 必须传递一个
class MyAvatar extends StatelessWidget {
  const MyAvatar(
      {super.key,
      this.src,
      this.srcs,
      this.color,
      this.radius = 4,
      this.size = 40,
      this.nums = '',
      this.borderWidth = 0});

  final String? src;
  final List<String>? srcs;
  final double radius;
  final Color? color;
  final double size;
  final String nums;
  final int borderWidth;

  @override
  Widget build(BuildContext context) {
    if (src == null && srcs == null) {
      return const SizedBox();
    }
    return srcs != null && srcs!.isNotEmpty ? buildItems() : buildItem(src!);
  }

  Widget buildItem(String url) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.topRight,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: NetWorkImg(
              url,
              raduis: radius,
              width: size - borderWidth,
              height: size - borderWidth,
              fit: BoxFit.cover,
            ),
          ),
          nums.isEmpty == true
              ? const SizedBox()
              : Positioned(
                  top: -2,
                  right: -2,
                  child: Badge(
                    backgroundColor: successColor,
                  ),
                )
        ],
      ),
    );
  }

  Widget buildItems() {
    return SizedBox(
      height: size + 4,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: List.generate(
          srcs!.length,
          (i) => Positioned(
            left: i * (size / 1.5),
            child: buildItem(srcs![i]),
          ),
        ),
      ),
    );
  }
}
