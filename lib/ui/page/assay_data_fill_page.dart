import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/event/event_code.dart';
import 'package:flutter_gzxjyh/event/event_manager.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/assay_data.dart';
import 'package:flutter_gzxjyh/model/assay_data_detail.dart';
import 'package:flutter_gzxjyh/model/assay_item_format.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/model/site_info.dart';
import 'package:flutter_gzxjyh/ui/page/assay_item_page.dart';
import 'package:flutter_gzxjyh/ui/page/choose_sewage_page.dart';
import 'package:flutter_gzxjyh/ui/page/fill_assay_data_page.dart';
import 'package:flutter_gzxjyh/ui/page/fill_assay_data_water_temp_page.dart';
import 'package:flutter_gzxjyh/ui/widget/empty_view.dart';
import 'package:flutter_gzxjyh/utils/date_util.dart';
import 'package:flutter_gzxjyh/utils/toast_util.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_gzxjyh/utils/screen_util.dart';

/// 化验数据填报
class AssayDataFillPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AssayDataFillPageState();
}

class AssayDataFillPageState extends State<AssayDataFillPage> {
  /// 污水厂
  SiteInfo _mSite;

  /// 化验日期
  String _chooseDate;

  /// 已选取的化验分析项
  List<AssayItemFormat> _mCheckedList = List();

  String _itemIds = "";
  String _assayType = "";
  String _emptyText = "请选择污水厂";

  String typeName = "";

  List<AssayDataDetail> _list = List();

  /// 化验人员
  var _assayPeopleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyColors.FF2EAFFF,
        title: Text('化验数据填报'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                verticalDirection: VerticalDirection.down,
                children: <Widget>[
                  /// 污水厂
                  MaterialButton(
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(15),
                        bottom: ScreenUtil().setHeight(15),
                        left: ScreenUtil().setWidth(20),
                        right: ScreenUtil().setWidth(20)),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin:
                          EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                          child: Text(
                            "污水厂",
                            style: TextStyle(
                              color: MyColors.FF333333,
                              fontSize: ScreenUtil().setSp(16),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _mSite == null ? "请选择" : _mSite.name,
                            style: TextStyle(
                              color: _mSite == null
                                  ? MyColors.FF999999
                                  : MyColors.FF1296DB,
                              fontSize: ScreenUtil().setSp(16),
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right)
                      ],
                    ),
                    onPressed: () {
                      /// 跳转污水厂选择
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  ChooseSewagePage(chooseSite: _mSite)))
                          .then((site) {
                        if (site != null) {
                          _mSite = site;
                          _loadAssayItem();
                        }
                      });
                    },
                  ),

                  Container(
                    padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(20),
                        right: ScreenUtil().setWidth(20)),
                    child: Divider(height: 1.0),
                  ),

                  /// 化验人员
                  Container(
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(15),
                        bottom: ScreenUtil().setHeight(15),
                        left: ScreenUtil().setWidth(20),
                        right: ScreenUtil().setWidth(20)),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin:
                          EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                          child: Text(
                            "化验人员",
                            style: TextStyle(
                              color: MyColors.FF333333,
                              fontSize: ScreenUtil().setSp(16),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _assayPeopleController,
                            decoration: InputDecoration(
                              hintText: "请填写",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            style: TextStyle(
                              color: MyColors.FF1296DB,
                              fontSize: ScreenUtil().setSp(16),
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(20),
                        right: ScreenUtil().setWidth(20)),
                    child: Divider(height: 1.0),
                  ),

                  /// 化验日期
                  MaterialButton(
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(15),
                        bottom: ScreenUtil().setHeight(15),
                        left: ScreenUtil().setWidth(20),
                        right: ScreenUtil().setWidth(20)),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin:
                          EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                          child: Text(
                            "化验日期",
                            style: TextStyle(
                              color: MyColors.FF333333,
                              fontSize: ScreenUtil().setSp(16),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _chooseDate == null ? "请选择" : _chooseDate,
                            style: TextStyle(
                              color: _chooseDate == null
                                  ? MyColors.FF999999
                                  : MyColors.FF1296DB,
                              fontSize: ScreenUtil().setSp(16),
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right)
                      ],
                    ),
                    onPressed: () => _showTimePicker(),
                  ),

                  Divider(height: 1.0),

                  Container(
                    color: MyColors.FFF0F0F0,
                    padding: EdgeInsets.only(
                        top: ScreenUtil().setHeight(15),
                        bottom: ScreenUtil().setHeight(15),
                        left: ScreenUtil().setWidth(20),
                        right: ScreenUtil().setWidth(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "化验分析项",
                          style: TextStyle(
                            color: MyColors.FF999999,
                            fontSize: ScreenUtil().setSp(15),
                          ),
                        ),
                        InkWell(
                          child: Text(
                            "添加分析项 +",
                            style: TextStyle(
                              color: MyColors.FF61A2CA,
                              fontSize: ScreenUtil().setSp(15),
                            ),
                          ),
                          onTap: () {
                            //进入分析项
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => AssayItemPage(
                                        mCheckedList: _mCheckedList)))
                                .then((checkedList) {
//                      _mCheckedList.clear();
//                      _mCheckedList.addAll(checkedList);
                              _bindData();
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  /// 列表
                  Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Offstage(
                        child: Container(
                          height: ScreenUtil().setHeight(270),
                          child: EmptyView(msg: _emptyText),
                        ),
                        offstage: _list.isNotEmpty,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: _renderItem,
                        itemCount: _list.length * 2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Divider(height: 1.0),

          /// 确认上报
          InkWell(
            child: Container(
              width: ScreenUtil.screenWidth,
              height: ScreenUtil().setHeight(44),
              margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(20),
                  top: ScreenUtil().setWidth(15),
                  bottom: ScreenUtil().setWidth(15),
                  right: ScreenUtil().setWidth(20)),
              color: MyColors.FF1296DB,
              child: Center(
                child: Text("确认上报",
                    style: TextStyle(
                      color: MyColors.FFFFFFFF,
                      fontSize: ScreenUtil().setSp(18),
                    )),
              ),
            ),

            /// 确认
            onTap: () {
              _saveAssayData();
            },
          )
        ],
      ),
    );
  }

  /// 渲染Item
  Widget _renderItem(BuildContext context, int index) {
    if (index.isOdd && index != _list.length * 2) {
      return Container(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20)),
        child: Divider(height: 1.0),
      );
    }

    index = index ~/ 2;

    return MaterialButton(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(15),
          bottom: ScreenUtil().setHeight(15),
          left: ScreenUtil().setWidth(20),
          right: ScreenUtil().setWidth(20)),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
            child: Text(
              _list[index].planTypeName,
              style: TextStyle(
                color: MyColors.FF333333,
                fontSize: ScreenUtil().setSp(16),
              ),
            ),
          ),
          Expanded(
            child: Text(
              _convert(_list[index]) == "" ? "请选择" : _convert(_list[index]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _mSite == null ? MyColors.FF999999 : MyColors.FF1296DB,
                fontSize: ScreenUtil().setSp(16),
              ),
              textAlign: TextAlign.end,
            ),
          ),
          Icon(Icons.keyboard_arrow_right)
        ],
      ),
      onPressed: () {
        /// 条目点击
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => _list[index].relationId == "1"
                    ? FillAssayDataWaterTempPage(mList: _list[index].assayList)
                    : FillAssayDataPage(mList: _list[index].assayList))).then(
                (assayDataDetailList) {
              /// 条目点击带参数返回
              setState(() {
                if (assayDataDetailList != null) {
                  for (int i = 0; i < assayDataDetailList.length; i++) {
                    _list[index].assayList[i].dataVal =
                        assayDataDetailList[i].dataVal;
                    _list[index].assayList[i].remarks =
                        assayDataDetailList[i].remarks;
                  }
                }
              });
            });
      },
    );
  }

  ///  显示时间选择
  _showTimePicker() {
    var currentTime = DateTime.now();
    if (_chooseDate != null) {
      currentTime = DateTime.tryParse(_chooseDate);
    }

    Picker(
        adapter: DateTimePickerAdapter(
            isNumberMonth: true,
            value: currentTime,
            yearBegin: DateTime.now().year - 2,
            yearEnd: DateTime.now().year + 1,
            type: PickerDateTimeType.kYMD,
            yearSuffix: '年',
            monthSuffix: '月',
            daySuffix: '日'),
        confirmText: '确定',
        cancelText: '取消',
        title: Text('请选择化验日期'),
        onConfirm: (Picker picker, List<int> selected) {
          // 选中事件回调
          setState(() {
            _chooseDate = picker.adapter.text
                .substring(0, DateUtil.FORMAT_YEAR_MONTH_DAY.length);
          });
        }).showModal(context);
  }

  _bindData() {
    _itemIds = "";
    _assayType = "";
    for (var assayItemFormat in _mCheckedList) {
      if (assayItemFormat.itemInfo != null) {
        _itemIds = _itemIds == ""
            ? assayItemFormat.itemInfo.id
            : "$_itemIds,${assayItemFormat.itemInfo.id}";
      }
      if (assayItemFormat.assayTypeDto != null) {
        _assayType = _assayType == ""
            ? "${assayItemFormat.assayTypeDto.assayType}"
            : "$_assayType,${assayItemFormat.assayTypeDto.assayType}";
      }
    }

    _loadAssayItem();
  }

  /// 分析项条目
  _loadAssayItem() {
    if (_mSite == null) {
      _emptyText = "请选择污水厂";
      setState(() {});
      return;
    }
    if (_itemIds == "" && _assayType == "") {
      _emptyText = "请选择分析项";
      setState(() {});
      return;
    }

    NetUtil.instance.get(Api.instance.loadAssayItem, (body) {
      AssayData assayData =
          BaseResp<AssayData>(body, (jsonRes) => AssayData.fromJson(jsonRes))
              .resultObj;
      _renderData(assayData);
    }, params: {
      'siteId': _mSite.id,
      'itemIds': _itemIds,
      'assayType': _assayType
    });
  }

  _renderData(AssayData assayData) {
    _list.clear();
    if (assayData != null) {
      AssayDataDetail assayDataDetail;
      for (var assay in assayData.tList) {
        if (assayDataDetail?.relationId == assay.relationId) {
          if (assayDataDetail?.assayList == null) {
            assayDataDetail?.assayList = List();
          }
          assayDataDetail?.assayList?.add(assay);
        } else {
          assayDataDetail = AssayDataDetail();
          assayDataDetail.relationId = assay.relationId;
          assayDataDetail.planTypeName = assay.planTypeName;
          assayDataDetail.assayList = List();
          assayDataDetail.assayList?.add(assay);
          _list.add(assayDataDetail);
        }
      }
      if (assayData.swList != null && assayData.swList.isNotEmpty) {
        assayDataDetail = AssayDataDetail();
        assayDataDetail.assayList = List();
        assayDataDetail.relationId = assayData.swList[0].relationId;
        assayDataDetail.planTypeName = assayData.swList[0].planTypeName;
        assayDataDetail.assayList?.addAll(assayData.swList);
        _list.add(assayDataDetail);
      }
      if (assayData.wnList != null && assayData.wnList.isNotEmpty) {
        assayDataDetail = AssayDataDetail();
        assayDataDetail.assayList = List();
        assayDataDetail.relationId = assayData.wnList[0].relationId;
        assayDataDetail.planTypeName = assayData.wnList[0].planTypeName;
        assayDataDetail.assayList?.addAll(assayData.wnList);
        _list.add(assayDataDetail);
      }
      if (assayData.tsList != null && assayData.tsList.isNotEmpty) {
        assayDataDetail = AssayDataDetail();
        assayDataDetail.assayList = List();
        assayDataDetail.relationId = assayData.tsList[0].relationId;
        assayDataDetail.planTypeName = assayData.tsList[0].planTypeName;
        assayDataDetail.assayList?.addAll(assayData.tsList);
        _list.add(assayDataDetail);
      }
    }

    setState(() {});
  }

  String _convert(AssayDataDetail item) {
    String content = "";
    if (item.assayList != null) {
      if (item.relationId == "1") {
        if (item.assayList[0].dataVal == null) {
          content = "";
        } else {
          content =
          "${item.assayList[0].dataVal}${item.unit == null ? "℃" : item.unit}";
        }
      } else {
        content = "";
        for (int i = 0; i < item.assayList.length; i++) {
          if (item.assayList[i].dataVal != null) {
            content = i == 0
                ? "${item.assayList[i].planItemName}: ${item.assayList[i].dataVal}${item.assayList[i].unit == null ? "" : item.assayList[i].unit}"
                : "$content、${item.assayList[i].planItemName}: ${item.assayList[i].dataVal}${item.assayList[i].unit == null ? "" : item.assayList[i].unit}";
          }
        }
      }
    }

    return content;
  }

  /// 上报化验数据
  _saveAssayData() {
    String people = _assayPeopleController.text.toString().trim();
    if (_mSite == null) return ToastUtil.showShort("请先选择污水厂");
    if (people == "") return ToastUtil.showShort("请先选择化验人员");
    if (_chooseDate == "") return ToastUtil.showShort("请先选择日期");
    if (_list == null || _list.isEmpty) return ToastUtil.showShort("请先选择分析项");

    List<AssayDataDetail> data = List();
    for (var assay in _list) {
      if (assay.assayList != null) {
        for (var assayDataDetail in assay.assayList) {
          data.add(assayDataDetail);
        }
      }
    }

    NetUtil.instance.post(Api.instance.saveAssayData, (body) {
      ToastUtil.showShort("上报成功");
      EventManager.instance.eventBus.fire(EventCode(EventCode.OPERATE_ASSAY_DATA_SUCCESS));
      Navigator.pop(context);
    }, params: {
      'siteId': _mSite.id,
      'assayer': people,
      'collectTime': _chooseDate,
      'dataJson': data.toString(),
    });
  }
}
