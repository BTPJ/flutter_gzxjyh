import 'package:flutter_gzxjyh/constant/sp_key.dart';
import 'package:flutter_gzxjyh/utils/sp_util.dart';

/// 接口
class Api {
  static Api _instance;

  static Api get instance => _getInstance();

  factory Api() => _getInstance();

  Api._internal();

  /// 获取单例
  static Api _getInstance() {
    if (_instance == null) {
      _instance = Api._internal();
    }
    if (selIp == null) {
      selIp = DEFAULT_IP;
    }
    return _instance;
  }

  /// 默认Ip
  static const String DEFAULT_IP = "58.247.126.70:8098";

  /// 选择Ip
  static String selIp;

  /// 附件根地址
  String get filePath => "http://$selIp";

  /// 根IP
  String get home => "http://$selIp/gzxjyh/a/";

  /// 登录
  String get login => '${home}login';

  /// 一键拨号列表
  String get contactList => '${home}gzxj/jc/gzxjSpeedDial/getAppList';

  /// 巡检任务分页查询
  String get patrolTaskPageList => '${home}gzxj/xj/gzxjPatrolTask/getAppPage';

  /// 养护任务分页查询
  String get maintainTaskPageList =>
      '${home}gzxj/yh/gzxjMaintainTask/getAppPage';

  /// 案卷分页查询
  String get dossierPageList => '${home}gzxj/aj/gzxjDossierInfo/getAppPage';

  /// 获取字典值
  String get dictList => '${home}sys/dict/getAppList';

  /// 历史告警查询（初始时传入pageNo和pageSize）
  String get historyWarn => '${home}gzxj/sjjc/rest/findHistoryWarn';

  /// 历史监测数据查询（初始时传入pageNo和pageSize）
  String get historyData => '${home}gzxj/sjjc/rest/findHistoryData';

  /// 获取站点列表
  String get siteList => '${home}gzxj/sjjc/rest/findSites';

  /// 数据查询-生产数据详情
  String get produceDataDetail =>
      '${home}gzxj/produce/gzxjProduceData/detailOfApp';

  /// 获得填报数据时可选的污水厂
  String get sewageList => '${home}gzxj/produce/gzxjAssayData/getSiteListOfApp';

  /// 数据查询-生产计划追踪查看
  String get producePlanTrack =>
      '${home}gzxj/produce/gzxjProducePlan/producePlanTrack';

  /// 获取当前用户的通知列表
  String get notifyList => '${home}gzxj/jc/gzxjNotifyInfo/getAcceptPage';

  /// 获取当前用户未阅读的通知列表
  String get unReadNotifyList => '${home}gzxj/jc/gzxjNotifyInfo/getNotReadList';

  /// 获取通知详情
  String get notifyDetail => '${home}gzxj/jc/gzxjNotifyInfo/getNotifyInfo';

  /// 获取首页待办巡检任务列表
  String get patrolTaskList =>
      '${home}gzxj/xj/gzxjPatrolTask/getCurrentUserList';

  /// 获取首页待办案卷任务列表
  String get dossierTaskList =>
      '${home}gzxj/aj/gzxjDossierInfo/getCurrentUserList';

  /// 生产填报数据查询列表 -自己创建的所有或待审列表
  String get loadProduceData =>
      '${home}gzxj/produce/gzxjProduceData/proListOfApp';

  /// 化验数据列表
  String get loadAssayDataList =>
      '${home}gzxj/produce/gzxjAssayData/assayDataListOfApp';

  /// 案卷上报
  String get reportDossier => '${home}gzxj/aj/gzxjDossierInfo/save';

  /// 化验数据填报 -选择分析项
  String get loadAssayItemList => '${home}gzxj/produce/gzxjAssayData/itemForm';

  /// 生产管理 - 化验数据填报 -新增界面 -选择分析项目 - 确认分析项
  String get loadAssayItem => '${home}gzxj/produce/gzxjAssayData/itemFormSave';
}
