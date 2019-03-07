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

  /// 审核化验数据成功
  static const OPERATE_ASSAY_DATA_SUCCESS = 5;

  /// 审核化验数据成功
  static const AUDIT_PRODUCE_OR_ASSAY_DATA = 6;

  /// 到达巡检点
  static const ARRIVE_TO_PATROL_POINT = 7;

  /// 开始巡检
  static const START_PATROL_TASK = 8;

  /// 刷新告警关注
  static const REFRESH_WARN_ATTENTION = 5;

  int code;
  String msg;

  EventCode(this.code, {this.msg});
}
