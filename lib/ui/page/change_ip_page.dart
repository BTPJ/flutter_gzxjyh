import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/sp_key.dart';
import 'package:flutter_gzxjyh/utils/sp_util.dart';
import 'package:flutter_gzxjyh/utils/screen_util.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/ui/page/login_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// 切换IP的界面
class ChangeIpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChangeIpState();
}

class ChangeIpState extends State<ChangeIpPage> {
  List<String> _ipList = List();
  String _currentIp = '';
  TextEditingController _ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  /// 初始化(异步)
  _initAsync() async {
    await SpUtil.getInstance();
    var ipList = SpUtil.getString(SpKey.IP_LIST)?.split('、');
    setState(() {
      _ipList.add(Api.DEFAULT_IP);
      if (ipList != null) {
        ipList.forEach((ip) {
          if (ip.isNotEmpty) {
            _ipList.add(ip);
          }
        });
      }
      _currentIp = SpUtil.getString(SpKey.DEFAULT_IP) ?? Api.DEFAULT_IP;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('切换Ip'),
        centerTitle: true,
        leading: InkWell(
          child: Icon(
            Icons.chevron_left,
            size: 40.0,
            color: Colors.white,
          ),
          onTap: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xff37a8e8),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10.0, 4.0, 10.0, 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(right: 10.0),
                          child: TextField(
                            controller: _ipController,
                            autofocus: false,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(6.0),
                                hintText: '请输入Ip和端口'),
                          ))),
                  FlatButton(
                    color: const Color(0xff37a8e8),
                    child: Text('确定',
                        style: TextStyle(color: const Color(0xffffffff))),
                    onPressed: () {
                      if (_ipController.text.isEmpty) {
                        Fluttertoast.showToast(msg: '请输入ip与端口号');
                        return;
                      }
                      showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                                key: Key('a'),
                                title: Text('你确定修改Ip为：${_ipController.text}'),
                                actions: <Widget>[
                                  FlatButton(
                                      child: Text('取消'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                  FlatButton(
                                      child: Text('确定'),
                                      onPressed: () {
                                        String defaultIp = _ipController.text;
                                        SpUtil.putString(
                                            SpKey.DEFAULT_IP, defaultIp);
                                        _ipList.add(defaultIp);
                                        // 去重并转为Json
                                        Set set = Set.from(_ipList);
                                        String ipSetStr = '';
                                        set.forEach((ip) {
                                          ipSetStr += '$ip、';
                                        });
                                        SpUtil.putString(
                                            SpKey.IP_LIST, ipSetStr);
                                        // 赋值选中的IP
                                        Api.selIp = defaultIp;
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => LoginPage()),
                                            (route) => route == null);
                                      })
                                ]);
                          });
                    },
                  ),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(left: 10.0),
                width: ScreenUtil.screenWidth,
                color: const Color(0xfff0f0f0),
                height: 45.0,
                child: Text('历史IP与端口(可选择)', style: TextStyle(fontSize: 14.0)),
                alignment: Alignment.centerLeft),
            Expanded(
                child: ListView.builder(
              itemBuilder: (BuildContext buildContext, int index) =>
                  _renderItem(index),
              itemCount: _ipList.length * 2,
            ))
          ],
        ),
      ),
    );
  }

  /// 渲染IP列表的Item
  _renderItem(int index) {
    if (index.isOdd) {
      return Padding(
        child: Divider(height: 1.0, color: const Color(0xffd9d9d9)),
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      );
    }

    index = index ~/ 2;
    String ip = _ipList[index];
    var item = Container(
      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      height: 60.0,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(ip),
          ),
          _currentIp != ip
              ? InkWell(
                  child: Icon(
                    Icons.close,
                    size: 20.0,
                  ),
                  onTap: () {
                    setState(() {
                      _ipList.remove(ip);
                      // 去重
                      Set set = Set.from(_ipList);
                      String ipSetStr = '';
                      set.forEach((ip) {
                        ipSetStr += '$ip、';
                      });
                      SpUtil.putString(SpKey.IP_LIST, ipSetStr);
                    });
                  },
                )
              : Container()
        ],
      ),
    );

    return InkWell(
        child: item,
        onTap: () {
          _ipController.text = ip;
        });
  }
}
