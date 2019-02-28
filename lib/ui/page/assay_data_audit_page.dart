import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/event/event_code.dart';
import 'package:flutter_gzxjyh/event/event_manager.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/assay_data.dart';
import 'package:flutter_gzxjyh/utils/toast_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 审核
class AssayDataAuditPage extends StatefulWidget {

  final AssayData mAssayData;

  const AssayDataAuditPage({Key key, this.mAssayData}) : super(key: key);

  @override
  _AssayDataAuditPageState createState() => _AssayDataAuditPageState();
}

class _AssayDataAuditPageState extends State<AssayDataAuditPage> {
  bool _pass = true;

  var remarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: MyColors.FF2EAFFF,
          title: Text('任务延期审核'),
          centerTitle: true,
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  ///
                  Container(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
                    child: Text(
                      "审核意见",
                      style: TextStyle(
                        color: MyColors.FF666666,
                        fontSize: ScreenUtil().setSp(16),
                      ),
                    ),
                  ),

                  ///
                  Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                      bottom: ScreenUtil().setHeight(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          child: MaterialButton(
                            elevation: 0,
                            height: ScreenUtil().setHeight(42),
                            onPressed: () {
                              if (!_pass) {
                                _pass = true;
                                setState(() {});
                              }
                            },
                            color:
                            _pass ? MyColors.FFCCE8F9 : MyColors.FFF0F0F0,
                            textColor:
                            _pass ? MyColors.FF1B8BD0 : MyColors.FF999999,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Image.asset(
                                  _pass
                                      ? 'images/ic_check_blue.png'
                                      : 'images/ic_check_gray.png',
                                  height: ScreenUtil().setHeight(24),
                                  width: ScreenUtil().setWidth(24),
                                ),
                                Text("通过",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(16),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: ScreenUtil().setWidth(20),
                        ),
                        Expanded(
                          child: MaterialButton(
                            elevation: 0,
                            height: ScreenUtil().setHeight(42),
                            onPressed: () {
                              if (_pass) {
                                _pass = false;
                                setState(() {});
                              }
                            },
                            color:
                            _pass ? MyColors.FFF0F0F0 : MyColors.FFCCE8F9,
                            textColor:
                            _pass ? MyColors.FF999999 : MyColors.FF1B8BD0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Image.asset(
                                  _pass
                                      ? 'images/ic_x_gray.png'
                                      : 'images/ic_x_blue.png',
                                  height: ScreenUtil().setHeight(18),
                                  width: ScreenUtil().setWidth(18),
                                ),
                                Text("驳回",
                                    style: TextStyle(
                                      fontSize: ScreenUtil().setSp(16),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(20),
                        right: ScreenUtil().setWidth(20),
                      ),
                      child: Divider()),

                  Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      top: ScreenUtil().setHeight(15),
                      right: ScreenUtil().setWidth(20),
                      bottom: ScreenUtil().setHeight(10),
                    ),
                    child: Text(
                      "备注",
                      style: TextStyle(
                        color: MyColors.FF999999,
                        fontSize: ScreenUtil().setSp(16),
                      ),
                    ),
                  ),

                  /// 填写备注
                  Container(
                      padding: EdgeInsets.only(
                        left: ScreenUtil().setWidth(20),
                        right: ScreenUtil().setWidth(20),
                        bottom: ScreenUtil().setHeight(15),
                      ),
                      child: TextField(
                        controller: remarkController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText:"请输入备注",
                        ),
                        maxLines: 9,
                      )),
                ],
              ),
            ),
          ),
          Divider(height: 1.0),

          /// 提交
          InkWell(
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
                  child: Text("提交",
                      style: TextStyle(
                        color: MyColors.FFFFFFFF,
                        fontSize: ScreenUtil().setSp(18),
                      )),
                ),
              ),
            ),

            /// 审核
            onTap: () {
              _auditData();
            },
          )
        ]));
  }

  /// 加载化验详情列表
  _auditData() {
    NetUtil.instance.get(Api.instance.auditProduceOrAssayData, (body) {
      ToastUtil.showShort("审核成功");
      EventManager.instance.eventBus.fire(EventCode(EventCode.AUDIT_PRODUCE_OR_ASSAY_DATA));
      Navigator.pop(context);
    }, params: {
      "id": widget.mAssayData.audit?.id,
      "type": "0",
      "dataId": widget.mAssayData.id,
      "status": _pass ? "3" : "1",
      "remarks": remarkController.text.trim(),
    });
  }
}
