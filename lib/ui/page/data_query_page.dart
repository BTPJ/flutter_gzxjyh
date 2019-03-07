import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/ui/page/history_dossier_page.dart';
import 'package:flutter_gzxjyh/ui/page/history_task_page.dart';
import 'package:flutter_gzxjyh/ui/page/monitor_data_page.dart';
import 'package:flutter_gzxjyh/ui/page/produce_data_page.dart';
import 'package:flutter_gzxjyh/ui/page/produce_plan_track_page.dart';
import 'package:flutter_gzxjyh/ui/page/warn_data_page.dart';
import 'package:flutter_gzxjyh/utils/screen_util.dart';

/// 巡检人员主界面-数据查询
class DataQueryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DataQueryState();
}

class DataQueryState extends State<DataQueryPage> {
  static const _HISTORY_TASK = 0;
  static const _HISTORY_DOSSIER = 1;
  static const _MONITOR_DATA = 2;
  static const _WARN_DATA = 3;
  static const _LABORATORY_DATA = 4;
  static const _PRODUCT_DATA = 5;
  static const _PRODUCT_PLAN = 6;
  static const _DEVICE_INFO = 7;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('数据查询'),
        backgroundColor: const Color(0xff2eafff),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(10),
            ScreenUtil().setHeight(20),
            ScreenUtil().setWidth(10),
            ScreenUtil().setHeight(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: _getItem(
                        'images/ic_history_task.png', '历史任务', _HISTORY_TASK)),
                Expanded(
                    child: _getItem('images/ic_history_dossier.png', '历史案卷',
                        _HISTORY_DOSSIER)),
                Expanded(
                    child: _getItem(
                        'images/ic_monitor_data.png', '监测数据', _MONITOR_DATA)),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: _getItem(
                        'images/ic_warn_data.png', '告警数据', _WARN_DATA)),
                Expanded(
                    child: _getItem('images/ic_laboratory_data.png', '化验数据',
                        _LABORATORY_DATA)),
                Expanded(
                    child: _getItem(
                        'images/ic_product_data.png', '生产数据', _PRODUCT_DATA)),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: _getItem(
                      'images/ic_product_plan.png', '生产计划', _PRODUCT_PLAN),
                ),
                Expanded(
                  child: _getItem(
                      'images/ic_device_info.png', '设备信息', _DEVICE_INFO),
                ),
                Expanded(
                  child: Text(''),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 渲染每个Item的组件
  Widget _getItem(String imagePath, String text, int index) {
    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(imagePath,
              width: ScreenUtil().setWidth(64),
              height: ScreenUtil().setWidth(64)),
          Container(
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
            child: Text(text,
                style: TextStyle(
                    color: const Color(0xff1010101),
                    fontSize: ScreenUtil().setSp(16))),
          ),
        ],
      ),
      onTap: () {
        switch (index) {
          case _HISTORY_TASK: // 历史任务
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => HistoryTaskPage()));
            break;
          case _HISTORY_DOSSIER: // 历史案卷
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => HistoryDossierPage()));
            break;
          case _MONITOR_DATA: // 监测数据
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => MonitorDataPage()));
            break;
          case _WARN_DATA: // 告警数据
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => WarnDataPage()));
            break;
          case _LABORATORY_DATA: // 化验数据
            break;
          case _PRODUCT_DATA: // 生产数据
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => ProduceDataPage()));
            break;
          case _PRODUCT_PLAN: // 生产计划
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => ProducePlanTrackPage()));
            break;
          case _DEVICE_INFO: // 设备信息
            break;
        }
      },
    );
  }
}
