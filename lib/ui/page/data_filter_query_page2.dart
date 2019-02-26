import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/model/site_info.dart';
import 'package:flutter_gzxjyh/ui/page/choose_sewage_page.dart';
import 'package:flutter_gzxjyh/utils/date_util.dart';
import 'package:flutter_gzxjyh/utils/toast_util.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 首页(巡检人员)-数据查询-化验数据/生产数据-查询
class DataFilterQueryPage2 extends StatefulWidget {
  /// 标题
  final String title;

  const DataFilterQueryPage2({Key key, @required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DataFilterQueryState2();
}

class _DataFilterQueryState2 extends State<DataFilterQueryPage2> {
  var _blackTextStyle =
      TextStyle(color: MyColors.FF333333, fontSize: ScreenUtil().setSp(16));
  var _blueTextStyle =
      TextStyle(color: MyColors.FF1296DB, fontSize: ScreenUtil().setSp(16));

  SiteInfo _chooseSite;
  String _chooseDate;

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      backgroundColor: MyColors.FFF0F0F0,
      titleSpacing: ScreenUtil().setWidth(-36),
      title: Text(widget?.title,
          style: TextStyle(
              color: MyColors.FF666666, fontSize: ScreenUtil().setSp(17))),
      leading: Container(),
      centerTitle: false,
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.close, color: MyColors.FF101010),
            onPressed: () => Navigator.pop(context))
      ],
    );

    var divider = Padding(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20)),
        child: Divider(height: 1.0));

    return Scaffold(
      appBar: appBar,
      body: Column(
        children: <Widget>[
          /// 污水厂
          InkWell(
            child: Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
              child: Row(
                children: <Widget>[
                  Text('污水厂', style: _blackTextStyle),
                  Expanded(
                      child: Text(
                    _chooseSite?.name ?? '',
                    textAlign: TextAlign.end,
                    style: _blueTextStyle,
                  )),
                  Icon(Icons.keyboard_arrow_right)
                ],
              ),
            ),
            onTap: () {
              /// 进入站点选择
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              ChooseSewagePage(chooseSite: _chooseSite)))
                  .then((site) {
                if (site != null) {
                  setState(() {
                    _chooseSite = site;
                  });
                }
              });
            },
          ),

          divider,
          _renderTime(),
          Divider(height: 1.0),

          /// 查询
          Container(
            width: ScreenUtil.screenWidth,
            margin: EdgeInsets.all(ScreenUtil().setWidth(20)),
            child: RaisedButton(
              padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
              color: MyColors.FF2EAFFF,
              onPressed: () {
                //TODO 查询
                if (_chooseSite == null) {
                  ToastUtil.showShort('请选择污水厂');
                  return;
                }
                if (_chooseDate == null) {
                  ToastUtil.showShort('请选择化验日期');
                  return;
                }
                Navigator.pop(context, [_chooseSite, _chooseDate]);
              },
              child: Text(
                '查询',
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(17)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 渲染时间视图
  Widget _renderTime() {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
        child: Row(
          children: <Widget>[
            Text('化验日期', style: _blackTextStyle),
            Expanded(
                child: Text(
              _chooseDate ?? '',
              textAlign: TextAlign.end,
              style: _blueTextStyle,
            )),
            Icon(Icons.keyboard_arrow_right)
          ],
        ),
      ),
      onTap: () => _showTimePicker(),
    );
  }

  ///  显示时间选择
  _showTimePicker() {
    var currentTime = DateTime.now();
    if (_chooseDate != null) {
      currentTime = DateTime.tryParse(_chooseDate);
    }

    Picker(
        adapter: DateTimePickerAdapter(
            isNumberMonth: true,
            value: currentTime,
            yearBegin: DateTime.now().year - 2,
            yearEnd: DateTime.now().year + 2,
            type: PickerDateTimeType.kYMD,
            yearSuffix: '年',
            monthSuffix: '月',
            daySuffix: '日'),
        confirmText: '确定',
        cancelText: '取消',
        title: Text('请选择化验日期'),
        onConfirm: (Picker picker, List<int> selected) {
          //TODO 选中事件回调
          print(picker.adapter.text);
          setState(() {
            _chooseDate = picker.adapter.text
                .substring(0, DateUtil.FORMAT_YEAR_MONTH_DAY.length);
          });
        }).showModal(context);
  }
}
