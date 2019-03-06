import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/model/history_data.dart';
import 'package:flutter_gzxjyh/model/history_warn.dart';
import 'package:flutter_gzxjyh/model/monitor_data.dart';
import 'package:flutter_gzxjyh/model/zone_info.dart';

/// 站点信息Entity
class SiteInfo {
  bool isNewRecord;
  String endDate;
  String id;
  String name;
  String typeName;
  String startDate;
  HistoryWarnPage historyWarn;
  HistoryDataPage historyData;
  double latitude;
  double longitude;
  double elevation;
  double diameter;
  String address;
  String type;
  String status;
  String updateDate;
  String code;
  String size;
  String remarks;
  ZoneInfo zone;
  List<MonitorData> currentData;

  String get statusName {
    switch (status) {
      case '0':
        return "正常";
      case '1':
        return "异常";
      case '2':
        return "失联";
      default:
        return "";
    }
  }

  Color get statusColor {
    switch (status) {
      case '0':
        return MyColors.FF42D27B;
      case '1':
        return MyColors.FFFB7474;
      default:
        return MyColors.FF6F6D6D;
    }
  }

  SiteInfo.fromParams(
      {this.isNewRecord,
      this.endDate,
      this.id,
      this.name,
      this.typeName,
      this.startDate,
      this.updateDate,
      this.elevation,
      this.diameter,
      this.code,
      this.size,
      this.zone,
      this.remarks,
      this.historyWarn});

  factory SiteInfo(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new SiteInfo.fromJson(json.decode(jsonStr))
          : new SiteInfo.fromJson(jsonStr);

  SiteInfo.fromJson(jsonRes) {
    isNewRecord = jsonRes['isNewRecord'];
    endDate = jsonRes['endDate'];
    id = jsonRes['id'];
    latitude = jsonRes['latitude'];
    longitude = jsonRes['longitude'];
    elevation = jsonRes['elevation'];
    diameter = jsonRes['diameter'];
    isNewRecord = jsonRes['isNewRecord'];
    address = jsonRes['address'];
    type = jsonRes['type'];
    status = jsonRes['status'];
    name = jsonRes['name'];
    typeName = jsonRes['typeName'];
    remarks = jsonRes['remarks'];
    code = jsonRes['code'];
    size = jsonRes['size'];
    startDate = jsonRes['startDate'];
    updateDate = jsonRes['updateDate'];
    zone =
        jsonRes['zone'] == null ? null : new ZoneInfo.fromJson(jsonRes['zone']);
    historyWarn = jsonRes['historyWarn'] == null
        ? null
        : new HistoryWarnPage.fromJson(jsonRes['historyWarn']);
    historyData = jsonRes['historyData'] == null
        ? null
        : new HistoryDataPage.fromJson(jsonRes['historyData']);

    currentData = jsonRes['currentData'] == null ? null : [];

    for (var currentDataItem in currentData == null ? [] : jsonRes['currentData']) {
      currentData.add(
          currentDataItem == null ? null : new MonitorData.fromJson(currentDataItem));
    }
  }

  @override
  String toString() {
    return 'SiteInfo{isNewRecord: $isNewRecord, endDate: $endDate, id: $id, name: $name, typeName: $typeName, startDate: $startDate, historyWarn: $historyWarn, historyData: $historyData, latitude: $latitude, longitude: $longitude, address: $address, type: $type, status: $status, updateDate: $updateDate, code: $code, zone: $zone, currentData: $currentData}';
  }
}

/// 案卷任务分页
class SiteInfoPage {
  int count;
  int pageNo;
  int pageSize;
  List<SiteInfo> list;

  SiteInfoPage.fromParams(
      {this.count, this.pageNo, this.pageSize, this.list});

  SiteInfoPage.fromJson(jsonRes) {
    count = jsonRes['count'];
    pageNo = jsonRes['pageNo'];
    pageSize = jsonRes['pageSize'];
    list = jsonRes['list'] == null ? null : [];

    for (var listItem in list == null ? [] : jsonRes['list']) {
      list.add(listItem == null ? null : SiteInfo.fromJson(listItem));
    }
  }

  @override
  String toString() {
    return '{"count": $count,"pageNo": $pageNo,"pageSize": $pageSize,"list": $list}';
  }
}
