import 'package:dio/dio.dart';

/// 默认dio配置
Duration _connectTimeout = const Duration(seconds: 30);
Duration _receiveTimeout = const Duration(seconds: 30);
Duration _sendTimeout = const Duration(seconds: 10);
String _baseUrl = '';
List<Interceptor> _interceptors = [];
Options _options = Options(
    headers: {
      'Content-Type': 'application/json;charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Headers':
      'Content-Type, Content-Length, Authorization, Accept, X-Requested-With , yourHeaderFeild',
      'Access-Control-Allow-Methods': 'PUT,POST,GET,DELETE,OPTIONS',
      'X-Powered-By': '3.2.1',
      'Accept': 'application/json, text/plain, */*'
    });

/// 初始化Dio配置
void configDio({
  Duration? connectTimeout,
  Duration? receiveTimeout,
  Duration? sendTimeout,
  String? baseUrl,
  List<Interceptor>? interceptors,
  Options? options
}) {
  _connectTimeout = connectTimeout ?? _connectTimeout;
  _receiveTimeout = receiveTimeout ?? _receiveTimeout;
  _sendTimeout = sendTimeout ?? _sendTimeout;
  _baseUrl = baseUrl ?? _baseUrl;
  _interceptors = interceptors ?? _interceptors;
  _options = options ?? _options;
}

/// Dio util
class DioUtil {
  DioUtil._internal();

  ///网络请求配置
  static final Dio dio = Dio(BaseOptions(
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      sendTimeout: _sendTimeout
  ));

  ///get请求
  static Future get(String url, Map<String, dynamic>? params, Options? options) async {
    Response? response;
    if (params != null) {
      response = await dio.get(url, queryParameters: params, options: _checkOptions(options));
    } else {
      response = await dio.get(url);
    }
    return response?.data;
  }

  ///post 表单请求
  static Future post(String url, Map<String, dynamic>? params, Options? options) async {
    Response? response = await dio.post(url, queryParameters: params, options: _checkOptions(options) );
    return response?.data;
  }

  ///post body请求
  static Future postJson(String url, Map<String, dynamic>? data, Options? options) async {
    Response? response = await dio.post(url, data: data, options: _checkOptions(options));
    return response?.data;
  }

  ///post body请求传list
  static Future postJsonList(String url, List<dynamic>? data, Options? options) async {
    Response? response = await dio.post(url, data: data, options: _checkOptions(options));
    return response.data;
  }

  ///下载文件
  static Future downloadFile(urlPath, savePath) async {
    Response? response;
    try {
      response = await dio.download(urlPath, savePath,
          onReceiveProgress: (int count, int total) {
            //进度
            print("$count $total");
          });
    } on DioError catch (e) {
      handleError(e);
    }
    return response?.data;
  }

  /// check options
  static Options? _checkOptions(Options? options) {
    options ??= _options;
    return options;
  }

  ///error统一处理
  static void handleError(dynamic e) {
    switch (e.type) {
      case DioErrorType.connectionTimeout:
        print("连接超时");
        break;
      case DioErrorType.sendTimeout:
        print("请求超时");
        break;
      case DioErrorType.receiveTimeout:
        print("响应超时");
        break;
      case DioErrorType.badResponse:
        print("出现异常");
        break;
      case DioErrorType.cancel:
        print("请求取消");
        break;
      default:
        print("未知错误");
        break;
    }
  }
}