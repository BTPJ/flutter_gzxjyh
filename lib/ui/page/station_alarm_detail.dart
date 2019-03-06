import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/model/current_warn.dart';
import 'package:flutter_gzxjyh/model/site_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 实时监控-泵站监测点详情
class StationAlarmDetailPage extends StatefulWidget {
  final SiteInfo siteInfo;

  const StationAlarmDetailPage({Key key, this.siteInfo}) : super(key: key);

  @override
  _StationAlarmDetailPageState createState() => _StationAlarmDetailPageState();
}

class _StationAlarmDetailPageState extends State<StationAlarmDetailPage> {
  List<CurrentWarn> _list = List();

  /// 当前页面
  int _currentIndex = 0;

  /// 是否正在加载
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentWarnBySite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.FFF0F0F0,
      appBar: AppBar(
        backgroundColor: MyColors.FF2EAFFF,
        title: Text('告警详情'),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Offstage(
            child: Center(child: CircularProgressIndicator()),
            offstage: !_isLoading,
          ),
          Column(
            children: <Widget>[
              /// 站点信息展示
              Container(
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(20),
                            right: ScreenUtil().setWidth(10),
                            top: ScreenUtil().setHeight(12),
                          ),
                          child: Text(
                            widget.siteInfo.name ?? "",
                            style: TextStyle(
                              color: MyColors.FF000000,
                              fontSize: ScreenUtil().setSp(16),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: ScreenUtil().setWidth(20),
                            right: ScreenUtil().setWidth(10),
                            bottom: ScreenUtil().setHeight(12),
                          ),
                          child: Text(
                            "${widget.siteInfo.typeName ?? _getTypeName()}监测",
                            style: TextStyle(
                              color: MyColors.FF999999,
                              fontSize: ScreenUtil().setSp(14),
                            ),
                          ),
                        ),
                      ],
                    )),
                    Container(
                      margin: EdgeInsets.only(
                        right: ScreenUtil().setWidth(20),
                      ),
                      decoration: BoxDecoration(
                          color: widget.siteInfo.statusColor,
                          //border: Border.all(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(4.0)),
                      width: ScreenUtil().setWidth(50),
                      height: ScreenUtil().setHeight(24),
                      child: Center(
                        child: Text(
                          widget.siteInfo.statusName ?? "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(14),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              ///
              Expanded(
                child: PageView.builder(
                  itemBuilder: _buildPageView,
                  itemCount: _list.length,
                  onPageChanged: (index) {
                    _currentIndex = index;

                    setState(() {});
                  },
                ),
              ),

              ///
              Container(
                padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(15),
                  bottom: ScreenUtil().setHeight(15),
                ),
                child: Text(
                  "${_currentIndex + 1}/${_list.length}",
                  style: TextStyle(
                    color: MyColors.FF666666,
                    fontSize: ScreenUtil().setSp(14),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  String _getTypeName() {
    if (widget.siteInfo?.type == "1") {
      return "泵站";
    } else if (widget.siteInfo?.type == "2") {
      return "污水厂";
    } else {
      return "";
    }
  }

  Widget _buildPageView(BuildContext context, int index) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      margin: EdgeInsets.only(
        left: ScreenUtil().setWidth(20),
        right: ScreenUtil().setWidth(20),
        top: ScreenUtil().setHeight(20),
      ),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          /// 告警名称
          Container(
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(15),
              right: ScreenUtil().setWidth(15),
              top: ScreenUtil().setHeight(20),
              bottom: ScreenUtil().setHeight(20),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    right: ScreenUtil().setWidth(20),
                  ),
                  child: Text(
                    "告警名称",
                    style: TextStyle(
                      color: MyColors.FF666666,
                      fontSize: ScreenUtil().setSp(16),
                    ),
                  ),
                ),

                ///
                Text(
                  "${_list[index].config?.location}${_list[index].config?.typeName}${_list[index].typeName}",
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
              left: ScreenUtil().setWidth(15),
              right: ScreenUtil().setWidth(15),
            ),
            child: Divider(
              height: 1,
            ),
          ),

          /// 监测类别
          Container(
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(15),
              right: ScreenUtil().setWidth(15),
              top: ScreenUtil().setHeight(20),
              bottom: ScreenUtil().setHeight(20),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    right: ScreenUtil().setWidth(20),
                  ),
                  child: Text(
                    "监测类别",
                    style: TextStyle(
                      color: MyColors.FF666666,
                      fontSize: ScreenUtil().setSp(16),
                    ),
                  ),
                ),

                ///
                Text(
                  "${_list[index].config?.typeName}(${_list[index].config?.unit})",
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
              left: ScreenUtil().setWidth(15),
              right: ScreenUtil().setWidth(15),
            ),
            child: Divider(
              height: 1,
            ),
          ),

          /// 仪表位置
          Container(
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(15),
              right: ScreenUtil().setWidth(15),
              top: ScreenUtil().setHeight(20),
              bottom: ScreenUtil().setHeight(20),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    right: ScreenUtil().setWidth(20),
                  ),
                  child: Text(
                    "仪表位置",
                    style: TextStyle(
                      color: MyColors.FF666666,
                      fontSize: ScreenUtil().setSp(16),
                    ),
                  ),
                ),

                ///
                Text(
                  _list[index].config?.location,
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
              left: ScreenUtil().setWidth(15),
              right: ScreenUtil().setWidth(15),
            ),
            child: Divider(
              height: 1,
            ),
          ),

          /// 当前值
          Container(
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(15),
              right: ScreenUtil().setWidth(15),
              top: ScreenUtil().setHeight(20),
              bottom: ScreenUtil().setHeight(20),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    right: ScreenUtil().setWidth(20),
                  ),
                  child: Text(
                    "当前值    ",
                    style: TextStyle(
                      color: MyColors.FF666666,
                      fontSize: ScreenUtil().setSp(16),
                    ),
                  ),
                ),

                ///
                Text(
                  "${_list[index].value}",
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
              left: ScreenUtil().setWidth(15),
              right: ScreenUtil().setWidth(15),
            ),
            child: Divider(
              height: 1,
            ),
          ),

          /// 正常范围
          Container(
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(15),
              right: ScreenUtil().setWidth(15),
              top: ScreenUtil().setHeight(20),
              bottom: ScreenUtil().setHeight(20),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    right: ScreenUtil().setWidth(20),
                  ),
                  child: Text(
                    "正常范围",
                    style: TextStyle(
                      color: MyColors.FF666666,
                      fontSize: ScreenUtil().setSp(16),
                    ),
                  ),
                ),

                ///
                Text(
                  _list[index].normals,
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
              left: ScreenUtil().setWidth(15),
              right: ScreenUtil().setWidth(15),
            ),
            child: Divider(
              height: 1,
            ),
          ),

          /// 告警时间
          Container(
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(15),
              right: ScreenUtil().setWidth(15),
              top: ScreenUtil().setHeight(20),
              bottom: ScreenUtil().setHeight(20),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    right: ScreenUtil().setWidth(20),
                  ),
                  child: Text(
                    "告警时间",
                    style: TextStyle(
                      color: MyColors.FF666666,
                      fontSize: ScreenUtil().setSp(16),
                    ),
                  ),
                ),

                ///
                Text(
                  _list[index].startDate,
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
              left: ScreenUtil().setWidth(15),
              right: ScreenUtil().setWidth(15),
            ),
            child: Divider(
              height: 1,
            ),
          ),

          /// 关注
          Container(
            padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(15),
              right: ScreenUtil().setWidth(15),
              top: ScreenUtil().setWidth(15),
              bottom: ScreenUtil().setWidth(15),
            ),
            child: InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                      _list[index].attention == null
                          ? "images/ic_star_gray.png"
                          : "images/ic_star_blue.png",
                      width: ScreenUtil().setWidth(22),
                      height: ScreenUtil().setHeight(22)),
                  Text(
                    _list[index].attention == null ? "关注" : "已关注",
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(15),
                      color: MyColors.FF999999,
                    ),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _isLoading = true;
                });
                if (_list[index].attention == null) {
                  _saveAttention(_list[index]);
                } else {
                  _deleteAttention(_list[index]);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  /// 加载站点详情
  _loadCurrentWarnBySite() {
    NetUtil.instance.get(Api.instance.loadCurrentWarnBySite, (res) {
      var list = BaseRespList<CurrentWarn>(
          res, (jsonRes) => CurrentWarn.fromJson(jsonRes)).resultObj;

      _isLoading = false;
      setState(() {
        _list.clear();
        _list.addAll(list);
      });
    }, params: {
      'site.id': widget.siteInfo.id,
    });
  }

  /// 关注
  _saveAttention(CurrentWarn item) {
    NetUtil.instance.get(Api.instance.saveWarnAttention, (res) {
      _loadCurrentWarnBySite();
    }, params: {
      'warn.id': item?.id,
    });
  }

  /// 取消关注
  _deleteAttention(CurrentWarn item) {
    NetUtil.instance.get(Api.instance.deleteAttention, (res) {
      _loadCurrentWarnBySite();
    }, params: {
      'id': item?.attention?.id,
    });
  }
}
