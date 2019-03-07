import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/model/site_info.dart';
import 'package:flutter_gzxjyh/ui/page/choose_site_page.dart';
import 'package:flutter_gzxjyh/utils/date_util.dart';
import 'package:flutter_gzxjyh/utils/toast_util.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_gzxjyh/utils/screen_util.dart';

/// 首页(巡检人员)-数据查询-监测数据/告警数据-查询
class DataFilterQueryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DataFilterQueryState();
}

class _DataFilterQueryState extends State<DataFilterQueryPage> {
  var _blackTextStyle =
      TextStyle(color: MyColors.FF333333, fontSize: ScreenUtil().setSp(16));
  var _blueTextStyle =
      TextStyle(color: MyColors.FF1296DB, fontSize: ScreenUtil().setSp(16));

  String _chooseSiteType;
  var _siteTypeList = ['泵站', '污水厂'];
  SiteInfo _chooseSite;
  String _startDate;
  String _endDate;

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      backgroundColor: MyColors.FFF0F0F0,
      titleSpacing: ScreenUtil().setWidth(-36),
      title: Text('监测数据查询',
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
          /// 站点类型
          InkWell(
            child: Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
              child: Row(
                children: <Widget>[
                  Text('站点类型', style: _blackTextStyle),
                  Expanded(
                      child: Text(
                    _chooseSiteType ?? '',
                    textAlign: TextAlign.end,
                    style: _blueTextStyle,
                  )),
                  Icon(Icons.keyboard_arrow_right)
                ],
              ),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      contentPadding: EdgeInsets.zero,
                      children: _renderSiteTypeItem(),
                    );
                  });
            },
          ),

          divider,

          /// 站点名称
          InkWell(
            child: Container(
              padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
              child: Row(
                children: <Widget>[
                  Text('站点名称', style: _blackTextStyle),
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
              if (_chooseSiteType == null) {
                ToastUtil.showShort('请先选择站点类型');
                return;
              }

              /// 进入站点选择
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ChooseSitePage(
                          chooseSite: _chooseSite,
                          siteType: _chooseSiteType))).then((site) {
                if (site != null) {
                  setState(() {
                    _chooseSite = site;
                  });
                }
              });
            },
          ),

          divider,
          _renderTime(true),
          divider,
          _renderTime(false),
          divider,

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
                  ToastUtil.showShort('请选择站点名称');
                  return;
                }
                if (_startDate != null && _endDate == null ||
                    _startDate == null && _endDate != null) {
                  ToastUtil.showShort('请同时选择开始和结束日期');
                  return;
                }
                Navigator.pop(context, [_chooseSite, _startDate, _endDate]);
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
  /// isStartDate 是否是开始时间
  Widget _renderTime(bool isStartDate) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
        child: Row(
          children: <Widget>[
            Text(isStartDate ? '开始日期' : '结束日期', style: _blackTextStyle),
            Expanded(
                child: Text(
              isStartDate ? _startDate ?? '' : _endDate ?? '',
              textAlign: TextAlign.end,
              style: _blueTextStyle,
            )),
            Icon(Icons.keyboard_arrow_right)
          ],
        ),
      ),
      onTap: () => _showTimePicker(isStartDate),
    );
  }

  /// 渲染站点类型弹出框列表项
  List<Widget> _renderSiteTypeItem() {
    var list = List<Widget>();
    for (var siteType in _siteTypeList) {
      var selected = _chooseSiteType == siteType;
      list
        ..add(SimpleDialogOption(
          child: Container(
            padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(10),
                bottom: ScreenUtil().setHeight(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(siteType,
                    style: TextStyle(
                        color: selected ? MyColors.FF1296DB : MyColors.FF333333,
                        fontSize: ScreenUtil().setSp(16))),
                Offstage(
                    child: Icon(Icons.check, color: MyColors.FF1296DB),
                    offstage: !selected)
              ],
            ),
          ),
          onPressed: () {
            setState(() {
              _chooseSiteType = siteType;
            });
            Navigator.pop(context);
          },
        ))
        ..add(Padding(
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(10),
              right: ScreenUtil().setWidth(10)),
          child: Divider(height: 1.0),
        ));
    }
    return list;
  }

  ///  显示时间选择
  ///  isStartDate 是否是开始时间
  _showTimePicker(bool isStartDate) {
    var currentTime = DateTime.now();
    if (isStartDate && _startDate != null) {
      currentTime = DateTime.tryParse(_startDate);
    }
    if (!isStartDate && _endDate != null) {
      currentTime = DateTime.tryParse(_endDate);
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
          // 监测时间是否合法，开始时间应不晚于结束时间
          var date = DateTime.tryParse(picker.adapter.text
              .substring(0, DateUtil.FORMAT_YEAR_MONTH_DAY.length));
          if (isStartDate) {
            if (_endDate != null) {
              if (!DateTime.tryParse(_endDate).isBefore(date)) {
                setState(() {
                  _startDate = DateUtil.dateTimeStr(date,
                      formatStr: DateUtil.FORMAT_YEAR_MONTH_DAY);
                });
              } else {
                ToastUtil.showShort('开始时间应不晚于结束时间');
              }
            } else {
              setState(() {
                _startDate = DateUtil.dateTimeStr(date,
                    formatStr: DateUtil.FORMAT_YEAR_MONTH_DAY);
              });
            }
          } else {
            if (_startDate != null) {
              if (!date.isBefore(DateTime.tryParse(_startDate))) {
                setState(() {
                  _endDate = DateUtil.dateTimeStr(date,
                      formatStr: DateUtil.FORMAT_YEAR_MONTH_DAY);
                });
              } else {
                ToastUtil.showShort('结束时间应不早于开始时间');
              }
            } else {
              setState(() {
                _endDate = DateUtil.dateTimeStr(date,
                    formatStr: DateUtil.FORMAT_YEAR_MONTH_DAY);
              });
            }
          }
        }).showModal(context);
  }
}
