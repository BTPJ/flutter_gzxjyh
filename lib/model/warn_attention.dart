import 'dart:convert' show json;

import 'package:flutter_gzxjyh/model/current_warn.dart';

/// 实时监测管理Entity
class WarnAttention {
  bool isNewRecord;
  String id;
  CurrentWarn warn;

  WarnAttention.fromParams({this.isNewRecord, this.id, this.warn});

  factory WarnAttention(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
      ? new WarnAttention.fromJson(json.decode(jsonStr))
      : new WarnAttention.fromJson(jsonStr);

  WarnAttention.fromJson(jsonRes) {
    isNewRecord = jsonRes['isNewRecord'];
    id = jsonRes['id'];

    warn = jsonRes['warn'] == null
        ? null
        : new CurrentWarn.fromJson(jsonRes['warn']);
  }

}
