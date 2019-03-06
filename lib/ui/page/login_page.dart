import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/sp_key.dart';
import 'package:flutter_gzxjyh/event/event_manager.dart';
import 'package:flutter_gzxjyh/event/event_code.dart';
import 'package:flutter_gzxjyh/event/user_event.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/user.dart';
import 'package:flutter_gzxjyh/ui/page/change_ip_page.dart';
import 'package:flutter_gzxjyh/ui/page/main_assay_page.dart';
import 'package:flutter_gzxjyh/ui/page/main_patrol_page.dart';
import 'package:flutter_gzxjyh/ui/widget/loading_dialog.dart';
import 'package:flutter_gzxjyh/utils/toast_util.dart';
import 'package:flutter_gzxjyh/utils/user_manager.dart';
import 'package:flutter_gzxjyh/utils/sp_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// 登录
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  /// 用户名输入的控制器
  var _loginNameController = TextEditingController();

  /// 密码输入的控制器
  var _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  /// 初始化(异步)
  _initAsync() async {
    await SpUtil.getInstance();
    _loginNameController.text = SpUtil.getString(SpKey.LOGIN_NAME);
    _passwordController.text = SpUtil.getString(SpKey.LOGIN_PASSWORD);
    if (SpUtil.getBool(SpKey.IS_AUTO_LOGIN) ?? false) {
      _login();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: 创建界面
    //设置适配尺寸 (填入设计稿中设备的屏幕尺寸)
    ScreenUtil.instance = ScreenUtil(width: 360, height: 640)..init(context);

    return MaterialApp(
      home: WillPopScope(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  /// 最上面的图标（3次连续点击可以切换IP）
                  Container(
                    child: InkWell(
                      child: Image.asset(
                        'images/ic_logo.png',
                        width: ScreenUtil().setWidth(100),
                        height: ScreenUtil().setHeight(100),
                      ),
                      onTap: () => _changeIp(),
                    ),
                    margin: EdgeInsets.fromLTRB(
                        0.0, ScreenUtil().setHeight(90), 0.0, 0.0),
                    alignment: Alignment.center,
                  ),

                  Container(
                    child: Text('巡检养护系统',
                        style: TextStyle(
                            color: const Color(0xff2eafff),
                            fontSize: ScreenUtil().setSp(28),
                            fontWeight: FontWeight.w600)),
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(30)),
                  ),

                  /// 用户名输入
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(30),
                        ScreenUtil().setHeight(50),
                        ScreenUtil().setWidth(30),
                        0.0),
                    child: TextField(
                      controller: _loginNameController,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.all(ScreenUtil().setHeight(4)),
                        icon: Icon(Icons.person),
                        labelText: '请输入你的用户名',
                      ),
                    ),
                  ),

                  ///  密码输入
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(30),
                        ScreenUtil().setHeight(20),
                        ScreenUtil().setWidth(30),
                        0.0),
                    child: TextField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.all(ScreenUtil().setHeight(4)),
                        icon: Icon(Icons.lock),
                        labelText: '请输入你的密码',
                      ),
                    ),
                  ),

                  /// 登录按键
                  Container(
                    width: ScreenUtil.screenWidth,
                    margin: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(28),
                        ScreenUtil().setWidth(50),
                        ScreenUtil().setWidth(28),
                        0.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              ScreenUtil().setHeight(20))),
                      color: const Color(0xff2eafff),
                      onPressed: () => _login(),
                      padding: EdgeInsets.fromLTRB(
                          0.0,
                          ScreenUtil().setHeight(10),
                          0.0,
                          ScreenUtil().setHeight(10)),
                      child: Text(
                        '登录',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(18)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          onWillPop: _doubleClickBack),
    );
  }

  String loginName;
  String password;

  /// 登录
  _login() {
    loginName = _loginNameController.text.trim();
    password = _passwordController.text.trim();
    if (loginName.isEmpty) {
      Fluttertoast.showToast(msg: '请输入用户名');
      return;
    }
    if (password.isEmpty) {
      Fluttertoast.showToast(msg: '请输入密码');
      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) => LoadingDialog(text: '登录中...'));

    /// 每次登录前需要清除之前的缓存
    /// 不直接 NetUtil.instance.defaultCookieJar.deleteAll()是因为会报错(暂不明原因)
    if (Api.selIp == null) {
      Api.selIp = Api.DEFAULT_IP;
    }
    List hostAndPort = Api.selIp.split(':');
    NetUtil.instance.defaultCookieJar
        .delete(Uri(host: hostAndPort[0], port: int.parse(hostAndPort[1])));

    NetUtil.instance.post(Api.instance.login, (body) {},
        params: {'username': loginName, 'password': password},
        errorCallBack: (errorMsg) {
      Navigator.pop(context);
    });

    EventManager.instance.eventBus.on<UserEvent>().listen((event) {
      User user = event.user;
      UserManager.instance.storeUser(user);
      SpUtil.putString(SpKey.LOGIN_NAME, loginName);
      SpUtil.putString(SpKey.LOGIN_PASSWORD, password);
      if (user.positionId == null || user.positionId.isEmpty) {
        SpUtil.putBool(SpKey.IS_AUTO_LOGIN, false);
        ToastUtil.showShort('管理员暂未给此用户分配权限,无法登录');
      } else {
        switch (user.positionId) {
          case '1': // 巡检人员
            SpUtil.putBool(SpKey.IS_AUTO_LOGIN, true);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => MainPatrolPage()),
                (route) => route == null);
            break;
          case '7': // 化验人员
            SpUtil.putBool(SpKey.IS_AUTO_LOGIN, true);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => MainAssayPage()),
                (route) => route == null);
            break;
        }
      }
    });

    /// 登录失败
    EventManager.instance.eventBus.on<EventCode>().listen((event) {
      switch (event.code) {
        case EventCode.LOGIN_FAILED:
        case EventCode.CONNECT_TIME_OUT:
          Navigator.pop(context);
          break;
      }
    });
  }

  /// 点击次数
  int _clickTimes = 0;

  /// 跳转到修改IP的界面（这里的逻辑是1.5秒内连续点击3次才触发）
  _changeIp() {
    Future.delayed(const Duration(milliseconds: 1500), () => _clickTimes = 0);
    _clickTimes++;
    if (_clickTimes > 2) {
      _clickTimes = 0;
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => ChangeIpPage()));
    }
  }

  /// 上次点击返回键的时间
  int _lastClickTimeMinutes = 0;

  /// 双击返回键退出
  Future<bool> _doubleClickBack() {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastClickTimeMinutes > 1500) {
      _lastClickTimeMinutes = DateTime.now().millisecondsSinceEpoch;
      Fluttertoast.showToast(msg: '再按一次 退出程序');
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
