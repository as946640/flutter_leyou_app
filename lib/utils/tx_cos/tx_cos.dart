import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import "package:mall_community/utils/request/dio.dart";

ApiClient apiClient = ApiClient();

class UploadDio {
  static String bucket = "public-1259264706";
  static String region = 'ap-guangzhou';

  /// 上传文件
  /// @param 本地 filePath 文件路径
  /// @param 远端 存储路径 默认 flutter_app 根目录  remotePath
  /// @param progressCallback 进度回调
  static Future<String> upload(
    String filePath, {
    String? remotePath,
    ProgressCallback? progressCallback,
  }) async {
    List filePaths = filePath.split('/');
    String ext = filePaths[filePaths.length - 1];
    Map<String, dynamic> directTransferData = await _getStsDirectSign(ext);

    String cosHost = "$bucket.cos.$region.myqcloud.com";
    String cosKey = ext;
    String authorization = directTransferData['tmpSecretKey'];
    String securityToken = directTransferData['sessionToken'];
    String url =
        'https://$cosHost/flutter_app/${remotePath!= null && remotePath.isNotEmpty ? "$remotePath/$cosKey" : cosKey}';
    File file = File(filePath);
    Options options = Options(
      method: 'PUT',
      headers: {
        'Content-Length': await file.length(),
        'Content-Type': 'application/octet-stream',
        'Authorization': authorization,
        'x-cos-security-token': securityToken,
        'Host': cosHost,
      },
    );
    try {
      Dio dio = Dio();
      Response response = await dio.put(
        url,
        data: file.openRead(),
        options: options,
        onSendProgress: (int sent, int total) {
          double progress = sent / total;
          if (kDebugMode) {
            print('Progress: ${progress.toStringAsFixed(2)}');
          }
          progressCallback?.call(sent, total);
        },
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('上传成功');
        }
        return Future.value(url);
      } else {
        throw Exception("上传失败 ${response.statusMessage}");
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
      throw Exception("上传失败 ${error.toString()}");
    }
  }

  /// 获取直传的url和签名等
  /// @param ext 文件后缀 直传后端会根据后缀生成cos key
  /// @return 直传url和签名等
  static Future _getStsDirectSign(String ext) async {
    var result = await apiClient.request(url: '/auth/cos', method: 'post');
    return result.data['credentials'];
  }
}
