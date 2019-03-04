import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 首页(巡检人员)-实时监测Tab-实时监测Tab
class RealTimeMonitorChildTabPage extends StatefulWidget {
  @override
  _RealTimeMonitorChildTabPageState createState() =>
      _RealTimeMonitorChildTabPageState();
}

class _RealTimeMonitorChildTabPageState
    extends State<RealTimeMonitorChildTabPage> {
  GlobalKey _myKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      key: _myKey,
      children: <Widget>[
        /// 条件筛选
        Container(
          color: MyColors.FFF0F0F0,
          height: ScreenUtil().setHeight(40),
          child: Row(
            children: <Widget>[
              /// 监测区域
              Expanded(
                  child: InkWell(
                      child: Center(
                        child: Container(
                          height: ScreenUtil().setHeight(40),
                          child: Row(
                            children: <Widget>[
                              Text("监测区域",
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(14),
                                      color: _popBuilder
                                          ? MyColors.FF2EAFFF
                                          : MyColors.FF333333)),
                              Icon(Icons.arrow_drop_down,
                                  color: _popBuilder
                                      ? MyColors.FF2EAFFF
                                      : MyColors.FF333333)
                            ],
                          ),
                        ),
                      ),
                      onTap: (){

                        showDialog<Null>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Container(
                              //height: _myKey.currentContext.size.height+ScreenUtil.bottomBarHeight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("1"),
                                  Text("2"),
                                ],
                              ),
                            );
                          },
                        ).then((val) {
                          print(val);
                        });

                      })),

              Container(
                color: MyColors.FFCCCCCC,
                width: ScreenUtil().setWidth(1),
                height: ScreenUtil().setHeight(24),
              ),

              /// 站点类型
              Expanded(
                  child: Center(
                child: PopupMenuButton<int>(
                  elevation: 0,
                  offset: Offset(
                      ScreenUtil().setWidth(20), ScreenUtil().setWidth(40)),
                  // padding: const EdgeInsets.all(0.0),
                  itemBuilder: _popItemBuilder,
                  onSelected: (position) {
                    _siteTypeIndex = position;
                    _popBuilder = false;
                    setState(() {});
                  },
                  onCanceled: () {
                    _popBuilder = false;
                    setState(() {});
                  },
                  child: Container(
                    height: ScreenUtil().setHeight(40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(_siteTypeList[_siteTypeIndex],
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(14),
                                color: _popBuilder
                                    ? MyColors.FF2EAFFF
                                    : MyColors.FF333333)),
                        Icon(Icons.arrow_drop_down,
                            color: _popBuilder
                                ? MyColors.FF2EAFFF
                                : MyColors.FF333333)
                      ],
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),

        /// 列表

      ],
    );
  }

  List<String> _siteTypeList = ["全部", "泵站", "污水厂"];
  int _siteTypeIndex = 0;
  bool _popBuilder = false;

  List<PopupMenuEntry<int>> _popItemBuilder(BuildContext context) {
    var list = List<PopupMenuEntry<int>>();

    for (int i = 0; i < _siteTypeList.length; i++) {
      list.add(
        PopupMenuItem(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                _siteTypeList[i],
                style: TextStyle(
                    color: i == _siteTypeIndex
                        ? MyColors.FF2EAFFF
                        : MyColors.FF333333,
                    fontSize: ScreenUtil().setSp(14)),
              ),
              Opacity(
                opacity: i == _siteTypeIndex ? 1 : 0,
                child: Icon(Icons.check, color: MyColors.FF2EAFFF),
              )
            ],
          ),
          value: i,
        ),
      );

      if (i != _siteTypeList.length - 1) {
        list.add(PopupMenuDivider(height: 1.0));
      }
    }

    _popBuilder = true;
    setState(() {});
    return list;
  }
}
