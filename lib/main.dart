import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/sp_key.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/timer/report_user_position_timer.dart';
import 'package:flutter_gzxjyh/ui/page/login_page.dart';
import 'package:flutter_gzxjyh/utils/sp_util.dart';
import 'package:amap_base/amap_base.dart';

void main() async {
  /// IOS端设置高德地图key
  await AMap.init('14441bcdfc85b1cb402c44a8cbce0d26');
  runApp(MyApp());
}

/// APP入口
class MyApp extends StatelessWidget {
  /// 构造
  MyApp() {
    _initDefaultIpAsync();
    ReportUserPositionTimer().startTimer();
  }

  /// 初始化默认IP(异步)
  _initDefaultIpAsync() async {
    await SpUtil.getInstance();
    Api.selIp = SpUtil.getString(SpKey.DEFAULT_IP);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '资产管理',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: <String, WidgetBuilder>{
        'HomePage': (_) => LoginPage(),
      },
    );
  }
}
