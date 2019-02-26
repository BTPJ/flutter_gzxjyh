import 'dart:convert' show json;
import 'dart:ui';

import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/model/dossier_info.dart';
import 'package:flutter_gzxjyh/model/user.dart';
import 'package:flutter_gzxjyh/utils/date_util.dart';

/// 案卷任务
class DossierTask {
  bool isNewRecord;
  String createDate;
  String id;
  String planCompleteDate;
  String status;
  String updateDate;
  User createBy;
  DossierInfo dossier;
  User user;

  DossierTask.fromParams(
      {this.isNewRecord,
      this.createDate,
      this.id,
      this.planCompleteDate,
      this.status,
      this.updateDate,
      this.createBy,
      this.dossier,
      this.user});

  factory DossierTask(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new DossierTask.fromJson(json.decode(jsonStr))
          : new DossierTask.fromJson(jsonStr);

  DossierTask.fromJson(jsonRes) {
    isNewRecord = jsonRes['isNewRecord'];
    createDate = jsonRes['createDate'];
    id = jsonRes['id'];
    planCompleteDate = jsonRes['planCompleteDate'];
    status = jsonRes['status'];
    updateDate = jsonRes['updateDate'];
    createBy = jsonRes['createBy'] == null
        ? null
        : new User.fromJson(jsonRes['createBy']);
    dossier = jsonRes['dossier'] == null
        ? null
        : new DossierInfo.fromJson(jsonRes['dossier']);
    user = jsonRes['user'] == null ? null : new User.fromJson(jsonRes['user']);
  }

  /// 获取任务状态的字典值
  /// 0.待处理，1.已处理
  String get statusName {
    switch (status) {
      case '0':
        return '待处理';
      case '1':
        return '已处理';
      default:
        return '';
    }
  }

  /// 任务开始状态（正常进行，即将到期，已延期）
  String get timeFlag {
    if (planCompleteDate != null && planCompleteDate.isNotEmpty) {
      var spaceMinutes = DateUtil.getMinutesSpaceFromNow(planCompleteDate);
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

  @override
  String toString() {
    return '{"isNewRecord": $isNewRecord,"createDate": ${createDate != null ? '${json.encode(createDate)}' : 'null'},"id": ${id != null ? '${json.encode(id)}' : 'null'},"planCompleteDate": ${planCompleteDate != null ? '${json.encode(planCompleteDate)}' : 'null'},"status": ${status != null ? '${json.encode(status)}' : 'null'},"updateDate": ${updateDate != null ? '${json.encode(updateDate)}' : 'null'},"createBy": $createBy,"dossier": $dossier,"user": $user}';
  }
}
