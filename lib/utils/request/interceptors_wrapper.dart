import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:mall_community/common/app_config.dart';
import 'package:mall_community/modules/user_module.dart';
import 'package:mall_community/utils/request/dio.dart';
import 'package:mall_community/utils/request/dio_response.dart';
import 'package:mall_community/utils/request/error_exception.dart';
import 'package:mall_community/utils/request/white_api.dart';
import 'package:mall_community/utils/toast/toast.dart';

class LoggingInterceptor extends dio.InterceptorsWrapper {
  @override
  void onRequest(
      dio.RequestOptions options, dio.RequestInterceptorHandler handler) {
    options.headers['authorization'] = UserInfo.token;
    options.headers['operationID'] = AppConfig.operationID;
    if (options.method == Method.get || options.method == Method.put) {
      // options.queryParameters ?? {};
      // options.queryParameters['app_id'] = ApiConfig.appId;
    } else {
      if (options.data is Map) {
        // options.data['app_id'] = ApiConfig.appId;
      } else if (options.data is dio.FormData) {
        // options.data.fields.add(MapEntry('app_id', ApiConfig.appId.toString()));
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
      dio.Response response, dio.ResponseInterceptorHandler handler) {
    final apiResponse = ApiResponse.fromJson(
        response.data is String ? json.decode(response.data) : response.data);
    String msg = apiResponse.msg;
    if (apiResponse.code != 1 && apiResponse.code != 200) {
      throw dio.DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: msg,
      );
    }
    super.onResponse(response, handler);
  }

// 920962a2a50370f68a6d8246a866192c
  @override
  void onError(dio.DioException err, dio.ErrorInterceptorHandler handler) {
    String msg = err.message ?? err.error.toString();
    int code = err.response?.data['code'] ?? 500;
    if (err.error.runtimeType == ApiError) {
      final apiError = err.error as ApiError;
      code = apiError.errCode;
    }
    // 在请求发生错误时拦截并处理错误 白名单就不会提示错误信息等处理
    if (!whiteApis.contains(err.requestOptions.path)) {
      switch (code) {
        case 401:
          break;
        default:
          ToastUtils.showToast(msg);
      }
    }
    switch (err.type) {
      //接收超时
      case dio.DioExceptionType.receiveTimeout:
        break;
      case dio.DioExceptionType.sendTimeout:
        ToastUtils.showToast('发送超时 请检查手机网络');
        break;
      case dio.DioExceptionType.connectionError:
        ToastUtils.showToast('连接错误，请检查网络连接');
        break;
      case dio.DioExceptionType.badCertificate:
        ToastUtils.showToast('证书错误，请检查证书配置');
        break;
      default:
    }

    throw ApiError(code: code, msg: msg);
  }
}
