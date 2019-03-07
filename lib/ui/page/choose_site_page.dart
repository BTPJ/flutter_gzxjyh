import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/model/site_info.dart';
import 'package:flutter_gzxjyh/ui/widget/empty_view.dart';
import 'package:flutter_gzxjyh/utils/screen_util.dart';

/// 首页(巡检人员)-数据查询-监测数据/告警数据-查询-站点选择
class ChooseSitePage extends StatefulWidget {
  final SiteInfo chooseSite;
  final String siteType;

  const ChooseSitePage({Key key, this.chooseSite, this.siteType})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChooseSiteState();
}

class _ChooseSiteState extends State<ChooseSitePage> {
  List<SiteInfo> _list = List();
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
      title: Text('站点选择',
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
                            child: ListView.builder(
                              itemBuilder: _renderItem,
                              itemCount: _list.length * 2,
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(20),
                                  right: ScreenUtil().setWidth(20)),
                            ),
                            onRefresh: _onRefresh)
                      ],
                    ))
        ],
      ),
    );
  }

  /// 渲染List Item
  Widget _renderItem(BuildContext context, int index) {
    if (index.isOdd) {
      return Divider(height: 1.0);
    }

    index = index ~/ 2;
    SiteInfo site = _list[index];
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(12),
            bottom: ScreenUtil().setHeight(12)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(site.name,
                style: TextStyle(
                    color: MyColors.FF333333, fontSize: ScreenUtil().setSp(16))),
            Opacity(
              opacity: widget.chooseSite?.id == site.id ? 1 : 0,
              child: Icon(Icons.check, color: MyColors.FF1296DB),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.pop(context, site);
      },
    );
  }

  /// 下拉刷新
  Future<void> _onRefresh() async {
    _loadSiteList();
  }

  /// 加载站点列表
  _loadSiteList() {
    NetUtil.instance.get(Api.instance.siteList, (res) {
      var list =
          BaseRespList<SiteInfo>(res, (jsonRes) => SiteInfo.fromJson(jsonRes))
              .resultObj;
      setState(() {
        _isLoading = false;
        _list
          ..clear()
          ..addAll(list);
      });
    }, params: {
      'type': widget.siteType == '泵站' ? '1' : '2',
      'name': _searchName
    });
  }
}
