import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/model/assay_data_detail.dart';
import 'package:flutter_gzxjyh/utils/toast_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 水温-数据填写
class FillAssayDataWaterTempPage extends StatefulWidget {
  final List<AssayDataDetail> mList;

  const FillAssayDataWaterTempPage({Key key, this.mList}) : super(key: key);

  @override
  State<StatefulWidget> createState() => FillAssayDataWaterTempPageState();
}

class FillAssayDataWaterTempPageState
    extends State<FillAssayDataWaterTempPage> {
  /// 检查结果
  TextEditingController _fillInDataController = TextEditingController();

  /// 备注
  TextEditingController _remarkController = TextEditingController();

  /// 防止浅复制
  List<AssayDataDetail> _list = List();

  @override
  void initState() {
    // 防止浅复制
    for (int i = 0; i < widget.mList.length; i++) {
      AssayDataDetail assayDataDetail = new AssayDataDetail();
      assayDataDetail.dataVal = widget.mList[i].dataVal;
      assayDataDetail.remarks = widget.mList[i].remarks;
      _list.add(assayDataDetail);
    }

    _fillInDataController.text =
        "${_list[0].dataVal == null ? "" : _list[0].dataVal}";

    _remarkController.text =
        "${_list[0].remarks == null ? "" : _list[0].remarks}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyColors.FFF0F0F0,
        titleSpacing: ScreenUtil().setWidth(-36),
        title: Text("水温（℃）",
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          /// 检测结果
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                    top: ScreenUtil().setHeight(15),
                    right: ScreenUtil().setWidth(10),
                    bottom: ScreenUtil().setHeight(15)),
                child: Text(
                  "检测结果",
                  style: TextStyle(
                    color: MyColors.FF333333,
                    fontSize: ScreenUtil().setSp(16),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                      top: ScreenUtil().setHeight(15),
                      right: ScreenUtil().setWidth(20),
                      bottom: ScreenUtil().setHeight(15)),
                  child: TextField(
                    controller: _fillInDataController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      //WhitelistingTextInputFormatter.digitsOnly,
                      WhitelistingTextInputFormatter(
                          RegExp(r'([1-9]\d*\.?\d*)|(0\.\d*[1-9])')),
                    ],
                    onChanged: (text) {
                      /// 水温
                      //_list[0].dataVal = double.tryParse(_fillInDataController.text.toString().trim());
                      _list[0].dataVal = double.tryParse(text);
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
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ],
          ),

          Container(
            padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
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
              controller: _remarkController,
              onChanged: (text) {
                /// 备注
                //_list[0].remarks = _remarkController.text.toString().trim();
                _list[0].remarks = text;
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

          Divider(height: 1.0),

          Expanded(
            child: Stack(
              children: <Widget>[
                Container(
                  color: MyColors.FFF0F0F0,
                ),
                InkWell(
                  child: Container(
                    width: ScreenUtil.screenWidth,
                    height: ScreenUtil().setHeight(44),
                    margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(20),
                        top: ScreenUtil().setWidth(20),
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
                    if (_list[0].dataVal == null) {
                      return ToastUtil.showShort("请填写水温");
                    }
                    Navigator.pop(context, _list);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
