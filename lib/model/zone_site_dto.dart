import 'dart:convert' show json;

import 'package:flutter_gzxjyh/model/site_info.dart';

/// 污水厂选择
class ZoneSiteDto {
  bool isNewRecord;
  String name;
  String zoneId;
  List<SiteInfo> siteList;

  ZoneSiteDto.fromParams(
      {this.isNewRecord, this.name, this.zoneId, this.siteList});

  factory ZoneSiteDto(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new ZoneSiteDto.fromJson(json.decode(jsonStr))
          : new ZoneSiteDto.fromJson(jsonStr);

  ZoneSiteDto.fromJson(jsonRes) {
    isNewRecord = jsonRes['isNewRecord'];
    name = jsonRes['name'];
    zoneId = jsonRes['zoneId'];
    siteList = jsonRes['siteList'] == null ? null : [];

    for (var siteListItem in siteList == null ? [] : jsonRes['siteList']) {
      siteList.add(
          siteListItem == null ? null : new SiteInfo.fromJson(siteListItem));
    }
  }

  @override
  String toString() {
    return '{"isNewRecord": $isNewRecord,"name": ${name != null ? '${json.encode(name)}' : 'null'},"zoneId": ${zoneId != null ? '${json.encode(zoneId)}' : 'null'},"siteList": $siteList}';
  }
}
