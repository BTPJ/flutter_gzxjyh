import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/event/event_code.dart';
import 'package:flutter_gzxjyh/event/event_manager.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/model/notify_info.dart';
import 'package:flutter_gzxjyh/utils/screen_util.dart';

/// 首页-个人中心-通知公告-详情
class NotifyDetailPage extends StatefulWidget {
  final String notifyId;
  final bool isUnRead;

  const NotifyDetailPage(
      {Key key, @required this.notifyId, @required this.isUnRead})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _NotifyDetailState();
}

class _NotifyDetailState extends State<NotifyDetailPage> {
  bool _isLoading = true;
  NotifyInfo _notify;

  @override
  void initState() {
    super.initState();
    _loadNotifyDetail();
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
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /// 标题
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(14),
                        ScreenUtil().setHeight(15),
                        ScreenUtil().setWidth(14),
                        0.0),
                    padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                    child: Text(_notify.title ?? '',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenUtil().setSp(20))),
                    decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(
                                color: MyColors.FF1296DB,
                                width: ScreenUtil().setWidth(5)))),
                  ),

                  /// 发布人和时间
                  Container(
                    child: Text(
                        '${_notify.createBy?.name ?? ''}  ${_notify.createDate ?? ''}',
                        style: TextStyle(
                            color: MyColors.FF999999,
                            fontSize: ScreenUtil().setSp(16))),
                    margin: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(14),
                        ScreenUtil().setHeight(20),
                        ScreenUtil().setWidth(14),
                        0.0),
                  ),

                  /// 内容
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(14),
                        ScreenUtil().setHeight(20),
                        ScreenUtil().setWidth(14),
                        0.0),
                    child: Text('  ${_notify.content ?? ''}',
                        style: TextStyle(
                            color: MyColors.FF333333,
                            fontSize: ScreenUtil().setSp(16))),
                  )
                ],
              ),
            ),
    );
  }

  /// 加载通知公告详情
  _loadNotifyDetail() {
    NetUtil.instance.get(Api.instance.notifyDetail, (res) {
      if (widget.isUnRead) {
        EventManager.instance.eventBus.fire(EventCode(EventCode.READ_NOTIFY));
      }
      var notify =
          BaseResp<NotifyInfo>(res, (jsonRes) => NotifyInfo.fromJson(jsonRes))
              .resultObj;
      setState(() {
        _isLoading = false;
        _notify = notify;
      });
    }, params: {'notifyId': widget.notifyId});
  }
}
