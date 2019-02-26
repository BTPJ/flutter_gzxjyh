import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 自定义的LoadingDialog
// ignore: must_be_immutable
class LoadingDialog extends Dialog {
  String text;

  LoadingDialog({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: 自定义显示框大小等试图
    return Material(
      type: MaterialType.transparency, // 透明类型
      child: Center(
        child: Container(
          width: ScreenUtil().setHeight(100),
          height: ScreenUtil().setHeight(100),
          decoration: ShapeDecoration(
              color: Colors.black38,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setHeight(4))))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CupertinoActivityIndicator(radius: ScreenUtil().setWidth(16),),
              Padding(
                padding: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(14), color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
