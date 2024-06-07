import "package:mall_community/utils/request/dio.dart";

ApiClient apiClient = ApiClient();

/// 用户登录
Future reqLogin( data) {
  return apiClient.request(
    url: '/auth/login',
    method: 'post',
    data: data,
  );
}
