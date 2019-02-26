import 'dart:convert' show json;

/// 国祯巡检年生产计划详情Entity
class ProducePlanDetail {
  double numApr;
  double numAug;
  double numDec;
  double numFeb;
  double numJan;
  double numJul;
  double numJun;
  double numMar;
  double numMay;
  double numNov;
  double numOct;
  double numSep;
  double numYear;
  double numYearOfFact;
  bool isNewRecord;
  String id;
  String planId;
  String planItemName;
  String planTypeName;
  String relationId;
  String type;
  String unit;

  ProducePlanDetail.fromParams(
      {this.numApr,
      this.numAug,
      this.numDec,
      this.numFeb,
      this.numJan,
      this.numJul,
      this.numJun,
      this.numMar,
      this.numMay,
      this.numNov,
      this.numOct,
      this.numSep,
      this.numYear,
      this.isNewRecord,
      this.id,
      this.planId,
      this.planItemName,
      this.planTypeName,
      this.relationId,
      this.type,
      this.unit});

  factory ProducePlanDetail(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new ProducePlanDetail.fromJson(json.decode(jsonStr))
          : new ProducePlanDetail.fromJson(jsonStr);

  ProducePlanDetail.fromJson(jsonRes) {
    numApr = jsonRes['numApr'];
    numAug = jsonRes['numAug'];
    numDec = jsonRes['numDec'];
    numFeb = jsonRes['numFeb'];
    numJan = jsonRes['numJan'];
    numJul = jsonRes['numJul'];
    numJun = jsonRes['numJun'];
    numMar = jsonRes['numMar'];
    numMay = jsonRes['numMay'];
    numNov = jsonRes['numNov'];
    numOct = jsonRes['numOct'];
    numSep = jsonRes['numSep'];
    numYear = jsonRes['numYear'];
    numYearOfFact = jsonRes['numYearOfFact'];
    isNewRecord = jsonRes['isNewRecord'];
    id = jsonRes['id'];
    planId = jsonRes['planId'];
    planItemName = jsonRes['planItemName'];
    planTypeName = jsonRes['planTypeName'];
    relationId = jsonRes['relationId'];
    type = jsonRes['type'];
    unit = jsonRes['unit'];
  }

  @override
  String toString() {
    return '{"numApr": $numApr,"numAug": $numAug,"numDec": $numDec,"numFeb": $numFeb,"numJan": $numJan,"numJul": $numJul,"numJun": $numJun,"numMar": $numMar,"numMay": $numMay,"numNov": $numNov,"numOct": $numOct,"numSep": $numSep,"numYear": $numYear,"isNewRecord": $isNewRecord,"id": ${id != null ? '${json.encode(id)}' : 'null'},"planId": ${planId != null ? '${json.encode(planId)}' : 'null'},"planItemName": ${planItemName != null ? '${json.encode(planItemName)}' : 'null'},"planTypeName": ${planTypeName != null ? '${json.encode(planTypeName)}' : 'null'},"relationId": ${relationId != null ? '${json.encode(relationId)}' : 'null'},"type": ${type != null ? '${json.encode(type)}' : 'null'},"unit": ${unit != null ? '${json.encode(unit)}' : 'null'}}';
  }
}
