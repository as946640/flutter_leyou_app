import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/weather_icon/weather_icon.dart';
import 'package:mall_community/pages/home/home_page/components/ball_view.dart';
import 'package:mall_community/pages/home/home_page/controller/home_module.dart';

class HomeNavBar extends StatelessWidget {
  final double shrinkOffset;
  final HomeController homeController;
  
  HomeNavBar({
    super.key,
    required this.shrinkOffset,
    required this.homeController,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryData size = MediaQuery.of(context);
    double height = 60 + size.padding.top;
    double opacity = shrinkOffset / height > 1 ? 1 : shrinkOffset / height;
    return Column(
      children: [
        Container(
          height: height,
          width: size.size.width,
          padding: EdgeInsets.only(top: size.padding.top, left: 20, right: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
          ),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '乐悠',
                style: tx20.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              WeatherIcon(),
              const Spacer(),
              searchWidget,
              const SizedBox(width: 10),
              Badge(
                child: InkWell(
                  child: Icon(
                    const IconData(0xee20, fontFamily: 'micon'),
                    color: primaryColor,
                    size: 30,
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 20,),
        Obx(() => BallView(
              shrinkOffset: shrinkOffset,
              list: homeController.recommendUserList.value,
              homeController: homeController,
            ))
      ],
    );
  }

  final Widget searchWidget = Container(
    height: 34.h,
    width: 150.w,
    padding: const EdgeInsets.only(left: 14),
    decoration: BoxDecoration(
      color: primaryColor.withOpacity(0.5),
      borderRadius: BorderRadius.circular(22),
    ),
    child: Row(
      children: [
        const Icon(
          IconData(0xe67e, fontFamily: 'micon'),
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          "搜索用户/房间",
          style: tx14.copyWith(color: Colors.white),
        ),
      ],
    ),
  );
}
