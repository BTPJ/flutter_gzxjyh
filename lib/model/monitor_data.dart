import 'dart:convert' show json;

import 'package:flutter_gzxjyh/model/warn_config.dart';

/// 实时监测管理Entity
class MonitorData {
  double value;
  bool isNewRecord;
  WarnConfig config;

  MonitorData.fromParams({this.value, this.isNewRecord, this.config});

  MonitorData.fromJson(jsonRes) {
    value = jsonRes['value'];
    isNewRecord = jsonRes['isNewRecord'];
    config = jsonRes['config'] == null
        ? null
        : new WarnConfig.fromJson(jsonRes['config']);
  }

  @override
  String toString() {
    return '{"value": $value,"isNewRecord": $isNewRecord,"config": $config}';
  }
}
