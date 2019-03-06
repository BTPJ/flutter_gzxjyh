/// EventCode值
class EventCode {
  /// 登录session过期
  static const LOGIN_EXPIRED = 0;

  /// 登录失败
  static const LOGIN_FAILED = 1;

  /// 阅读消息
  static const READ_NOTIFY = 2;

  /// 上报问题（案卷任务）成功
  static const REPORT_DOSSIER_TASK_SUCCESS = 3;

  /// 服务器请求超时
  static const CONNECT_TIME_OUT = 4;

  int code;
  String msg;

  EventCode(this.code, {this.msg});
}
