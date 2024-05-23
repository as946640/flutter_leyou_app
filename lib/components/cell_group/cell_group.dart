import 'package:flutter/widgets.dart';
import 'cell_item.dart';

class CellGroup extends StatelessWidget {
  final List<CellModule> list;

  const CellGroup({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        list.length,
        (i) => CellItem(
          i: i,
          item: list[i],
          borderRadius: list.length > 1 ? 0 : 10,
          bottomBorder: i == list.length - 1,
        ),
      ),
    );
  }
}

class CellModule {
  /// 标题
  late String title;

  /// 副标题
  late String? subTitle;

  /// 末尾是否展示箭头指示
  late bool showArrow;

  /// 点击回调
  late Function(CellModule)? callback;

  /// 列表前缀 widget
  late Widget? leading;

  /// 列表后缀widget 不存在就展示箭头
  late Widget? trailing;

  CellModule(Map<String, dynamic> json) {
    title = json['title'] ?? "";
    subTitle = json['subTitle'];
    leading = json['leading'];
    trailing = json['trailing'];
    showArrow = json['showArrow'] ?? true;
    callback = json['callback'];
  }
}
