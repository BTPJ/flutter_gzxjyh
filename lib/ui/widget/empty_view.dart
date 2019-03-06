import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 空列表的提示组件
class EmptyView extends StatelessWidget {
  /// 提示文本
  final String msg;
  final IconData iconData;

  EmptyView({Key key, this.iconData: Icons.message, this.msg = '列表为空'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          iconData,
          size: ScreenUtil().setWidth(60),
          color: const Color(0xff888888),
        ),
        Container(
          child: Text(
            msg,
            style: TextStyle(
                color: const Color(0xff666666),
                fontSize: ScreenUtil().setSp(20)),
          ),
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
        )
      ],
    );
  }
}
