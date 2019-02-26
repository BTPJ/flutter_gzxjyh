import 'dart:convert' show json;

import 'package:flutter_gzxjyh/model/history_data.dart';
import 'package:flutter_gzxjyh/model/history_warn.dart';
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
  ZoneInfo zone;

  SiteInfo.fromParams(
      {this.isNewRecord,
      this.endDate,
      this.id,
      this.name,
      this.startDate,
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
    name = jsonRes['name'];
    startDate = jsonRes['startDate'];
    zone =
        jsonRes['zone'] == null ? null : new ZoneInfo.fromJson(jsonRes['zone']);
    historyWarn = jsonRes['historyWarn'] == null
        ? null
        : new HistoryWarnPage.fromJson(jsonRes['historyWarn']);
    historyData = jsonRes['historyData'] == null
        ? null
        : new HistoryDataPage.fromJson(jsonRes['historyData']);
  }

  @override
  String toString() {
    return '{"isNewRecord": $isNewRecord,"endDate": ${endDate != null ? '${json.encode(endDate)}' : 'null'},"id": ${id != null ? '${json.encode(id)}' : 'null'},"name": ${name != null ? '${json.encode(name)}' : 'null'},"startDate": ${startDate != null ? '${json.encode(startDate)}' : 'null'},"historyWarn": $historyWarn}';
  }
}
