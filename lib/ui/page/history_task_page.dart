import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/model/maintain_task.dart';
import 'package:flutter_gzxjyh/model/patrol_task.dart';
import 'package:flutter_gzxjyh/model/task.dart';
import 'package:flutter_gzxjyh/ui/page/patrol_task_detail_page.dart';
import 'package:flutter_gzxjyh/ui/widget/empty_view.dart';
import 'package:flutter_gzxjyh/ui/widget/loading_more.dart';
import 'package:flutter_gzxjyh/utils/date_util.dart';
import 'package:flutter_gzxjyh/utils/toast_util.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 首页(巡检人员)-数据查询-历史任务
class HistoryTaskPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HistoryTaskState();
}

class _HistoryTaskState extends State<HistoryTaskPage> {
  var _taskTypeList = ['巡检任务', '养护任务'];
  var _taskTypeIndex = 0;
  var _taskType = 0;
  var _executorTypeList = ['全部', '自己'];
  var _executorTypeIndex = 0;
  var _statusTypeList = ['全部', '已关闭', '未执行', '按时完成', '延期完成'];
  var _statusTypeIndex = 0;
  static const TYPE_TASK = 0;
  static const TYPE_EXECUTOR = 1;
  static const TYPE_STATUS = 2;

  static var _beginTimeHint = '开始时间';
  var _beginTimeStr = _beginTimeHint;
  static var _endTimeHint = '结束时间';
  var _endTimeStr = _endTimeHint;

  /// 滑动控制器
  ScrollController _scrollController;
  var _list = List<Task>();

  /// 是否正在加载
  bool _isLoading = true;

  /// 当前页
  var _pageNo = 1;

  /// 每次请求的数量
  static const int _PAGE_SIZE = 10;

  /// 列表数量
  var _listTotalSize = 0;

  @override
  void initState() {
    super.initState();
    _initScrollController();
    _onRefresh();
  }

  /// 初始化ScrollController
  _initScrollController() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      // 最大的滚动距离
      var maxScrollPixels = _scrollController.position.maxScrollExtent;
      // 已向下滚动的距离
      var nowScrollPixels = _scrollController.position.pixels;
      // 对比判定是否滚动到底从而分页加载
      if (nowScrollPixels == maxScrollPixels && _list.length < _listTotalSize) {
        _onLoadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            Text('历史任务查询', style: TextStyle(fontSize: ScreenUtil().setSp(18))),
        centerTitle: true,
        actions: <Widget>[
          /// 这里需要添加Builder才能使用Scaffold.of(context)
          Builder(
              builder: (BuildContext context) => InkWell(
                    child: Container(
                      width: ScreenUtil().setWidth(74),
                      padding: EdgeInsets.only(
                          right: ScreenUtil().setWidth(10),
                          left: ScreenUtil().setWidth(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text('筛选',
                              style:
                                  TextStyle(fontSize: ScreenUtil().setSp(15))),
                          Image.asset('images/ic_filter.png',
                              width: ScreenUtil().setWidth(18),
                              height: ScreenUtil().setWidth(18)),
                        ],
                      ),
                    ),
                    onTap: () {
                      Scaffold.of(context).openEndDrawer();
                    }, // 打开抽屉
                  ))
        ],
      ),
      endDrawer: _renderEndDrawer(),
      body: Column(children: <Widget>[
        Container(
          width: ScreenUtil.screenWidth,
          height: ScreenUtil().setHeight(40),
          color: const Color(0xfff0f0f0),
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(11)),
          alignment: Alignment.centerLeft,
          child: Text(
            _taskType == 0 ? '巡检任务' : '养护任务',
            style: TextStyle(
                color: const Color(0xff101010),
                fontSize: ScreenUtil().setSp(15)),
          ),
        ),
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Offstage(child: EmptyView(), offstage: _list.isNotEmpty),
                    RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: ListView.builder(
                            // 保持ListView任何情况都能滚动，解决在RefreshIndicator的兼容问题(列表未铺满时无法上拉)
                            physics: AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            itemBuilder: _renderItem,
                            itemCount: _list.length * 2 + 1))
                  ],
                ),
        )
      ]),
    );
  }

  /// 渲染ListItem
  Widget _renderItem(BuildContext context, int index) {
    if (index == _list.length * 2) {
      if (_listTotalSize > _PAGE_SIZE) {
        return LoadingMore(haveMore: _list.length < _listTotalSize);
      } else {
        /// 当列表不够上拉时，返回空布局
        return Container();
      }
    }

    if (index.isOdd) {
      return Padding(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(16), right: ScreenUtil().setWidth(16)),
        child: Divider(height: 1.0),
      );
    }

    index = index ~/ 2;
    Task task = _list[index];

    return InkWell(
      child: Container(
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(16), right: ScreenUtil().setWidth(16)),
        width: ScreenUtil.screenWidth,
        height: ScreenUtil().setHeight(80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  _taskType == 0
                      ? task.patrolTask.name
                      : task.maintainTask.name,
                  style: TextStyle(
                      color: Colors.black, fontSize: ScreenUtil().setSp(16)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
                Text(
                  _taskType == 0
                      ? task.patrolTask.statusName
                      : task.maintainTask.statusName,
                  style: TextStyle(
                      color: const Color(0xff2eafff),
                      fontSize: ScreenUtil().setSp(14)),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  _taskType == 0
                      ? task.patrolTask.user?.name
                      : task.maintainTask.user?.name,
                  style: TextStyle(
                      color: const Color(0xff999999),
                      fontSize: ScreenUtil().setSp(14)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
                Text(
                  _taskType == 0
                      ? task.patrolTask.updateDate
                      : task.maintainTask.updateDate,
                  style: TextStyle(
                      color: const Color(0xff999999),
                      fontSize: ScreenUtil().setSp(14)),
                )
              ],
            ),
          ],
        ),
      ),
      onTap: () {
        if (_taskType == 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PatrolTaskDetailPage(
                        patrolTaskId: task.patrolTask?.id,
                      )));
        }
      },
    );
  }

  /// 历史巡检任务
  _loadPatrolTaskPageList(int pageNo) {
    NetUtil.instance.get(Api.instance.patrolTaskPageList, (res) {
      _isLoading = false;
      var page = BaseResp<PatrolTaskPage>(
          res, (jsonRes) => PatrolTaskPage.fromJson(jsonRes)).resultObj;
      _listTotalSize = page.count;
      var list = page.list ?? List();
      setState(() {
        for (PatrolTask patrolTask in list) {
          _list.add(Task.fromParams(type: 0, patrolTask: patrolTask));
        }
      });
    }, params: {
      'pageNo': '$pageNo',
      'pageSize': '$_PAGE_SIZE',
      'isSelf': _executorTypeIndex == 0 ? '0' : '1',
      'status': _getStatus(),
      'beginTime': _beginTimeStr == _beginTimeHint ? '' : _beginTimeStr,
      'endTime': _endTimeStr == _endTimeHint ? '' : _endTimeStr
    });
  }

  /// 历史养护任务
  _loadMaintainTaskPageList(int pageNo) {
    NetUtil.instance.get(Api.instance.maintainTaskPageList, (res) {
      _isLoading = false;
      var page = BaseResp<MaintainTaskPage>(
          res, (jsonRes) => MaintainTaskPage.fromJson(jsonRes)).resultObj;
      _listTotalSize = page.count;
      var list = page.list ?? List();
      setState(() {
        for (MaintainTask maintainTask in list) {
          _list.add(Task.fromParams(type: 1, maintainTask: maintainTask));
        }
      });
    }, params: {
      'pageNo': '$pageNo',
      'pageSize': '$_PAGE_SIZE',
      'isSelf': _executorTypeIndex == 0 ? '0' : '1',
      'status': _getStatus(),
      'beginTime': _beginTimeStr == _beginTimeHint ? '' : _beginTimeStr,
      'endTime': _endTimeStr == _endTimeHint ? '' : _endTimeStr
    });
  }

  /// 下拉刷新
  Future<Null> _onRefresh() async {
    _pageNo = 1;
    _list.clear();
    if (_taskType == 0) {
      _loadPatrolTaskPageList(_pageNo);
    } else {
      _loadMaintainTaskPageList(_pageNo);
    }
    return null;
  }

  /// 上拉加载
  _onLoadMore() {
    _pageNo++;
    if (_taskType == 0) {
      _loadPatrolTaskPageList(_pageNo);
    } else {
      _loadMaintainTaskPageList(_pageNo);
    }
  }

  /// 渲染侧滑视图
  Widget _renderEndDrawer() {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// 任务类型
              Container(
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(15),
                    top: ScreenUtil().setHeight(40)),
                child: Text('任务类型',
                    style: TextStyle(
                        color: const Color(0xff666666),
                        fontSize: ScreenUtil().setSp(16))),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(10),
                    ScreenUtil().setHeight(4),
                    ScreenUtil().setWidth(10),
                    ScreenUtil().setHeight(4)),
                height: ScreenUtil().setHeight(48),
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) =>
                        _renderTypeItem(index, TYPE_TASK),
                    itemCount: _taskTypeList.length),
              ),

              /// 任务执行人
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(15)),
                child: Text('任务执行人',
                    style: TextStyle(
                        color: const Color(0xff666666),
                        fontSize: ScreenUtil().setSp(16))),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(10),
                    ScreenUtil().setWidth(4),
                    ScreenUtil().setWidth(10),
                    ScreenUtil().setWidth(4)),
                height: ScreenUtil().setHeight(48),
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) =>
                        _renderTypeItem(index, TYPE_EXECUTOR),
                    itemCount: _executorTypeList.length),
              ),

              /// 任务状态
              Container(
                margin: EdgeInsets.only(left: ScreenUtil().setWidth(13)),
                child: Text('任务状态',
                    style: TextStyle(
                        color: const Color(0xff666666),
                        fontSize: ScreenUtil().setSp(16))),
              ),
              Container(
                height: ScreenUtil().setHeight(106),
                margin: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(10),
                    ScreenUtil().setWidth(4),
                    ScreenUtil().setWidth(10),
                    ScreenUtil().setWidth(4)),
                child: GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.86,
                        crossAxisSpacing: 0.0),
                    itemBuilder: (_, index) =>
                        _renderTypeItem(index, TYPE_STATUS),
                    itemCount: _statusTypeList.length),
              ),

              /// 上报时间
              Container(
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(13),
                    bottom: ScreenUtil().setHeight(10)),
                child: Text('上报时间',
                    style: TextStyle(
                        color: const Color(0xff666666),
                        fontSize: ScreenUtil().setSp(16))),
              ),
              _renderTime(true),
              _renderTime(false),
            ],
          ),

          /// 重置或确定
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                  child: FlatButton(
                      padding: EdgeInsets.only(
                          top: ScreenUtil().setHeight(10),
                          bottom: ScreenUtil().setHeight(10)),
                      color: const Color(0xffd3e2ec),
                      onPressed: () {
                        //TODO 重置
                        setState(() {
                          _taskTypeIndex = 0;
                          _executorTypeIndex = 0;
                          _statusTypeIndex = 0;
                          _beginTimeStr = _beginTimeHint;
                          _endTimeStr = _endTimeHint;
                        });
                      },
                      child: Text('重置',
                          style: TextStyle(
                              color: const Color(0xff2eafff),
                              fontSize: ScreenUtil().setSp(16))))),
              Expanded(
                  child: FlatButton(
                      padding: EdgeInsets.only(
                          top: ScreenUtil().setHeight(10),
                          bottom: ScreenUtil().setHeight(10)),
                      color: const Color(0xff2eafff),
                      onPressed: () {
                        //TODO 确定
                        setState(() {
                          _isLoading = true;
                        });
                        _taskType = _taskTypeIndex;
                        _onRefresh();
                        Navigator.pop(context);
                      },
                      child: Text('确定',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(16)))))
            ],
          )
        ],
      ),
    );
  }

  /// 渲染Item
  Widget _renderTypeItem(int index, int type) {
    var listIndex;
    var list;
    switch (type) {
      case TYPE_TASK:
        listIndex = _taskTypeIndex;
        list = _taskTypeList;
        break;
      case TYPE_EXECUTOR:
        listIndex = _executorTypeIndex;
        list = _executorTypeList;
        break;
      default:
        listIndex = _statusTypeIndex;
        list = _statusTypeList;
        break;
    }

    return InkWell(
      child: Container(
        width: ScreenUtil().setWidth(88),
        margin: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(5),
            ScreenUtil().setHeight(6),
            ScreenUtil().setWidth(5),
            ScreenUtil().setHeight(6)),
        alignment: Alignment.center,
        child: Text(
          list[index],
          textAlign: TextAlign.center,
          style: TextStyle(
              color: index == listIndex
                  ? const Color(0xff1b8bd0)
                  : const Color(0xff787878)),
        ),
        color: index == listIndex
            ? const Color(0xffcce8f9)
            : const Color(0xffefefef),
      ),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        setState(() {
          switch (type) {
            case TYPE_TASK:
              _taskTypeIndex = index;
              break;
            case TYPE_EXECUTOR:
              _executorTypeIndex = index;
              break;
            default:
              _statusTypeIndex = index;
              break;
          }
        });
      },
    );
  }

  /// 渲染时间视图
  /// beginDate 是否是开始时间
  Widget _renderTime(bool beginDate) {
    var isHint;
    if (beginDate) {
      isHint = _beginTimeStr == _beginTimeHint;
    } else {
      isHint = _endTimeStr == _endTimeHint;
    }

    return Container(
      width: ScreenUtil.screenWidth,
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(13), right: ScreenUtil().setWidth(13)),
      child: OutlineButton(
        onPressed: () => _showTimePicker(beginDate),
        child: Text(
          beginDate ? _beginTimeStr : _endTimeStr,
          style: TextStyle(
              color: isHint ? const Color(0xff999999) : const Color(0xff666666),
              fontSize: ScreenUtil().setSp(15)),
        ),
        highlightedBorderColor: const Color(0xffd9d9d9),
        borderSide: BorderSide(
            color: const Color(0xffd9d9d9), width: ScreenUtil().setWidth(1)),
      ),
    );
  }

  ///  显示时间选择
  ///  isBeginDate 是否是开始时间
  _showTimePicker(bool isBeginDate) {
    var currentTime = DateTime.now();
    if (isBeginDate && _beginTimeStr != _beginTimeHint) {
      currentTime = DateTime.tryParse(_beginTimeStr);
    }
    if (!isBeginDate && _endTimeStr != _endTimeHint) {
      currentTime = DateTime.tryParse(_endTimeStr);
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
          if (isBeginDate) {
            if (_endTimeStr != _endTimeHint) {
              if (!DateTime.tryParse(_endTimeStr).isBefore(date)) {
                setState(() {
                  _beginTimeStr = DateUtil.dateTimeStr(date,
                      formatStr: DateUtil.FORMAT_YEAR_MONTH_DAY);
                });
              } else {
                ToastUtil.showShort('开始时间应不晚于结束时间');
              }
            } else {
              setState(() {
                _beginTimeStr = DateUtil.dateTimeStr(date,
                    formatStr: DateUtil.FORMAT_YEAR_MONTH_DAY);
              });
            }
          } else {
            if (_beginTimeStr != _beginTimeHint) {
              if (!date.isBefore(DateTime.tryParse(_beginTimeStr))) {
                setState(() {
                  _endTimeStr = DateUtil.dateTimeStr(date,
                      formatStr: DateUtil.FORMAT_YEAR_MONTH_DAY);
                });
              } else {
                ToastUtil.showShort('结束时间应不早于开始时间');
              }
            } else {
              setState(() {
                _endTimeStr = DateUtil.dateTimeStr(date,
                    formatStr: DateUtil.FORMAT_YEAR_MONTH_DAY);
              });
            }
          }
        }).showModal(context);
  }

  /// 获取状态值
  String _getStatus() {
    switch (_statusTypeIndex) {
      case 0:
        return '2,3,5,6,7,8';
      case 1:
        return '8';
      case 2:
        return '5';
      case 3:
        return '3,7';
      case 4:
        return '2,6';
      default:
        return '2,3,5,6,7,8';
    }
  }
}
