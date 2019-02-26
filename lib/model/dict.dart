import 'dart:convert' show json;

/// 字典实体
class Dict {
  int sort;
  bool isNewRecord;
  String createDate;
  String description;
  String id;
  String label;
  String moduleId;
  String parentId;
  String remarks;
  String type;
  String updateDate;
  String value;

  Dict.fromParams(
      {this.sort,
      this.isNewRecord,
      this.createDate,
      this.description,
      this.id,
      this.label,
      this.moduleId,
      this.parentId,
      this.remarks,
      this.type,
      this.updateDate,
      this.value});

  factory Dict(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new Dict.fromJson(json.decode(jsonStr))
          : new Dict.fromJson(jsonStr);

  Dict.fromJson(jsonRes) {
    sort = jsonRes['sort'];
    isNewRecord = jsonRes['isNewRecord'];
    createDate = jsonRes['createDate'];
    description = jsonRes['description'];
    id = jsonRes['id'];
    label = jsonRes['label'];
    moduleId = jsonRes['moduleId'];
    parentId = jsonRes['parentId'];
    remarks = jsonRes['remarks'];
    type = jsonRes['type'];
    updateDate = jsonRes['updateDate'];
    value = jsonRes['value'];
  }

  @override
  String toString() {
    return '{"sort": $sort,"isNewRecord": $isNewRecord,"createDate": ${createDate != null ? '${json.encode(createDate)}' : 'null'},"description": ${description != null ? '${json.encode(description)}' : 'null'},"id": ${id != null ? '${json.encode(id)}' : 'null'},"label": ${label != null ? '${json.encode(label)}' : 'null'},"moduleId": ${moduleId != null ? '${json.encode(moduleId)}' : 'null'},"parentId": ${parentId != null ? '${json.encode(parentId)}' : 'null'},"remarks": ${remarks != null ? '${json.encode(remarks)}' : 'null'},"type": ${type != null ? '${json.encode(type)}' : 'null'},"updateDate": ${updateDate != null ? '${json.encode(updateDate)}' : 'null'},"value": ${value != null ? '${json.encode(value)}' : 'null'}}';
  }
}
