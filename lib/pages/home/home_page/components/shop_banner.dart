import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mall_community/common/app_config.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/new_work_image_widget/new_work_image_widget.dart';

class ShopBanner extends StatelessWidget {
  const ShopBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
        height: 70,
        width: 1.sw - 20,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color.fromRGBO(234, 184, 116, 0.6),
              Color.fromRGBO(221, 160, 97, 0.9),
            ],
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "官方商城",
                  style: tx14.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "您有一件商品正在派送中",
                  style: tx12.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Positioned(
              right: 0,
              top: -20,
              child: NetWorkImg(
                "${AppConfig.qiniuPath}app/home/3d_renwu_gouwu.png",
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );
  }
}
