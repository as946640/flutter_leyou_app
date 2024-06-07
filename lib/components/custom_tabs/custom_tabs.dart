import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Tabs extends StatelessWidget implements PreferredSizeWidget {
  const Tabs({
    super.key,
    required this.tabs,
    required this.tabController,
    this.change,
    this.labelStyle = const TextStyle(fontSize: 14),
    this.labelColor = Colors.black,
    this.unselectedLabelColor = Colors.black45,
    this.isScrollable = true,
    this.labelPadding = 10,
    this.align = TabAlignment.start,
    this.indicatorColor,
    this.unselectedLabelStyle = const TextStyle(fontSize: 14),
    this.indicator,
  });

  final List tabs;

  /// 是否可滚动
  final bool isScrollable;

  /// 控制器
  final TabController tabController;

  /// 改变回调
  final Function? change;

  /// 文字颜色
  final Color labelColor;

  /// 指示器颜色
  final Color? indicatorColor;

  final Color unselectedLabelColor;

  /// 文字 padding
  final double labelPadding;

  /// 激活文字样式
  final TextStyle? labelStyle;

  /// 未激活文字颜色
  final TextStyle? unselectedLabelStyle;

  /// 对齐方式
  final TabAlignment align;

  /// 指示器样式
  final Decoration? indicator;

  @override
  Size get preferredSize => Size.fromHeight(44.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      width: double.maxFinite,
      color: Colors.transparent,
      child: TabBar(
        controller: tabController,
        labelColor: labelColor,
        indicatorColor: indicatorColor,
        unselectedLabelColor: unselectedLabelColor,
        labelPadding: EdgeInsets.symmetric(horizontal: labelPadding),
        indicatorSize: TabBarIndicatorSize.label,
        isScrollable: isScrollable,
        labelStyle: labelStyle,
        unselectedLabelStyle: unselectedLabelStyle,
        tabAlignment: align,
        indicator: indicator,
        automaticIndicatorColorAdjustment:false,
        dividerColor: Colors.transparent, // 为了去除底部的边框
        tabs: tabs.map((e) => Tab(text: e['text'])).toList(),
      ),
    );
  }
}
