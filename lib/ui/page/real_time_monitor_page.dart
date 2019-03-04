import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/ui/page/real_time_monitor_child_tab_page.dart';
import 'package:flutter_gzxjyh/ui/page/real_time_warn_tab_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 巡检人员主界面-实时监控
class RealTimeMonitorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RealTimeMonitorState();
}

class RealTimeMonitorState extends State<RealTimeMonitorPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _selectedIndex = 0;
  List<Widget> _tabs = [Tab(text: '实时监测'), Tab(text: '实时告警')];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      vsync: this,
      initialIndex: _selectedIndex,
      length: _tabs.length,
    );
  }

  @override
  void dispose() {
    super.dispose();
    //释放内存
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      appBar: AppBar(
        title: Text('实时监控'),
        backgroundColor: MyColors.FF2EAFFF,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: MyColors.FF1296DB,
              labelColor: MyColors.FF1296DB,
              unselectedLabelColor: MyColors.FF101010,
              indicatorWeight: ScreenUtil().setHeight(3),
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: TextStyle(fontSize: ScreenUtil().setSp(16)),
              tabs: _tabs,
            ),
          ),

          Expanded(
              child: TabBarView(controller: _tabController, children: [
            /// 实时监测
            RealTimeMonitorChildTabPage(),

            /// 实时告警
            RealTimeWarnTabPage()
          ]))
        ],
      ),
    );
  }
}
