import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/model/produce_data.dart';
import 'package:flutter_gzxjyh/model/site_info.dart';
import 'package:flutter_gzxjyh/ui/page/data_filter_query_page2.dart';
import 'package:flutter_gzxjyh/ui/widget/empty_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 首页(巡检人员)-数据查询-生产数据
class ProduceDataPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProduceDataState();
}

class _ProduceDataState extends State<ProduceDataPage> {
  ProduceData _produceData;
  bool _isLoading = true;

  /// 查询筛选的污水厂
  SiteInfo _chooseSite;

  /// 查询筛选的日期
  String _chooseDate;

  static const TYPE_PRO = 0;
  static const TYPE_MED = 1;
  static const TYPE_OTHER = 2;

  var _blackTextStyle =
      TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(16));
  var _grayTextStyle =
      TextStyle(color: MyColors.FF787878, fontSize: ScreenUtil().setSp(15));
  var _blueTextStyle =
      TextStyle(color: MyColors.FF5988A4, fontSize: ScreenUtil().setSp(16));

  @override
  void initState() {
    super.initState();
    _loadProduceData();
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: Text('生产数据', style: TextStyle(fontSize: ScreenUtil().setSp(18))),
      centerTitle: true,
      actions: <Widget>[
        FlatButton(
          textColor: Colors.white,
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
          child: Text('查询', style: TextStyle(fontSize: ScreenUtil().setSp(14))),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => DataFilterQueryPage2(
                          title: '生产数据查询',
                        ))).then((list) {
              if (list != null) {
                _isLoading = true;
                _chooseSite = list[0];
                _chooseDate = list[1];
                _loadProduceData();
              }
            });
          },
        )
      ],
    );

    return Scaffold(
      backgroundColor: MyColors.FFF0F0F0,
      appBar: appBar,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _produceData == null
              ? Center(child: EmptyView())
              : ListView(
                  children: <Widget>[
                    /// 标题
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(16)),
                      child: Text('${_produceData?.name ?? '--'}',
                          style: _blackTextStyle),
                    ),

                    /// 填报人
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: ScreenUtil().setHeight(4)),
                      child: Text('填报人员：${_produceData.createBy?.name ?? '--'}',
                          style: _grayTextStyle),
                    ),

                    /// 生产数据
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _renderProListView(TYPE_PRO),
                    ),

                    /// 药剂数据
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _renderProListView(TYPE_MED),
                    ),

                    /// 其他
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _renderProListView(TYPE_OTHER),
                    ),
                  ],
                ),
    );
  }

  /// 渲染生产数据
  /// type:(TYPE_PRO：生产数据、TYPE_MED：药剂数据、TYPE_OTHER：其他)
  List<Widget> _renderProListView(int type) {
    var widgets = List<Widget>();
    var list;
    var title;
    switch (type) {
      case TYPE_PRO:
        list = _produceData.proList;
        title = '生产数据';
        break;
      case TYPE_MED:
        list = _produceData.medList;
        title = '药剂数据';
        break;
      default:
        list = _produceData.othList;
        title = '其他';
        break;
    }
    if (list.isNotEmpty) {
      widgets.add(Container(
        child: Text(title, style: _grayTextStyle),
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(20),
            top: ScreenUtil().setHeight(10),
            bottom: ScreenUtil().setHeight(10)),
      ));

      for (var detail in list) {
        /// 是否含备注
        var hasRemarks = detail.remarks != null && detail.remarks.isNotEmpty;
        widgets.add(
          Card(
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(20),
                right: ScreenUtil().setWidth(20),
                bottom: ScreenUtil().setHeight(8)),
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(15)),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(detail.planItemName ?? '',
                              style: _blueTextStyle),
                          flex: 3),
                      Expanded(
                          child: Text('${detail.dataVal}${detail.unit}',
                              style: _blackTextStyle, textAlign: TextAlign.end),
                          flex: 2),
                    ],
                  ),
                  Offstage(
                    child: Divider(height: 1.0),
                    offstage: !hasRemarks,
                  ),
                  Offstage(
                    child: Text('备注：${detail.remarks}'),
                    offstage: !hasRemarks,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    return widgets;
  }

  /// 加载生产数据详情
  _loadProduceData() {
    NetUtil.instance.get(Api.instance.produceDataDetail, (res) {
      var produceData =
          BaseResp<ProduceData>(res, (jsonRes) => ProduceData.fromJson(jsonRes))
              .resultObj;
      setState(() {
        _isLoading = false;
        _produceData = produceData;
      });
    }, params: {
      'siteId': _chooseSite?.id ?? '',
      'collectTime': _chooseDate ?? ''
    });
  }
}
