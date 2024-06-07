import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/avatar/avatar.dart';
import 'package:mall_community/components/new_work_image_widget/new_work_image_widget.dart';

class RoomList extends StatelessWidget {
  final List<RoomModule> list;

  const RoomList({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      sliver: SliverMasonryGrid.count(
        childCount: list.length,
        crossAxisCount: 2,
        mainAxisSpacing: 6,
        crossAxisSpacing: 8,
        itemBuilder: (context, index) {
          return buildItem(index, list[index]);
        },
      ),
    );
  }

  Widget buildItem(int i, RoomModule item) {
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NetWorkImg(item.cover),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    item.title,
                    maxLines: 1,
                    style: tx14.copyWith(color: primaryTextC),
                  ),
                ),
                Text(
                  item.des,
                  maxLines: 2,
                  style: tx12.copyWith(
                    color: routineTextC,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 66,
                      child: MyAvatar(
                        srcs: item.users,
                        size:26,
                        radius: 26,
                      ),
                    ),
                    Text("4人在线")
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RoomModule {
  late String title;
  late String cover;
  late String des;
  late List<String> users;

  RoomModule.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    cover = json['cover'];
    des = json['des'];
    List list = json['users'];
    users = list.toList().cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['cover'] = cover;
    data['des'] = des;
    return data;
  }
}
