import 'dart:convert' show json;

import 'package:flutter_gzxjyh/model/produce_plan_detail.dart';
import 'package:flutter_gzxjyh/model/user.dart';

/// 国祯巡检年生产计划表Entity
class ProducePlan {
  bool isNewRecord;
  String createDate;
  String id;
  String name;
  String planYear;
  String updateDate;
  List<ProducePlanDetail> prodList;
  List<ProducePlanDetail> medList;
  User createBy;

  ProducePlan.fromParams(
      {this.isNewRecord,
      this.createDate,
      this.id,
      this.name,
      this.planYear,
      this.updateDate,
      this.prodList,
      this.createBy});

  factory ProducePlan(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new ProducePlan.fromJson(json.decode(jsonStr))
          : new ProducePlan.fromJson(jsonStr);

  ProducePlan.fromJson(jsonRes) {
    isNewRecord = jsonRes['isNewRecord'];
    createDate = jsonRes['createDate'];
    id = jsonRes['id'];
    name = jsonRes['name'];
    planYear = jsonRes['planYear'];
    updateDate = jsonRes['updateDate'];
    prodList = jsonRes['prodList'] == null ? null : [];
    medList = jsonRes['medList'] == null ? null : [];

    for (var prodListItem in prodList == null ? [] : jsonRes['prodList']) {
      prodList.add(prodListItem == null
          ? null
          : new ProducePlanDetail.fromJson(prodListItem));
    }

    for (var medListItem in medList == null ? [] : jsonRes['medList']) {
      medList.add(medListItem == null
          ? null
          : new ProducePlanDetail.fromJson(medListItem));
    }

    createBy = jsonRes['createBy'] == null
        ? null
        : new User.fromJson(jsonRes['createBy']);
  }

  @override
  String toString() {
    return '{"isNewRecord": $isNewRecord,"createDate": ${createDate != null ? '${json.encode(createDate)}' : 'null'},"id": ${id != null ? '${json.encode(id)}' : 'null'},"name": ${name != null ? '${json.encode(name)}' : 'null'},"planYear": ${planYear != null ? '${json.encode(planYear)}' : 'null'},"updateDate": ${updateDate != null ? '${json.encode(updateDate)}' : 'null'},"prodList": $prodList,"createBy": $createBy}';
  }
}
