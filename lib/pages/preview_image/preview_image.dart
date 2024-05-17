import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:mall_community/components/drag_bottom_dismiss/drag_bottom_pop_sheet.dart';
import 'package:mall_community/components/new_work_image_widget/new_work_image_widget.dart';
import 'package:mall_community/utils/image_picker/image_picker.dart';
import 'package:mall_community/utils/utils.dart';

class PreviewImage extends StatefulWidget {
  const PreviewImage({
    super.key,
    required this.pics,
    this.current = 0,
    this.menus = const [
      {'title': '保存到相册'}
    ],
    this.onLongPressDown,
  });
  final List<Pics> pics;
  final List<Map<String, dynamic>> menus;
  final Function(Map)? onLongPressDown;
  final int current;

  @override
  State<PreviewImage> createState() => _PreviewImage2State();
}

class _PreviewImage2State extends State<PreviewImage> {
  int currentIndex = 0;

  List<String> menus = ['保存到相册'];

  /// 长按
  onLongPressDown() {
    if (menus.isEmpty) return;
    showBottomMenu(widget.menus, (Map? data) {
      if (data != null) {
        widget.onLongPressDown?.call(data);
        switch (data['title']) {
          case '保存到相册':
            saveNetWorkImg(widget.pics[currentIndex].url);
            break;
          default:
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    currentIndex = widget.current;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DragBottomPopGesture(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          onLongPress: onLongPressDown,
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.top,
              bottom: MediaQuery.of(context).viewPadding.bottom,
            ),
            child: PageView.builder(
              itemBuilder: (BuildContext context, int index) {
                Widget image = NetWorkImg(
                  widget.pics[index].url,
                  raduis: 10,
                );
                return Hero(
                  tag: widget.pics[index].key,
                  flightShuttleBuilder: (flightContext, animation,
                      flightDirection, fromHeroContext, toHeroContext) {
                    if (index == currentIndex) return image;
                    return const SizedBox();
                  },
                  child: image,
                );
              },
              itemCount: widget.pics.length,
              onPageChanged: (int index) {
                currentIndex = index;
              },
              controller: PageController(
                initialPage: widget.current,
              ),
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
      ),
    );
  }
}

class Pics {
  late String url;
  late String key;
  late String cover;

  Pics(Map<String, String> json) {
    url = json['url'] ?? "";
    key = json['key'] ?? "";
    cover = json['cover'] ?? "";
  }
}
