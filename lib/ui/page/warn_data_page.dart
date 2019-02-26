import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/model/history_warn.dart';
import 'package:flutter_gzxjyh/model/site_info.dart';
import 'package:flutter_gzxjyh/ui/page/data_filter_query_page.dart';
import 'package:flutter_gzxjyh/ui/widget/empty_view.dart';
import 'package:flutter_gzxjyh/ui/widget/loading_more.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 首页(巡检人员)-数据查询-告警数据
class WarnDataPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WarnDataState();
}

class _WarnDataState extends State<WarnDataPage> {
  SiteInfo _site;
  SiteInfo _chooseSite;

  var _startDate;
  var _endDate;

  /// 滑动控制器
  ScrollController _scrollController;

  /// 历史告警
  var _list = List();

  /// 是否正在加载
  bool _isLoading = true;

  /// 当前页
  var _pageNo = 1;

  /// 每次请求的数量
  static const int _PAGE_SIZE = 10;

  /// 列表总数
  var _listTotalSize = 0;

  var _blackTextStyle =
      TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(16));
  var _grayTextStyle =
      TextStyle(color: MyColors.FF787878, fontSize: ScreenUtil().setSp(15));

  @override
  void initState() {
    super.initState();
    _initScrollController();
    _onRefresh();
  }

  /// 初始化ScrollController
  _initScrollController() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      // 最大的滚动距离
      var maxScrollPixels = _scrollController.position.maxScrollExtent;
      // 已向下滚动的距离
      var nowScrollPixels = _scrollController.position.pixels;
      // 对比判定是否滚动到底从而分页加载
      if (nowScrollPixels == maxScrollPixels && _list.length < _listTotalSize) {
        _onLoadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.FFF0F0F0,
      appBar: AppBar(
        title: Text('告警数据', style: TextStyle(fontSize: ScreenUtil().setSp(18))),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(30)),
            child:
                Text('查询', style: TextStyle(fontSize: ScreenUtil().setSp(14))),
            onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (_) => DataFilterQueryPage()))
                  .then((list) {
                if (list != null) {
                  _isLoading = true;
                  _chooseSite = list[0];
                  _site = _chooseSite;
                  _startDate = list[1];
                  _endDate = list[2];
                  _onRefresh();
                }
              });
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Offstage(child: EmptyView(), offstage: _list.isNotEmpty),
                RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                        // 保持ListView任何情况都能滚动，解决在RefreshIndicator的兼容问题(列表未铺满时无法下拉)
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        itemBuilder: _renderItem,
                        itemCount: _list.length + 2))
              ],
            ),
    );
  }

  /// 渲染ListItem
  Widget _renderItem(BuildContext context, int index) {
    if (index == 0) {
      return Padding(
          padding: EdgeInsets.only(
              top: ScreenUtil().setHeight(16),
              bottom: ScreenUtil().setHeight(10)),
          child: Column(
            children: <Widget>[
              Text('${_site.name}历史告警数据', style: _blackTextStyle),
              Offstage(
                  child: Container(
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(4)),
                    child: Text('$_startDate  至  $_endDate',
                        style: _grayTextStyle),
                  ),
                  offstage: _startDate == null)
            ],
          ));
    }

    if (index == _list.length + 1) {
      if (_listTotalSize > _PAGE_SIZE) {
        return LoadingMore(haveMore: _list.length < _listTotalSize);
      } else {
        /// 当列表不够上拉时，返回空布局
        return Container();
      }
    }

    index--;
    HistoryWarn warn = _list[index];
    return Container(
      margin: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(15),
          ScreenUtil().setHeight(2),
          ScreenUtil().setWidth(15),
          ScreenUtil().setHeight(2)),
      width: ScreenUtil.screenWidth,
      child: Card(
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '${warn.config?.location}${warn.config?.typeName}',
                    style: _blackTextStyle,
                  ),
                  Text(
                    '${warn.value}${warn.config?.unit}',
                    style: _blackTextStyle,
                  )
                ],
              ),
              margin: EdgeInsets.all(ScreenUtil().setWidth(18)),
            ),
            Container(
              child: Divider(height: 1.0),
              margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(16),
                  right: ScreenUtil().setWidth(16)),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '正常范围',
                    style: _blackTextStyle,
                  ),
                  Text(
                    '${warn.normals}${warn.config?.unit}',
                    style: _blackTextStyle,
                  )
                ],
              ),
              margin: EdgeInsets.all(ScreenUtil().setWidth(18)),
            ),
            Container(
              child: Divider(height: 1.0),
              margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(16),
                  right: ScreenUtil().setWidth(16)),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '告警时间',
                    style: _grayTextStyle,
                  ),
                  Text(
                    warn.startDate,
                    style: _grayTextStyle,
                  )
                ],
              ),
              margin: EdgeInsets.all(ScreenUtil().setWidth(18)),
            )
          ],
        ),
      ),
    );
  }

  /// 下拉刷新
  Future<Null> _onRefresh() async {
    _pageNo = 1;
    _list.clear();
    _loadWarnDataList(_pageNo);
    return null;
  }

  /// 上拉加载
  _onLoadMore() {
    _pageNo++;
    _loadWarnDataList(_pageNo);
  }

  /// 服务器请求加载告警数据
  _loadWarnDataList(int pageNo) {
    NetUtil.instance.get(Api.instance.historyWarn, (res) {
      _isLoading = false;
      var site =
          BaseResp<SiteInfo>(res, (jsonRes) => SiteInfo.fromJson(jsonRes))
              .resultObj;
      _listTotalSize = site.historyWarn.count;
      var list = site.historyWarn.list ?? List();
      setState(() {
        /// 接口传Id后返回的站点无站点名（接口所致）
        if (site.name != null) {
          _site = site;
        }
        if (site.startDate != null && site.startDate.isNotEmpty) {
          _startDate = site.startDate;
        }
        if (site.endDate != null && site.endDate.isNotEmpty) {
          _endDate = site.endDate;
        }
        _list.addAll(list);
      });
    }, params: {
      'pageNo': '$pageNo',
      'pageSize': '$_PAGE_SIZE',
      'id': '${_chooseSite?.id ?? ''}',
      'startDate': _startDate ?? '',
      'endDate': _endDate ?? ''
    });
  }
}
