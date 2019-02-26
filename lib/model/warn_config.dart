import 'dart:convert' show json;

/// 告警配置管理Entity
class WarnConfig {
  int timeType;
  bool isNewRecord;
  String location;
  String type;
  String typeName;
  String unit;

  WarnConfig.fromParams(
      {this.timeType,
      this.isNewRecord,
      this.location,
      this.type,
      this.typeName,
      this.unit});

  WarnConfig.fromJson(jsonRes) {
    timeType = jsonRes['timeType'];
    isNewRecord = jsonRes['isNewRecord'];
    location = jsonRes['location'];
    type = jsonRes['type'];
    typeName = jsonRes['typeName'];
    unit = jsonRes['unit'];
  }

  @override
  String toString() {
    return '{"timeType": $timeType,"isNewRecord": $isNewRecord,"location": ${location != null ? '${json.encode(location)}' : 'null'},"type": ${type != null ? '${json.encode(type)}' : 'null'},"typeName": ${typeName != null ? '${json.encode(typeName)}' : 'null'},"unit": ${unit != null ? '${json.encode(unit)}' : 'null'}}';
  }
}
