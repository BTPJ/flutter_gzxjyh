import 'dart:convert' show json;

class ItemInfo {
  bool isNewRecord;
  String createDate;
  String id;
  String isFix;
  String name;
  String type;

  ItemInfo.fromParams(
      {this.isNewRecord,
      this.createDate,
      this.id,
      this.isFix,
      this.name,
      this.type});

  ItemInfo.fromJson(jsonRes) {
    isNewRecord = jsonRes['isNewRecord'];
    createDate = jsonRes['createDate'];
    id = jsonRes['id'];
    isFix = jsonRes['isFix'];
    name = jsonRes['name'];
    type = jsonRes['type'];
  }

  @override
  String toString() {
    return '{"isNewRecord": $isNewRecord,"createDate": ${createDate != null ? '${json.encode(createDate)}' : 'null'},"id": ${id != null ? '${json.encode(id)}' : 'null'},"isFix": ${isFix != null ? '${json.encode(isFix)}' : 'null'},"name": ${name != null ? '${json.encode(name)}' : 'null'},"type": ${type != null ? '${json.encode(type)}' : 'null'}}';
  }
}
