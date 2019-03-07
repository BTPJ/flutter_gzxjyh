import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/event/event_code.dart';
import 'package:flutter_gzxjyh/event/event_manager.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/model/notify_info.dart';
import 'package:flutter_gzxjyh/ui/page/notify_detail_page.dart';
import 'package:flutter_gzxjyh/ui/widget/empty_view.dart';
import 'package:flutter_gzxjyh/ui/widget/loading_more.dart';
import 'package:flutter_gzxjyh/utils/screen_util.dart';

/// 首页-个人中心-通知公告
class NotifyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NotifyState();
}

class _NotifyState extends State<NotifyPage> {
  /// 通知消息
  var _list = List<NotifyInfo>();

  /// 是否正在加载
  bool _isLoading = true;

  /// 滑动控制器
  ScrollController _scrollController;

  /// 当前页
  var _pageNo = 1;

  /// 每次请求的数量
  static const int _PAGE_SIZE = 10;

  /// 列表总数
  var _listTotalSize = 0;

  @override
  void initState() {
    super.initState();
    _initScrollController();
    _onRefresh();

    /// 监听阅读未阅读状态的通知消息
    EventManager.instance.eventBus.on<EventCode>().listen((event) {
      if (event.code == EventCode.READ_NOTIFY) {
        _onRefresh();
      }
    });
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
    var appBar = AppBar(
      title: Text('通知公告', style: TextStyle(fontSize: ScreenUtil().setSp(18))),
      centerTitle: true,
    );

    return Scaffold(
      appBar: appBar,
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
                        itemCount: _list.length * 2 + 1))
              ],
            ),
    );
  }

  Widget _renderItem(BuildContext context, int index) {
    if (index == _list.length * 2) {
      if (_listTotalSize > _PAGE_SIZE) {
        return LoadingMore(haveMore: _list.length < _listTotalSize);
      } else {
        /// 当列表不够上拉时，返回空布局
        return Container();
      }
    }

    if (index.isOdd) {
      return Padding(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(16), right: ScreenUtil().setWidth(16)),
        child: Divider(height: 1.0),
      );
    }

    index = index ~/ 2;
    NotifyInfo item = _list[index];
    return InkWell(
        child: Container(
          width: ScreenUtil.screenWidth,
          height: ScreenUtil().setHeight(76),
          margin: EdgeInsets.only(
              left: ScreenUtil().setWidth(16),
              right: ScreenUtil().setWidth(16)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(16))),
                  Text('${item.createBy?.name ?? ''}  ${item.createDate ?? ''}',
                      style: TextStyle(
                          color: MyColors.FF999999,
                          fontSize: ScreenUtil().setSp(15)))
                ],
              )),

              /// 未阅读小红点
              Opacity(
                opacity: item.haveRead == '0' ? 1 : 0,
                child: Container(
                  width: ScreenUtil().setWidth(14),
                  decoration:
                      BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
              )
            ],
          ),
        ),
        //TODO 点击Item
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => NotifyDetailPage(
                    notifyId: item.id, isUnRead: item.haveRead == '0'))));
  }

  /// 下拉刷新
  Future<Null> _onRefresh() async {
    _pageNo = 1;
    _list.clear();
    _loadNotifyList(_pageNo);
    return null;
  }

  /// 上拉加载
  _onLoadMore() {
    _pageNo++;
    _loadNotifyList(_pageNo);
  }

  /// 加载通知列表
  _loadNotifyList(int pageNo) {
    NetUtil.instance.get(Api.instance.notifyList, (res) {
      var page = BaseResp<NotifyInfoPage>(
          res, (jsonRes) => NotifyInfoPage.fromJson(jsonRes)).resultObj;
      _listTotalSize = page.count;
      var list = page.list ?? List();
      setState(() {
        _isLoading = false;
        _list.addAll(list);
      });
    });
  }
}
