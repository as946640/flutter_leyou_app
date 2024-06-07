import 'package:flutter/material.dart';
import 'package:mall_community/common/app_config.dart';
import 'package:mall_community/components/new_work_image_widget/new_work_image_widget.dart';

/// 天气icon 根据当前城市
class WeatherIcon extends StatelessWidget {
  WeatherIcon({super.key, this.size = 40});
  final double size;
  final Map data = {
    "晴": "qing",
    "太阳": "taiyang",
    "乌云": "wuyun",
    "乌云下雨": "wuyun_xiayu",
  };
  final String current = "乌云下雨";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: NetWorkImg("${AppConfig.qiniuPath}app/weather_icon/${data[current]}.png"),
    );
  }
}
