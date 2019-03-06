import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_gzxjyh/event/event_code.dart';
import 'package:flutter_gzxjyh/event/event_manager.dart';
import 'package:flutter_gzxjyh/event/user_event.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/model/user.dart';
import 'package:flutter_gzxjyh/utils/toast_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// 网络请求工具类（Dio）参考：https://www.jianshu.com/p/e010041f0ec0
class NetUtil {
  static const String GET = 'GET';
  static const String POST = 'POST';

  static NetUtil _instance;
  Dio _dio;

  factory NetUtil() => _getInstance();

  /// 获取单例
  static NetUtil get instance => _getInstance();

  static _getInstance() {
    if (_instance == null) {
      _instance = NetUtil._internal();
    }
    return _instance;
  }

  /// cookie
  DefaultCookieJar defaultCookieJar;

  NetUtil._internal() {
    _initDio();
  }

  /// 初始化Dio
  _initDio() {
    BaseOptions baseOptions = BaseOptions(
      connectTimeout: 60000,
      receiveTimeout: 30000,
      contentType: ContentType.parse("application/x-www-form-urlencoded"),
      // contentType: ContentType.parse("multipart/form-data"),

      /// 不设置这个返回的JSON格式中键不带引号
      responseType: ResponseType.plain,

      /// 设置手机标识符
      headers: {
        "User-Agent":
            "Mozilla/5.0 (Linux; U; Android 8.0.0; zh-cn; MI 5 Build/OPR1.170623.032) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30"
      },
    );

    _dio = Dio(baseOptions);
    defaultCookieJar = DefaultCookieJar();

    _dio.interceptors
      ..add(LogInterceptor(
          responseHeader: false,
          responseBody: true,
          requestHeader: false,
          requestBody: true))
      ..add(CookieManager(defaultCookieJar))
      ..add(InterceptorsWrapper(
          onError: (DioError e) => _handleError(null, e.message, dioError: e),
          onResponse: (Response response) {
            /// 判断session过期，自动重新登录
            if (response.data.toString().contains('<title>')) {
              EventManager.instance.eventBus
                  .fire(EventCode(EventCode.LOGIN_FAILED));
            }
          })); //错误逻辑处理
  }

  /// 网络请求
  _request(String url, Function callBack,
      {String method,
      Map<String, dynamic> params,
      Function errorCallBack}) async {
    String errorMsg;
    int statusCode;

    try {
      Response response;
      if (method == GET) {
        // 组合Get请求的参数
        if (params != null && params.isNotEmpty) {
          StringBuffer sb = StringBuffer('?');
          params.forEach((key, value) {
            sb.write('$key=$value&');
          });
          String paramStr = sb.toString();
          paramStr = paramStr.substring(0, paramStr.length - 1);
          url += paramStr;
        }
        print('----------请求Url:$url');
        response = await _dio.get(url);
      } else {
        print('----------请求Url:$url');
        if (params != null && params.isNotEmpty) {
          response = await _dio.post(url, data: params);
          print(_dio.options.headers);
          print('post参数：$params');
        } else {
          response = await _dio.post(url);
        }
      }

      statusCode = response.statusCode;
      print('------------返回码：$statusCode');
      // 处理错误部分
      if (statusCode != 200) {
        errorMsg = '服务器请求错误,状态码?:$statusCode';
        _handleError(errorCallBack, errorMsg);
        return;
      }

      if (callBack != null) {
        print('----------返回内容:${response.data}');
        Map body = json.decode(response.data);
        // 请求数据结果码
        String tipMessage = body['tipMessage'];
        bool success = body['success'];
        // String tipMessage = respMap['message'];

        if (success) {
          // 请求成功
          callBack(response.data);
        } else {
          _handleError(errorCallBack, tipMessage);
        }
      }
    } catch (e) {
      print('报错${e.toString()}');
    }
  }

  /// get请求
  void get(String url, Function callBack,
      {Map<String, dynamic> params, Function errorCallBack}) async {
    _request(url, callBack,
        method: GET, params: params, errorCallBack: errorCallBack);
  }

  /// post请求
  void post(String url, Function callBack,
      {Map<String, dynamic> params, Function errorCallBack}) async {
    _request(url, callBack,
        method: POST, params: params, errorCallBack: errorCallBack);
  }

  /// 统一错误处理
  void _handleError(Function errorCallBack, String errorMsg,
      {DioError dioError}) {
    print('----------请求错误:$errorMsg');
    if (errorCallBack != null) {
      errorCallBack(errorMsg);
    }
    if (dioError == null) {
      ToastUtil.showShort('$errorMsg');
      return;
    }
    switch (dioError.type) {
      case DioErrorType.CONNECT_TIMEOUT:
        ToastUtil.showShort('网络连接超时');
        EventManager.instance.eventBus
            .fire(EventCode(EventCode.CONNECT_TIME_OUT));
        break;
      case DioErrorType.RESPONSE:
        switch (dioError.response.statusCode) {
          case 302:
            // 处理'302重定向'时执行登录
            var location =
                dioError.response.headers.value(HttpHeaders.locationHeader);
            get(location, (body) {
              User user =
                  BaseResp<User>(body, (res) => User.fromJson(res)).resultObj;
              EventManager.instance.eventBus.fire(UserEvent(user));
            }, errorCallBack: (errorMsg) {
              EventManager.instance.eventBus
                  .fire(EventCode(EventCode.LOGIN_FAILED));
            });
            break;
          case 404:
            Fluttertoast.showToast(msg: '网络连接错误：404');
            break;
          case 500:
            Fluttertoast.showToast(msg: '服务器请求错误：500');
            break;
        }
        break;

      default:
        ToastUtil.showShort('$errorMsg');
        break;
    }
  }
}
