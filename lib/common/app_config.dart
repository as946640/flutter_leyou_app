import 'package:mall_community/utils/utils.dart';

class AppConfig {
  static const String appTitle = "乐悠云社";

  static const String host = "http://";

  /// 请求地址
  static String baseUrl =
      isProduction() ? '${host}8.138.91.219:3000' : '${host}8.138.91.219:3000';

  /// mock 请求地址
  static const String mockUrl =
      "https://mock.apipark.cn/m1/4575065-4223724-default";

  /// openIm server api
  static String openApi = isProduction()
      ? '${host}8.138.91.219:10002'
      : '${host}8.138.91.219:10002';

  /// openIm chat wss
  static String openChatWss =
      isProduction() ? 'ws://8.138.91.219:10001' : 'ws://8.138.91.219:10001';

  /// openIm 全局链路追踪ID
  static String get operationID =>
      DateTime.now().millisecondsSinceEpoch.toString();

  static const String openImSecret = "openIM123";

  /// oss 资源前缀
  static const String ossPath =
      "https://public-1259264706.cos.ap-guangzhou.myqcloud.com/";

  /// 七牛云存储资源前缀
  static const String qiniuPath = "${host}qiniu.as-leyou.top/";

  /// 请求超时时间
  static const Duration timeout = Duration(seconds: 60);

  /// AppId
  static const int appId = 10001;

  /// 端口ID
  static const String portId = "6";

  /// 隐私政策是否同意
  static bool privacyStatementHasAgree = true;

  /// 百度地图 ios key
  static const String amapIosKey = "VE5RJxtPuSqV9eTtId3sY9WtGxd9pjUV";

  /// 百度地图 android key
  static const String amapAndroidKey = "";

  /// 高德地图 web
  static const String amapWebkey = "";

  /// 极光推送 appkey
  static const String jPushKey = "";

  /// 极光推送注册id
  static String jPushId = '';

  /// 腾讯云 cos 秘钥id
  static String secretId = "";

  /// 腾讯云 cos 秘钥key
  static String secretKey = "";

  /// 键盘高度
  static double keyBoardHeight = 0.0;
}
