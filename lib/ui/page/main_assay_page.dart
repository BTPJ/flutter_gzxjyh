import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/ui/page/contact_page.dart';
import 'package:flutter_gzxjyh/ui/page/data_query_page.dart';
import 'package:flutter_gzxjyh/ui/page/home_assay_tab_page.dart';
import 'package:flutter_gzxjyh/utils/toast_util.dart';
import 'package:flutter_gzxjyh/utils/screen_util.dart';

/// 化验类主页,底部为三标签
class MainAssayPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainAssayPageState();
}

class MainAssayPageState extends State<MainAssayPage> {
  int _tabIndex = 0;

  /// tab的图片
  var _tabImages;
  var tabTitles = ['首页', '数据查询', '通讯录'];

  /// 存储的三个子页面
  var _childPages;

  @override
  Widget build(BuildContext context) {
    _initPages();
    return WillPopScope(
        child: Scaffold(
          body: IndexedStack(children: _childPages, index: _tabIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: getTabIcon(0), title: getTabTitle(0)),
              BottomNavigationBarItem(
                  icon: getTabIcon(1), title: getTabTitle(1)),
              BottomNavigationBarItem(
                  icon: getTabIcon(2), title: getTabTitle(2)),
            ],
            currentIndex: _tabIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              setState(() {
                _tabIndex = index;
              });
            },
          ),
        ),
        onWillPop: _doubleClickBack);
  }

  /// 初始化页面
  _initPages() {
    _tabImages = [
      [
        getTabImage('images/ic_index.png'),
        getTabImage('images/ic_index_sel.png')
      ],
      [
        getTabImage('images/ic_report_history.png'),
        getTabImage('images/ic_report_history_sel.png')
      ],
      [
        getTabImage('images/ic_call.png'),
        getTabImage('images/ic_call_sel.png')
      ],
    ];

    _childPages = [
      HomeAssayTabPage(),
      DataQueryPage(),
      ContactPage()
    ];
  }

  /// 根据image路径获取图片
  Image getTabImage(path) => Image.asset(path,
      width: ScreenUtil().setWidth(24), height: ScreenUtil().setHeight(24));

  /// 根据索引获得对应的normal或是press的icon
  Image getTabIcon(int currentIndex) {
    if (currentIndex == _tabIndex) {
      return _tabImages[currentIndex][1];
    }
    return _tabImages[currentIndex][0];
  }

  /// 获取bottomTab的颜色和文字
  Text getTabTitle(int currentIndex) {
    if (currentIndex == _tabIndex) {
      return Text(tabTitles[currentIndex],
          style: TextStyle(
              color: const Color(0xff2eafff),
              fontSize: ScreenUtil().setSp(12)));
    }
    return Text(tabTitles[currentIndex],
        style: TextStyle(
            color: const Color(0xff787878), fontSize: ScreenUtil().setSp(12)));
  }

  /// 上次点击返回键的时间
  int _lastClickTimeMinutes = 0;

  /// 双击返回键退出
  Future<bool> _doubleClickBack() {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastClickTimeMinutes > 1500) {
      _lastClickTimeMinutes = DateTime.now().millisecondsSinceEpoch;
      ToastUtil.showShort('再按一次 退出程序');
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}