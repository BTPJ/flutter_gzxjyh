import 'dart:convert' show json;

import 'package:flutter_gzxjyh/model/produce_data_detail.dart';
import 'package:flutter_gzxjyh/model/user.dart';

/// 国祯巡检生产数据Entity
class ProduceData {

  bool isNewRecord;
  String collectTime;
  String createDate;
  String id;
  String name;
  String siteId;
  String status;
  String statusName;
  String updateDate;
  List<ProduceDataDetail> medList;
  List<ProduceDataDetail> othList;
  List<ProduceDataDetail> proList;
  User audit;
  User createBy;

  ProduceData.fromParams({this.isNewRecord, this.collectTime, this.createDate, this.id, this.name, this.siteId, this.status, this.statusName, this.updateDate, this.medList, this.othList, this.proList, this.audit, this.createBy});

  factory ProduceData(jsonStr) => jsonStr == null ? null : jsonStr is String ? new ProduceData.fromJson(json.decode(jsonStr)) : new ProduceData.fromJson(jsonStr);

  ProduceData.fromJson(jsonRes) {
    isNewRecord = jsonRes['isNewRecord'];
    collectTime = jsonRes['collectTime'];
    createDate = jsonRes['createDate'];
    id = jsonRes['id'];
    name = jsonRes['name'];
    siteId = jsonRes['siteId'];
    status = jsonRes['status'];
    statusName = jsonRes['statusName'];
    updateDate = jsonRes['updateDate'];
    medList = jsonRes['medList'] == null ? null : [];

    for (var medListItem in medList == null ? [] : jsonRes['medList']){
      medList.add(medListItem == null ? null : new ProduceDataDetail.fromJson(medListItem));
    }

    othList = jsonRes['othList'] == null ? null : [];

    for (var othListItem in othList == null ? [] : jsonRes['othList']){
      othList.add(othListItem == null ? null : new ProduceDataDetail.fromJson(othListItem));
    }

    proList = jsonRes['proList'] == null ? null : [];

    for (var proListItem in proList == null ? [] : jsonRes['proList']){
      proList.add(proListItem == null ? null : new ProduceDataDetail.fromJson(proListItem));
    }

    audit = jsonRes['audit'] == null ? null : new User.fromJson(jsonRes['audit']);
    createBy = jsonRes['createBy'] == null ? null : new User.fromJson(jsonRes['createBy']);
  }

  @override
  String toString() {
    return '{"isNewRecord": $isNewRecord,"collectTime": ${collectTime != null?'${json.encode(collectTime)}':'null'},"createDate": ${createDate != null?'${json.encode(createDate)}':'null'},"id": ${id != null?'${json.encode(id)}':'null'},"name": ${name != null?'${json.encode(name)}':'null'},"siteId": ${siteId != null?'${json.encode(siteId)}':'null'},"status": ${status != null?'${json.encode(status)}':'null'},"statusName": ${statusName != null?'${json.encode(statusName)}':'null'},"updateDate": ${updateDate != null?'${json.encode(updateDate)}':'null'},"medList": $medList,"othList": $othList,"proList": $proList,"audit": $audit,"createBy": $createBy}';
  }
}