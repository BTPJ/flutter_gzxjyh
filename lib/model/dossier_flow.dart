import 'dart:convert' show json;

import 'package:flutter_gzxjyh/model/user.dart';

/// 案卷操作流程Entity
class DossierFlow {
  bool isNewRecord;
  String createDate;
  String dossierId;
  String id;
  String operateType;
  String operateTypeName;
  String checkType;
  String checkTypeName;
  String updateDate;
  String remarks;
  String files;
  User createBy;

  DossierFlow.fromParams(
      {this.isNewRecord,
      this.createDate,
      this.dossierId,
      this.id,
      this.operateType,
      this.operateTypeName,
      this.updateDate,
      this.createBy});

  DossierFlow.fromJson(jsonRes) {
    isNewRecord = jsonRes['isNewRecord'];
    createDate = jsonRes['createDate'];
    dossierId = jsonRes['dossierId'];
    id = jsonRes['id'];
    operateType = jsonRes['operateType'];
    operateTypeName = jsonRes['operateTypeName'];
    checkType = jsonRes['checkType'];
    checkTypeName = jsonRes['checkTypeName'];
    updateDate = jsonRes['updateDate'];
    remarks = jsonRes['remarks'];
    files = jsonRes['files'];
    createBy = jsonRes['createBy'] == null
        ? null
        : new User.fromJson(jsonRes['createBy']);
  }

  @override
  String toString() {
    return '{"isNewRecord": $isNewRecord,"createDate": ${createDate != null ? '${json.encode(createDate)}' : 'null'},"dossierId": ${dossierId != null ? '${json.encode(dossierId)}' : 'null'},"id": ${id != null ? '${json.encode(id)}' : 'null'},"operateType": ${operateType != null ? '${json.encode(operateType)}' : 'null'},"operateTypeName": ${operateTypeName != null ? '${json.encode(operateTypeName)}' : 'null'},"updateDate": ${updateDate != null ? '${json.encode(updateDate)}' : 'null'},"createBy": $createBy}';
  }
}
