import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mall_community/app.dart';
import 'package:mall_community/common/app_config.dart';
import 'package:mall_community/modules/user_module.dart';
import 'package:mall_community/utils/location/location.dart';
import 'package:mall_community/utils/storage.dart';

void main() async {
  await init();
  runApp(const MyApp());
}

init() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 存储
  await GetStorage.init();
  // 隐私政策
  AppConfig.privacyStatementHasAgree =
      Storage().read('privacyStatementHasAgree') ?? false;
  // 用户信息
  UserInfo.token = Storage().read('token') ?? '';
  if (AppConfig.privacyStatementHasAgree) {
    // 百度地图
    await BdLocation().init();
  }
}
