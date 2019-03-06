import 'dart:convert' show json;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/model/patrol_line.dart';
import 'package:flutter_gzxjyh/model/patrol_plan.dart';
import 'package:flutter_gzxjyh/model/patrol_task_flow.dart';
import 'package:flutter_gzxjyh/model/user.dart';
import 'package:flutter_gzxjyh/utils/date_util.dart';

/// 巡检任务
class PatrolTask {

  bool isNewRecord;
  String createDate;
  String flowId;
  String id;
  String name;
  String planBeginDate;
  String planEndDate;
  String realBeginDate;
  String realEndDate;
  String status;
  String updateDate;
  List<PatrolTaskFlow> flowList;
  User createBy;
  PatrolLine line;
  PatrolPlan plan;
  User user;

  PatrolTask.fromParams({this.isNewRecord, this.createDate, this.flowId, this.id, this.name, this.planBeginDate, this.planEndDate, this.realBeginDate, this.status, this.updateDate, this.flowList, this.createBy, this.line, this.plan, this.user});

  factory PatrolTask(jsonStr) => jsonStr == null ? null : jsonStr is String ? new PatrolTask.fromJson(json.decode(jsonStr)) : new PatrolTask.fromJson(jsonStr);

  PatrolTask.fromJson(jsonRes) {
    isNewRecord = jsonRes['isNewRecord'];
    createDate = jsonRes['createDate'];
    flowId = jsonRes['flowId'];
    id = jsonRes['id'];
    name = jsonRes['name'];
    planBeginDate = jsonRes['planBeginDate'];
    planEndDate = jsonRes['planEndDate'];
    realBeginDate = jsonRes['realBeginDate'];
    realEndDate = jsonRes['realEndDate'];
    status = jsonRes['status'];
    updateDate = jsonRes['updateDate'];
    flowList = jsonRes['flowList'] == null ? null : [];

    for (var flowListItem in flowList == null ? [] : jsonRes['flowList']){
      flowList.add(flowListItem == null ? null : new PatrolTaskFlow.fromJson(flowListItem));
    }

    createBy = jsonRes['createBy'] == null ? null : new User.fromJson(jsonRes['createBy']);
    line = jsonRes['line'] == null ? null : new PatrolLine.fromJson(jsonRes['line']);
    plan = jsonRes['plan'] == null ? null : new PatrolPlan.fromJson(jsonRes['plan']);
    user = jsonRes['user'] == null ? null : new User.fromJson(jsonRes['user']);
  }

  @override
  String toString() {
    return '{"isNewRecord": $isNewRecord,"createDate": ${createDate != null?'${json.encode(createDate)}':'null'},"flowId": ${flowId != null?'${json.encode(flowId)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"planBeginDate": ${planBeginDate != null?'${json.encode(planBeginDate)}':'null'},"planEndDate": ${planEndDate != null?'${json.encode(planEndDate)}':'null'},"realBeginDate": ${realBeginDate != null?'${json.encode(realBeginDate)}':'null'},"status": ${status != null?'${json.encode(status)}':'null'},"updateDate": ${updateDate != null?'${json.encode(updateDate)}':'null'},"flowList": $flowList,"createBy": $createBy,"line": $line,"plan": $plan,"user": $user}';
  }

  /// 获取任务状态的字典值
  /// 0.未开始，1.未完成，2.延期完成，3.按时完成，4.审批中，5.未执行，6.已确认(延期)，7.已确认(按时)，8.作废
  String get statusName {
    switch (status) {
      case '0':
        return '未开始';
      case '1':
        return '巡检中';
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

  /// 任务开始状态（正常进行，即将到期，已延期）
  String get timeFlag {
    if (status == '1' && planEndDate != null && planEndDate.isNotEmpty) {
      var spaceMinutes = DateUtil.getMinutesSpaceFromNow(planEndDate);
      if (spaceMinutes <= 0) {
        return '已  延  期';
      }
      if (spaceMinutes <= 30 * 60 * 1000) {
        return '即将到期';
      }
      if (spaceMinutes > 30 * 60 * 1000) {
        return '正常进行';
      } else
        return '';
    } else {
      return '';
    }
  }

  /// 任务开始状态的显示颜色值（正常进行，即将到期，已延期）
  Color get timeFlagColor {
    switch (timeFlag) {
      case '正常进行':
        return MyColors.FF3DD1AD;
      case '即将到期':
        return MyColors.FFFF9800;
      case '已  延  期':
        return MyColors.FFE51C23;
      default:
        return MyColors.FF3DD1AD;
    }
  }
}

/// 巡检任务分页
class PatrolTaskPage {
  int count;
  int pageNo;
  int pageSize;
  List<PatrolTask> list;

  PatrolTaskPage.fromParams(
      {this.count, this.pageNo, this.pageSize, this.list});

  PatrolTaskPage.fromJson(jsonRes) {
    count = jsonRes['count'];
    pageNo = jsonRes['pageNo'];
    pageSize = jsonRes['pageSize'];
    list = jsonRes['list'] == null ? null : [];

    for (var listItem in list == null ? [] : jsonRes['list']) {
      list.add(listItem == null ? null : PatrolTask.fromJson(listItem));
    }
  }

  @override
  String toString() {
    return '{"count": $count,"pageNo": $pageNo,"pageSize": $pageSize,"list": $list}';
  }
}
