import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mall_community/common/theme.dart';

/// 常用字体大小
TextStyle tx10 = const TextStyle(fontSize: 10);
TextStyle tx12 = const TextStyle(fontSize: 12);
TextStyle tx14 = const TextStyle(fontSize: 14);
TextStyle tx16 = const TextStyle(fontSize: 16);
TextStyle tx18 = const TextStyle(fontSize: 18);
TextStyle tx20 = const TextStyle(fontSize: 20);
TextStyle tx22 = const TextStyle(fontSize: 22);

/**
 * 系统主题色
 * */
///主题色
Color primaryColor = HexColor("#A593E0");

/// 导航栏颜色
Color primaryNavColor = HexColor("#D1B6E1");

/// 成功
Color successColor = HexColor("#5CAB7D");

/// 错误
Color errorColor = HexColor("#F16B6F");

/// 警告
Color warningColor = HexColor("#ffc952");

/// info
Color infoColor = HexColor("#a3a1a1");

/// 背景色
Color backgroundColor = HexColor("#f3f4f6");

/// 边框颜色
Color borderColor = HexColor("#e4e7ed");

/**
 * 常用文字颜色
 * */
/// 主要文字颜色
Color primaryTextC = HexColor("#303133");

/// 常规文字颜色
Color routineTextC = HexColor("#606266");

/// 次要文字颜色
Color secondaryTextC = HexColor("#909399");

/// 占位文字颜色
Color placeholderTextC = HexColor("#e3dede");

/// 常用颜色
Color cCcc = HexColor('#cccccc');
Color c666 = HexColor('#666666');
Color cEe4c3d = HexColor('#ee4c3d');
Color c333 = HexColor("#333333");
Color c999 = HexColor("#999999");
Color cF1f1f1 = HexColor("#f1f1f1");
Color c898989 = HexColor("#898989");
Color cAaaaaa = HexColor("#aaaaaa");
Color darkColor = HexColor("#1c1b1f");

///Hex转换函数

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

///配合 Color 跳转明暗  兼容黑暗模式
class HexThemColor extends Color {
  static int _getColorFromHex(Color color, int brightnessDirection) {
    int parsedColor = color.value;
    if (AppTheme.mode == ThemeMode.dark) {
      int brightness = 50;
      // 提取ARGB通道的值
      int alpha = (parsedColor >> 24) & 0xFF;
      int red = (parsedColor >> 16) & 0xFF;
      int green = (parsedColor >> 8) & 0xFF;
      int blue = parsedColor & 0xFF;
      // 根据亮度和黑暗模式状态调整颜色的每个通道
      red = (red + brightness * brightnessDirection).clamp(0, 255);
      green = (green + brightness * brightnessDirection).clamp(0, 255);
      blue = (blue + brightness * brightnessDirection).clamp(0, 255);
      // 组合新的颜色代码
      parsedColor = (alpha << 24) | (red << 16) | (green << 8) | blue;
    }
    return parsedColor;
  }

  HexThemColor(final Color color, {int direction = 1})
      : super(_getColorFromHex(color, direction));
}

/// 获取一个随机颜色
Color getRandomColor() {
  Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}
