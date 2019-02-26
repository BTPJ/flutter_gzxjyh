import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/ui/page/produce_data_record_tab_page.dart';
import 'package:flutter_gzxjyh/ui/page/produce_data_report_tab_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 首页-生产数据填报
class ProduceDataReportPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProduceDataReportState();
}

class ProduceDataReportState extends State<ProduceDataReportPage>
    with SingleTickerProviderStateMixin {

  TabController _tabController;
  int _selectedIndex = 0;
  List<Widget> _tabs = [Tab(text: '数据填报'), Tab(text: '填报记录')];

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
    //释放内存
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('生产数据填报'),
        backgroundColor: const Color(0xff1296db),
        centerTitle: true,
      ),

      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xff1296db),
              labelColor: const Color(0xff1296db),
              unselectedLabelColor: const Color(0xff101010),
              indicatorWeight: ScreenUtil().setHeight(3),
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: TextStyle(fontSize: ScreenUtil().setSp(16)),
              tabs: _tabs,
            ),
          ),
          Container(
            color: const Color(0xfff0f0f0),
            height: ScreenUtil().setHeight(10),
          ),
          Expanded(
              child: TabBarView(controller: _tabController, children: [
                /// 数据填报
                ProduceDataReportTabPage(),
                /// 填报记录
                ProduceDataRecordTabPage()
              ]))
        ],
      ),
    );
  }
}
