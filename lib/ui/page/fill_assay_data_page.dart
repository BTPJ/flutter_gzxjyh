import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/model/assay_data_detail.dart';
import 'package:flutter_gzxjyh/utils/toast_util.dart';
import 'package:flutter_gzxjyh/utils/screen_util.dart';

/// 数据填写
class FillAssayDataPage extends StatefulWidget {
  final List<AssayDataDetail> mList;

  const FillAssayDataPage({Key key, this.mList}) : super(key: key);

  @override
  State<FillAssayDataPage> createState() => _FillAssayDataPageState();
}

class _FillAssayDataPageState extends State<FillAssayDataPage> {
  /// 检测结果集合
  List<TextEditingController> _resultList;

  /// 备注集合
  List<TextEditingController> _remarkList;

  /// 防止浅复制
  List<AssayDataDetail> _list = List();

  String _title() {
    if (widget.mList == null || widget.mList.isEmpty) {
      return "";
    } else {
      if (widget.mList[0].unit == null) {
        return "${widget.mList[0].planTypeName}";
      } else {
        return "${widget.mList[0].planTypeName}(${widget.mList[0].unit})";
      }
    }
  }

  @override
  void initState() {

    // 防止浅复制
    for (int i = 0; i < widget.mList.length; i++) {
      AssayDataDetail assayDataDetail = new AssayDataDetail();
      assayDataDetail.dataVal = widget.mList[i].dataVal;
      assayDataDetail.remarks = widget.mList[i].remarks;
      assayDataDetail.minVal = widget.mList[i].minVal;
      assayDataDetail.maxVal = widget.mList[i].maxVal;
      assayDataDetail.planItemName = widget.mList[i].planItemName;
      assayDataDetail.unit = widget.mList[i].unit;
      _list.add(assayDataDetail);
    }

    _resultList = List(_list.length);
    _remarkList = List(_list.length);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyColors.FFF0F0F0,
        titleSpacing: ScreenUtil().setWidth(-36),
        title: Text(_title(),
            style: TextStyle(
                color: MyColors.FF666666, fontSize: ScreenUtil().setSp(17))),
        leading: Container(),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close, color: MyColors.FF101010),
              onPressed: () => Navigator.pop(context))
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
            itemBuilder: _renderItem,
            itemCount: _list.length * 2 - 1,
          )),

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
                child: Text("确认",
                    style: TextStyle(
                      color: MyColors.FFFFFFFF,
                      fontSize: ScreenUtil().setSp(18),
                    )),
              ),
            ),

            /// 确认
            onTap: () {
              for (var data in _list) {
                if (data.dataVal == null) {
                  return ToastUtil.showShort("请填写${data.planItemName}的检测结果");
                }
              }

              Navigator.pop(context, _list);
            },
          )
        ],
      ),
    );
  }

  /// 渲染Item
  Widget _renderItem(BuildContext context, int index) {
    if (index.isOdd && index != _list.length * 2 - 1) {
      return Container(
        color: MyColors.FFF0F0F0,
        height: ScreenUtil().setHeight(10),
      );
    }

    index = index ~/ 2;

    if (_resultList[index] == null) {
      _resultList[index] = TextEditingController(
        text:
            "${_list[index].dataVal == null ? "" : _list[index].dataVal}",
      );
    }
    if (_remarkList[index] == null) {
      _remarkList[index] = TextEditingController(
        text:
            "${_list[index].remarks == null ? "" : _list[index].remarks}",
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        /// 条目名称
        Container(
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(20),
              top: ScreenUtil().setWidth(15),
              right: ScreenUtil().setWidth(20)),
          child: Text(_list[index].planItemName,
              style: TextStyle(
                color: MyColors.FF5988A4,
                fontSize: ScreenUtil().setSp(16),
              )),
        ),

        /// 执行标准
        Offstage(
          child: Container(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
                top: ScreenUtil().setWidth(20),
                right: ScreenUtil().setWidth(20)),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("执行标准",
                        style: TextStyle(
                          color: MyColors.FF333333,
                          fontSize: ScreenUtil().setSp(16),
                        )),
                    Text(
                        _list[index].maxVal == null
                            ? "${_list[index].minVal}"
                            : "${_list[index].minVal}~${_list[index].maxVal}",
                        style: TextStyle(
                          color: MyColors.FF000000,
                          fontSize: ScreenUtil().setSp(16),
                        ))
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: ScreenUtil().setHeight(15),
                  ),
                  child: Divider(height: 1.0),
                ),
              ],
            ),
          ),
          offstage: (_list[index]?.minVal == null &&
              _list[index]?.maxVal == null),
        ),

        /// 检测结果
        Container(
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(20),
              top: ScreenUtil().setWidth(20),
              right: ScreenUtil().setWidth(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
                child: Text("检测结果",
                    style: TextStyle(
                      color: MyColors.FF333333,
                      fontSize: ScreenUtil().setSp(16),
                    )),
              ),
              Expanded(
                child: TextField(
                    controller: _resultList[index],
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter(
                          RegExp(r'([1-9]\d*\.?\d*)|(0\.\d*[1-9])')),
                    ],
                    onChanged: (text) {
                      /// 检测结果
                      if (text == null || text.trim() == "") {
                        _list[index].dataVal = null;
                      } else {
                        _list[index].dataVal = double.tryParse(text);
                      }

                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: "请填写",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: _resultColorItem(_list[index]),
                      fontSize: ScreenUtil().setSp(16),
                    )),
              )
            ],
          ),
        ),

        Container(
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(20),
              top: ScreenUtil().setHeight(15),
              right: ScreenUtil().setWidth(20)),
          child: Divider(height: 1.0),
        ),

        Container(
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(20),
              top: ScreenUtil().setHeight(15),
              right: ScreenUtil().setWidth(20)),
          child: Text(
            "备注",
            style: TextStyle(
              color: MyColors.FF333333,
              fontSize: ScreenUtil().setSp(16),
            ),
          ),
        ),

        /// 备注
        Container(
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(20),
              top: ScreenUtil().setHeight(15),
              right: ScreenUtil().setWidth(20),
              bottom: ScreenUtil().setHeight(15)),
          child: TextField(
            controller: _remarkList[index],
            onChanged: (text) {
              /// 备注
              //_list[0].remarks = _remarkController.text.toString().trim();
              _list[index].remarks = text;
            },
            decoration: InputDecoration(
              hintText: "请填写",
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: TextStyle(
              color: MyColors.FF1296DB,
              fontSize: ScreenUtil().setSp(16),
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Color _resultColorItem(AssayDataDetail item) {
    if (item != null) {
      if (item.minVal == null && item.maxVal == null) {
        return MyColors.FF1296DB;
      }
      if (item.dataVal != null) {
        if (item.minVal == null && item.maxVal == null) {
          return MyColors.FF1296DB;
        } else if (item.maxVal == null) {
          if (item.minVal - item.dataVal < 0.0) {
            return MyColors.FFE51C1C;
          } else {
            return MyColors.FF1296DB;
          }
        } else {
          if (item.maxVal - item.dataVal >= 0 &&
              item.minVal - item.dataVal <= 0) {
            return MyColors.FF1296DB;
          } else {
            return MyColors.FFE51C1C;
          }
        }
      }
    }

    return MyColors.FF1296DB;
  }
}
