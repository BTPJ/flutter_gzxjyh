import 'dart:convert' show json;

class AssayTypeDto {
  bool isNewRecord;
  String assayType;
  String name;

  AssayTypeDto.fromParams({this.isNewRecord, this.assayType, this.name});

  AssayTypeDto.fromJson(jsonRes) {
    isNewRecord = jsonRes['isNewRecord'];
    assayType = jsonRes['assayType'];
    name = jsonRes['name'];
  }

  @override
  String toString() {
    return '{"isNewRecord": $isNewRecord,"assayType": ${assayType != null ? '${json.encode(assayType)}' : 'null'},"name": ${name != null ? '${json.encode(name)}' : 'null'}}';
  }
}
