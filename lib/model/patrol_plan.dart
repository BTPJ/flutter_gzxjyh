import 'dart:convert' show json;

/// 巡检计划Entity
class PatrolPlan {
  bool current;
  bool isNewRecord;
  String id;
  String name;

  PatrolPlan.fromParams({this.current, this.isNewRecord, this.id, this.name});

  PatrolPlan.fromJson(jsonRes) {
    current = jsonRes['current'];
    isNewRecord = jsonRes['isNewRecord'];
    id = jsonRes['id'];
    name = jsonRes['name'];
  }

  @override
  String toString() {
    return '{"current": $current,"isNewRecord": $isNewRecord,"id": ${id != null ? '${json.encode(id)}' : 'null'},"name": ${name != null ? '${json.encode(name)}' : 'null'}}';
  }
}
