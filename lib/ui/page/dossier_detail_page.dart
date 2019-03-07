import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/model/dossier_flow.dart';
import 'package:flutter_gzxjyh/model/dossier_info.dart';
import 'package:flutter_gzxjyh/model/record.dart';
import 'package:flutter_gzxjyh/ui/widget/photo_gallery.dart';
import 'package:flutter_gzxjyh/utils/toast_util.dart';
import 'package:flutter_gzxjyh/utils/screen_util.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:url_launcher/url_launcher.dart';

/// 案卷详情（首页-问题处理-案卷详情）®
class DossierDetailPage extends StatefulWidget {
  /// 案卷Id
  final String dossierId;

  /// 是否是片区管理人员(有审核按键可以审核)
  final bool isManager;

  const DossierDetailPage({Key key, this.dossierId, this.isManager = false})
      : super(key: key);

  @override
  _DossierDetailPageState createState() => _DossierDetailPageState();
}

class _DossierDetailPageState extends State<DossierDetailPage>
    with WidgetsBindingObserver {
  /// 是否正在加载
  bool _isLoading = true;

  DossierInfo _dossierInfo;

  List<String> _pictureUrls = List();

  /// 语音文件
  List<Record> _records = List();
  List<Record> _allRecords = List();
  FlutterSound _flutterSound;
  StreamSubscription _playerSubscription;
  List<String> _accessoryUrls = List();

  var _keyTextStyle =
      TextStyle(color: MyColors.FF9D9898, fontSize: ScreenUtil().setSp(16));

  @override
  void initState() {
    super.initState();
    _loadDossierTaskDetail();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    /// AppBar
    var appBar = AppBar(
      backgroundColor: MyColors.FF2EAFFF,
      title: Text('案卷详情'),
      centerTitle: true,
    );

    var valueTextStyle =
        TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(16));

    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      /// 上方的流程
                      Offstage(
                        // 作废状态无上方的流程
                        offstage: _dossierInfo?.status == '6',
                        child: Container(
                          height: ScreenUtil().setHeight(105),
                          child: ListView(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(4),
                                top: ScreenUtil().setHeight(15),
                                bottom: ScreenUtil().setHeight(15)),
                            scrollDirection: Axis.horizontal,
                            children: _buildTopFlows(),
                          ),
                        ),
                      ),
                      Container(
                        height: ScreenUtil().setHeight(10),
                        decoration: BoxDecoration(
                            color: MyColors.FFF0F0F0,
                            border: Border(
                                top: BorderSide(color: MyColors.FFD9D9D9))),
                      ),

                      _buildKeyValueItem('案卷名称', _dossierInfo?.name),

                      _buildKeyValueItem('案卷类型', _dossierInfo?.typeName),

                      _buildKeyValueItem('案卷来源', _dossierInfo?.sourceName),

                      _buildKeyValueItem('紧急程度', _dossierInfo?.levelName),

                      /// 案卷地址
                      Container(
                          child: Text('案卷地址', style: _keyTextStyle),
                          margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(16),
                              top: ScreenUtil().setHeight(10))),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom:
                                      BorderSide(color: MyColors.FFD9D9D9))),
                          margin: EdgeInsets.only(
                              left: ScreenUtil().setWidth(16),
                              right: ScreenUtil().setWidth(16)),
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(10),
                              bottom: ScreenUtil().setHeight(10)),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  child: Text(_dossierInfo.address,
                                      style: valueTextStyle)),
                              Container(
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setWidth(6)),
                                padding: EdgeInsets.fromLTRB(
                                    ScreenUtil().setWidth(10),
                                    ScreenUtil().setHeight(2),
                                    ScreenUtil().setWidth(14),
                                    ScreenUtil().setHeight(2)),
                                decoration: BoxDecoration(
                                    color: MyColors.FFCBDAE3,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            ScreenUtil().setHeight(14)))),
                                child: Row(
                                  children: <Widget>[
                                    Icon(Icons.location_on,
                                        color: MyColors.FF5988A4),
                                    Text('定位',
                                        style: TextStyle(
                                            color: MyColors.FF5988A4,
                                            fontSize: ScreenUtil().setSp(14)))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      Offstage(
                        offstage: _dossierInfo?.taskId == null ||
                            _dossierInfo.taskId.isEmpty,
                        child:
                            _buildKeyValueItem('所属任务', _dossierInfo?.taskName),
                      ),

                      Offstage(
                        offstage: _dossierInfo?.pointId == null ||
                            _dossierInfo.pointId.isEmpty,
                        child:
                            _buildKeyValueItem('所属点位', _dossierInfo?.pointName),
                      ),

                      _buildKeyValueItem('案卷描述', _dossierInfo?.describe),

                      /// 图片
                      Offstage(
                        offstage: _pictureUrls.isEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(10),
                                  left: ScreenUtil().setWidth(16)),
                              child: Text('图片（${_pictureUrls.length}张）',
                                  style: _keyTextStyle),
                            ),
                            SingleChildScrollView(
                              padding:
                                  EdgeInsets.all(ScreenUtil().setWidth(16)),
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  children: _buildPicturesView(_pictureUrls)),
                            ),
                          ],
                        ),
                      ),

                      /// 语音
                      Offstage(
                        offstage: _records.isEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildVoiceView(_records),
                        ),
                      ),

                      /// 其它附件
                      Offstage(
                        offstage: _accessoryUrls.isEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _buildAccessoryView(_accessoryUrls),
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
                            currentStep: _dossierInfo.flowList.length - 1,
                            steps: _buildSteps(),
                          )),

                      /// 完成时间
                      Stack(
                        alignment: Alignment.centerRight,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              /// 计划(要求)完成时间
                              Offstage(
                                offstage:
                                    _dossierInfo?.task?.planCompleteDate ==
                                        null,
                                child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                        top: ScreenUtil().setHeight(10)),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(
                                                color: MyColors.FFD9D9D9))),
                                    child: Text(
                                      '要求完成时间 ${_dossierInfo?.task?.planCompleteDate}',
                                      style: TextStyle(
                                          color: MyColors.FF999999,
                                          fontSize: ScreenUtil().setSp(18)),
                                    )),
                              ),

                              /// 实际完成时间
                              Offstage(
                                offstage:
                                    _dossierInfo?.task?.realCompleteDate ==
                                        null,
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                      bottom: ScreenUtil().setHeight(10)),
                                  child: Text(
                                    '实际完成时间 ${_dossierInfo?.task?.realCompleteDate}',
                                    style: TextStyle(
                                        color: MyColors.FF999999,
                                        fontSize: ScreenUtil().setSp(18)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Offstage(
                            offstage: _isOnTime() == null,
                            child: Container(
                              margin: EdgeInsets.only(
                                  right: ScreenUtil().setWidth(14)),
                              child: Image.asset(
                                _isOnTime() == true
                                    ? 'images/ic_on_time_flag.png'
                                    : 'images/ic_postpone_flag.png',
                                width: ScreenUtil().setWidth(40),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),

                /// 底部操作按键
                Offstage(
                  offstage: _getOperateType().isEmpty,
                  child: Container(
                    width: ScreenUtil.screenWidthDp,
                    child: RaisedButton(
                      padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
                      onPressed: () {},
                      child: Text(
                        _getOperateType(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(17)),
                      ),
                      color: MyColors.FF2EAFFF,
                    ),
                  ),
                )
              ],
            ),
    );
  }

  /// 加载案卷任务详情
  _loadDossierTaskDetail() {
    NetUtil().get(Api().getDossierTaskDetail, (res) {
      _dossierInfo =
          BaseResp<DossierInfo>(res, (jsonRes) => DossierInfo.fromJson(jsonRes))
              .resultObj;
      _isLoading = false;
      filterFiles();
      setState(() {});
    }, params: {'id': widget.dossierId});
  }

  /// 构建上方流程
  List<Widget> _buildTopFlows() {
    List<Widget> widgets = List();
    List<DossierFlow> flowList = _dossierInfo?.flowList ?? List();
    for (var i = 0; i < 5; i++) {
      DossierFlow flow;
      try {
        flow = flowList[i];
      } catch (e) {}
      widgets.add(Container(
        width: ScreenUtil().setWidth(90),
        margin: EdgeInsets.only(
            left: ScreenUtil().setWidth(6), right: ScreenUtil().setWidth(6)),
        padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(12),
            bottom: ScreenUtil().setHeight(12)),
        decoration: BoxDecoration(
            color: flow == null ? MyColors.FFF0F0F0 : Colors.white,
            border: Border.all(color: MyColors.FFD7D5D5),
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setWidth(4)))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(Icons.check_circle,
                size: ScreenUtil().setWidth(31),
                color: flow == null ? MyColors.FFABACAC : MyColors.FF2EAFFF),
            Text(
              '${_getFlowName(i)} ${flow?.createBy?.name ?? ''}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: MyColors.FF101010, fontSize: ScreenUtil().setSp(14)),
            )
          ],
        ),
      ));
    }
    return widgets;
  }

  /// 获取上方流程的流程名
  String _getFlowName(int flowIndex) {
    switch (flowIndex) {
      case 0:
        return '上报';
      case 1:
        return '立案';
      case 2:
        return '派遣';
      case 3:
        return '处理';
      case 4:
        return '确认';
      default:
        return '';
    }
  }

  /// 创建一个通用的Key-Value布局
  Widget _buildKeyValueItem(String keyText, String valueText) {
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(14), right: ScreenUtil().setWidth(14)),
      padding: EdgeInsets.only(
          top: ScreenUtil().setWidth(14), bottom: ScreenUtil().setWidth(14)),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: MyColors.FFD9D9D9))),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              keyText ?? '',
              style: TextStyle(
                  color: MyColors.FF9D9898, fontSize: ScreenUtil().setSp(16)),
            ),
            flex: 3,
          ),
          Expanded(
            child: Text(
              valueText ?? '',
              style: TextStyle(
                  color: Colors.black, fontSize: ScreenUtil().setSp(16)),
            ),
            flex: 8,
          ),
        ],
      ),
    );
  }

  /// 分解文件为图片/语音/附件
  filterFiles() {
    List<String> fileUrls = List();
    if (_dossierInfo?.files != null) {
      fileUrls.addAll(_dossierInfo.files.split('|'));
    }

    for (String fileUrl in fileUrls) {
      String fileUrlLower = fileUrl.toLowerCase();
      if (fileUrlLower.contains('jpg') || fileUrlLower.contains('png')) {
        _pictureUrls.add('${Api().filePath}$fileUrl');
      } else if (fileUrlLower.contains('aac') || fileUrlLower.contains('amr')) {
        String name = fileUrl.split('/').last;
        _records.add(
            Record.fromParams(path: '${Api().filePath}$fileUrl', name: name));
      } else {
        if (fileUrl.isNotEmpty) {
          _accessoryUrls.add(fileUrl);
        }
      }
    }
  }

  /// 构建图片View
  List<Widget> _buildPicturesView(List<String> picUrls) {
    List<Widget> widgets = List();
    for (int i = 0; i < picUrls.length; i++) {
      widgets.add(
        InkWell(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => PhotoGallery(
                        pictureUrls: picUrls,
                        currentIndex: i,
                      ))),
          child: Container(
            margin: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
            child: FadeInImage.assetNetwork(
              placeholder: 'images/ic_loading_pic.png',
              image: picUrls[i],
              width: ScreenUtil().setWidth(80),
              height: ScreenUtil().setWidth(80),
              fit: BoxFit.fill,
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  /// 构建语音视图
  List<Widget> _buildVoiceView(List<Record> records, {bool isFlow = false}) {
    List<Widget> widgets = List();
    if (!isFlow) {
      widgets
        ..add(Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(16),
                right: ScreenUtil().setWidth(16)),
            child: Divider(height: 1.0)))
        ..add(Container(
          margin: EdgeInsets.only(
              top: ScreenUtil().setHeight(10), left: ScreenUtil().setWidth(16)),
          child: Container(
            child: Text('语音', style: _keyTextStyle),
            margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
          ),
        ));
    }

    for (Record record in records) {
      widgets.add(InkWell(
        splashColor: Colors.transparent, // 取消点击效果
        onTap: () {
          switch (record.status) {
            case 0:
              for (Record record2 in _allRecords) {
                if (record2.status != 0 && record2.name != record.name) {
                  _stopPlayer(record2);
                }
              }
              _startPlayer(record);
              break;
            case 1:
              _pausePlayer(record);
              break;
            case 2:
              for (Record record2 in _allRecords) {
                if (record2.status == 1 && record2.name != record.name) {
                  _stopPlayer(record2);
                }
              }
              _resumePlayer(record);
              break;
          }
        },
        child: Container(
          height: ScreenUtil().setHeight(30),
          width: isFlow
              ? ScreenUtil().setWidth(250)
              : ScreenUtil.screenWidthDp,
          margin: isFlow
              ? EdgeInsets.only(
                  right: ScreenUtil().setWidth(20),
                  bottom: ScreenUtil().setHeight(10))
              : EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), 0.0,
                  ScreenUtil().setWidth(20), ScreenUtil().setHeight(10)),
          padding: EdgeInsets.only(
              left: ScreenUtil().setWidth(10),
              right: ScreenUtil().setWidth(10)),
          color: MyColors.FFBDE5EF,
          child: Row(
            children: <Widget>[
              Icon(Icons.record_voice_over,
                  color: MyColors.FF4D7DAD, size: ScreenUtil().setWidth(20)),
              Container(
                child: Text(
                  record?.duration == null ? '' : '${record.duration ~/ 1000}"',
                  style: TextStyle(
                      color: MyColors.FF4D7DAD,
                      fontSize: ScreenUtil().setSp(16)),
                ),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(8),
                    right: ScreenUtil().setWidth(8)),
              ),
              Expanded(
                  child: Container(
                height: ScreenUtil().setHeight(5),
                child: LinearProgressIndicator(
                  value: record.progress ?? 0.00001,
                ),
              )),
            ],
          ),
        ),
      ));
    }
    return widgets;
  }

  /// 构建附件视图
  List<Widget> _buildAccessoryView(List<String> accessoryUrls,
      {bool isFlow = false}) {
    List<Widget> widgets = List();
    if (!isFlow) {
      widgets
        ..add(Container(
            margin: EdgeInsets.only(
                left: ScreenUtil().setWidth(16),
                right: ScreenUtil().setWidth(16)),
            child: Divider(height: 1.0)))
        ..add(Container(
          margin: EdgeInsets.only(
              top: ScreenUtil().setHeight(10), left: ScreenUtil().setWidth(16)),
          child: Container(
            child: Text('附件', style: _keyTextStyle),
            margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
          ),
        ));
    }

    for (String url in accessoryUrls) {
      String name = '';
      if (url.isNotEmpty) {
        name = url.split('/').last;
        // 转码
//        name = na
      }
      widgets.add(InkWell(
        splashColor: Colors.transparent, // 取消点击效果
        onTap: () => _launchBrowser('${Api().filePath}$url'),
        child: Container(
          alignment: Alignment.centerLeft,
          height: ScreenUtil().setHeight(30),
          width: ScreenUtil.screenWidthDp,
          margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), 0.0,
              ScreenUtil().setWidth(20), ScreenUtil().setHeight(10)),
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
          color: MyColors.FFBDE5EF,
          child: Text(
            name,
            style: TextStyle(
                color: MyColors.FF4D7DAD, fontSize: ScreenUtil().setSp(14)),
          ),
        ),
      ));
    }
    return widgets;
  }

  /// 开始播放录音
  _startPlayer(Record record) async {
    _flutterSound = FlutterSound();
    String playPath = await _flutterSound.startPlayer(record.path);
    await _flutterSound.setVolume(1.0);
    print('startPlayer: $playPath');

    try {
      _playerSubscription = _flutterSound.onPlayerStateChanged.listen((e) {
        if (e != null) {
          setState(() {
            record.duration = e.duration;
            if (e.duration != 0) {
              record.progress = e.currentPosition / e.duration;
            }
          });
          if (e.duration == e.currentPosition) {
            setState(() {
              record.status = 0;
            });
          }
        }
      });
      setState(() {
        record.status = 1;
      });
    } catch (err) {
      print('error: $err');
    }
  }

  /// 暂停播放
  _pausePlayer(Record record) async {
    String result = await _flutterSound.pausePlayer();
    print('pausePlayer: $result');
    setState(() {
      record.status = 2;
    });
  }

  /// 继续播放
  _resumePlayer(Record record) async {
    String result = await _flutterSound.resumePlayer();
    print('resumePlayer: $result');
    setState(() {
      record.status = 1;
    });
  }

  /// 结束播放
  _stopPlayer(Record record) async {
    try {
      String result = await _flutterSound.stopPlayer();
      print('stopPlayer: $result');
      if (_playerSubscription != null) {
        _playerSubscription.cancel();
        _playerSubscription = null;
      }

      setState(() {
        record.status = 0;
        record.progress = 0;
      });
    } catch (err) {
      print('error: $err');
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _stopPlayOnPaused();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _stopPlayOnPaused();
    }
  }

  /// 在当前界面处于onPaused状态时停止播放正在播放的录音
  /// 这里onPaused状态很怪异，home键可触发，进入照片选择也可触发，进入语音选择不可触发，返回也不触发，具体原因未知
  _stopPlayOnPaused() {
    for (Record record in _records) {
      if (record.status != 0) {
        _stopPlayer(record);
      }
    }
  }

  /// 打开浏览器查看附件
  _launchBrowser(String accessoryUrl) async {
    print(accessoryUrl);
    var url = '$accessoryUrl';
    if (await canLaunch(url)) {
      await launch(url, enableJavaScript: true);
    } else {
      ToastUtil.showShortInCenter('无效网址$accessoryUrl');
    }
  }

  /// 获取操作类型
  String _getOperateType() {
    switch (_dossierInfo?.status) {
      case '1':
        return widget.isManager ? '立案' : '';
      case '2':
        return widget.isManager ? '派遣' : '';
      case '3':
        return widget.isManager ? '确认处理' : '';
      case '4':
        return widget.isManager ? '确认' : '';
      default:
        return '';
    }
  }

  /// 构建流程视图
  List<Step> _buildSteps() {
    List<Step> steps = List();

    for (var i = 0; i < _dossierInfo.flowList.length; i++) {
      bool isLatest = i == _dossierInfo.flowList.length - 1;
      DossierFlow flow = _dossierInfo.flowList[i];

      /// 流程中的图片、语音、附件
      List<String> picturePathList = List();
      List<Record> recordPathList = List();
      List<String> accessoryPathList = List();

      List<String> filePathList = List();
      if (flow?.files != null && flow.files.isNotEmpty) {
        filePathList.addAll(flow?.files?.split('|'));
      }

      for (String filePath in filePathList) {
        filePath = filePath.toLowerCase();
        if (filePath.contains('jpg') || filePath.contains('png')) {
          picturePathList.add('${Api().filePath}$filePath');
        } else if (filePath.contains('aac') || filePath.contains('amr')) {
          String name = filePath.split('/').last;
          recordPathList.add(Record.fromParams(
              path: '${Api().filePath}$filePath', name: name));
        } else {
          if (filePath.isNotEmpty) {
            accessoryPathList.add('${Api().filePath}$filePath');
          }
        }
      }
      _allRecords.clear();
      _allRecords.addAll(_records);
      _allRecords.addAll(recordPathList);

      String content;
      if (flow.remarks == null || flow.remarks.isEmpty) {
        content = '${flow?.createBy?.name ?? ''} ${flow.createDate}';
      } else {
        content =
            '${flow?.createBy?.name ?? ''} ${flow.createDate}\n意见：${flow.remarks}';
      }

      steps.add(Step(
          title: Text(
            '${flow.operateTypeName ?? ''}  ${flow.checkTypeName ?? ''}',
            style: TextStyle(
                color: isLatest ? MyColors.FF2EAFFF : MyColors.FF333333,
                fontSize: ScreenUtil().setSp(15)),
          ),
          subtitle: Container(
            padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  content,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(13),
                      color: isLatest ? MyColors.FF2EAFFF : MyColors.FF999999),
                ),

                /// 图片
                Offstage(
                  offstage: picturePathList.isEmpty,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                    scrollDirection: Axis.horizontal,
                    child: Row(children: _buildPicturesView(picturePathList)),
                  ),
                ),

                /// 语音
                Offstage(
                  offstage: recordPathList.isEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildVoiceView(recordPathList, isFlow: true),
                  ),
                ),

                /// 其它附件
                Offstage(
                  offstage: accessoryPathList.isEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        _buildAccessoryView(accessoryPathList, isFlow: true),
                  ),
                ),
              ],
            ),
          ),
          content: Container(),
          isActive: isLatest));
    }

    return steps;
  }

  /// 判定案卷任务是否准时完成,为null时表示案卷状态未完成
  bool _isOnTime() {
    var planCompleteDate = _dossierInfo?.task?.planCompleteDate;
    var realCompleteDate = _dossierInfo?.task?.realCompleteDate;
    if (planCompleteDate != null && realCompleteDate != null) {
      return DateTime.tryParse(realCompleteDate)
          .isBefore(DateTime.tryParse(planCompleteDate));
    }
    return null;
  }
}
