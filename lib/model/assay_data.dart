import 'dart:convert' show json;
import 'dart:ui';

import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/model/assay_data_detail.dart';
import 'package:flutter_gzxjyh/model/data_audit.dart';
import 'package:flutter_gzxjyh/model/user.dart';

class AssayData {
  bool isNewRecord;
  String assayer;
  String collectTime;
  String createDate;
  String id;
  String name;
  String siteId;
  String status;
  String statusName;
  String updateDate;
  DataAudit audit;
  User createBy;
  String assayType;
  String itemIds;
  String siteName;
  List<AssayDataDetail> tList;
  List<AssayDataDetail> swList;
  List<AssayDataDetail> wnList;
  List<AssayDataDetail> tsList;

  Color get statusColor {
    switch (status) {
      case '0':
        return MyColors.FF2EAFFF;
      default:
        return MyColors.FF999999;
    }
  }

  AssayData.fromParams({
    this.isNewRecord,
    this.assayer,
    this.collectTime,
    this.createDate,
    this.id,
    this.name,
    this.siteId,
    this.status,
    this.statusName,
    this.updateDate,
    this.audit,
    this.createBy,
    this.assayType,
    this.itemIds,
    this.siteName,
    this.tList,
    this.swList,
    this.wnList,
    this.tsList,
  });

  AssayData.fromJson(jsonRes) {
    isNewRecord = jsonRes['isNewRecord'];
    assayer = jsonRes['assayer'];
    collectTime = jsonRes['collectTime'];
    createDate = jsonRes['createDate'];
    id = jsonRes['id'];
    name = jsonRes['name'];
    siteId = jsonRes['siteId'];
    status = jsonRes['status'];
    statusName = jsonRes['statusName'];
    updateDate = jsonRes['updateDate'];
    audit = jsonRes['audit'] == null
        ? null
        : new DataAudit.fromJson(jsonRes['audit']);
    createBy = jsonRes['createBy'] == null
        ? null
        : new User.fromJson(jsonRes['createBy']);
    assayType = jsonRes['assayType'];
    itemIds = jsonRes['itemIds'];
    siteName = jsonRes['siteName'];
    tList = jsonRes['tList'] == null ? null : [];

    for (var tListItem in tList == null ? [] : jsonRes['tList']) {
      tList.add(
          tListItem == null ? null : new AssayDataDetail.fromJson(tListItem));
    }

    swList = jsonRes['swList'] == null ? null : [];

    for (var swListItem in swList == null ? [] : jsonRes['swList']) {
      swList.add(
          swListItem == null ? null : new AssayDataDetail.fromJson(swListItem));
    }

    wnList = jsonRes['wnList'] == null ? null : [];

    for (var wnListItem in wnList == null ? [] : jsonRes['wnList']) {
      wnList.add(
          wnListItem == null ? null : new AssayDataDetail.fromJson(wnListItem));
    }

    tsList = jsonRes['tsList'] == null ? null : [];

    for (var tsListItem in tsList == null ? [] : jsonRes['tsList']) {
      tsList.add(
          tsListItem == null ? null : new AssayDataDetail.fromJson(tsListItem));
    }
  }

  @override
  String toString() {
    return 'AssayData{isNewRecord: $isNewRecord, assayer: $assayer, collectTime: $collectTime, createDate: $createDate, id: $id, name: $name, siteId: $siteId, status: $status, statusName: $statusName, updateDate: $updateDate, audit: $audit, createBy: $createBy, assayType: $assayType, itemIds: $itemIds, siteName: $siteName, tList: $tList, swList: $swList, wnList: $wnList, tsList: $tsList}';
  }
}
