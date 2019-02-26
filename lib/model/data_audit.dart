import 'dart:convert' show json;

class DataAudit {
  bool isNewRecord;
  String id;

  DataAudit.fromParams({this.isNewRecord, this.id});

  DataAudit.fromJson(jsonRes) {
    isNewRecord = jsonRes['isNewRecord'];
    id = jsonRes['id'];
  }

  @override
  String toString() {
    return '{"isNewRecord": $isNewRecord,"id": ${id != null ? '${json.encode(id)}' : 'null'}}';
  }
}
