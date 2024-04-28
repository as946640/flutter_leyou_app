import 'package:get/get.dart';

class AppPages {
  static const String home = "/home";
  static const String login = "/login";
  static const String privacyStatement = "/privacyStatement";
  static const String chat = "/chat";
  static const String callVideo = "/chat/call";
  static const String map = "/map";
}

List<GetPage> getRouters(List<Map<String, dynamic>> list) {
  return list.map((e) {
    return GetPage(
      name: e['name'],
      page: e['page'],
      children: e.containsKey('children') ? getRouters(e['children']) : [],
    );
  }).toList();
}
