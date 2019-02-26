import 'dart:convert' show json;

/// 请求接口的基类（单对象）参考：https://juejin.im/post/5b4e04bbe51d45198c018e6e
class BaseResp<T> {
  /// 是否请求成功
  bool success;

  /// 提示消息
  String tipMessage;

  /// 登录过期重新登录的提示
  String message;

  /// 返回数据
  T resultObj;

  factory BaseResp(jsonStr, Function buildFun) => jsonStr is String
      ? BaseResp.fromJson(json.decode(jsonStr), buildFun)
      : BaseResp.fromJson(jsonStr, buildFun);

  BaseResp.fromJson(jsonRes, Function buildFun) {
    success = jsonRes['success'];
    tipMessage = jsonRes['tipMessage'];
    message = jsonRes['message'];

    _check(success, message);

    var res = jsonRes['resultObj'];
    if (buildFun != null && res != null && res.toString().isNotEmpty) {
      resultObj = buildFun(res);
    } else {
      if (res == null || res.toString().isEmpty) {
        resultObj = null;
      } else {
        resultObj = res;
      }
    }
  }
}

/// 请求接口的基类（对象集合）
class BaseRespList<T> {
  /// 是否请求成功
  bool success;

  /// 提示消息
  String tipMessage;

  /// 登录过期重新登录的提示
  String message;

  /// 返回数据集
  List<T> resultObj;

  factory BaseRespList(jsonStr, Function buildFun) => jsonStr is String
      ? BaseRespList.fromJson(json.decode(jsonStr), buildFun)
      : BaseRespList.fromJson(jsonStr, buildFun);

  BaseRespList.fromJson(jsonRes, Function buildFun) {
    success = jsonRes['success'];
    tipMessage = jsonRes['tipMessage'];
    message = jsonRes['message'];

    _check(success, message);

    try {
      resultObj = (jsonRes['resultObj'] as List)
          .map<T>((ele) => buildFun(ele))
          .toList();
    } catch (e) {
      resultObj = new List();
    }
  }
}

/// 请求接口的基类（分页集合）
/// 这里写成通用行不通，不明原因，待解决
//class BaseRespPage<T> {
//  int count;
//  int pageNo;
//  int pageSize;
//  List<T> list;
//
//  BaseRespPage.fromParams({this.count, this.pageNo, this.pageSize, this.list});
//
//  BaseRespPage.fromJson(jsonRes, Function buildFun) {
//    count = jsonRes['count'];
//    pageNo = jsonRes['pageNo'];
//    pageSize = jsonRes['pageSize'];
//
//    try {
//      list = (jsonRes['list'] as List)
//          .map<T>((ele) => buildFun(ele))
//          .toList();
//    } catch (e) {
//      list = new List();
//    }
//  }
//
//  @override
//  String toString() {
//    return '{"count": $count,"pageNo": $pageNo,"pageSize": $pageSize,"list": $list}';
//  }
//}

/// 这里可以做code和msg的处理逻辑
void _check(bool success, String msg) {}
