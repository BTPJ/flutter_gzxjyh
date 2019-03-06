import 'dart:convert' show json;

/// 建设区域管理Entity
class ZoneInfo {
  bool isNewRecord;
  String id;
  String name;
  ZoneInfo parent;

  ZoneInfo.fromParams({this.isNewRecord, this.id, this.name, this.parent});

  ZoneInfo.fromJson(jsonRes) {
    isNewRecord = jsonRes['isNewRecord'];
    id = jsonRes['id'];
    name = jsonRes['name'];
    parent = jsonRes['parent'] == null
        ? null
        : new ZoneInfo.fromJson(jsonRes['parent']);
  }

  @override
  String toString() {
    return '{"isNewRecord": $isNewRecord,"id": ${id != null ? '${json.encode(id)}' : 'null'},"name": ${name != null ? '${json.encode(name)}' : 'null'}}';
  }
}
