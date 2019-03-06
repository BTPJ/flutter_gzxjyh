import 'dart:convert' show json;
import 'package:flutter_gzxjyh/model/patrol_task.dart';
import 'package:flutter_gzxjyh/model/user.dart';

class PatrolTaskFlow {
  bool isNewRecord;
  String createDate;
  String id;

  /// 操作类型(1.分派，2.申请撤销，3.申请延期，4.撤销审核，5.延期审核，6.确认)
  String operateType;
  String operateTypeName;

  /// 审批结果(1.通过， 2.驳回 ，3.重新分派)
  String checkType;
  String checkTypeName;
  String reason;

  /// 要求完成时间
  String oldDate;

  /// 延期时间
  String delayDate;

  /// 意见
  String opinion;

  /// 评分
  int score;
  String updateDate;
  User createBy;
  PatrolTask task;

  PatrolTaskFlow.fromParams(
      {this.isNewRecord,
      this.createDate,
      this.id,
      this.operateType,
      this.operateTypeName,
      this.updateDate,
      this.createBy,
      this.task});

  PatrolTaskFlow.fromJson(jsonRes) {
    isNewRecord = jsonRes['isNewRecord'];
    createDate = jsonRes['createDate'];
    id = jsonRes['id'];
    operateType = jsonRes['operateType'];
    operateTypeName = jsonRes['operateTypeName'];
    checkType = jsonRes['checkType'];
    checkTypeName = jsonRes['checkTypeName'];
    reason = jsonRes['reason'];
    oldDate = jsonRes['oldDate'];
    delayDate = jsonRes['delayDate'];
    opinion = jsonRes['opinion'];
    score = jsonRes['score'];
    updateDate = jsonRes['updateDate'];
    createBy = jsonRes['createBy'] == null
        ? null
        : new User.fromJson(jsonRes['createBy']);
    task = jsonRes['task'] == null
        ? null
        : new PatrolTask.fromJson(jsonRes['task']);
  }

  @override
  String toString() {
    return '{"isNewRecord": $isNewRecord,"createDate": ${createDate != null ? '${json.encode(createDate)}' : 'null'},"id": ${id != null ? '${json.encode(id)}' : 'null'},"operateType": ${operateType != null ? '${json.encode(operateType)}' : 'null'},"operateTypeName": ${operateTypeName != null ? '${json.encode(operateTypeName)}' : 'null'},"updateDate": ${updateDate != null ? '${json.encode(updateDate)}' : 'null'},"createBy": $createBy,"task": $task}';
  }
}
