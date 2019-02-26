import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 声音大小的仿水波纹展示
class RecordVolumeView extends StatefulWidget {
  /// 进度（0-100）
  final double progress;

  const RecordVolumeView({Key key, this.progress = 0}) : super(key: key);

  @override
  _RecordVolumeViewState createState() => _RecordVolumeViewState();
}

class _RecordVolumeViewState extends State<RecordVolumeView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        /// 最里层的圆形背景
        Container(
          decoration:
              BoxDecoration(color: MyColors.FF2EAFFF, shape: BoxShape.circle),
          width: ScreenUtil().setWidth(180),
          height: ScreenUtil().setWidth(180),
        ),

        /// 第一层圆环
        Opacity(
          opacity: widget.progress > 0 ? 1 : 0,
          child: Container(
              width: ScreenUtil().setWidth(196),
              height: ScreenUtil().setWidth(196),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: MyColors.CC2E9BE9,
                      width: ScreenUtil().setWidth(8)))),
        ),

        /// 第二层圆环
        Opacity(
            opacity: widget.progress > 20 ? 1 : 0,
            child: Container(
                width: ScreenUtil().setWidth(216),
                height: ScreenUtil().setWidth(216),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: MyColors.A32E9BE9,
                        width: ScreenUtil().setWidth(10))))),

        /// 第三层圆环
        Opacity(
            opacity: widget.progress > 40 ? 1 : 0,
            child: Container(
                width: ScreenUtil().setWidth(242),
                height: ScreenUtil().setWidth(242),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: MyColors.F822E9BE9,
                        width: ScreenUtil().setWidth(13))))),

        /// 第四层圆环
        Opacity(
            opacity: widget.progress > 60 ? 1 : 0,
            child: Container(
                width: ScreenUtil().setWidth(276),
                height: ScreenUtil().setWidth(276),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: MyColors.F682E9BE9,
                        width: ScreenUtil().setWidth(17))))),

        /// 第五层圆环
        Opacity(
            opacity: widget.progress > 80 ? 1 : 0,
            child: Container(
                width: ScreenUtil().setWidth(320),
                height: ScreenUtil().setWidth(320),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: MyColors.F502E9BE9,
                        width: ScreenUtil().setWidth(22))))),
      ],
    );
  }
}
