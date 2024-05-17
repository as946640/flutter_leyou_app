import 'package:flutter/material.dart';
import 'package:mall_community/common/app_config.dart';
import 'package:mall_community/common/comm_style.dart';
import 'package:mall_community/components/new_work_image_widget/new_work_image_widget.dart';

///网络加载状态展示组件
class NotDataIcon extends StatelessWidget {
  const NotDataIcon({
    super.key,
    required this.status,
    this.label,
    this.callBack,
    this.subTitle = '',
  });

  /// 提示状态
  final int status;

  /// 副标题 展示在缺省状态下方
  final String subTitle;

  /// 操作文案 展示在 文字按钮里面
  final String? label;

  /// 文案按钮回调
  final Function? callBack;

  String getUrl() {
    String path = AppConfig.ossPath;
    switch (status) {
      case NetWorkDataStatus.notLogin:
        return "${path}flutter_app%2Fuser%2Fnot_login_2.png";
      case NetWorkDataStatus.notMsg:
        return "${path}flutter_app%2Fuser%2Fnot_login.png";
      case NetWorkDataStatus.notData:
        return "${path}flutter_app/not_data_icon/not_data.png";
      default:
        return "${path}flutter_app%2Fnot_data_icon%2Ferr_500.png";
    }
  }

  String getTitle() {
    if (subTitle.isNotEmpty && status == NetWorkDataStatus.notData) {
      return subTitle;
    }
    switch (status) {
      case NetWorkDataStatus.notLogin:
        return "哎呀 您当前还未登录呢";
      case NetWorkDataStatus.notError:
        return "哎呀 请求失败了";
      case NetWorkDataStatus.notMsg:
        return "暂时还没人找你呢 孤单的人";
      case NetWorkDataStatus.notData:
        return "没有更多数据了呢";
      case NetWorkDataStatus.notMoreData:
        return "没有更多数据了";
      case NetWorkDataStatus.notNertwork:
        return '哎呀 您当前网络不可用呢';
      case NetWorkDataStatus.networkTimOut:
        return '哎呀 请求超时了呢';
      default:
        return '哎呀 加载失败了 请稍后重试';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      width: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NetWorkImg(
            getUrl(),
            width: 200.0,
            height: 200.0,
          ),
          Text(
            getTitle(),
            style: tx14.copyWith(color: HexThemColor(secondaryTextC)),
          ),
          label != null && callBack != null
              ? TextButton(
                  onPressed: () {
                    callBack?.call();
                  },
                  child: Text(label!))
              : const SizedBox()
        ],
      ),
    );
  }
}

/// 网络请求状态
class NetWorkDataStatus {
  /// 加载中
  static const notLoading = 0;

  /// 加载完毕
  static const loadingOK = 200;

  /// 请求失败
  static const notError = 2;

  /// 没有数据
  static const notData = 3;

  /// 没有消息
  static const notMsg = 4;

  /// 没有更多数据
  static const notMoreData = 5;

  ///未登录
  static const notLogin = 401;

  ///没有权限
  static const notAuth = 404;

  ///服务端错误
  static const notNetworkError = 500;

  ///请求超时
  static const networkTimOut = 501;

  ///没有网络
  static const notNertwork = 505;
}
