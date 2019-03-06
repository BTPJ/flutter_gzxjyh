import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/event/event_code.dart';
import 'package:flutter_gzxjyh/event/event_manager.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/model/dossier_task.dart';
import 'package:flutter_gzxjyh/model/notify_info.dart';
import 'package:flutter_gzxjyh/model/patrol_task.dart';
import 'package:flutter_gzxjyh/model/task.dart';
import 'package:flutter_gzxjyh/ui/page/dossier_detail_page.dart';
import 'package:flutter_gzxjyh/ui/page/dossier_report_page.dart';
import 'package:flutter_gzxjyh/ui/page/login_page.dart';
import 'package:flutter_gzxjyh/ui/page/notify_detail_page.dart';
import 'package:flutter_gzxjyh/ui/page/patrol_task_detail_page.dart';
import 'package:flutter_gzxjyh/ui/page/personal_center_page.dart';
import 'package:flutter_gzxjyh/ui/page/produce_data_report_page.dart';
import 'package:flutter_gzxjyh/ui/widget/badge_view.dart';
import 'package:flutter_gzxjyh/ui/widget/empty_view.dart';
import 'package:flutter_gzxjyh/ui/widget/marquee_vertical.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 巡检人员主界面-首页
class IndexPatrolPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexPatrolState();
}

class IndexPatrolState extends State<IndexPatrolPage> {
  /// 未阅读的消息集(TextSpan集用于Marquee)
  List<NotifyInfo> _unReadNotifyList = List();
  List<TextSpan> _unReadTextSpanList = List();

  /// 待办事项类型
  List<String> _filterTask = ['全部', '巡检任务', '问题处理'];
  int _selFilterIndex = 0;

  /// 待办任务
  var _isLoading = true;
  List<Task> _tasks = List();
  var _loadingPatrolTasksComplete = false;
  List<PatrolTask> _patrolTasks = List();
  var _loadingDossierTasksComplete = false;
  List<DossierTask> _dossierTasks = List();

  @override
  void initState() {
    super.initState();
    _onRefresh();

    /// event_bus监听
    EventManager.instance.eventBus.on<EventCode>().listen((event) {
      switch (event.code) {
        case EventCode.LOGIN_EXPIRED: // 监听登录过期
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LoginPage()),
              (route) => route == null);
          break;
        case EventCode.READ_NOTIFY: // 监听阅读未阅读状态的通知消息
          _loadUnReadNotifyList();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: MyColors.FF2EAFFF,
        title: Text('首页'),
        centerTitle: true,
        leading: BadgeView(
            num: _unReadNotifyList.length > 0 ? 0 : -1,
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(10),
                top: ScreenUtil().setHeight(10)),
            child: IconButton(
                icon: Icon(Icons.person),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => PersonalCenterPage()));
                })),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /// 问题上报&生产填报
          Container(
              width: ScreenUtil.screenWidth,
              height: ScreenUtil().setHeight(86),
              color: MyColors.FF2EAFFF,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('images/ic_problem.png',
                              width: ScreenUtil().setWidth(30)),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(8)),
                              child: Text(
                                '问题上报',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(16)),
                              ))
                        ],
                      ),
                      //TODO 问题上报
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DossierReportPage()));
                      },
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    height: ScreenUtil().setHeight(44),
                    width: 1.0,
                  ),
                  Expanded(
                    child: InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('images/ic_produce.png',
                              width: ScreenUtil().setWidth(30)),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(8)),
                              child: Text(
                                '生产填报',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(16)),
                              ))
                        ],
                      ),
                      //TODO 生产填报
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ProduceDataReportPage()));
                      },
                    ),
                  )
                ],
              )),

          /// 轮播通知
          Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(14),
                right: ScreenUtil().setWidth(14)),
            height: ScreenUtil().setHeight(40),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: ScreenUtil().setWidth(6)),
                  child: Icon(Icons.volume_up, color: MyColors.FF666666),
                ),
                Expanded(
                    child: _unReadNotifyList.isEmpty
                        ? Text('暂无未阅读的通知公告',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(15)))
                        : _buildMarquee()),
              ],
            ),
          ),

          /// 筛选
          Divider(height: 1.0),
          Container(
              height: ScreenUtil().setHeight(40),
              color: MyColors.FFF2F2F2,
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(16),
                  right: ScreenUtil().setWidth(10)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('待办事项',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(15),
                            color: MyColors.FF999999)),
                    Container(
                      /// 这里设置高度后再设置PopupMenuButton的Offset即可实现在底部出现
                      height: ScreenUtil().setHeight(40),
                      child: PopupMenuButton(
                          //   offset: Offset(0, 60),
                          child: Row(
                            children: <Widget>[
                              Text(_filterTask[_selFilterIndex],
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(15),
                                      color: MyColors.FF999999)),
                              Icon(Icons.arrow_drop_down,
                                  color: MyColors.FF999999)
                            ],
                          ),
                          itemBuilder: _buildFilterMenus,
                          onSelected: (String value) {
                            setState(() {
                              for (int i = 0; i < _filterTask.length; i++) {
                                if (_filterTask[i] == value) {
                                  _selFilterIndex = i;
                                  break;
                                }
                              }
                            });
                            _onRefresh();
                          }),
                    )
                  ])),

          /// 列表
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Offstage(child: EmptyView(), offstage: _tasks.isNotEmpty),
                      RefreshIndicator(
                          child: ListView.builder(
                              // 保持ListView任何情况都能滚动，解决在RefreshIndicator的兼容问题(列表未铺满时无法上拉)
                              physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: _buildItem,
                              itemCount: _tasks.length),
                          onRefresh: _onRefresh)
                    ],
                  ),
          )
        ],
      ),
    );
  }

  /// 渲染未阅读消息的跑马灯效果
  Widget _buildMarquee() {
    var controller = MarqueeController();
    return GestureDetector(
      child: Marquee(
        textSpanList: _unReadTextSpanList,
        controller: controller,
        fontSize: ScreenUtil().setSp(14),
      ),
      onTap: () {
        NotifyInfo notify = _unReadNotifyList[controller.position];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => NotifyDetailPage(
                    notifyId: notify.id, isUnRead: notify.haveRead == '0')));
      },
    );
  }

  /// 渲染待办事项的选项
  List<PopupMenuEntry<String>> _buildFilterMenus(BuildContext context) {
    var list = List<PopupMenuEntry<String>>();
    for (int i = 0; i < _filterTask.length; i++) {
      list.add(PopupMenuItem(
        value: _filterTask[i],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              _filterTask[i],
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(15),
                  color: i == _selFilterIndex
                      ? MyColors.FF2EAFFF
                      : MyColors.FF333333),
            ),
            Opacity(
              opacity: i == _selFilterIndex ? 1 : 0,
              child: Icon(Icons.check, color: MyColors.FF2EAFFF),
            )
          ],
        ),
      ));
      if (i != _filterTask.length - 1) {
        list.add(PopupMenuDivider(height: 1.0));
      }
    }
    return list;
  }

  /// 渲染列表项
  Widget _buildItem(BuildContext context, int index) {
    Task task = _tasks[index];
    bool isPatrolTask = task.type == 0;
    return InkWell(
      onTap: () {
        if (isPatrolTask) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      PatrolTaskDetailPage(patrolTaskId: task.patrolTask?.id)));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => DossierDetailPage(
                      dossierId: task.dossierTask?.dossier?.id)));
        }
      },
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(ScreenUtil().setWidth(16)),
            child: Row(
              children: <Widget>[
                Image.asset(
                    isPatrolTask
                        ? 'images/ic_patrol_task.png'
                        : 'images/ic_dossier_task.png',
                    height: ScreenUtil().setHeight(50)),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
                    height: ScreenUtil().setHeight(44),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(isPatrolTask ? '巡检任务' : '问题处理',
                                style: TextStyle(
                                    color: MyColors.FF333333,
                                    fontSize: ScreenUtil().setSp(16))),
                            Offstage(
                              offstage: isPatrolTask
                                  ? task.patrolTask.timeFlag == null ||
                                      task.patrolTask.timeFlag.isEmpty
                                  : task.dossierTask.timeFlag == null ||
                                      task.dossierTask.timeFlag.isEmpty,
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(6)),
                                padding: EdgeInsets.fromLTRB(
                                    ScreenUtil().setWidth(8),
                                    ScreenUtil().setHeight(2),
                                    ScreenUtil().setWidth(8),
                                    ScreenUtil().setHeight(2)),
                                decoration: BoxDecoration(
                                    color: isPatrolTask
                                        ? task.patrolTask.timeFlagColor
                                        : task.dossierTask.timeFlagColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Text(
                                  isPatrolTask
                                      ? task.patrolTask.timeFlag
                                      : task.dossierTask.timeFlag,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(12)),
                                ),
                              ),
                            ),
                            Expanded(
                                child: Text(
                                    isPatrolTask
                                        ? task.patrolTask.statusName
                                        : task.dossierTask.statusName,
                                    style: TextStyle(
                                        color: MyColors.FF2EAFFF,
                                        fontSize: ScreenUtil().setSp(14)),
                                    textAlign: TextAlign.end))
                          ],
                        ),
                        Text(
                          isPatrolTask
                              ? task.patrolTask.name
                              : task.dossierTask.dossier?.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(15)),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(16),
                  right: ScreenUtil().setWidth(16)),
              child: Divider(height: 1.0)),

          /// 创建人和时间
          Container(
            padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  isPatrolTask
                      ? task.patrolTask.createBy?.name
                      : task.dossierTask.createBy?.name,
                  style: TextStyle(
                      color: MyColors.FF999999,
                      fontSize: ScreenUtil().setSp(14)),
                ),
                Text(
                  isPatrolTask
                      ? task.patrolTask.updateDate
                      : task.dossierTask.createDate,
                  style: TextStyle(
                      color: MyColors.FF999999,
                      fontSize: ScreenUtil().setSp(14)),
                )
              ],
            ),
          ),
          Divider(height: 1.0),
          Container(
              height: ScreenUtil().setHeight(10), color: MyColors.FFF2F2F2)
        ],
      ),
    );
  }

  /// 加载未阅读的通知消息
  _loadUnReadNotifyList() {
    NetUtil.instance.get(Api.instance.unReadNotifyList, (res) {
      var list = BaseRespList<NotifyInfo>(
          res, (jsonRes) => NotifyInfo.fromJson(jsonRes)).resultObj;
      _unReadNotifyList
        ..clear()
        ..addAll(list);
      _unReadTextSpanList.clear();
      for (var notify in _unReadNotifyList) {
        _unReadTextSpanList.add(TextSpan(
            text: notify.title.length > 15
                ? notify.title.substring(0, 15)
                : notify.title,
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text: ' — ${notify.createDate}',
                  style: TextStyle(color: MyColors.FF666666))
            ]));
      }
      setState(() {});
    });
  }

  /// 获取巡检任务列表
  _loadPatrolTaskList() {
    NetUtil.instance.get(Api.instance.patrolTaskList, (res) {
      var list = BaseRespList<PatrolTask>(
          res, (jsonRes) => PatrolTask.fromJson(jsonRes)).resultObj;
      _patrolTasks
        ..clear()
        ..addAll(list);
      _loadingPatrolTasksComplete = true;
      _handleData();
    });
  }

  /// 获取案卷任务列表
  _loadDossierTaskList() {
    NetUtil.instance.get(Api.instance.dossierTaskList, (res) {
      var list = BaseRespList<DossierTask>(
          res, (jsonRes) => DossierTask.fromJson(jsonRes)).resultObj;
      _dossierTasks
        ..clear()
        ..addAll(list);
      _loadingDossierTasksComplete = true;
      _handleData();
    });
  }

  /// 组装处理数据
  _handleData() {
    if (_loadingPatrolTasksComplete && _loadingDossierTasksComplete) {
      _isLoading = false;
      _tasks.clear();
      if (_patrolTasks.isNotEmpty) {
        for (PatrolTask patrolTask in _patrolTasks) {
          // 这里存时间用于排序
          _tasks.add(Task.fromParams(
              type: 0, patrolTask: patrolTask, update: patrolTask.updateDate));
        }
      }

      if (_dossierTasks.isNotEmpty) {
        for (DossierTask dossierTask in _dossierTasks) {
          // 这里存时间用于排序
          _tasks.add(Task.fromParams(
              type: 2,
              dossierTask: dossierTask,
              update: dossierTask.updateDate));
        }
      }

      // 按时间排序
      _tasks.sort((task1, task2) => task1.update.compareTo(task2.update));
      setState(() {});
      _loadingPatrolTasksComplete = false;
      _loadingDossierTasksComplete = false;
    }
  }

  Future<void> _onRefresh() async {
    //TODO 下拉刷新
    _loadUnReadNotifyList();
    switch (_selFilterIndex) {
      case 0: // 全部
        _loadPatrolTaskList();
        _loadDossierTaskList();
        break;
      case 1: // 巡检任务
        _loadingDossierTasksComplete = true;
        _dossierTasks.clear();
        _loadPatrolTaskList();
        break;
      case 2: // 案卷任务
        _loadingPatrolTasksComplete = true;
        _patrolTasks.clear();
        _loadDossierTaskList();
        break;
    }
  }
}
