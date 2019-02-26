import 'dart:convert' show json;

import 'package:flutter_gzxjyh/model/assay_type_dto.dart';
import 'package:flutter_gzxjyh/model/item_info.dart';

class AssayFormat {
  List<ItemInfo> itemList;
  List<AssayTypeDto> typeList;

  AssayFormat.fromParams({this.itemList, this.typeList});

  AssayFormat.fromJson(jsonRes) {
    itemList = jsonRes['itemList'] == null ? null : [];

    for (var itemListItem in itemList == null ? [] : jsonRes['itemList']) {
      itemList.add(
          itemListItem == null ? null : new ItemInfo.fromJson(itemListItem));
    }

    typeList = jsonRes['typeList'] == null ? null : [];

    for (var typeListItem in typeList == null ? [] : jsonRes['typeList']) {
      typeList.add(typeListItem == null
          ? null
          : new AssayTypeDto.fromJson(typeListItem));
    }
  }

  @override
  String toString() {
    return '{"itemList": $itemList,"typeList": $typeList}';
  }

//  List<AssayItemFormat> getList() {
//    List<AssayItemFormat> list = List();
//
//    for (var item in itemList) {
//      AssayItemFormat itemFormat = AssayItemFormat();
//      itemFormat.itemInfo = item;
//      list.add(itemFormat);
//    }
//    for (var type in typeList) {
//      AssayItemFormat itemFormat = AssayItemFormat();
//      itemFormat.assayTypeDto = type;
//      list.add(itemFormat);
//    }
//    return list;
//  }
}
