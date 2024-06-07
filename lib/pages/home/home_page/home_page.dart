import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/components/automatic_keep_alive/automatic_keep_alive.dart';
import 'package:mall_community/components/easy_refresh_diy/easy_refresh_diy.dart';
import 'package:mall_community/components/sticky_header_delegate/sticky_header_delegate.dart';
import 'package:mall_community/pages/home/home_page/controller/home_module.dart';
import 'components/combination.dart';
import 'components/list.dart';
import 'components/nav_bar.dart';
import 'components/shop_banner.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return MyAutomaticKeepAlive(
      child: Scaffold(
        drawerDragStartBehavior: DragStartBehavior.down,
        body: Container(
            height: 1.sh,
            width: 1.sw,
            decoration: const BoxDecoration(
              // color: Colors.black87,
              image: DecorationImage(
                image: AssetImage("lib/assets/image/home/home_bg.webp"),
                fit: BoxFit.cover,
              ),
            ),
            child: EasyRefresh.builder(
              onLoad: () {
                  homeController.getRoomList();
              },
              footer: sliverFooterLoading,
              childBuilder: (context, physics) {
                return Obx(() => CustomScrollView(
                      controller: homeController.scrollController,
                      physics: homeController.moveStatus.value
                          ? const NeverScrollableScrollPhysics()
                          : physics,
                      slivers: [
                        SliverPersistentHeader(
                          delegate: StickyHeaderDelegate(
                            buildChild:
                                (double shrinkOffset, bool overlapsContent) {
                              return HomeNavBar(
                                shrinkOffset: shrinkOffset,
                                homeController: homeController,
                              );
                            },
                            minHeight: 60 + ScreenUtil().statusBarHeight,
                            maxHeight: 450.w,
                          ),
                          pinned: true,
                        ),
                        const SliverToBoxAdapter(child: Combination()),
                        const SliverToBoxAdapter(
                          child: ShopBanner(),
                        ),
                        RoomList(
                          list: homeController.list.value,
                        ),
                        const FooterLocator.sliver(),
                      ],
                    ));
              },
            )),
      ),
    );
  }
}
