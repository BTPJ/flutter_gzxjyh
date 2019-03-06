import 'dart:convert' show json;

import 'package:flutter_gzxjyh/model/site_info.dart';
import 'package:flutter_gzxjyh/model/warn_attention.dart';
import 'package:flutter_gzxjyh/model/warn_config.dart';

/// 站点报警详情
class CurrentWarn {
  double value;
  bool isNewRecord;
  String code;
  String confirmStatus;
  String createDate;
  String id;
  String normals;
  String startDate;
  String type;
  String typeName;
  WarnConfig config;
  WarnAttention attention;
  SiteInfo site;

  CurrentWarn.fromParams(
      {this.value,
      this.isNewRecord,
      this.code,
      this.confirmStatus,
      this.createDate,
      this.id,
      this.normals,
      this.startDate,
      this.type,
      this.typeName,
      this.config,
      this.attention,
      this.site});

  factory CurrentWarn(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new CurrentWarn.fromJson(json.decode(jsonStr))
          : new CurrentWarn.fromJson(jsonStr);

  CurrentWarn.fromJson(jsonRes) {
    value = jsonRes['value'];
    isNewRecord = jsonRes['isNewRecord'];
    code = jsonRes['code'];
    confirmStatus = jsonRes['confirmStatus'];
    createDate = jsonRes['createDate'];
    id = jsonRes['id'];
    normals = jsonRes['normals'];
    startDate = jsonRes['startDate'];
    type = jsonRes['type'];
    typeName = jsonRes['typeName'];
    config = jsonRes['config'] == null
        ? null
        : new WarnConfig.fromJson(jsonRes['config']);
    attention = jsonRes['attention'] == null
        ? null
        : new WarnAttention.fromJson(jsonRes['attention']);
    site =
        jsonRes['site'] == null ? null : new SiteInfo.fromJson(jsonRes['site']);
  }

  @override
  String toString() {
    return '{"value": $value,"isNewRecord": $isNewRecord,"code": ${code != null ? '${json.encode(code)}' : 'null'},"confirmStatus": ${confirmStatus != null ? '${json.encode(confirmStatus)}' : 'null'},"createDate": ${createDate != null ? '${json.encode(createDate)}' : 'null'},"id": ${id != null ? '${json.encode(id)}' : 'null'},"normals": ${normals != null ? '${json.encode(normals)}' : 'null'},"startDate": ${startDate != null ? '${json.encode(startDate)}' : 'null'},"type": ${type != null ? '${json.encode(type)}' : 'null'},"typeName": ${typeName != null ? '${json.encode(typeName)}' : 'null'},"config": $config,"site": $site}';
  }
}
