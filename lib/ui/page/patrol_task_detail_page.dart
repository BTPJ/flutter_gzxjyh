import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/model/patrol_task.dart';
import 'package:flutter_gzxjyh/model/patrol_task_flow.dart';
import 'package:flutter_gzxjyh/ui/widget/rating_bar.dart';
import 'package:flutter_gzxjyh/utils/user_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 巡检任务详情（首页-巡检任务-详情）
class PatrolTaskDetailPage extends StatefulWidget {
  /// 巡检任务ID
  final String patrolTaskId;

  /// 是否是片区管理人员(有审核按键可以审核)
  final bool isManager;

  const PatrolTaskDetailPage(
      {Key key, @required this.patrolTaskId, this.isManager = false})
      : super(key: key);

  @override
  _PatrolTaskDetailPageState createState() => _PatrolTaskDetailPageState();
}

class _PatrolTaskDetailPageState extends State<PatrolTaskDetailPage> {
  /// 是否正在加载
  bool _isLoading = true;

  PatrolTask _patrolTask;

  @override
  void initState() {
    super.initState();
    _loadPatrolTaskDetail();
  }

  @override
  Widget build(BuildContext context) {
    /// AppBar
    var appBar = AppBar(
      backgroundColor: MyColors.FF2EAFFF,
      title: Text('巡检任务'),
      centerTitle: true,
      actions: <Widget>[
        Container(
          margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
          alignment: Alignment.center,
          child: Text(_patrolTask?.statusName ?? '',
              style: TextStyle(fontSize: ScreenUtil().setSp(14))),
        )
      ],
    );

    var keyTextStyle =
        TextStyle(color: MyColors.FF9D9898, fontSize: ScreenUtil().setSp(16));
    var valueTextStyle =
        TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(16));
    var flagTextStyle =
        TextStyle(color: MyColors.FF6F6D6D, fontSize: ScreenUtil().setSp(14));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      /// 任务名称
                      Container(
                        // 下面的线（设置下边框）
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: MyColors.FFD9D9D9))),
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(14),
                            right: ScreenUtil().setWidth(14)),
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(18),
                            bottom: ScreenUtil().setHeight(14)),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('任务名称', style: keyTextStyle),
                              flex: 3,
                            ),
                            Expanded(
                              child: Text(_patrolTask?.name ?? '',
                                  style: valueTextStyle),
                              flex: 8,
                            )
                          ],
                        ),
                      ),

                      /// 巡检计划
                      Container(
                        // 下面的线（设置下边框）
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: MyColors.FFD9D9D9))),
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(14),
                            right: ScreenUtil().setWidth(14)),
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(14),
                            bottom: ScreenUtil().setHeight(14)),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('巡检计划', style: keyTextStyle),
                              flex: 3,
                            ),
                            Expanded(
                              child: Text(_patrolTask?.plan?.name ?? '',
                                  style: valueTextStyle),
                              flex: 8,
                            )
                          ],
                        ),
                      ),

                      /// 巡检人
                      Container(
                        // 下面的线（设置下边框）
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: MyColors.FFD9D9D9))),
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(14),
                            right: ScreenUtil().setWidth(14)),
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(14),
                            bottom: ScreenUtil().setHeight(14)),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('巡检人', style: keyTextStyle),
                              flex: 3,
                            ),
                            Expanded(
                              child: Text(_patrolTask?.user?.name ?? '',
                                  style: valueTextStyle),
                              flex: 8,
                            )
                          ],
                        ),
                      ),

                      /// 要求时间
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: MyColors.FFD9D9D9))),
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(14),
                            right: ScreenUtil().setWidth(14)),
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(7),
                            bottom: ScreenUtil().setHeight(7)),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('要求时间', style: keyTextStyle),
                              flex: 3,
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        color: MyColors.FFEAE8E8,
                                        margin: EdgeInsets.only(
                                            right: ScreenUtil().setWidth(10),
                                            bottom: ScreenUtil().setHeight(3)),
                                        padding: EdgeInsets.fromLTRB(
                                            ScreenUtil().setWidth(10),
                                            ScreenUtil().setHeight(2),
                                            ScreenUtil().setWidth(10),
                                            ScreenUtil().setHeight(2)),
                                        child: Text(
                                          '开始',
                                          style: flagTextStyle,
                                        ),
                                      ),
                                      Text(
                                        _patrolTask?.planBeginDate ?? '',
                                        style: valueTextStyle,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        color: MyColors.FFEAE8E8,
                                        margin: EdgeInsets.only(
                                            right: ScreenUtil().setWidth(10),
                                            top: ScreenUtil().setHeight(3)),
                                        padding: EdgeInsets.fromLTRB(
                                            ScreenUtil().setWidth(10),
                                            ScreenUtil().setHeight(2),
                                            ScreenUtil().setWidth(10),
                                            ScreenUtil().setHeight(2)),
                                        child: Text(
                                          '结束',
                                          style: flagTextStyle,
                                        ),
                                      ),
                                      Text(
                                        _patrolTask?.planEndDate ?? '',
                                        style: valueTextStyle,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              flex: 8,
                            ),
                          ],
                        ),
                      ),

                      /// 实际时间
                      Offstage(
                        offstage: !(_patrolTask.status == '2' ||
                            _patrolTask.status == '3' ||
                            _patrolTask.status == '6' ||
                            _patrolTask.status == '7'),
                        child: Container(
                          // 下面的线（设置下边框）
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: MyColors.FFD9D9D9))),
                          margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(14),
                              right: ScreenUtil().setWidth(14)),
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(7),
                              bottom: ScreenUtil().setHeight(7)),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text('实际时间', style: keyTextStyle),
                                flex: 3,
                              ),
                              Expanded(
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              color: MyColors.FFEAE8E8,
                                              margin: EdgeInsets.only(
                                                  right:
                                                      ScreenUtil().setWidth(10),
                                                  bottom: ScreenUtil()
                                                      .setHeight(3)),
                                              padding: EdgeInsets.fromLTRB(
                                                  ScreenUtil().setWidth(10),
                                                  ScreenUtil().setHeight(2),
                                                  ScreenUtil().setWidth(10),
                                                  ScreenUtil().setHeight(2)),
                                              child: Text(
                                                '开始',
                                                style: flagTextStyle,
                                              ),
                                            ),
                                            Text(
                                              _patrolTask?.realBeginDate ?? '',
                                              style: valueTextStyle,
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              color: MyColors.FFEAE8E8,
                                              margin: EdgeInsets.only(
                                                  right:
                                                      ScreenUtil().setWidth(10),
                                                  top: ScreenUtil()
                                                      .setHeight(3)),
                                              padding: EdgeInsets.fromLTRB(
                                                  ScreenUtil().setWidth(10),
                                                  ScreenUtil().setHeight(2),
                                                  ScreenUtil().setWidth(10),
                                                  ScreenUtil().setHeight(2)),
                                              child: Text(
                                                '结束',
                                                style: flagTextStyle,
                                              ),
                                            ),
                                            Text(
                                              _patrolTask?.realEndDate ?? '',
                                              style: valueTextStyle,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Image.asset(
                                      _patrolTask.status == '2' ||
                                              _patrolTask.status == '6'
                                          ? 'images/ic_postpone_flag.png'
                                          : 'images/ic_on_time_flag.png',
                                      width: ScreenUtil().setWidth(50),
                                    )
                                  ],
                                ),
                                flex: 8,
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// 巡检点
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: MyColors.FFD9D9D9))),
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(14),
                            right: ScreenUtil().setWidth(14)),
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setWidth(14),
                            bottom: ScreenUtil().setWidth(14)),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text('巡检点', style: keyTextStyle),
                              flex: 3,
                            ),
                            Expanded(
                              child: Text(_patrolTask?.line?.pointNames ?? '',
                                  style: valueTextStyle),
                              flex: 8,
                            )
                          ],
                        ),
                      ),

                      /// 线路查看
                      InkWell(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: MyColors.FFD9D9D9))),
                          margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(14),
                              right: ScreenUtil().setWidth(14)),
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setWidth(14),
                              bottom: ScreenUtil().setWidth(14)),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text('线路查看', style: keyTextStyle),
                                flex: 3,
                              ),
                              Expanded(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.fromLTRB(
                                              ScreenUtil().setWidth(8),
                                              ScreenUtil().setHeight(2),
                                              ScreenUtil().setWidth(10),
                                              ScreenUtil().setHeight(2)),
                                          decoration: BoxDecoration(
                                              color: MyColors.FFEAE8E8,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(ScreenUtil()
                                                      .setWidth(20)))),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.location_on,
                                                color: MyColors.FF61A2CA,
                                              ),
                                              Text('地图',
                                                  style: TextStyle(
                                                      color: MyColors.FF61A2CA,
                                                      fontSize: ScreenUtil()
                                                          .setSp(15)))
                                            ],
                                          )),
                                      Icon(
                                        Icons.keyboard_arrow_right,
                                        color: MyColors.FF9D9898,
                                      )
                                    ],
                                  ),
                                ),
                                flex: 8,
                              )
                            ],
                          ),
                        ),
                      ),

                      /// 操作流程
                      Container(
                          margin:
                              EdgeInsets.only(top: ScreenUtil().setHeight(4)),
                          padding:
                              EdgeInsets.only(top: ScreenUtil().setHeight(6)),
                          color: MyColors.FFEEECEC,
                          child: Stepper(
                            controlsBuilder: (BuildContext context,
                                    {VoidCallback onStepContinue,
                                    VoidCallback onStepCancel}) =>
                                Container(),
                            physics: ScrollPhysics(),
                            currentStep: _patrolTask.flowList.length - 1,
                            steps: _buildSteps(),
                          ))
                    ],
                  ),
                )),

                /// 底部的操作
                Divider(height: 1.0),
                Offstage(
                  offstage:
                      !(_patrolTask.user?.id == UserManager.instance.user.id &&
                              (_patrolTask.status == '0' ||
                                  _patrolTask.status == '1') ||
                          widget.isManager),
                  child: Container(
                    width: ScreenUtil.screenWidthDp,
                    child: Row(
                      children: <Widget>[
                        Offstage(
                          offstage: !(_patrolTask.status == '0' ||
                              _patrolTask.status == '1'),
                          child: InkWell(
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  ScreenUtil().setWidth(22),
                                  ScreenUtil().setHeight(10),
                                  ScreenUtil().setWidth(12),
                                  ScreenUtil().setHeight(10)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Icon(
                                    _patrolTask.status == '0'
                                        ? Icons.forward_5
                                        : Icons.access_time,
                                    color: MyColors.FF4D7DAD,
                                    size: ScreenUtil().setWidth(32),
                                  ),
                                  Text(_patrolTask.status == '0' ? '撤销' : '延期',
                                      style: TextStyle(
                                          color: MyColors.FF6F6D6D,
                                          fontSize: ScreenUtil().setSp(17)))
                                ],
                              ),
                            ),
                            onTap: () {},
                          ),
                        ),
                        Expanded(
                            child: Container(
                          margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(18),
                              right: ScreenUtil().setWidth(18)),
                          child: RaisedButton(
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setHeight(8),
                                bottom: ScreenUtil().setHeight(8)),
                            color: MyColors.FF2EAFFF,
                            onPressed: () {},
                            child: Text(
                              _getOperateText(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(17)),
                            ),
                          ),
                        ))
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }

  /// 加载巡检任务详情
  _loadPatrolTaskDetail() {
    NetUtil().get(Api().getPatrolTaskDetail, (res) {
      _patrolTask =
          BaseResp<PatrolTask>(res, (jsonRes) => PatrolTask.fromJson(jsonRes))
              .resultObj;
      setState(() {
        _isLoading = false;
      });
    }, params: {'id': widget.patrolTaskId});
  }

  /// 构建流程视图
  List<Step> _buildSteps() {
    List<Step> steps = List();
    for (var i = 0; i < _patrolTask.flowList.length; i++) {
      bool isLatest = i == _patrolTask.flowList.length - 1;
      PatrolTaskFlow flow = _patrolTask.flowList[i];
      String content;
      switch (flow.operateType) {
        case '1': // 分派
          content = '${flow.createBy?.name ?? ''}   ${flow.createDate ?? ''}';
          break;
        case '2': // 申请撤销
          content =
              '${flow.createBy?.name}   ${flow.createDate}\n理由：${flow.reason ?? '--'}';
          break;
        case '3': // 申请延期
          content =
              '${flow.createBy?.name}   ${flow.createDate}\n理由：${flow.reason ?? '--'}'
              '\n要求完成时间：${flow.oldDate ?? (_patrolTask.planEndDate ?? '--')}'
              '\n申请完成时间：${flow.delayDate ?? '--'}';
          break;
        default: // 撤销审批/延期审批/确认
          content =
              '${flow.createBy?.name}   ${flow.createDate}\n意见：${flow.opinion ?? '--'}';
          break;
      }

      steps.add(Step(
          title: Row(
            children: <Widget>[
              Text(
                '${flow.operateTypeName ?? ''}  ${flow.checkTypeName ?? ''}',
                style: TextStyle(
                    color: isLatest ? MyColors.FF2EAFFF : MyColors.FF333333,
                    fontSize: ScreenUtil().setSp(15)),
              ),
              Offstage(
                offstage: flow.score == null,
                child: RatingBar(
                    rating: (flow.score ?? 0).toDouble(),
                    color: Colors.amber,
                    size: ScreenUtil().setWidth(20)),
              )
            ],
          ),
          subtitle: Container(
            padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(8)),
            child: Text(
              content,
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(13),
                  color: isLatest ? MyColors.FF2EAFFF : MyColors.FF999999),
            ),
          ),
          content: Container(),
          isActive: isLatest));
    }

    return steps;
  }

  /// 获取底部操作按键的文本
  String _getOperateText() {
    switch (_patrolTask.status) {
      case '0':
        return '开始巡检';
      case '1':
        return '巡检中';
      case '2':
      case '3':
        return '确认';
      case '4':
        return '审核';
      default:
        return '';
    }
  }
}
