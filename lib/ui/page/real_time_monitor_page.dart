import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 巡检人员主界面-实时监控
class RealTimeMonitorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RealTimeMonitorState();
}

class RealTimeMonitorState extends State<RealTimeMonitorPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('实时监控'),
        backgroundColor: const Color(0xff2eafff),
        centerTitle: true,
      ),
      body: Center(
        child: Text('我是实时监控'),
      ),
    );
  }
}
