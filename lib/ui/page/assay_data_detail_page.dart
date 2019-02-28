import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/assay_data.dart';
import 'package:flutter_gzxjyh/model/assay_data_detail.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/ui/page/assay_data_audit_page.dart';
import 'package:flutter_gzxjyh/ui/widget/empty_view.dart';
import 'package:flutter_gzxjyh/utils/date_util.dart';
import 'package:flutter_gzxjyh/utils/user_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 化验数据详情
class AssayDataDetailPage extends StatefulWidget {
  final String assayDataId;

  const AssayDataDetailPage({Key key, this.assayDataId}) : super(key: key);

  @override
  State<AssayDataDetailPage> createState() => _AssayDataDetailPageState();
}

class _AssayDataDetailPageState extends State<AssayDataDetailPage> {
  AssayData _assayData;

  List<AssayDataDetail> _list = List();

  @override
  void initState() {
    super.initState();

    _loadAssayDataDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.FFF0F0F0,
      appBar: AppBar(
        backgroundColor: MyColors.FF2EAFFF,
        title: Text('化验数据详情'),
        centerTitle: true,
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                /// 状态
                Container(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                    top: ScreenUtil().setHeight(15),
                    right: ScreenUtil().setWidth(20),
                    bottom: ScreenUtil().setHeight(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                          right: ScreenUtil().setWidth(20),
                        ),
                        child: Text(
                          "状态",
                          style: TextStyle(
                            color: MyColors.FF666666,
                            fontSize: ScreenUtil().setSp(16),
                          ),
                        ),
                      ),
                      Text(
                        _assayData?.statusName == null
                            ? ""
                            : _assayData.statusName,
                        style: TextStyle(
                          color: MyColors.FF666666,
                          fontSize: ScreenUtil().setSp(16),
                        ),
                      )
                    ],
                  ),
                ),

                /// 污水厂
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                    top: ScreenUtil().setHeight(15),
                    right: ScreenUtil().setWidth(20),
                    bottom: ScreenUtil().setHeight(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                          right: ScreenUtil().setWidth(20),
                        ),
                        child: Text(
                          "污水厂",
                          style: TextStyle(
                            color: MyColors.FF666666,
                            fontSize: ScreenUtil().setSp(16),
                          ),
                        ),
                      ),
                      Text(
                        _assayData?.siteName == null ? "" : _assayData.siteName,
                        style: TextStyle(
                          color: MyColors.FF000000,
                          fontSize: ScreenUtil().setSp(16),
                        ),
                      )
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20)),
                  child: Divider(height: 1.0),
                ),

                /// 化验人员
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                    top: ScreenUtil().setHeight(15),
                    right: ScreenUtil().setWidth(20),
                    bottom: ScreenUtil().setHeight(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                          right: ScreenUtil().setWidth(20),
                        ),
                        child: Text(
                          "化验人员",
                          style: TextStyle(
                            color: MyColors.FF666666,
                            fontSize: ScreenUtil().setSp(16),
                          ),
                        ),
                      ),
                      Text(
                        _assayData?.assayer == null ? "" : _assayData.assayer,
                        style: TextStyle(
                          color: MyColors.FF000000,
                          fontSize: ScreenUtil().setSp(16),
                        ),
                      )
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
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                    top: ScreenUtil().setHeight(15),
                    right: ScreenUtil().setWidth(20),
                    bottom: ScreenUtil().setHeight(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                          right: ScreenUtil().setWidth(20),
                        ),
                        child: Text(
                          "化验日期",
                          style: TextStyle(
                            color: MyColors.FF666666,
                            fontSize: ScreenUtil().setSp(16),
                          ),
                        ),
                      ),
                      Text(
                        DateUtil.long2ShortDateStr(_assayData?.collectTime),
                        style: TextStyle(
                          color: MyColors.FF000000,
                          fontSize: ScreenUtil().setSp(16),
                        ),
                      )
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                    top: ScreenUtil().setHeight(15),
                    right: ScreenUtil().setWidth(20),
                    bottom: ScreenUtil().setHeight(15),
                  ),
                  child: Text(
                    "分析项目",
                    style: TextStyle(
                      color: MyColors.FF000000,
                      fontSize: ScreenUtil().setSp(14),
                    ),
                  ),
                ),

                /// 列表
                Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Offstage(
                      child: Container(
                        height: ScreenUtil().setHeight(270),
                        child: EmptyView(msg: ""),
                      ),
                      offstage: _list.isNotEmpty,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: _renderItem,
                      itemCount: _list.length,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        Offstage(
            // 控制显示,false为显示
            offstage: true,
            child: Divider(height: 1.0)),

        /// 审核
        Offstage(
          // 控制显示,false为显示
          offstage: UserManager.instance.user.positionId != "6",
          child: InkWell(
            child: Container(
              color: Colors.white,
              child: Container(
                width: ScreenUtil.screenWidth,
                height: ScreenUtil().setHeight(44),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                    top: ScreenUtil().setWidth(15),
                    bottom: ScreenUtil().setWidth(15),
                    right: ScreenUtil().setWidth(20)),
                color: MyColors.FF2EAFFF,
                child: Center(
                  child: Text("审核",
                      style: TextStyle(
                        color: MyColors.FFFFFFFF,
                        fontSize: ScreenUtil().setSp(18),
                      )),
                ),
              ),
            ),

            /// 审核
            onTap: () {
              if (_assayData != null) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AssayDataAuditPage()));
              }
            },
          ),
        )
      ]),
    );
  }

  /// 加载化验详情列表
  _loadAssayDataDetail() {
    NetUtil.instance.get(Api.instance.loadAssayDataDetail, (body) {
      AssayData assayData =
          BaseResp<AssayData>(body, (jsonRes) => AssayData.fromJson(jsonRes))
              .resultObj;

      _bindData(assayData);
    }, params: {
      'id': widget.assayDataId,
    });
  }

  _bindData(AssayData assayData) {
    _assayData = assayData;

    _list.clear();

    if (assayData != null) {
      AssayDataDetail assayDataDetail;

      if (assayData.tList != null) {
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
      }

      if (assayData.swList != null && assayData.swList.isNotEmpty) {
        assayDataDetail = AssayDataDetail.itemType(AssayDataDetail.TYPE_0);
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

  /// 渲染Item
  Widget _renderItem(BuildContext context, int index) {
//    if (index.isOdd && index != _list.length * 2) {
//      return Container(
//        padding: EdgeInsets.only(
//            left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20)),
//        child: Divider(height: 1.0),
//      );
//    }
//
//    index = index ~/ 2;

    // 水温类型条目
    if (_list[index].itemType == 0) {
      return Card(
        margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(15),
          right: ScreenUtil().setWidth(15),
          bottom: ScreenUtil().setHeight(15),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
                top: ScreenUtil().setHeight(15),
                right: ScreenUtil().setWidth(20),
                bottom: ScreenUtil().setHeight(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    _list[index].planTypeName,
                    style: TextStyle(
                      color: MyColors.FF5988A4,
                      fontSize: ScreenUtil().setSp(16),
                    ),
                  ),
                  Text(
                    "${_list[index].assayList[0].dataVal}${_list[index].assayList[0].unit == null ? "" : _list[index].assayList[0].unit}",
                    style: TextStyle(
                      color: MyColors.FF000000,
                      fontSize: ScreenUtil().setSp(16),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(15),
                  right: ScreenUtil().setWidth(15)),
              child: Divider(height: 1.0),
            ),

            /// 备注
            Container(
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
                top: ScreenUtil().setHeight(15),
                right: ScreenUtil().setWidth(20),
                bottom: ScreenUtil().setHeight(15),
              ),
              child: Text(
                "备注: ${_list[index].assayList[0].remarks}",
                style: TextStyle(
                  color: MyColors.FF787878,
                  fontSize: ScreenUtil().setSp(14),
                ),
              ),
            )
          ],
        ),
      );
    } else {
      // 其他类型条目
      return Card(
        margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(15),
          right: ScreenUtil().setWidth(15),
          bottom: ScreenUtil().setHeight(15),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
                top: ScreenUtil().setHeight(15),
                right: ScreenUtil().setWidth(20),
                bottom: ScreenUtil().setHeight(15),
              ),
              child: Text(
                _list[index].planTypeName,
                style: TextStyle(
                  color: MyColors.FF5988A4,
                  fontSize: ScreenUtil().setSp(16),
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(15),
                  right: ScreenUtil().setWidth(15)),
              child: Divider(height: 1.0),
            ),

            /// 动态添加
            Column(
              children: _addItem(_list[index]),
            ),

            /// 备注
            Container(
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
                top: ScreenUtil().setHeight(15),
                right: ScreenUtil().setWidth(20),
                bottom: ScreenUtil().setHeight(15),
              ),
              child: Text(
                _standardRremark(_list[index]),
                style: TextStyle(
                  color: MyColors.FF787878,
                  fontSize: ScreenUtil().setSp(14),
                ),
              ),
            )
          ],
        ),
      );
    }
  }

  List<Widget> _addItem(AssayDataDetail item) {
    var widgetItems = List<Widget>();
    for (var assay in item.assayList) {
      //针对污泥脱水后效果数据修改(* 100)
      double dataVal = assay.dataVal;
      if ((assay.relationId == "6" || assay.relationId == "7") &&
          assay.type == "1") {
        dataVal = (assay.dataVal != null ? assay.dataVal : 0.0) * 100;
      }

      var widgetItem = new Column(
        children: <Widget>[
          ///
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(20),
              top: ScreenUtil().setHeight(15),
              right: ScreenUtil().setWidth(20),
              bottom: ScreenUtil().setHeight(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    right: ScreenUtil().setWidth(20),
                  ),
                  child: Text(
                    assay.planItemName,
                    style: TextStyle(
                      color: MyColors.FF666666,
                      fontSize: ScreenUtil().setSp(16),
                    ),
                  ),
                ),
                Text(
                  "$dataVal${assay.unit != null ? assay.unit : ""}",
                  style: TextStyle(
                    color: _addItemValueColor(assay),
                    fontSize: ScreenUtil().setSp(16),
                  ),
                )
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
                right: ScreenUtil().setWidth(20)),
            child: Divider(height: 1.0),
          ),
        ],
      );

      widgetItems.add(widgetItem);
    }
    return widgetItems;
  }

  String _standardRremark(AssayDataDetail item) {
    var standard = "";
    var remark = "";
    if (item?.remarks != null && item?.remarks != "") {
      remark = "\n${item?.remarks}";
    }
    for (var assay in item?.assayList) {
      if (assay.minVal == null && assay.maxVal == null) {
      } else if (assay.maxVal == null && assay.minVal != null) {
        //只有最小值
        //执行标准
        standard =
            "$standard、${assay.planItemName}(${assay.minVal}${assay.unit != null ? assay.unit : ""})";
      } else if (assay.maxVal != null && assay.minVal != null) {
        //执行标准
        standard =
            "$standard、${assay.planItemName}(${assay.minVal}~${assay.maxVal}${assay.unit != null ? assay.unit : ""})";
      }

      //备注
      if (assay.remarks != null && assay.remarks != "") {
        remark = "$remark\n${assay.planItemName} (${assay.remarks})";
      }
    }

    if (standard != "") {
      standard = standard.substring(1, standard.length);
      standard = "执行标准:\n$standard";
    }
    if (remark != "") {
      remark = standard != null ? "\n备注:$remark" : "备注:$remark";
    }

    return "$standard$remark";
  }

  Color _addItemValueColor(AssayDataDetail assay) {
    //针对污泥脱水后效果数据修改(* 100)
    double dataVal = assay.dataVal;
    if ((assay.relationId == "6" || assay.relationId == "7") &&
        assay.type == "1") {
      dataVal = (assay.dataVal != null ? assay.dataVal : 0.0) * 100;
    }

    //颜色
    if (assay.minVal == null && assay.maxVal == null) {
      return MyColors.FF000000;
    } else if (assay.maxVal == null && assay.minVal != null) {
      //只有最小值
      if (assay.minVal - dataVal < 0) {
        return MyColors.FFE51C1C;
      } else {
        return MyColors.FF000000;
      }
    } else if (assay.maxVal != null && assay.minVal != null) {
      if (assay.minVal - dataVal <= 0 && assay.maxVal - dataVal >= 0) {
        return MyColors.FF000000;
      } else {
        return MyColors.FFE51C1C;
      }
    }

    return MyColors.FF000000;
  }
}
