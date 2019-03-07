import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/event/event_code.dart';
import 'package:flutter_gzxjyh/event/event_manager.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/assay_data.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/model/notify_info.dart';
import 'package:flutter_gzxjyh/ui/page/assay_data_detail_page.dart';
import 'package:flutter_gzxjyh/ui/page/assay_data_fill_page.dart';
import 'package:flutter_gzxjyh/ui/page/notify_detail_page.dart';
import 'package:flutter_gzxjyh/ui/page/personal_center_page.dart';
import 'package:flutter_gzxjyh/ui/widget/badge_view.dart';
import 'package:flutter_gzxjyh/ui/widget/empty_view.dart';
import 'package:flutter_gzxjyh/ui/widget/marquee_vertical.dart';
import 'package:flutter_gzxjyh/utils/screen_util.dart';

/// 首页(化验人员)
class HomeAssayTabPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeAssayTabPageState();
}

class HomeAssayTabPageState extends State<HomeAssayTabPage> {
  bool _isLoading = true;

  /// 未阅读的消息集(TextSpan集用于Marquee)
  List<NotifyInfo> _unReadNotifyList = List();
  List<TextSpan> _unReadTextSpanList = List();

  List<AssayData> _list = List();

  @override
  void initState() {
    super.initState();
    _onRefresh();

    /// 监听阅读未阅读状态的通知消息
    EventManager.instance.eventBus.on<EventCode>().listen((event) {
      if (event.code == EventCode.READ_NOTIFY) {
        _loadUnReadNotifyList();
      }

      if (event.code == EventCode.OPERATE_ASSAY_DATA_SUCCESS) {
        _loadAssayDataList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: MyColors.FF2EAFFF,
        title: Text('首页'),
        centerTitle: true,
        leading: BadgeView(
            num: _unReadNotifyList.length > 0 ? 0 : -1,
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(10),
                top: ScreenUtil().setHeight(10)),
            child: IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => PersonalCenterPage()));
                })),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /// 轮播通知
          Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(14),
                right: ScreenUtil().setWidth(14)),
            height: ScreenUtil().setHeight(55),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: ScreenUtil().setWidth(6)),
                  child: Icon(Icons.volume_up, color: MyColors.FF666666),
                ),
                Expanded(
                    child: _unReadNotifyList.isEmpty
                        ? Text('暂无未阅读的通知公告',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(15)))
                        : _buildMarquee()),
              ],
            ),
          ),

          /// 化验数据填报
          Stack(children: <Widget>[
            Container(
                height: ScreenUtil().setHeight(34), color: MyColors.FFF0F0F0),
            Container(
              width: ScreenUtil.screenWidth,
              margin: EdgeInsets.only(
                top: ScreenUtil().setHeight(12),
                left: ScreenUtil().setWidth(20),
                right: ScreenUtil().setWidth(20),
                bottom: ScreenUtil().setWidth(12),
              ),
              height: ScreenUtil().setHeight(44),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenUtil().setWidth(44)))),
                color: MyColors.FF2EAFFF,
                padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(20),
                  right: ScreenUtil().setWidth(20),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('images/ic_test.png',
                          width: ScreenUtil().setWidth(22),
                          height: ScreenUtil().setHeight(22)),
                      Container(
                        margin:
                        EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                        child: Text(
                          "化验数据填报",
                          style: TextStyle(
                              color: MyColors.FFFFFFFF,
                              fontSize: ScreenUtil().setSp(18)),
                        ),
                      )
                    ],
                  ),
                ),
                onPressed: () {
                  /// 化验数据填报
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AssayDataFillPage()));
                },
              ),
            ),
          ]),

          /// 列表
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Offstage(child: EmptyView(), offstage: _list.isNotEmpty),
                RefreshIndicator(
                    child: ListView.builder(
                      // 保持ListView任何情况都能滚动，解决在RefreshIndicator的兼容问题(列表未铺满时无法上拉)
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: _renderItem,
                        itemCount: _list.length * 2),
                    onRefresh: _onRefresh)
              ],
            ),
          )
        ],
      ),
    );
  }

//  Widget _listView() {
//    if (_isLoading) {
//      return Center(child: CircularProgressIndicator());
//    }
//    return Stack(
//      alignment: Alignment.center,
//      children: <Widget>[
//        Offstage(
//          child: EmptyView(),
//          offstage: _list.isNotEmpty,
//        ),
//        RefreshIndicator(
//            child: ListView.builder(
//              itemBuilder: _renderItem,
//              itemCount: _list.length * 2,
//            ),
//            onRefresh: _onRefresh)
//      ],
//    );
//  }

  /// 渲染Item
  Widget _renderItem(BuildContext context, int index) {
    if (index.isOdd) {
      return Padding(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20)),
        child: Divider(
          color: const Color(0xffd9d9d9),
          height: ScreenUtil().setHeight(1),
        ),
      );
    }

    index = index ~/ 2;
    AssayData assayData = _list[index];
    return InkWell(
      child: Container(
        height: ScreenUtil().setHeight(84),
        padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(10),
            bottom: ScreenUtil().setHeight(10),
            left: ScreenUtil().setWidth(20),
            right: ScreenUtil().setWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              "${assayData.name}",
              style: TextStyle(
                color: const Color(0xff101010),
                fontSize: ScreenUtil().setSp(16),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  assayData.statusName,
                  style: TextStyle(
                    color: assayData.statusColor,
                    fontSize: ScreenUtil().setSp(14),
                  ),
                ),
                Text(
                  assayData.createDate,
                  style: TextStyle(
                    color: MyColors.FF999999,
                    fontSize: ScreenUtil().setSp(14),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      onTap: () {
        // 进入详情
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    AssayDataDetailPage(assayDataId: _list[index].id)));
      },
    );
  }

  /// 加载化验详情列表
  _loadAssayDataList() {
    NetUtil.instance.get(Api.instance.loadAssayDataList, (body) {
      List<AssayData> list = BaseRespList<AssayData>(
          body, (jsonRes) => AssayData.fromJson(jsonRes)).resultObj;
      setState(() {
        _isLoading = false;
        _list.clear();
        _list.addAll(list);
      });
    }, params: {"qType": "1"});
  }

  /// 渲染未阅读消息的跑马灯效果
  Widget _buildMarquee() {
    var controller = MarqueeController();
    return GestureDetector(
      child: Marquee(
        textSpanList: _unReadTextSpanList,
        controller: controller,
        fontSize: ScreenUtil().setSp(14),
      ),
      onTap: () {
        NotifyInfo notify = _unReadNotifyList[controller.position];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => NotifyDetailPage(
                    notifyId: notify.id, isUnRead: notify.haveRead == '0')));
      },
    );
  }

  /// 加载未阅读的通知消息
  _loadUnReadNotifyList() {
    NetUtil.instance.get(Api.instance.unReadNotifyList, (res) {
      var list = BaseRespList<NotifyInfo>(
          res, (jsonRes) => NotifyInfo.fromJson(jsonRes)).resultObj;
      _unReadNotifyList
        ..clear()
        ..addAll(list);
      _unReadTextSpanList.clear();
      for (var notify in _unReadNotifyList) {
        _unReadTextSpanList.add(TextSpan(
            text: notify.title.length > 15
                ? notify.title.substring(0, 15)
                : notify.title,
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text: ' — ${notify.createDate}',
                  style: TextStyle(color: MyColors.FF666666))
            ]));
      }
      setState(() {});
    });
  }

  Future<void> _onRefresh() async {
    // 下拉刷新
    _loadUnReadNotifyList();
    _loadAssayDataList();
  }
}
