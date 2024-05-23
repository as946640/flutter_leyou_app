import 'package:mall_community/pages/chat/pages/call_video/call_video.dart';
import 'package:mall_community/pages/chat/pages/chat_setting/chat_setting.dart';
import 'package:mall_community/pages/chat/pages/message/message.dart';
import 'package:mall_community/pages/home/home_table.dart';
import 'package:mall_community/pages/login/login.dart';
import 'package:mall_community/pages/map_search/map_search.dart';
import 'package:mall_community/pages/privacy_statement/privacy_statement.dart';
import 'package:mall_community/router/router.dart';

List<Map<String, dynamic>> kApprouters = [
  {"name": AppPages.home, "page": () => const HomeTabblePage()},
  {"name": AppPages.login, "page": () => LoginPage()},
  {
    "name": AppPages.privacyStatement,
    "page": () => const PrivacyStatementPage()
  },
  {
    "name": AppPages.chat,
    "page": () => MessageListPage(),
    "children": [
      {
        "name": '/callVideo',
        "page": () => const CallVieoPage(),
      },
      {
        "name": '/setting',
        "page": () => ChatSetting(),
      }
    ]
  },
  {"name": AppPages.map, "page": () => const MapPage()},
];
