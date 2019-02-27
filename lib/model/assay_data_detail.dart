import 'dart:convert' show json;

class AssayDataDetail {
  static const int TYPE_0 = 0;
  static const int TYPE_1 = 1;

  AssayDataDetail();

  AssayDataDetail.itemType(int itemType){
    this.itemType = itemType;
  }

  double maxVal;
  double minVal;
  double dataVal;
  bool isNewRecord;
  String planItemName;
  String planTypeName;
  String relationId;
  String type;
  String unit;
  String remarks;
  String wqdataType;

  /// app自建,类型
  int itemType;

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
        this.remarks,
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
    remarks = jsonRes['remarks'];
    wqdataType = jsonRes['wqdataType'];
  }

  @override
  String toString() {
    return '{\"maxVal\": \"${maxVal == null ? "" : maxVal}\", \"minVal\": \"${minVal == null ? "" : minVal}\", \"dataVal\": \"${dataVal == null ? "" : dataVal}\", \"isNewRecord\": \"$isNewRecord\", \"planItemName\": \"${planItemName == null ? "" : planItemName}\", \"planTypeName\": \"${planTypeName == null ? "" : planTypeName}\", \"relationId\": \"${relationId == null ? "" : relationId}\", \"type\": \"${type == null ? "" : type}\", \"unit\": \"${unit == null ? "" : unit}\", \"remarks\": \"${remarks == null ? "" : remarks}\", \"wqdataType\": \"${wqdataType == null ? "" : wqdataType}\", \"assayList\": \"${assayList == null ? "" : assayList}\"}';
  }
}
