import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/theme.dart';
import 'package:mall_community/components/easy_refresh_diy/easy_refresh_diy.dart';
import 'package:mall_community/controller/global_base_socket.dart';
import 'package:mall_community/controller/open_im_controller.dart';
import 'package:mall_community/router/router.dart';
import 'package:mall_community/router/router_pages.dart';
import 'common/app_config.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyappState();
}

class _MyappState extends State<MyApp> {
  final BaseSocket baseSocket = Get.put(BaseSocket());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, child) {
        setEasyRefreshDeafult();
        return GetMaterialApp(
          getPages: getRouters(kApprouters),
          title: AppConfig.appTitle,
          initialRoute: AppConfig.privacyStatementHasAgree
              ? '/home'
              : "/privacyStatement",
          showPerformanceOverlay: false,
          theme: AppTheme.primaryTheme,
          themeMode: AppTheme.mode,
          darkTheme: AppTheme.darkTheme,
          builder: EasyLoading.init(),
          defaultTransition: Transition.native,
        );
      },
    );
  }

  @override
  void dispose() {
    OpenImController.unInitSDK();
    super.dispose();
  }
}
