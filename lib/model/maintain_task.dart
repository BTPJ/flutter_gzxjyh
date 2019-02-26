import 'dart:convert' show json;

import 'package:flutter_gzxjyh/model/user.dart';
import 'package:flutter_gzxjyh/model/maintain_plan.dart';

/// 养护任务Entity
class MaintainTask {
  bool isNewRecord;
  String createDate;
  String facilityIds;
  String facilityNames;
  String flowId;
  String id;
  String name;
  String planBeginDate;
  String planEndDate;
  String pointIds;
  String pointNames;
  String realBeginDate;
  String realEndDate;
  String status;
  String updateDate;
  User createBy;
  MaintainPlan plan;
  User user;

  MaintainTask.fromParams(
      {this.isNewRecord,
      this.createDate,
      this.facilityIds,
      this.facilityNames,
      this.flowId,
      this.id,
      this.name,
      this.planBeginDate,
      this.planEndDate,
      this.pointIds,
      this.pointNames,
      this.realBeginDate,
      this.realEndDate,
      this.status,
      this.updateDate,
      this.createBy,
      this.plan,
      this.user});

  factory MaintainTask(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new MaintainTask.fromJson(json.decode(jsonStr))
          : new MaintainTask.fromJson(jsonStr);

  MaintainTask.fromJson(jsonRes) {
    isNewRecord = jsonRes['isNewRecord'];
    createDate = jsonRes['createDate'];
    facilityIds = jsonRes['facilityIds'];
    facilityNames = jsonRes['facilityNames'];
    flowId = jsonRes['flowId'];
    id = jsonRes['id'];
    name = jsonRes['name'];
    planBeginDate = jsonRes['planBeginDate'];
    planEndDate = jsonRes['planEndDate'];
    pointIds = jsonRes['pointIds'];
    pointNames = jsonRes['pointNames'];
    realBeginDate = jsonRes['realBeginDate'];
    realEndDate = jsonRes['realEndDate'];
    status = jsonRes['status'];
    updateDate = jsonRes['updateDate'];
    createBy = jsonRes['createBy'] == null
        ? null
        : new User.fromJson(jsonRes['createBy']);
    plan = jsonRes['plan'] == null
        ? null
        : new MaintainPlan.fromJson(jsonRes['plan']);
    user = jsonRes['user'] == null ? null : new User.fromJson(jsonRes['user']);
  }

  @override
  String toString() {
    return '{"isNewRecord": $isNewRecord,"createDate": ${createDate != null ? '${json.encode(createDate)}' : 'null'},"facilityIds": ${facilityIds != null ? '${json.encode(facilityIds)}' : 'null'},"facilityNames": ${facilityNames != null ? '${json.encode(facilityNames)}' : 'null'},"flowId": ${flowId != null ? '${json.encode(flowId)}' : 'null'},"id": ${id != null ? '${json.encode(id)}' : 'null'},"name": ${name != null ? '${json.encode(name)}' : 'null'},"planBeginDate": ${planBeginDate != null ? '${json.encode(planBeginDate)}' : 'null'},"planEndDate": ${planEndDate != null ? '${json.encode(planEndDate)}' : 'null'},"pointIds": ${pointIds != null ? '${json.encode(pointIds)}' : 'null'},"pointNames": ${pointNames != null ? '${json.encode(pointNames)}' : 'null'},"realBeginDate": ${realBeginDate != null ? '${json.encode(realBeginDate)}' : 'null'},"realEndDate": ${realEndDate != null ? '${json.encode(realEndDate)}' : 'null'},"status": ${status != null ? '${json.encode(status)}' : 'null'},"updateDate": ${updateDate != null ? '${json.encode(updateDate)}' : 'null'},"createBy": $createBy,"plan": $plan,"user": $user}';
  }

  /// 获取任务状态的字典值
  /// 0.未开始，1.未完成，2.延期完成，3.按时完成，4.审批中，5.未执行，6.已确认(延期)，7.已确认(按时)，8.作废
  String get statusName {
    switch (status) {
      case '0':
        return '未开始';
      case '1':
        return '养护中';
      case '2':
      case '6':
        return '延期完成';
      case '3':
      case '7':
        return '按时完成';
      case '4':
        return '审批中';
      case '5':
        return '未执行';
      case '8':
        return '已关闭';
      default:
        return '';
    }
  }
}

/// 养护任务分页
class MaintainTaskPage {
  int count;
  int pageNo;
  int pageSize;
  List<MaintainTask> list;

  MaintainTaskPage.fromParams(
      {this.count, this.pageNo, this.pageSize, this.list});

  MaintainTaskPage.fromJson(jsonRes) {
    count = jsonRes['count'];
    pageNo = jsonRes['pageNo'];
    pageSize = jsonRes['pageSize'];
    list = jsonRes['list'] == null ? null : [];

    for (var listItem in list == null ? [] : jsonRes['list']) {
      list.add(listItem == null ? null : MaintainTask.fromJson(listItem));
    }
  }

  @override
  String toString() {
    return '{"count": $count,"pageNo": $pageNo,"pageSize": $pageSize,"list": $list}';
  }
}
