import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/model/site_info.dart';
import 'package:flutter_gzxjyh/model/zone_site_dto.dart';
import 'package:flutter_gzxjyh/ui/widget/empty_view.dart';
import 'package:flutter_gzxjyh/utils/screen_util.dart';

/// 首页(巡检人员)-数据查询-监测数据/告警数据-查询-站点选择
class ChooseSewagePage extends StatefulWidget {
  /// 要回显的之前选择的污水厂
  final SiteInfo chooseSite;

  const ChooseSewagePage({Key key, this.chooseSite}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChooseSewageState();
}

class _ChooseSewageState extends State<ChooseSewagePage> {
  List<ZoneSiteDto> _list = List();
  bool _isLoading = true;
  String _searchName = '';

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      backgroundColor: MyColors.FFF0F0F0,
      titleSpacing: ScreenUtil().setWidth(-36),
      title: Text('污水厂选择',
          style: TextStyle(
              color: MyColors.FF666666, fontSize: ScreenUtil().setSp(17))),
      leading: Container(),
      centerTitle: false,
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.close, color: MyColors.FF101010),
            onPressed: () => Navigator.pop(context))
      ],
    );

    var searchContainer = Container(
      width: ScreenUtil.screenWidth,
      margin: EdgeInsets.all(ScreenUtil().setWidth(20)),
      height: ScreenUtil().setHeight(36),
      decoration: BoxDecoration(
          border: Border.all(color: MyColors.FFD9D9D9),
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setWidth(20)))),
      child: Row(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: ScreenUtil().setWidth(6)),
              child: Icon(Icons.search, color: MyColors.FF999999)),
          Expanded(
              child: TextField(
                  decoration: InputDecoration(
                      hintText: '请输入站点名搜索',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero),
                  onChanged: (value) {
                    _searchName = value;
                    _onRefresh();
                  },
                  style: TextStyle(
                      color: MyColors.FF333333,
                      fontSize: ScreenUtil().setSp(14))))
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: Column(
        children: <Widget>[
          searchContainer,
          Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Offstage(
                            child: EmptyView(), offstage: _list.isNotEmpty),
                        RefreshIndicator(
                            child: ListView(
                              children: _renderList(),
                            ),
                            onRefresh: _onRefresh)
                      ],
                    ))
        ],
      ),
    );
  }

  /// 渲染分组List
  List<Widget> _renderList() {
    var widgets = List<Widget>();

    for (var zoneSite in _list) {
      widgets.add(Container(
          padding: EdgeInsets.fromLTRB(
              ScreenUtil().setWidth(20),
              ScreenUtil().setHeight(10),
              ScreenUtil().setWidth(20),
              ScreenUtil().setHeight(10)),
          color: MyColors.FFF0F0F0,
          child: Text(zoneSite.name,
              style: TextStyle(
                  color: MyColors.FF333333, fontSize: ScreenUtil().setSp(15)))));
      for (var site in zoneSite.siteList) {
        widgets
          ..add(InkWell(
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(20),
                  ScreenUtil().setHeight(10),
                  ScreenUtil().setWidth(20),
                  ScreenUtil().setHeight(10)),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Text(site.name,
                          style: TextStyle(
                              color: MyColors.FF333333,
                              fontSize: ScreenUtil().setSp(16)))),
                  Opacity(
                      opacity: widget.chooseSite?.id == site.id ? 1 : 0,
                      child: Icon(Icons.check, color: MyColors.FF1296DB))
                ],
              ),
            ),
            onTap: () {
              Navigator.pop(context, site);
            },
          ))
          ..add(Container(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(20),
                  right: ScreenUtil().setWidth(20)),
              child: Divider(height: 1.0)));
      }
    }
    return widgets;
  }

  /// 下拉刷新
  Future<void> _onRefresh() async {
    _loadSiteList();
  }

  /// 加载站点列表
  _loadSiteList() {
    NetUtil.instance.get(Api.instance.sewageList, (res) {
      var list = BaseRespList<ZoneSiteDto>(
          res, (jsonRes) => ZoneSiteDto.fromJson(jsonRes)).resultObj;
      setState(() {
        _isLoading = false;
        _list
          ..clear()
          ..addAll(list);
      });
    }, params: {'name': _searchName});
  }
}
