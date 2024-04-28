import "package:mall_community/common/app_config.dart";
import "package:mall_community/utils/request/dio.dart";
import "package:mall_community/utils/request/dio_response.dart";

ApiClient apiClient = ApiClient();

/// 获取oepnIm token
Future<ApiResponse<Map>> reqOpenImToken(data) {
  return apiClient.request(
    url: '/auth/user_token',
    data: data,
    method: Method.post,
    baseUrl: AppConfig.openApi,
  );
}
