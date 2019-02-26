import 'dart:convert' show json;

/// 国祯巡检生产数据详情Entity
class ProduceDataDetail {

  double beforeVal;
  double dataVal;
  bool isNewRecord;
  String id;
  String pdId;
  String planItemName;
  String planTypeName;
  String relationId;
  String remarks;
  String type;
  String unit;

  ProduceDataDetail.fromParams({this.beforeVal, this.dataVal, this.isNewRecord, this.id, this.pdId, this.planItemName, this.planTypeName, this.relationId, this.remarks, this.type, this.unit});

  ProduceDataDetail.fromJson(jsonRes) {
    beforeVal = jsonRes['beforeVal'];
    dataVal = jsonRes['dataVal'];
    isNewRecord = jsonRes['isNewRecord'];
    id = jsonRes['id'];
    pdId = jsonRes['pdId'];
    planItemName = jsonRes['planItemName'];
    planTypeName = jsonRes['planTypeName'];
    relationId = jsonRes['relationId'];
    remarks = jsonRes['remarks'];
    type = jsonRes['type'];
    unit = jsonRes['unit'];
  }

  @override
  String toString() {
    return '{"beforeVal": $beforeVal,"dataVal": $dataVal,"isNewRecord": $isNewRecord,"id": ${id != null?'${json.encode(id)}':'null'},"pdId": ${pdId != null?'${json.encode(pdId)}':'null'},"planItemName": ${planItemName != null?'${json.encode(planItemName)}':'null'},"planTypeName": ${planTypeName != null?'${json.encode(planTypeName)}':'null'},"relationId": ${relationId != null?'${json.encode(relationId)}':'null'},"remarks": ${remarks != null?'${json.encode(remarks)}':'null'},"type": ${type != null?'${json.encode(type)}':'null'},"unit": ${unit != null?'${json.encode(unit)}':'null'}}';
  }
}