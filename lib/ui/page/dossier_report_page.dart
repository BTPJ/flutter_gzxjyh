import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/event/event_code.dart';
import 'package:flutter_gzxjyh/event/event_manager.dart';
import 'package:flutter_gzxjyh/ui/page/dossier_record_page.dart';
import 'package:flutter_gzxjyh/ui/page/dossier_report_child_page.dart';
import 'package:flutter_gzxjyh/utils/screen_util.dart';

/// 巡检人员主界面-首页-问题上报
class DossierReportPage extends StatefulWidget {
  @override
  _DossierReportPageState createState() => _DossierReportPageState();
}

class _DossierReportPageState extends State<DossierReportPage>
    with SingleTickerProviderStateMixin {
  /// tab控制器
  TabController _tabController;

  /// tab选中位置
  int _selTabIndex = 0;

  /// tabs
  List<Widget> _tabs = [Tab(text: '问题上报'), Tab(text: '上报记录')];

  @override
  void initState() {
    super.initState();

    /// 初始化_tabController
    _tabController = TabController(
        length: _tabs.length, vsync: this, initialIndex: _selTabIndex);

    EventManager.instance.eventBus.on<EventCode>().listen((event) {
      if (event.code == EventCode.REPORT_DOSSIER_TASK_SUCCESS) {
        _tabController.animateTo(1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: Text('问题上报'),
      backgroundColor: MyColors.FF2EAFFF,
      centerTitle: true,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: Column(
        children: <Widget>[
          /// Tab导航栏
          Container(
              child: TabBar(
                  tabs: _tabs,
                  controller: _tabController,
                  indicatorColor: MyColors.FF2EAFFF,
                  labelColor: MyColors.FF2EAFFF,
                  unselectedLabelColor: MyColors.FF101010,
                  indicatorWeight: ScreenUtil().setHeight(3),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: TextStyle(fontSize: ScreenUtil().setSp(16)))),

          /// 分割线
          Divider(height: 1.0),

          /// 子页面
          Expanded(
              child: TabBarView(
                  children: [DossierReportChildPage(), DossierRecordPage()],
                  controller: _tabController))
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
}
