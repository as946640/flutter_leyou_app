import 'package:flutter/widgets.dart';
import 'package:flutter_3d_ball/flutter_3d_ball.dart';
import 'package:get/get.dart';
import 'package:mall_community/api/home/home.dart';
import 'package:mall_community/pages/home/home_page/components/list.dart';
import 'package:mall_community/utils/event_bus/event_bus.dart';

class HomeController extends GetxController {
  // 3d球滑动状态
  var moveStatus = false.obs;

  // 滚动控制器
  ScrollController scrollController = ScrollController();
  scrollListen() {
    EventBus.fire("homeScroll", scrollController.offset);
  }

  // 用户推荐
  RxList<RBallTagData> recommendUserList = <RBallTagData>[].obs;
  getRecommendUserList() async {
    var result = await reqRecommendUser();
    List<RBallTagData> datas = result.data
        .map<RBallTagData>((item) => RBallTagData.fromJson(item))
        .toList();
    recommendUserList.addAll(datas);
  }

  Map<String, dynamic> params = {
    "page": 0,
    "size": 10,
  };
  int total = 10;
  RxList<RoomModule> list = <RoomModule>[].obs;
  // 获取房间推荐
  getRoomList() async {
    if (total == list.length) return;
    params['page'] += 1;
    var result = await reqRecommendRoom(params);
    List<RoomModule> rooms = result.data['list']
        .map<RoomModule>((item) => RoomModule.fromJson(item))
        .toList();
    list.addAll(rooms);
  }

  @override
  void onInit() {
    super.onInit();
    getRecommendUserList();
    getRoomList();
    scrollController.addListener(scrollListen);
  }

  @override
  void onClose() {
    scrollController.removeListener(scrollListen);
    scrollController.dispose();
    super.onClose();
  }
}
