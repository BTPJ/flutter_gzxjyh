import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';

/// 泵站详情
class BZDetailPage extends StatefulWidget {
  final String siteId;

  const BZDetailPage({Key key, this.siteId}) : super(key: key);

  @override
  _BZDetailPageState createState() => _BZDetailPageState();
}

class _BZDetailPageState extends State<BZDetailPage> {
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
