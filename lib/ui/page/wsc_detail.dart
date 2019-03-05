import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';

class WSCDetailPage extends StatefulWidget {

  final String siteId;

  const WSCDetailPage({Key key, this.siteId}) : super(key: key);

  @override
  _WSCDetailPageState createState() => _WSCDetailPageState();
}

class _WSCDetailPageState extends State<WSCDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.FFF0F0F0,
      appBar: AppBar(
        backgroundColor: MyColors.FF2EAFFF,
        title: Text('监测点详情'),
        centerTitle: true,
      ),
    );
  }
}
