import 'dart:convert' show json;

import 'package:flutter_gzxjyh/model/user.dart';

/// 通知公告信息Entity
class NotifyInfo {
  int readNum;
  int unReadNum;
  bool isNewRecord;
  String accepterIds;
  String accepterNames;
  String content;
  String createDate;
  String haveRead;
  String id;
  String title;
  String type;
  String typeName;
  User createBy;

  NotifyInfo.fromParams(
      {this.readNum,
      this.unReadNum,
      this.isNewRecord,
      this.accepterIds,
      this.accepterNames,
      this.content,
      this.createDate,
      this.haveRead,
      this.id,
      this.title,
      this.type,
      this.typeName,
      this.createBy});

  factory NotifyInfo(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new NotifyInfo.fromJson(json.decode(jsonStr))
          : new NotifyInfo.fromJson(jsonStr);

  NotifyInfo.fromJson(jsonRes) {
    readNum = jsonRes['readNum'];
    unReadNum = jsonRes['unReadNum'];
    isNewRecord = jsonRes['isNewRecord'];
    accepterIds = jsonRes['accepterIds'];
    accepterNames = jsonRes['accepterNames'];
    content = jsonRes['content'];
    createDate = jsonRes['createDate'];
    haveRead = jsonRes['haveRead'];
    id = jsonRes['id'];
    title = jsonRes['title'];
    type = jsonRes['type'];
    typeName = jsonRes['typeName'];
    createBy = jsonRes['createBy'] == null
        ? null
        : new User.fromJson(jsonRes['createBy']);
  }

  @override
  String toString() {
    return '{"readNum": $readNum,"unReadNum": $unReadNum,"isNewRecord": $isNewRecord,"accepterIds": ${accepterIds != null ? '${json.encode(accepterIds)}' : 'null'},"accepterNames": ${accepterNames != null ? '${json.encode(accepterNames)}' : 'null'},"content": ${content != null ? '${json.encode(content)}' : 'null'},"createDate": ${createDate != null ? '${json.encode(createDate)}' : 'null'},"haveRead": ${haveRead != null ? '${json.encode(haveRead)}' : 'null'},"id": ${id != null ? '${json.encode(id)}' : 'null'},"title": ${title != null ? '${json.encode(title)}' : 'null'},"type": ${type != null ? '${json.encode(type)}' : 'null'},"typeName": ${typeName != null ? '${json.encode(typeName)}' : 'null'},"createBy": $createBy}';
  }
}

/// 分页
class NotifyInfoPage {
  int count;
  int pageNo;
  int pageSize;
  List<NotifyInfo> list;

  NotifyInfoPage.fromParams(
      {this.count, this.pageNo, this.pageSize, this.list});

  NotifyInfoPage.fromJson(jsonRes) {
    count = jsonRes['count'];
    pageNo = jsonRes['pageNo'];
    pageSize = jsonRes['pageSize'];
    list = jsonRes['list'] == null ? null : [];

    for (var listItem in list == null ? [] : jsonRes['list']) {
      list.add(listItem == null ? null : new NotifyInfo.fromJson(listItem));
    }
  }

  @override
  String toString() {
    return '{"count": $count,"pageNo": $pageNo,"pageSize": $pageSize,"list": $list}';
  }
}
