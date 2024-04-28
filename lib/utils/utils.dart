import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/drag_bottom_dismiss/drag_bottom_dismiss_dialog.dart';
import 'package:mall_community/pages/preview_video/preview_video.dart';
import 'package:mall_community/utils/toast/toast.dart';

/// 是否生产模式
bool isProduction() {
  return kReleaseMode;
}

/// 底部弹窗菜单选择
showBottomMenu(List<Map<String, dynamic>> list, Function(Map?) callback) {
  showModalBottomSheet(
    context: Get.context!,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
          padding: const EdgeInsets.only(top: 4),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...list.map(
                  (e) => InkWell(
                    onTap: () {
                      Get.back();
                      callback.call(e);
                    },
                    child: Container(
                      height: 55,
                      alignment: Alignment.center,
                      child: Text(e['title'], style: tx16),
                    ),
                  ),
                ),
                const Divider(
                  thickness: 8,
                  color: Color.fromRGBO(241, 241, 241, 1),
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                    callback.call(null);
                  },
                  child: Container(
                    height: 55,
                    alignment: Alignment.center,
                    child: Text('取消', style: tx16),
                  ),
                ),
              ],
            ),
          ));
    },
  );
}

///获取当前 widget 的size信息
Size? getWidgetSize(GlobalKey key) {
  final RenderBox box = key.currentContext?.findRenderObject() as dynamic;
  return box.size;
}

/// 获取当前 widget Rect 信息
Rect? getRect(GlobalKey key) {
  final currentContext = key.currentContext;
  final renderBox = currentContext?.findRenderObject() as RenderBox?;
  if (renderBox == null) return null;
  final offset = renderBox.localToGlobal(renderBox.paintBounds.topLeft);
  return offset & renderBox.paintBounds.size;
}

///复制文本
Future<void> copyText(String tx) async {
  try {
    await Clipboard.setData(ClipboardData(text: tx));
  } catch (e) {
    ToastUtils.showToast('复制出错', position: 'bottom');
  }
}

///视频预览
Future previewVideo(BuildContext context,
    {required String url, required String cover}) async {
  var result = await Navigator.push(
    context,
    DragBottomDismissDialog(
      builder: (context) {
        return PreviewVideo(
          url: url,
          cover: cover,
        );
      },
    ),
  );
  return result;
}
