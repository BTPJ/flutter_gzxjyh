import 'package:flutter_gzxjyh/model/dossier_task.dart';
import 'package:flutter_gzxjyh/model/maintain_task.dart';
import 'package:flutter_gzxjyh/model/patrol_task.dart';

/// 首页任务（自建）
class Task {
  /// 任务类型
  /// 0.巡检任务 -> PatrolTask
  /// 1.养护任务 -> MaintainTask
  /// 2.案卷任务 -> DossierTask
  /// 3.生产数据 ->ProduceData
  /// 4.问题处理 ->DossierInfo
  int type = 0;

  /// 更新时间
  String update;

  /// 巡检任务
  PatrolTask patrolTask;

  /// 养护任务
  MaintainTask maintainTask;

  /// 案卷任务
  DossierTask dossierTask;

  Task.fromParams(
      {this.type,
      this.patrolTask,
      this.maintainTask,
      this.dossierTask,
      this.update});
}
