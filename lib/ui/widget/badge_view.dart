import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 自定义一个显示Badge的组件
class BadgeView extends StatefulWidget {
  /// badgeView的背景颜色
  final Color color;

  /// 子组件
  final Widget child;

  /// badgeView上显示的数值（<0时不显示、0：显示小红点，1~99显示数值，>99 显示99+）
  final int num;

  final EdgeInsetsGeometry margin;

  const BadgeView(
      {Key key,
      this.color: const Color(0xffff0707),
      @required this.child,
      this.num,
      this.margin})
      : super(key: key);

  @override
  _BadgeViewState createState() => _BadgeViewState();
}

class _BadgeViewState extends State<BadgeView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: FractionalOffset.topCenter,
      children: <Widget>[
        Align(child: widget.child),
        Offstage(
          offstage: widget.num < 0,
          child: Container(
            padding:
                EdgeInsets.all(ScreenUtil().setWidth(_getPadding(widget.num))),
            margin: widget.margin,
            decoration:
                BoxDecoration(color: widget.color, shape: BoxShape.circle),
            child: Text(_getNum(widget.num),
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(11))),
          ),
        )
      ],
    );
  }

  /// 获取显示的数值
  String _getNum(int num) {
    if (num == 0) {
      return '';
    }
    if (num > 99) {
      return '99+';
    }
    return '$num';
  }

  /// 获取BadgeView的padding值
  int _getPadding(int num) {
    if (num == 0) {
      return 4;
    }
    if (num > 99) {
      return 6;
    }
    return 4;
  }
}
