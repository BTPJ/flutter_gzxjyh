import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/model/produce_plan.dart';
import 'package:flutter_gzxjyh/ui/widget/empty_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_picker/flutter_picker.dart';

/// 首页(巡检人员)-数据查询-生产计划
class ProducePlanTrackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProducePlanTrackState();
}

class _ProducePlanTrackState extends State<ProducePlanTrackPage> {
  /// 供选择的年份集合
  List _years = List<String>();

  /// 选择的年份,默认为当前年（index为2）
  String _selYear = DateTime.now().year.toString();
  int _selIndex = 2;

  bool _isLoading = true;
  ProducePlan _producePlan;

  @override
  void initState() {
    super.initState();

    /// 初始化供选择的年份集（当前年的前后两年）
    _years
      ..add('${DateTime.now().year - 2}年')
      ..add('${DateTime.now().year - 1}年')
      ..add('${DateTime.now().year}年')
      ..add('${DateTime.now().year + 1}年')
      ..add('${DateTime.now().year + 2}年');
    _loadProducePlanTrack();
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: Text('生产计划追踪', style: TextStyle(fontSize: ScreenUtil().setSp(18))),
      centerTitle: true,
      actions: <Widget>[
        InkWell(
          child: Container(
            child: Row(
              children: <Widget>[
                Text(
                  _years[_selIndex],
                  style: TextStyle(
                      color: Colors.white, fontSize: ScreenUtil().setWidth(15)),
                ),
                Icon(Icons.date_range, color: Colors.white)
              ],
            ),
            margin: EdgeInsets.all(ScreenUtil().setWidth(6)),
          ),
          onTap: () => _showYearChoiceDialog(),
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _producePlan == null
              ? Center(child: EmptyView(msg: '暂无该年的生产计划'))
              : SingleChildScrollView(
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    border: TableBorder.all(color: MyColors.FFD9D9D9),
                    children: _renderTableRows(),
                  ),
                ),
    );
  }

  /// 查询生产计划
  _loadProducePlanTrack() {
    NetUtil.instance.get(Api.instance.producePlanTrack, (res) {
      var producePlan =
          BaseResp<ProducePlan>(res, (jsonRes) => ProducePlan.fromJson(jsonRes))
              .resultObj;
      setState(() {
        _isLoading = false;
        _producePlan = producePlan;
      });
    }, params: {'planYear': _selYear});
  }

  List<TableRow> _renderTableRows() {
    var tableRows = List<TableRow>();
    tableRows.add(TableRow(
        decoration: BoxDecoration(color: MyColors.FFF0F0F0),
        children: [
          _renderContent('计划项目'),
          _renderContent('年度预算'),
          _renderContent('实际数据')
        ]));
    for (var detail in _producePlan.prodList) {
      tableRows.add(TableRow(children: [
        _renderContent('${detail.planItemName}\n（${detail.unit}）'),
        _renderContent('${detail.numYear ?? '--'}'),
        _renderContent('${detail.numYearOfFact ?? '--'}')
      ]));
    }
    for (var detail in _producePlan.medList) {
      tableRows.add(TableRow(children: [
        _renderContent('${detail.planItemName}\n（${detail.unit}）'),
        _renderContent('${detail.numYear ?? '--'}'),
        _renderContent('${detail.numYearOfFact ?? '--'}')
      ]));
    }
    return tableRows;
  }

  /// 渲染Table里的内容
  Widget _renderContent(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(6),
          ScreenUtil().setHeight(12),
          ScreenUtil().setWidth(6),
          ScreenUtil().setHeight(12)),
      child: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: MyColors.FF101010, fontSize: ScreenUtil().setSp(15))),
    );
  }

  ///  显示年份选择的弹出框
  _showYearChoiceDialog() {
    Picker(
        adapter: PickerDataAdapter(pickerdata: _years),
        title: Text('请选择年份'),
        hideHeader: true,
        cancelText: '取消',
        confirmText: '确定',
        selecteds: [_selIndex],
        onConfirm: (Picker picker, List value) {
          setState(() {
            _isLoading = true;
            _selIndex = value[0];
            _selYear = _years[_selIndex].toString().substring(0, 4);
          });
          _loadProducePlanTrack();
        }).showDialog(context);
  }
}
