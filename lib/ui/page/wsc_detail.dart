import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/model/site_info.dart';
import 'package:flutter_gzxjyh/ui/page/station_alarm_detail.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WSCDetailPage extends StatefulWidget {
  final String siteId;

  const WSCDetailPage({Key key, this.siteId}) : super(key: key);

  @override
  _WSCDetailPageState createState() => _WSCDetailPageState();
}

class _WSCDetailPageState extends State<WSCDetailPage> {
  SiteInfo _siteInfo;

  /// 是否正在加载
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSiteDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyColors.FF2EAFFF,
        title: Text('监测点详情'),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  /// 站点
                  Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                      top: ScreenUtil().setWidth(15),
                      bottom: ScreenUtil().setWidth(15),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                              right: ScreenUtil().setWidth(10),
                            ),
                            child: Text(
                              _siteInfo?.name ?? "",
                              style: TextStyle(
                                color: MyColors.FF000000,
                                fontSize: ScreenUtil().setSp(16),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          child: Row(
                            children: <Widget>[
                              Image.asset("images/ic_real_time_curves.png",
                                  width: ScreenUtil().setWidth(22),
                                  height: ScreenUtil().setHeight(22)),
                              Container(
                                margin: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(5),
                                ),
                                child: Text(
                                  "实时曲线",
                                  style: TextStyle(
                                    color: MyColors.FF2EAFFF,
                                    fontSize: ScreenUtil().setSp(14),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  ///
                  Container(
                    width: ScreenUtil.screenWidth,
                    height: ScreenUtil().setHeight(10),
                    color: MyColors.FFF0F0F0,
                  ),

                  /// 当前状态
                  Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                      top: ScreenUtil().setWidth(15),
                      bottom: ScreenUtil().setWidth(15),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(114),
                          margin: EdgeInsets.only(
                            right: ScreenUtil().setWidth(10),
                          ),
                          child: Text(
                            "当前状态",
                            style: TextStyle(
                              color: MyColors.FF666666,
                              fontSize: ScreenUtil().setSp(16),
                            ),
                          ),
                        ),

                        ///
                        Container(
                          decoration: BoxDecoration(
                              color: _siteInfo?.statusColor,
                              //border: Border.all(color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(4.0)),
                          width: ScreenUtil().setWidth(50),
                          height: ScreenUtil().setHeight(24),
                          child: Center(
                            child: Text(
                              _siteInfo?.statusName ?? "",
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(14),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Container(),
                        ),

                        ///
                        Offstage(
                          offstage: _siteInfo?.status == "0",
                          child: InkWell(
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "告警详情",
                                  style: TextStyle(
                                    color: MyColors.FF999999,
                                    fontSize: ScreenUtil().setSp(14),
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_right)
                              ],
                            ),
                            onTap: () {
                              if (_siteInfo != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => StationAlarmDetailPage(
                                            siteInfo: _siteInfo)));
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                    ),
                    child: Divider(
                      height: 1,
                    ),
                  ),

                  /// 采集时间
                  Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                      top: ScreenUtil().setWidth(15),
                      bottom: ScreenUtil().setWidth(15),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(114),
                          margin: EdgeInsets.only(
                            right: ScreenUtil().setWidth(10),
                          ),
                          child: Text(
                            "采集时间",
                            style: TextStyle(
                              color: MyColors.FF666666,
                              fontSize: ScreenUtil().setSp(16),
                            ),
                          ),
                        ),

                        ///
                        Text(
                          _siteInfo?.updateDate ?? "",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            color: MyColors.FF000000,
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
                    child: Divider(
                      height: 1,
                    ),
                  ),

                  /// 数据信息
                  Column(
                    children: _dataItem(),
                  ),

                  /// 基础信息
                  Container(
                    color: MyColors.FFF0F0F0,
                    width: ScreenUtil.screenWidth,
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                      top: ScreenUtil().setWidth(15),
                      bottom: ScreenUtil().setWidth(15),
                    ),
                    child: Text(
                      "基础信息",
                      style: TextStyle(
                        color: MyColors.FF999999,
                        fontSize: ScreenUtil().setSp(14),
                      ),
                    ),
                  ),

                  /// 站点编号
                  Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                      top: ScreenUtil().setWidth(15),
                      bottom: ScreenUtil().setWidth(15),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(114),
                          margin: EdgeInsets.only(
                            right: ScreenUtil().setWidth(10),
                          ),
                          child: Text(
                            "站点编号",
                            style: TextStyle(
                              color: MyColors.FF666666,
                              fontSize: ScreenUtil().setSp(16),
                            ),
                          ),
                        ),

                        ///
                        Text(
                          _siteInfo?.code ?? "",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            color: MyColors.FF000000,
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
                    child: Divider(
                      height: 1,
                    ),
                  ),

                  /// 站点类型
                  Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                      top: ScreenUtil().setWidth(15),
                      bottom: ScreenUtil().setWidth(15),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(114),
                          margin: EdgeInsets.only(
                            right: ScreenUtil().setWidth(10),
                          ),
                          child: Text(
                            "站点类型",
                            style: TextStyle(
                              color: MyColors.FF666666,
                              fontSize: ScreenUtil().setSp(16),
                            ),
                          ),
                        ),

                        ///
                        Text(
                          _siteInfo?.typeName ?? _getTypeName(),
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            color: MyColors.FF000000,
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
                    child: Divider(
                      height: 1,
                    ),
                  ),

                  /// 所属区域
                  Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                      top: ScreenUtil().setWidth(15),
                      bottom: ScreenUtil().setWidth(15),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(114),
                          margin: EdgeInsets.only(
                            right: ScreenUtil().setWidth(10),
                          ),
                          child: Text(
                            "所属区域",
                            style: TextStyle(
                              color: MyColors.FF666666,
                              fontSize: ScreenUtil().setSp(16),
                            ),
                          ),
                        ),

                        ///
                        Text(
                          "${_siteInfo?.zone?.parent?.name ?? ""}${_siteInfo?.zone?.name ?? ""}",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            color: MyColors.FF000000,
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
                    child: Divider(
                      height: 1,
                    ),
                  ),

                  /// 位置
                  Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                      top: ScreenUtil().setWidth(15),
                      bottom: ScreenUtil().setWidth(15),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(114),
                          margin: EdgeInsets.only(
                            right: ScreenUtil().setWidth(10),
                          ),
                          child: Text(
                            "位置",
                            style: TextStyle(
                              color: MyColors.FF666666,
                              fontSize: ScreenUtil().setSp(16),
                            ),
                          ),
                        ),

                        ///
                        Expanded(
                          child: Text(
                            _siteInfo?.address ?? "",
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(16),
                              color: MyColors.FF000000,
                            ),
                          ),
                        ),

                        Icon(Icons.location_on, color: MyColors.FF5988A4)
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                    ),
                    child: Divider(
                      height: 1,
                    ),
                  ),

                  /// 规模
                  Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                      top: ScreenUtil().setWidth(15),
                      bottom: ScreenUtil().setWidth(15),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(114),
                          margin: EdgeInsets.only(
                            right: ScreenUtil().setWidth(10),
                          ),
                          child: Text(
                            "规模",
                            style: TextStyle(
                              color: MyColors.FF666666,
                              fontSize: ScreenUtil().setSp(16),
                            ),
                          ),
                        ),

                        ///
                        Text(
                          _siteInfo?.scale ?? "",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            color: MyColors.FF000000,
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
                    child: Divider(
                      height: 1,
                    ),
                  ),

                  /// 出水达标要求
                  Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                      top: ScreenUtil().setWidth(15),
                      bottom: ScreenUtil().setWidth(15),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(114),
                          margin: EdgeInsets.only(
                            right: ScreenUtil().setWidth(10),
                          ),
                          child: Text(
                            "出水达标要求",
                            style: TextStyle(
                              color: MyColors.FF666666,
                              fontSize: ScreenUtil().setSp(16),
                            ),
                          ),
                        ),

                        ///
                        Expanded(
                          child: Text(
                            _siteInfo?.standardName ?? "",
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(16),
                              color: MyColors.FF999999,
                            ),
                          ),
                        ),

                        Icon(Icons.keyboard_arrow_right,
                            color: MyColors.FF101010)
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                    ),
                    child: Divider(
                      height: 1,
                    ),
                  ),

                  /// 进水达标要求
                  Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                      top: ScreenUtil().setWidth(15),
                      bottom: ScreenUtil().setWidth(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(114),
                          margin: EdgeInsets.only(
                            right: ScreenUtil().setWidth(10),
                          ),
                          child: Text(
                            "进水达标要求",
                            style: TextStyle(
                              color: MyColors.FF666666,
                              fontSize: ScreenUtil().setSp(16),
                            ),
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right,
                            color: MyColors.FF101010)
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                    ),
                    child: Divider(
                      height: 1,
                    ),
                  ),

                  /// 保底水量
                  Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                      top: ScreenUtil().setWidth(15),
                      bottom: ScreenUtil().setWidth(15),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(114),
                          margin: EdgeInsets.only(
                            right: ScreenUtil().setWidth(10),
                          ),
                          child: Text(
                            "保底水量",
                            style: TextStyle(
                              color: MyColors.FF666666,
                              fontSize: ScreenUtil().setSp(16),
                            ),
                          ),
                        ),

                        ///
                        Text(
                          (_siteInfo.minWater == null ||
                              _siteInfo.minWater == 0.0) ? "" : "${_siteInfo.minWater}万吨/天",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            color: MyColors.FF000000,
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
                    child: Divider(
                      height: 1,
                    ),
                  ),

                  /// 脱水后含水率
                  Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                      top: ScreenUtil().setWidth(15),
                      bottom: ScreenUtil().setWidth(15),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(114),
                          margin: EdgeInsets.only(
                            right: ScreenUtil().setWidth(10),
                          ),
                          child: Text(
                            "脱水后含水率",
                            style: TextStyle(
                              color: MyColors.FF666666,
                              fontSize: ScreenUtil().setSp(16),
                            ),
                          ),
                        ),

                        ///
                        Text(
                          (_siteInfo.waterRate == null ||
                              _siteInfo.waterRate == 0.0) ? "" : "${_siteInfo.waterRate}%",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            color: MyColors.FF000000,
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
                    child: Divider(
                      height: 1,
                    ),
                  ),

                  /// 备注
                  Container(
                    padding: EdgeInsets.only(
                      left: ScreenUtil().setWidth(20),
                      right: ScreenUtil().setWidth(20),
                      top: ScreenUtil().setWidth(15),
                      bottom: ScreenUtil().setWidth(15),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: ScreenUtil().setWidth(114),
                          margin: EdgeInsets.only(
                            right: ScreenUtil().setWidth(10),
                          ),
                          child: Text(
                            "备注",
                            style: TextStyle(
                              color: MyColors.FF666666,
                              fontSize: ScreenUtil().setSp(16),
                            ),
                          ),
                        ),

                        ///
                        Text(
                          _siteInfo?.remarks ?? "",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(16),
                            color: MyColors.FF000000,
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
                    child: Divider(
                      height: 1,
                    ),
                  ),

                  ///
                  Container(
                    height: ScreenUtil().setHeight(15),
                  ),

                  ///
                ],
              ),
            ),
    );
  }

  /// 循环添加数据信息
  List<Widget> _dataItem() {
    List<Widget> widgets = List();

    if (_siteInfo?.currentData != null && _siteInfo.currentData.isNotEmpty) {
      for (int i = 0; i < _siteInfo.currentData.length; i++) {
        var data = _siteInfo.currentData[i];
        widgets.add(
          Container(
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(20),
              right: ScreenUtil().setWidth(20),
              top: ScreenUtil().setWidth(15),
              bottom: ScreenUtil().setWidth(15),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: ScreenUtil().setWidth(114),
                  margin: EdgeInsets.only(
                    right: ScreenUtil().setWidth(10),
                  ),
                  child: Text(
                    "${data.config?.location}${data.config?.typeName}",
                    style: TextStyle(
                      color: MyColors.FF666666,
                      fontSize: ScreenUtil().setSp(16),
                    ),
                  ),
                ),

                ///
                Text(
                  "${data.value}${data.config?.unit}",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(16),
                    color: MyColors.FF000000,
                  ),
                ),
              ],
            ),
          ),
        );
        if (i != _siteInfo.currentData.length - 1) {
          widgets.add(
            Container(
              padding: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
                right: ScreenUtil().setWidth(20),
              ),
              child: Divider(
                height: 1,
              ),
            ),
          );
        }
      }
    }

    return widgets;
  }

  /// 加载站点详情
  _loadSiteDetail() {
    NetUtil.instance.get(Api.instance.loadSiteDetail, (res) {
      var siteInfo =
          BaseResp<SiteInfo>(res, (jsonRes) => SiteInfo.fromJson(jsonRes))
              .resultObj;
      _isLoading = false;
      setState(() {
        _siteInfo = siteInfo;
      });
    }, params: {
      'id': widget.siteId,
    });
  }

  String _getTypeName() {
    if (_siteInfo?.type == "1") {
      return "泵站";
    } else if (_siteInfo?.type == "2") {
      return "污水厂";
    } else {
      return "";
    }
  }
}
