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
  String startDate;
  HistoryWarnPage historyWarn;
  HistoryDataPage historyData;
  double latitude;
  double longitude;
  String address;
  String type;
  String status;
  String updateDate;
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
      this.startDate,
      this.updateDate,
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
    isNewRecord = jsonRes['isNewRecord'];
    address = jsonRes['address'];
    type = jsonRes['type'];
    status = jsonRes['status'];
    name = jsonRes['name'];
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
    return 'SiteInfo{isNewRecord: $isNewRecord, endDate: $endDate, id: $id, name: $name, startDate: $startDate, historyWarn: $historyWarn, historyData: $historyData, latitude: $latitude, longitude: $longitude, address: $address, type: $type, status: $status, updateDate: $updateDate, zone: $zone}';
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
