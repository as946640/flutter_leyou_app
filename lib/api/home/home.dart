import "package:mall_community/common/app_config.dart";
import "package:mall_community/utils/request/dio.dart";
import "package:mall_community/utils/request/dio_response.dart";

ApiClient apiClient = ApiClient();

/// 用户派对房间推荐
Future<ApiResponse> reqRecommendRoom(Map<String, dynamic> data) {
  return apiClient.request(
    url: '/recommend/room',
    query: data,
    baseUrl: AppConfig.mockUrl,
  );
}

/// 用户推荐 随机 基于自己的兴趣标签
Future<ApiResponse> reqRecommendUser() {
  return apiClient.request(
    url: '/recommend/user',
    baseUrl: AppConfig.mockUrl,
  );
}
