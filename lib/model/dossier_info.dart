import 'dart:convert' show json;

import 'package:flutter_gzxjyh/model/user.dart';

/// 案卷信息Entity
class DossierInfo {
  int flowNum;
  double latitude;
  double longitude;
  bool isNewRecord;
  bool self;
  String address;
  String code;
  String createDate;
  String describe;
  String id;
  String level;
  String levelName;
  String name;
  String pointId;
  String pointName;
  String source;
  String sourceName;
  String status;
  String statusName;
  String taskId;
  String taskName;
  String type;
  String typeName;
  String updateDate;
  String uploadDate;
  User createBy;
  User currentDealUser;
  User uploadBy;

  DossierInfo.fromParams(
      {this.flowNum,
      this.latitude,
      this.longitude,
      this.isNewRecord,
      this.self,
      this.address,
      this.code,
      this.createDate,
      this.describe,
      this.id,
      this.level,
      this.levelName,
      this.name,
      this.pointId,
      this.pointName,
      this.source,
      this.sourceName,
      this.status,
      this.statusName,
      this.taskId,
      this.taskName,
      this.type,
      this.typeName,
      this.updateDate,
      this.uploadDate,
      this.createBy,
      this.currentDealUser,
      this.uploadBy});

  factory DossierInfo(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new DossierInfo.fromJson(json.decode(jsonStr))
          : new DossierInfo.fromJson(jsonStr);

  DossierInfo.fromJson(jsonRes) {
    flowNum = jsonRes['flowNum'];
    latitude = jsonRes['latitude'];
    longitude = jsonRes['longitude'];
    isNewRecord = jsonRes['isNewRecord'];
    self = jsonRes['self'];
    address = jsonRes['address'];
    code = jsonRes['code'];
    createDate = jsonRes['createDate'];
    describe = jsonRes['describe'];
    id = jsonRes['id'];
    level = jsonRes['level'];
    levelName = jsonRes['levelName'];
    name = jsonRes['name'];
    pointId = jsonRes['pointId'];
    pointName = jsonRes['pointName'];
    source = jsonRes['source'];
    sourceName = jsonRes['sourceName'];
    status = jsonRes['status'];
    statusName = jsonRes['statusName'];
    taskId = jsonRes['taskId'];
    taskName = jsonRes['taskName'];
    type = jsonRes['type'];
    typeName = jsonRes['typeName'];
    updateDate = jsonRes['updateDate'];
    uploadDate = jsonRes['uploadDate'];
    createBy = jsonRes['createBy'] == null
        ? null
        : new User.fromJson(jsonRes['createBy']);
    currentDealUser = jsonRes['currentDealUser'] == null
        ? null
        : new User.fromJson(jsonRes['currentDealUser']);
    uploadBy = jsonRes['uploadBy'] == null
        ? null
        : new User.fromJson(jsonRes['uploadBy']);
  }

  @override
  String toString() {
    return '{"flowNum": $flowNum,"latitude": $latitude,"longitude": $longitude,"isNewRecord": $isNewRecord,"self": $self,"address": ${address != null ? '${json.encode(address)}' : 'null'},"code": ${code != null ? '${json.encode(code)}' : 'null'},"createDate": ${createDate != null ? '${json.encode(createDate)}' : 'null'},"describe": ${describe != null ? '${json.encode(describe)}' : 'null'},"id": ${id != null ? '${json.encode(id)}' : 'null'},"level": ${level != null ? '${json.encode(level)}' : 'null'},"levelName": ${levelName != null ? '${json.encode(levelName)}' : 'null'},"name": ${name != null ? '${json.encode(name)}' : 'null'},"pointId": ${pointId != null ? '${json.encode(pointId)}' : 'null'},"pointName": ${pointName != null ? '${json.encode(pointName)}' : 'null'},"source": ${source != null ? '${json.encode(source)}' : 'null'},"sourceName": ${sourceName != null ? '${json.encode(sourceName)}' : 'null'},"status": ${status != null ? '${json.encode(status)}' : 'null'},"statusName": ${statusName != null ? '${json.encode(statusName)}' : 'null'},"taskId": ${taskId != null ? '${json.encode(taskId)}' : 'null'},"taskName": ${taskName != null ? '${json.encode(taskName)}' : 'null'},"type": ${type != null ? '${json.encode(type)}' : 'null'},"typeName": ${typeName != null ? '${json.encode(typeName)}' : 'null'},"updateDate": ${updateDate != null ? '${json.encode(updateDate)}' : 'null'},"uploadDate": ${uploadDate != null ? '${json.encode(uploadDate)}' : 'null'},"createBy": $createBy,"currentDealUser": $currentDealUser,"uploadBy": $uploadBy}';
  }
}

/// 案卷任务分页
class DossierInfoPage {
  int count;
  int pageNo;
  int pageSize;
  List<DossierInfo> list;

  DossierInfoPage.fromParams(
      {this.count, this.pageNo, this.pageSize, this.list});

  DossierInfoPage.fromJson(jsonRes) {
    count = jsonRes['count'];
    pageNo = jsonRes['pageNo'];
    pageSize = jsonRes['pageSize'];
    list = jsonRes['list'] == null ? null : [];

    for (var listItem in list == null ? [] : jsonRes['list']) {
      list.add(listItem == null ? null : DossierInfo.fromJson(listItem));
    }
  }

  @override
  String toString() {
    return '{"count": $count,"pageNo": $pageNo,"pageSize": $pageSize,"list": $list}';
  }
}
