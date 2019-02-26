/// EventCode值
class EventCode {
  /// 登录失败
  static const LOGIN_FAILED = 0;

  /// 阅读消息
  static const READ_NOTIFY = 1;

  /// 上报问题（案卷任务）成功
  static const REPORT_DOSSIER_TASK_SUCCESS = 2;

  int code;
  String msg;

  EventCode(this.code, {this.msg});
}
