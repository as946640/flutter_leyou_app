import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:mall_community/common/comm_style.dart';

class AppTheme {
  static setThemeMode(ThemeMode mode) {
    AppTheme.mode = mode;
    Get.changeThemeMode(mode);
  }

  static ThemeMode mode = ThemeMode.light;

  /// 通用大小 标题栏icon
  static IconThemeData appBarIconThem = IconThemeData(
    color: Colors.white,
    size: 24.sp,
  );

  /// 黑色
  static final darkTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(
      background: Colors.white,
      brightness: Brightness.light,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: AppBarTheme(
      color: primaryNavColor,
      titleTextStyle: TextStyle(fontSize: 16.sp, color: primaryTextC),
      shadowColor: Colors.transparent,
      iconTheme: IconThemeData(
        color: primaryTextC,
        size: 24.sp,
      ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: primaryTextC),
      labelLarge: TextStyle(color: warningColor),
    ),
    textButtonTheme: const TextButtonThemeData(),
  );

  /// 橙色
  static final primaryTheme = ThemeData(
    useMaterial3: false,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.light(
      background: Colors.white,
      brightness: Brightness.light,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    splashColor: backgroundColor, // 点击水波纹的颜色
    appBarTheme: AppBarTheme(
      color: Colors.white,
      titleTextStyle: TextStyle(fontSize: 16.sp,color: primaryTextC),
      shadowColor: Colors.transparent,
      iconTheme: appBarIconThem.copyWith(color: primaryTextC),
      scrolledUnderElevation: 0,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: primaryTextC),
    ),
    textButtonTheme: const TextButtonThemeData(
      style: ButtonStyle(),
    ),
    bottomAppBarTheme: const BottomAppBarTheme(),
  );
}
