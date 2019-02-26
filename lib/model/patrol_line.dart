import 'dart:convert' show json;

/// 巡检线路信息Entity
class PatrolLine {
  bool isNewRecord;
  String id;
  String name;
  String pointNames;

  PatrolLine.fromParams(
      {this.isNewRecord, this.id, this.name, this.pointNames});

  PatrolLine.fromJson(jsonRes) {
    isNewRecord = jsonRes['isNewRecord'];
    id = jsonRes['id'];
    name = jsonRes['name'];
    pointNames = jsonRes['pointNames'];
  }

  @override
  String toString() {
    return '{"isNewRecord": $isNewRecord,"id": ${id != null ? '${json.encode(id)}' : 'null'},"name": ${name != null ? '${json.encode(name)}' : 'null'},"pointNames": ${pointNames != null ? '${json.encode(pointNames)}' : 'null'}}';
  }
}
