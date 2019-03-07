import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/ui/page/bz_detail_page.dart';
import 'package:flutter_gzxjyh/model/site_info.dart';
import 'package:flutter_gzxjyh/ui/page/wsc_detail.dart';
import 'package:flutter_gzxjyh/ui/widget/loading_more.dart';
import 'package:flutter_gzxjyh/utils/screen_util.dart';
import 'package:flutter_gzxjyh/ui/widget/empty_view.dart';

/// 首页(巡检人员)-实时监测Tab-实时监测Tab
class RealTimeMonitorChildTabPage extends StatefulWidget {
  @override
  _RealTimeMonitorChildTabPageState createState() =>
      _RealTimeMonitorChildTabPageState();
}

class _RealTimeMonitorChildTabPageState
    extends State<RealTimeMonitorChildTabPage> {
  GlobalKey _myKey = new GlobalKey();

  List<SiteInfo> _list = List();

  /// 是否正在加载
  bool _isLoading = true;

  /// 当前页
  var _pageNo = 1;

  /// 每次请求的数量
  static const int _PAGE_SIZE = 10;

  /// 列表总数
  var _listTotalSize = 0;

  /// 滑动控制器
  ScrollController _scrollController;

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
    return Column(
      key: _myKey,
      children: <Widget>[
        /// 条件筛选
        Container(
          color: MyColors.FFF0F0F0,
          height: ScreenUtil().setHeight(40),
          child: Row(
            children: <Widget>[
              /// 监测区域
              Expanded(
                  child: InkWell(
                      child: Container(
                        height: ScreenUtil().setHeight(40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("监测区域",
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(14),
                                    color: _popBuilder
                                        ? MyColors.FF2EAFFF
                                        : MyColors.FF333333)),
                            Icon(Icons.arrow_drop_down,
                                color: _popBuilder
                                    ? MyColors.FF2EAFFF
                                    : MyColors.FF333333)
                          ],
                        ),
                      ),
                      onTap: () {
                        showDialog<Null>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Container(
                              //height: _myKey.currentContext.size.height+ScreenUtil.bottomBarHeight,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("1"),
                                  Text("2"),
                                ],
                              ),
                            );
                          },
                        ).then((val) {
                          print(val);
                        });
                      })),

              Container(
                color: MyColors.FFCCCCCC,
                width: ScreenUtil().setWidth(1),
                height: ScreenUtil().setHeight(24),
              ),

              /// 站点类型
              Expanded(
                  child: Center(
                child: PopupMenuButton<int>(
                  elevation: 0,
                  offset: Offset(
                      ScreenUtil().setWidth(20), ScreenUtil().setWidth(40)),
                  // padding: const EdgeInsets.all(0.0),
                  itemBuilder: _popItemBuilder,
                  onSelected: (position) {
                    _siteTypeIndex = position;
                    _popBuilder = false;
                    _onRefresh();
                  },
                  onCanceled: () {
                    _popBuilder = false;
                    setState(() {});
                  },
                  child: Container(
                    height: ScreenUtil().setHeight(40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            _siteTypeIndex == 0
                                ? "站点类型"
                                : _siteTypeList[_siteTypeIndex],
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(14),
                                color: _popBuilder
                                    ? MyColors.FF2EAFFF
                                    : MyColors.FF333333)),
                        Icon(Icons.arrow_drop_down,
                            color: _popBuilder
                                ? MyColors.FF2EAFFF
                                : MyColors.FF333333)
                      ],
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),

        /// 列表
        Expanded(
          child: _isLoading
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
                            itemCount: _list.length * 2 + 1))
                  ],
                ),
        ),
      ],
    );
  }

  List<String> _siteTypeList = ["全部", "泵站", "污水厂"];
  int _siteTypeIndex = 0;
  bool _popBuilder = false;

  List<PopupMenuEntry<int>> _popItemBuilder(BuildContext context) {
    var list = List<PopupMenuEntry<int>>();

    for (int i = 0; i < _siteTypeList.length; i++) {
      list.add(
        PopupMenuItem(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _siteTypeList[i],
                style: TextStyle(
                    color: i == _siteTypeIndex
                        ? MyColors.FF2EAFFF
                        : MyColors.FF333333,
                    fontSize: ScreenUtil().setSp(14)),
              ),
              Opacity(
                opacity: i == _siteTypeIndex ? 1 : 0,
                child: Icon(Icons.check, color: MyColors.FF2EAFFF),
              )
            ],
          ),
          value: i,
        ),
      );

      if (i != _siteTypeList.length - 1) {
        list.add(PopupMenuDivider(height: 1.0));
      }
    }

    _popBuilder = true;
    setState(() {});
    return list;
  }

  /// 渲染Item
  Widget _renderItem(BuildContext context, int index) {
    if (index == _list.length * 2) {
      if (_listTotalSize > _PAGE_SIZE) {
        return LoadingMore(haveMore: _list.length < _listTotalSize);
      } else {
        /// 当列表不够上拉时，返回空布局
        return Container();
      }
    }

    if (index.isOdd && index != _list.length * 2) {
      return Container(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20)),
        child: Divider(height: 1.0),
      );
    }

    index = index ~/ 2;

    return InkWell(
      child: Container(
        padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(15),
            bottom: ScreenUtil().setHeight(15),
            left: ScreenUtil().setWidth(20),
            right: ScreenUtil().setWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ///
            Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: _list[index].statusColor,
                      //border: Border.all(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.circular(4.0)),
                  width: ScreenUtil().setWidth(50),
                  height: ScreenUtil().setHeight(24),
                  child: Center(
                    child: Text(
                      _list[index].statusName,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(14),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                ///
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(10),
                    right: ScreenUtil().setWidth(10),
                  ),
                  child: Text(
                    _list[index].name ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ScreenUtil().setSp(16),
                      color: MyColors.FF5988A4,
                    ),
                  ),
                )),

                ///
                Text(
                  _list[index].updateDate ?? "",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(14),
                    color: MyColors.FF999999,
                  ),
                )
              ],
            ),

            ///
            Container(
              margin: EdgeInsets.only(
                top: ScreenUtil().setHeight(15),
              ),
              child: Text(
                _contentItem(_list[index]),
                style: TextStyle(
                  fontSize: ScreenUtil().setSp(16),
                  color: MyColors.FF000000,
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        /// 条目点击
        if (_list[index].type == "1") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => BZDetailPage(siteId: _list[index].id)));
        } else if (_list[index].type == "2") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => WSCDetailPage(siteId: _list[index].id)));
        }
      },
    );
  }

  /// 下拉刷新
  Future<Null> _onRefresh() async {
    _pageNo = 1;
    _list.clear();
    loadSiteInfoPageList(_pageNo);
    return null;
  }

  /// 上拉加载
  _onLoadMore() {
    _pageNo++;
    loadSiteInfoPageList(_pageNo);
  }

  /// 服务器请求加载站点列表
  loadSiteInfoPageList(int pageNo) {
    NetUtil.instance.get(Api.instance.loadSiteInfoPageList, (res) {
      _isLoading = false;
      var page = BaseResp<SiteInfoPage>(
          res, (jsonRes) => SiteInfoPage.fromJson(jsonRes)).resultObj;
      _listTotalSize = page.count;
      var list = page.list ?? List();
      setState(() {
        _list.addAll(list);
      });
    }, params: {
      'pageNo': '$pageNo',
      'pageSize': '$_PAGE_SIZE',
      'zone.id': "",
      'type': _siteTypeIndex == 0 ? "" : "$_siteTypeIndex",
    });
  }

  String _contentItem(SiteInfo item) {
    String content;
    if (item.currentData != null && item.currentData.isNotEmpty) {
      for (int i = 0; i < item.currentData.length; i++) {
        if (i == 0) {
          content =
              "${item.currentData[i].config?.location}${item.currentData[i].config?.typeName}: ${item.currentData[i].value}${item.currentData[i].config?.unit}";
        } else {
          content =
              "$content\n${item.currentData[i].config?.location}${item.currentData[i].config?.typeName}: ${item.currentData[i].value}${item.currentData[i].config?.unit}";
        }
      }
    }

    return content ?? "暂无监测数据";
  }
}
