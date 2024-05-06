class ApiResponse<T> {
  ApiResponse({
    required this.code,
    required this.msg,
    required this.data,
  });
  late final int code;
  late final String msg;
  late T data;

  ApiResponse.fromJson(Map<String, dynamic> json) {
    // 这里要兼容 openiM 0 代码没有错误
    int c = json['code'] ?? json['errCode'];
    code = c == 0 ? 200 : c;
    msg = json['msg'] is List
        ? json['msg'].join()
        : json['msg'] ?? json['errMsg'] ?? '';
    data = json['data'] ?? {};
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['msg'] = msg;
    data['data'] = data;
    return data;
  }
}
