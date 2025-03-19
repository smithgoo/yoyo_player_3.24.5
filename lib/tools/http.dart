import 'dart:async';
import 'dart:convert';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide FormData;

/*
  * http 操作类
  *
  * 手册
  * https://github.com/flutterchina/dio/blob/master/README-ZH.md
  *
  * 从 3 升级到 4
  * https://github.com/flutterchina/dio/blob/master/migration_to_4.x.md
*/
class HttpUtil {
  static HttpUtil _instance = HttpUtil._internal();

  factory HttpUtil() => _instance;

  late Dio dio;
  CancelToken cancelToken = new CancelToken();

  String mapToString(Map<String, String> data) {
    List<String> pairs = [];

    // 遍历字典，将键值对转换为 "key=value" 的格式，并添加到列表中
    data.forEach((key, value) {
      pairs.add('$key=$value');
    });

    // 将列表中的所有键值对连接成一个字符串，用 "&" 符号分隔
    String result = pairs.join('&');

    return result;
  }

  HttpUtil._internal() {
    // BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    BaseOptions options = BaseOptions(
      // 请求基地址,可以包含子路径
      // baseUrl: Global.getApiHost(),
      baseUrl: "http://192.168.1.149:9000/v2",
      // baseUrl: storage.read(key: STORAGE_KEY_APIURL) ?? SERVICE_API_BASEURL,
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: Duration(milliseconds: 30000),

      // 响应流上前后两次接受到数据的间隔，单位为毫秒。
      // receiveTimeout: Duration(milliseconds: 10000),

      // Http请求头.
      headers: {
        "p": "ios",
      },

      /// 请求的Content-Type，默认值是"application/json; charset=utf-8".
      /// 如果您想以"application/x-www-form-urlencoded"格式编码请求数据,
      /// 可以设置此选项为 `Headers.formUrlEncodedContentType`,  这样[Dio]
      /// 就会自动编码请求体.
      contentType: 'application/json; charset=utf-8',

      /// [responseType] 表示期望以那种格式(方式)接受响应数据。
      /// 目前 [ResponseType] 接受三种类型 `JSON`, `STREAM`, `PLAIN`.
      ///
      /// 默认值是 `JSON`, 当响应头中content-type为"application/json"时，dio 会自动将响应内容转化为json对象。
      /// 如果想以二进制方式接受响应数据，如下载一个二进制文件，那么可以使用 `STREAM`.
      ///
      /// 如果想以文本(字符串)格式接收响应数据，请使用 `PLAIN`.
      responseType: ResponseType.json,
    );

    dio = Dio(options);

    // Cookie管理
    if (kIsWeb) {
      // Don't use the manager in Web environments
    } else {
      CookieJar cookieJar = CookieJar();
      dio.interceptors.add(CookieManager(cookieJar));
    }

    // 添加拦截器
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Do something before request is sent
        return handler.next(options); //continue
        // 如果你想完成请求并返回一些自定义数据，你可以resolve一个Response对象 `handler.resolve(response)`。
        // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义response.
        //
        // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象,如`handler.reject(error)`，
        // 这样请求将被中止并触发异常，上层catchError会被调用。
      },
      onResponse: (response, handler) {
        // Do something with response data
        return handler.next(response); // continue
        // 如果你想终止请求并触发一个错误,你可以 reject 一个`DioError`对象,如`handler.reject(error)`，
        // 这样请求将被中止并触发异常，上层catchError会被调用。
      },
      onError: (DioException e, handler) {
        // Loading.dismiss();
        ErrorEntity eInfo = createErrorEntity(e);
        int errCode = e.response?.statusCode ?? -1;
        // print("错误代码" + errCode.toString());
        // print(e.response);
        if (eInfo.code == 401) {
          Map<String, dynamic> responseData =
              e.response!.data as Map<String, dynamic>;
          onError(eInfo, responseData['message']);
        }
        // else if (eInfo.code == 500) {
        //   Logger.printlog("\x1b[31m----------------------------\x1b[0m");
        //   // toastInfo(msg: "500 Internal Server Erro");
        //   Logger.printlog("\x1b[31m500 Internal Server Error\x1b[0m");
        //   Logger.printlog("\x1b[31mRequest URL: ${e.requestOptions.uri.toString()}\x1b[0m");
        //   Logger.printlog("\x1b[31mRequest Method: ${e.requestOptions.method}\x1b[0m");
        //   Logger.printlog("\x1b[31mRequest Headers: ${e.requestOptions.headers}\x1b[0m");
        //   Logger.printlog("\x1b[31m----------------------------\x1b[0m");
        //   // Map<String, dynamic> responseData = e.response!.data as Map<String, dynamic>;
        //   // onError(eInfo, "500 Internal Server Error");
        // }
        else {
          // 尝试将响应数据转换成 JSON 格式
          if (e.response != null) {
            Map<String, dynamic> responseData =
                e.response!.data as Map<String, dynamic>;
            // Logger.printlog(responseData['code']); // 将 Map 转换成 JSON 字符串并打印
            if (responseData['code'] == 1002) {
              return handler.next(e);
            } else if (responseData['code'] == 1000 ||
                responseData['code'] == 1020 ||
                responseData['code'] == 1024) {
              //页面处理
              return handler.next(e);
            } else if (responseData['code'] == 1001) {
              // StorageService.to.remove(STORAGE_USER_TOKEN_KEY);
              // StorageService.to.setBool(STORAGE_IS_LOGIN, false);
              // UserStore.to.onLogout();
              // Get.toNamed(AppRoutes.SIGN_IN);
              return handler.next(e);
            } else {
              EasyLoading.showError(responseData['message']);
            }
          }
        }
        return handler.next(e);
      },
    ));
  }

  /*
   * error统一处理
   */

  // 错误处理
  void onError(ErrorEntity eInfo, msg) {
    switch (eInfo.code) {
      case 401:
        // UserStore.to.onLogout();
        EasyLoading.showError(msg);
        break;
      default:
        EasyLoading.showError('Unable to Connect to Server');
        break;
    }
  }

  // 错误信息
  ErrorEntity createErrorEntity(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        // 连接超时处理
        return ErrorEntity(code: -1, message: "Connection timed out");
      case DioExceptionType.sendTimeout:
        // 发送超时处理
        return ErrorEntity(code: -1, message: "Request timed out");
      case DioExceptionType.receiveTimeout:
        // 接收超时处理
        return ErrorEntity(code: -1, message: "Response timeout");
      case DioExceptionType.badResponse:
        // 服务器响应错误处理
        int errCode = error.response?.statusCode ?? -1;
        String errMsg = error.response?.statusMessage ?? '';
        return ErrorEntity(code: errCode, message: errMsg);
      case DioExceptionType.cancel:
        // 请求取消处理
        return ErrorEntity(code: -1, message: "Request cancellation");
      case DioExceptionType.connectionError:
        // 连接错误处理
        return ErrorEntity(code: -1, message: "connection Error");
        break;
      case DioExceptionType.unknown:
      default:
        // 其他错误处理
        return ErrorEntity(code: -1, message: error.message ?? "");
    }
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  /// 读取本地配置
  Map<String, dynamic>? getAuthorizationHeader() {
    var headers = <String, dynamic>{};
    // if (Get.isRegistered<UserStore>() && UserStore.to.hasToken == true) {
    //   headers['Authorization'] = '${UserStore.to.token}';
    // }
    return headers;
  }

  /// restful get 操作
  /// refresh 是否下拉刷新 默认 false
  /// noCache 是否不缓存 默认 true
  /// list 是否列表 默认 false
  /// cacheKey 缓存key
  /// cacheDisk 是否磁盘缓存
  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool refresh = false,
    bool noCache = false,
    bool list = false,
    String cacheKey = '',
    bool cacheDisk = false,
  }) async {
    Options requestOptions = options ?? Options();
    if (requestOptions.extra == null) {
      requestOptions.extra = Map();
    }
    requestOptions.extra!.addAll({
      "refresh": refresh,
      "noCache": noCache,
      "list": list,
      "cacheKey": cacheKey,
      "cacheDisk": cacheDisk,
    });
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    // filterLogCommPara("get", path, queryParameters);
    var response = await dio.get(
      path,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
//     Logger.printlog("-------------------------------------\n");
//     Logger.printlog("请求路径: $path");

// // 使用 jsonEncode 输出格式化的 JSON
//     Logger.printlog("响应内容: \n${JsonEncoder.withIndent('  ').convert(response.data)}");

//     Logger.printlog("\n-------------------------------------");
    return response.data;
  }

  /// restful post 操作
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }

    // filterLogCommPara("post", path, queryParameters);

    var response = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
//     Logger.printlog("-------------------------------------\n");
//     Logger.printlog("请求路径: $path");

// // 使用 jsonEncode 输出格式化的 JSON
//     Logger.printlog("响应内容: \n${JsonEncoder.withIndent('  ').convert(response.data)}");

//     Logger.printlog("\n-------------------------------------");
    return response.data;
  }

  /// restful put 操作
  Future put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }

    // filterLogCommPara("put", path, queryParameters);
    var response = await dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful patch 操作
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful delete 操作
  Future delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful post form 表单提交操作
  Future postForm(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.post(
      path,
      data: FormData.fromMap(data),
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful post Stream 流数据
  Future postStream(
    String path, {
    dynamic data,
    int dataLength = 0,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    requestOptions.headers!.addAll({
      Headers.contentLengthHeader: dataLength.toString(),
    });
    var response = await dio.post(
      path,
      data: Stream.fromIterable(data.map((e) => [e])),
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }
}

// 异常处理
class ErrorEntity implements Exception {
  int code = -1;
  String message = "";

  ErrorEntity({required this.code, required this.message});

  String toString() {
    if (message == "") return "Exception";
    return "Exception: code $code, $message";
  }
}
