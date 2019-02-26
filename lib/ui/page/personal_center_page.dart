import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/sp_key.dart';
import 'package:flutter_gzxjyh/event/event_code.dart';
import 'package:flutter_gzxjyh/event/event_manager.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/model/notify_info.dart';
import 'package:flutter_gzxjyh/ui/page/login_page.dart';
import 'package:flutter_gzxjyh/ui/page/notify_page.dart';
import 'package:flutter_gzxjyh/ui/widget/badge_view.dart';
import 'package:flutter_gzxjyh/utils/user_manager.dart';
import 'package:flutter_gzxjyh/utils/sp_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 首页-个人中心
class PersonalCenterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PersonalCenterState();
}

class PersonalCenterState extends State<PersonalCenterPage> {
  /// 未阅读的消息集
  List<NotifyInfo> _unReadNotifyList = List();
  var _user = UserManager.instance.user;
  var _divider = Padding(
      child: Divider(
          height: ScreenUtil().setHeight(1), color: const Color(0xffd9d9d9)),
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(10), 0, ScreenUtil().setWidth(10), 0));

  @override
  void initState() {
    super.initState();
    _loadUnReadNotifyList();

    /// 监听阅读未阅读状态的通知消息
    EventManager.instance.eventBus.on<EventCode>().listen((event) {
      if (event.code == EventCode.READ_NOTIFY) {
        _loadUnReadNotifyList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2eafff),
        title: Text('个人中心'),
        centerTitle: true,
        actions: <Widget>[
          BadgeView(
              num: _unReadNotifyList.length > 0 ? 0 : -1,
              margin: EdgeInsets.only(
                  left: ScreenUtil().setWidth(20),
                  top: ScreenUtil().setHeight(10)),
              child: IconButton(
                  icon: Icon(Icons.email),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => NotifyPage()))))
        ],
      ),
      body: ListView(
        children: <Widget>[
          _renderListItem('姓名', _user.name),
          _divider,
          _renderListItem('登录名', _user.loginName),
          _divider,
          _renderListItem('联系电话', _user.phone),
          _divider,
          _renderListItem('邮箱', _user.email),
          _divider,
          _renderListItem('职位', _user.positionName),
          _divider,
          _renderListItem('备注', _user.remarks),
          _divider,
          Container(
            margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20),
                ScreenUtil().setHeight(50), ScreenUtil().setWidth(20), 0),
            child: RaisedButton(
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(10),
                  bottom: ScreenUtil().setHeight(10)),
              onPressed: () {
                //TODO 退出登录
                SpUtil.putBool(SpKey.IS_AUTO_LOGIN, false);
                SpUtil.remove(SpKey.LOGIN_PASSWORD);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                    (route) => route == null);
              },
              color: const Color(0xff2eafff),
              child: Text('退出登录',
                  style: TextStyle(
                      color: Colors.white, fontSize: ScreenUtil().setSp(18))),
            ),
          )
        ],
      ),
    );
  }

  /// 渲染ListItem
  Widget _renderListItem(String key, String value) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(10),
          ScreenUtil().setHeight(15),
          ScreenUtil().setWidth(10),
          ScreenUtil().setHeight(15)),
      child: Row(
        children: <Widget>[
          Text(key,
              style: TextStyle(
                  color: Colors.black, fontSize: ScreenUtil().setSp(15))),
          Expanded(
              child: Text(value == null || value.isEmpty ? '--' : value,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: Colors.black, fontSize: ScreenUtil().setSp(15))))
        ],
      ),
    );
  }

  /// 加载未阅读的通知消息
  _loadUnReadNotifyList() {
    NetUtil.instance.get(Api.instance.unReadNotifyList, (res) {
      var list = BaseRespList<NotifyInfo>(
          res, (jsonRes) => NotifyInfo.fromJson(jsonRes)).resultObj;
      setState(() {
        _unReadNotifyList
          ..clear()
          ..addAll(list);
      });
    });
  }
}
