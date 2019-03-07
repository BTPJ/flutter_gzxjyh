import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/utils/screen_util.dart';

/// 巡检线路详情(首页-巡检任务-详情-开始巡检/巡检线路)
class PatrolLinePage extends StatefulWidget {
  /// 巡检任务Id
  final String taskId;

  const PatrolLinePage({Key key, @required this.taskId}) : super(key: key);

  @override
  _PatrolLinePageState createState() => _PatrolLinePageState();
}

class _PatrolLinePageState extends State<PatrolLinePage> {
  String _appTitleText;

  @override
  Widget build(BuildContext context) {
    /// AppBar
    var appBar = AppBar(
      backgroundColor: MyColors.FF2EAFFF,
      title: Text(_appTitleText ?? ''),
      centerTitle: true,
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
          alignment: Alignment.center,
          child:
              Text('暂停巡检', style: TextStyle(fontSize: ScreenUtil().setSp(14))),
        ),
        Container(
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
          alignment: Alignment.center,
          child:
              Text('结束巡检', style: TextStyle(fontSize: ScreenUtil().setSp(14))),
        ),
        Container(
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
          alignment: Alignment.center,
          child:
              Text('问题上报', style: TextStyle(fontSize: ScreenUtil().setSp(14))),
        )
      ],
    );
    return Scaffold(appBar: appBar, body: Container());
  }
}
