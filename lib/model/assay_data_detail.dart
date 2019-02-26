import 'dart:convert' show json;

class AssayDataDetail {
  double maxVal;
  double minVal;
  double dataVal;
  bool isNewRecord;
  String planItemName;
  String planTypeName;
  String relationId;
  String type;
  String unit;
  String wqdataType;

  AssayDataDetail();

  /// app自建
  List<AssayDataDetail> assayList;

  AssayDataDetail.fromParams(
      {this.maxVal,
      this.minVal,
      this.dataVal,
      this.isNewRecord,
      this.planItemName,
      this.planTypeName,
      this.relationId,
      this.type,
      this.unit,
      this.wqdataType});

  AssayDataDetail.fromJson(jsonRes) {
    maxVal = jsonRes['maxVal'];
    minVal = jsonRes['minVal'];
    dataVal = jsonRes['dataVal'];
    isNewRecord = jsonRes['isNewRecord'];
    planItemName = jsonRes['planItemName'];
    planTypeName = jsonRes['planTypeName'];
    relationId = jsonRes['relationId'];
    type = jsonRes['type'];
    unit = jsonRes['unit'];
    wqdataType = jsonRes['wqdataType'];
  }

  @override
  String toString() {
    return 'AssayDataDetail{maxVal: $maxVal, minVal: $minVal, dataVal: $dataVal, isNewRecord: $isNewRecord, planItemName: $planItemName, planTypeName: $planTypeName, relationId: $relationId, type: $type, unit: $unit, wqdataType: $wqdataType, assayList: $assayList}';
  }
}
