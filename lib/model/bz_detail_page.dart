import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/model/site_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 泵站详情
class BZDetailPage extends StatefulWidget {
  final String siteId;

  const BZDetailPage({Key key, this.siteId}) : super(key: key);

  @override
  _BZDetailPageState createState() => _BZDetailPageState();
}

class _BZDetailPageState extends State<BZDetailPage> {
  SiteInfo _siteInfo;

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
      body: SingleChildScrollView(
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
              child: Divider(),
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
              child: Divider(),
            ),

            /// 数据信息
            Column(
              children: _dataItem(),
            )

            ///
          ],
        ),
      ),
    );
  }

  /// 加载站点详情
  _loadSiteDetail() {
    NetUtil.instance.get(Api.instance.loadSiteDetail, (res) {
      var siteInfo =
          BaseResp<SiteInfo>(res, (jsonRes) => SiteInfo.fromJson(jsonRes))
              .resultObj;
      setState(() {
        _siteInfo = siteInfo;
      });
    }, params: {
      'id': widget.siteId,
    });
  }

  List<Widget> _dataItem() {
    List<Widget> widgets = List();

    if (_siteInfo?.currentData != null && _siteInfo.currentData.isNotEmpty) {
      for (var data in _siteInfo.currentData) {
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

        widgets.add(
          Container(
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(20),
              right: ScreenUtil().setWidth(20),
            ),
            child: Divider(),
          ),
        );
      }
    }

    return widgets;
  }
}
