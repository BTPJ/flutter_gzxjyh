import 'dart:convert' show json;

import 'package:flutter_gzxjyh/model/site_info.dart';
import 'package:flutter_gzxjyh/model/warn_config.dart';

/// 实时监测管理Entity
class HistoryWarn {
  double value;
  bool isNewRecord;
  String code;
  String createDate;
  String endDate;
  String id;
  String normals;
  String startDate;
  String type;
  String typeName;
  WarnConfig config;
  SiteInfo site;

  HistoryWarn.fromParams(
      {this.value,
      this.isNewRecord,
      this.code,
      this.createDate,
      this.endDate,
      this.id,
      this.normals,
      this.startDate,
      this.type,
      this.typeName,
      this.config,
      this.site});

  HistoryWarn.fromJson(jsonRes) {
    value = jsonRes['value'];
    isNewRecord = jsonRes['isNewRecord'];
    code = jsonRes['code'];
    createDate = jsonRes['createDate'];
    endDate = jsonRes['endDate'];
    id = jsonRes['id'];
    normals = jsonRes['normals'];
    startDate = jsonRes['startDate'];
    type = jsonRes['type'];
    typeName = jsonRes['typeName'];
    config = jsonRes['config'] == null
        ? null
        : new WarnConfig.fromJson(jsonRes['config']);
    site =
        jsonRes['site'] == null ? null : new SiteInfo.fromJson(jsonRes['site']);
  }

  @override
  String toString() {
    return '{"value": $value,"isNewRecord": $isNewRecord,"code": ${code != null ? '${json.encode(code)}' : 'null'},"createDate": ${createDate != null ? '${json.encode(createDate)}' : 'null'},"endDate": ${endDate != null ? '${json.encode(endDate)}' : 'null'},"id": ${id != null ? '${json.encode(id)}' : 'null'},"normals": ${normals != null ? '${json.encode(normals)}' : 'null'},"startDate": ${startDate != null ? '${json.encode(startDate)}' : 'null'},"type": ${type != null ? '${json.encode(type)}' : 'null'},"typeName": ${typeName != null ? '${json.encode(typeName)}' : 'null'},"config": $config,"site": $site}';
  }
}

/// 分页
class HistoryWarnPage {
  int count;
  int pageNo;
  int pageSize;
  List<HistoryWarn> list;

  HistoryWarnPage.fromParams(
      {this.count, this.pageNo, this.pageSize, this.list});

  HistoryWarnPage.fromJson(jsonRes) {
    count = jsonRes['count'];
    pageNo = jsonRes['pageNo'];
    pageSize = jsonRes['pageSize'];
    list = jsonRes['list'] == null ? null : [];

    for (var listItem in list == null ? [] : jsonRes['list']) {
      list.add(listItem == null ? null : new HistoryWarn.fromJson(listItem));
    }
  }

  @override
  String toString() {
    return '{"count": $count,"pageNo": $pageNo,"pageSize": $pageSize,"list": $list}';
  }
}
