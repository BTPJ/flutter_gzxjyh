import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';

/// 审核
class AssayDataAuditPage extends StatefulWidget {
  @override
  _AssayDataAuditPageState createState() => _AssayDataAuditPageState();
}

class _AssayDataAuditPageState extends State<AssayDataAuditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.FFF0F0F0,
      appBar: AppBar(
        backgroundColor: MyColors.FF2EAFFF,
        title: Text('任务延期审核'),
        centerTitle: true,
      ),
    );
  }
}
