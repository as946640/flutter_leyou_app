import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/new_work_image_widget/new_work_image_widget.dart';
import 'package:mall_community/pages/chat/module/message_module.dart';

class LocationMsg extends StatelessWidget {
  const LocationMsg({super.key, required this.item});
  final SendMsgModule item;

  getImgUrl(longitude, latitude) {
    return "https://restapi.amap.com/v3/staticmap?markers=-1,https://public-1259264706.cos.ap-guangzhou.myqcloud.com/flutter_app/address/location.png,0:$longitude,$latitude&key=ee95e52bf08006f63fd29bcfbcf21df0&size=350*150&zoom=19";
  }

  @override
  Widget build(BuildContext context) {
    Map data = jsonDecode(item.content);

    return Container(
      width: 200,
      height: 140,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Text(
              "${data['street'] ?? data['name']}",
              style: tx16,
              maxLines: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "${data['address']}",
              maxLines: 1,
              style: tx10.copyWith(
                overflow: TextOverflow.ellipsis,
                color: HexThemColor(secondaryTextC),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: NetWorkImg(
              getImgUrl(data['longitude'], data['latitude']),
              width: 200,
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
    );
  }
}
