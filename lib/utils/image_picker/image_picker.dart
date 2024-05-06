import "package:flutter/widgets.dart";
import "package:images_picker/images_picker.dart";
import 'package:dio/dio.dart' as dio;
import "dart:io";
import "package:mall_community/utils/request/dio.dart";
import "package:mall_community/utils/toast/toast.dart";
import "package:mall_community/utils/tx_cos/tx_cos.dart";

ApiClient apiClient = ApiClient();

/// 图片选择器
class ImagePicker {
  /// 选择多个图像
  static Future<List<Media>?> pickImages({int maxImages = 1}) async {
    return await ImagesPicker.pick(
      count: maxImages,
      pickType: PickType.image,
    );
  }

  /// 选择单个视频
  static Future<List<Media>?> pickVideo({int maxImages = 1}) async {
    return await ImagesPicker.pick(
      count: maxImages,
      pickType: PickType.video,
    );
  }

  /// 拍照
  static Future<List<Media>?> takePhotos(String type,
      {int maxTime = 15}) async {
    return await ImagesPicker.openCamera(
      pickType: type == 'image' ? PickType.image : PickType.video,
      maxTime: maxTime,
      quality: 0.5, //控制质量 避免太大
    );
  }

  /// 保存图片或者视频到相册
  static Future<bool> saveFile(File file,
      {String albumName = "", String type = 'image'}) async {
    if (type == 'image') {
      return await ImagesPicker.saveImageToAlbum(file, albumName: albumName);
    } else {
      return await ImagesPicker.saveVideoToAlbum(file, albumName: albumName);
    }
  }
}

/// 选择相册并且上传到服务器返回在线地址
Future<List<String>> selectImguploadFile() async {
  try {
    ToastUtils.showLoad();
    List<Media>? list = await ImagePicker.pickImages();
    if (list == null) return [];
    List<String> files = [];
    for (var item in list) {
      String cosUrl = await UploadDio.upload(item.path);
      files.add(cosUrl);
    }
    return files;
  } catch (e) {
    debugPrint('选择图片上传失败 $e');
    ToastUtils.showToast('图片上传失败');
    return [];
  } finally {
    ToastUtils.hideLoad();
  }
}

/// 选择单个视频上传到服务返回在线地址
Future<Map?> selectVideouploadFile() async {
  try {
    List<Media>? list = await ImagePicker.pickVideo();
    if (list == null) return null;
    ToastUtils.showLoad();
    Map cosResult = {};
    if (list[0].thumbPath != null) {
      String cosUrl = await UploadDio.upload(list[0].path);
      String coverUrl = await UploadDio.upload(list[0].thumbPath!);
      cosResult = {
        "cover": coverUrl,
        "url": cosUrl,
        'path': list[0].path,
        'size': list[0].size
      };
    }
    return cosResult;
  } catch (e) {
    return null;
  } finally {
    ToastUtils.hideLoad();
  }
}

/// 拍摄照片或者视频上传到服务器
/// 这是针对单个的
Future<Map?> taskPhone(String type) async {
  try {
    List<Media>? list = await ImagePicker.takePhotos(type);
    if (list == null) return null;
    ToastUtils.showLoad();
    Map cosResult = {};
    if (list[0].thumbPath != null) {
      String cosUrl = await UploadDio.upload(list[0].path);
      String coverUrl = await UploadDio.upload(list[0].thumbPath!);
      cosResult = {"cover": coverUrl, "url": cosUrl};
    }
    return cosResult;
  } catch (e) {
    return null;
  } finally {
    ToastUtils.hideLoad();
  }
}

///下载网络图片保存到本地相册
Future saveNetWorkImg(String url) async {
  try {
    ToastUtils.showLoad();
    File file = await apiClient.downloadFile(url);
    await ImagePicker.saveFile(file);
    ToastUtils.showToast("保存成功");
  } catch (e) {
    ToastUtils.showToast("保存照片失败 请稍后再试");
  }
}
