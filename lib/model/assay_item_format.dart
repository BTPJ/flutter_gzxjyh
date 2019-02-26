import 'package:flutter_gzxjyh/model/assay_type_dto.dart';
import 'package:flutter_gzxjyh/model/item_info.dart';

/// app自建 用于添加分析项
class AssayItemFormat {
  ItemInfo itemInfo;
  AssayTypeDto assayTypeDto;

  bool hasChecked = false;

  @override
  String toString() {
    return 'AssayItemFormat{itemInfo: $itemInfo, assayTypeDto: $assayTypeDto, hasChecked: $hasChecked}';
  }

  @override
  bool operator ==(other) {
    if (other is AssayItemFormat) {
      bool a = (itemInfo != null &&
              other.itemInfo != null &&
              itemInfo?.id == other.itemInfo?.id)
          ? true
          : (assayTypeDto != null &&
              other.assayTypeDto != null &&
              assayTypeDto?.assayType == other.assayTypeDto?.assayType);
      return a;
    } else {
      return false;
    }
  }
}
