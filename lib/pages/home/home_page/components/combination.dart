import 'package:flutter/material.dart';
import 'package:mall_community/common/app_config.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mall_community/components/avatar/avatar.dart';
import 'package:mall_community/components/new_work_image_widget/new_work_image_widget.dart';

class Combination extends StatelessWidget {
  const Combination({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170.w,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(top: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: 0,
            width: 1.sw - 200.w,
            height: 170.w,
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: buildItem(
                    title: "兴趣相聚",
                    subTitle: "和朋友一起玩转爱好",
                    icon: "/xq_icon.webp",
                    colors: const [
                      Color.fromRGBO(122, 92, 232, 1),
                      Color.fromRGBO(174, 146, 241, 1),
                      Color.fromRGBO(227, 161, 209, 1),
                    ],
                  ),
                ),
                Flexible(
                  child: buildItem(
                    title: "同城搭子",
                    subTitle: "一起结伴出行",
                    icon: "/3d_rewnu_shuangren.png",
                    colors: const [
                      Color.fromRGBO(127, 177, 239, 1),
                      Color.fromRGBO(214, 237, 251, 1),
                    ],
                  ),
                ),
                SizedBox(
                  width: 130.w,
                  child: buildItem(
                    title: "房间",
                    subTitle: "创建房间",
                    icon: "/msg_icon.webp",
                    colors: const [
                      Color.fromRGBO(235, 189, 105, 1),
                      Color.fromRGBO(243, 213, 155, 1),
                    ],
                  ),
                )
              ],
            ),
          ),
          buildItemFrist(),
        ],
      ),
    );
  }

  Widget buildItemFrist() {
    return Container(
      width: 170.w,
      height: 170.w,
      decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.pink.shade100,
              const Color.fromRGBO(178, 148, 242, 1),
            ],
          )),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "搭子速配",
                  style: tx16.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  "有趣的小伙伴陪您边玩边聊",
                  style: tx12.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 10),
                const MyAvatar(
                  srcs: [
                    "https://gd-hbimg.huaban.com/68e72efbc41362bb9bb98f82bd556e26a6edc041fa5-SMXldC_sq75webp",
                    "https://gd-hbimg.huaban.com/68e72efbc41362bb9bb98f82bd556e26a6edc041fa5-SMXldC_sq75webp",
                    "https://gd-hbimg.huaban.com/68e72efbc41362bb9bb98f82bd556e26a6edc041fa5-SMXldC_sq75webp",
                    "https://gd-hbimg.huaban.com/68e72efbc41362bb9bb98f82bd556e26a6edc041fa5-SMXldC_sq75webp",
                  ],
                  size: 30,
                  borderWidth: 2,
                  radius: 44,
                )
              ],
            ),
          ),
          Positioned(
            top: 10.w,
            right: -70,
            child: const NetWorkImg(
              "${AppConfig.qiniuPath}app/home/3d_pipei.png",
              width: 240,
              height: 240,
              loading: SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem({
    required List<Color> colors,
    required String title,
    required String subTitle,
    required String icon,
  }) {
    return Container(
        width: double.infinity,
        height: 170.w / 3 - 4,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
        ),
        padding: const EdgeInsets.only(left: 10, top: 10),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ).merge(tx12),
                ),
                const SizedBox(height: 4),
                Text(
                  subTitle,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Positioned(
              right: -2,
              top: -20,
              child: NetWorkImg(
                "${AppConfig.qiniuPath}app/home/$icon",
                width: 70,
                height: 70,
                loading: const SizedBox(),
              ),
            )
          ],
        ));
  }
}
