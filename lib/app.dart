import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mall_community/common/app_locale.dart';
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
  final FlutterLocalization localization = FlutterLocalization.instance;
  final BaseSocket baseSocket = Get.put(BaseSocket());
  // var routers = getRouters(kApprouters);

  @override
  void initState() {
    localization.init(
      mapLocales: [
        const MapLocale('zh', AppLocale.en),
        const MapLocale('en', AppLocale.en),
        const MapLocale('km', AppLocale.km),
        const MapLocale('ja', AppLocale.ja),
      ],
      initLanguageCode: 'zh',
    );
    localization.onTranslatedLanguage = onTranslatedLanguage;
    super.initState();
  }

  /// 当语言更换 刷新app
  void onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }

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
          supportedLocales: localization.supportedLocales,
          localizationsDelegates: localization.localizationsDelegates,
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
