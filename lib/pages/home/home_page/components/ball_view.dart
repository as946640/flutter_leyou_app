import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_3d_ball/flutter_3d_ball.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/loading/loading.dart';
import 'package:mall_community/pages/home/home_page/controller/home_module.dart';

double x = 0;
double y = 0;

class BallView extends StatelessWidget {
  final double shrinkOffset;
  final List<RBallTagData> list;
  final HomeController homeController;

  BallView({
    super.key,
    required this.shrinkOffset,
    required this.list,
    required this.homeController,
  });

  bool isAnimate = true;
  double w = 1.sw - 40;
  double wh = ((1.sw - 2 * 10) * 32 / 35);
  int radius = 1.sw ~/ 2 - 40;
  double baseScale = 1;
  double scale = 1;
  bool isTransTop = false;
  Offset offsets = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    double isEnd = (1.sw / shrinkOffset);
    double newScale = isEnd < 1.25 ? 0.2 : baseScale - (shrinkOffset / 1.sw);
    scale = newScale > baseScale ? baseScale : newScale;
    isAnimate = shrinkOffset == 0;
    if (isEnd > 1.05.w) {
      x = -(shrinkOffset * 0.15.w);
      y = -(shrinkOffset);
    }
    offsets = Offset(x, y);
    double opacity = scale - 0.3 < 0 ? 0 : scale;
    return Container(
      clipBehavior: Clip.none,
      child: list.isEmpty
          ? const LoadingText()
          : Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: offsets,
                child: Transform.scale(
                  scale: scale,
                  origin: const Offset(0, 340),
                  alignment: Alignment.topCenter,
                  child: RBallView(
                    maxChar: 4,
                    keywords: list,
                    radius: radius,
                    highlight: const [],
                    isAnimate: isAnimate,
                    isShowDecoration: false,
                    textColor: Colors.white,
                    mediaQueryData: MediaQueryData.fromView(
                      PlatformDispatcher.instance.views.first,
                    ),
                    onTapRBallTagCallback: (RBallTagData data) {
                      // print('点击回调：${data}');
                    },
                    onMove: (MoveStatus s) {
                      if (s == MoveStatus.DOWN) {
                        homeController.moveStatus.value = true;
                      } else if (s == MoveStatus.UP) {
                        homeController.moveStatus.value = false;
                      }
                    },
                  ),
                ),
              ),
            ),
    );
  }
}
