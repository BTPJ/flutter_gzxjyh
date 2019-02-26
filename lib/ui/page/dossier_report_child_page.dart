import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:amap_base/amap_base.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/event/event_code.dart';
import 'package:flutter_gzxjyh/event/event_manager.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/model/dict.dart';
import 'package:flutter_gzxjyh/model/patrol_point.dart';
import 'package:flutter_gzxjyh/model/patrol_task.dart';
import 'package:flutter_gzxjyh/model/record.dart';
import 'package:flutter_gzxjyh/ui/page/record_page.dart';
import 'package:flutter_gzxjyh/ui/page/search_address_page.dart';
import 'package:flutter_gzxjyh/ui/widget/asset_view.dart';
import 'package:flutter_gzxjyh/ui/widget/loading_dialog.dart';
import 'package:flutter_gzxjyh/utils/toast_util.dart';
import 'package:flutter_gzxjyh/utils/user_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

/// 巡检人员主界面-首页-问题上报-问题上报子页面
class DossierReportChildPage extends StatefulWidget {
  @override
  _DossierReportChildPageState createState() => _DossierReportChildPageState();
}

class _DossierReportChildPageState extends State<DossierReportChildPage>
    with WidgetsBindingObserver {
  /// 高德定位相关
  final _aMapLocation = AMapLocation();

  /// 定位
  List<Location> _locationResult = List();

  /// 选择的位置
  PoiItem _poiItem;

  /// 问题类型相关
  List<Dict> _dossierTypes = List(); // 问题类型的字典值集合
  Dict _selDossierType; // 选择的问题类型
  static const String DOSSIER_TYPE = 'xjyh_dossier_type'; // 问题类型字典字段

  /// 选择的问题紧急程度相关
  List<Dict> _urgencyLevels = List(); // 问题紧急程度的字典值集合
  Dict _selUrgencyLevel; // 选择的问题紧急程度
  static const String URGENCY_LEVEL = 'xjyh_dossier_level'; // 紧急程度字典字段

  /// TextField相关
  TextEditingController _nameEditController = TextEditingController();
  TextEditingController _descEditController = TextEditingController();
  var _descNode = FocusNode();

  /// 从地图中点击问题上报携带过来的巡检任务和巡检点（此时无法选择巡检任务）
  PatrolTask _patrolTask;
  List<PatrolPoint> _points = List();
  PatrolPoint _selPatrolPoint;

  /// 图片文件
  List<Asset> _images = List();

  /// 存储图片的key集
  List<GlobalKey> _keys = List();
  ScrollController _scrollController = ScrollController();

  /// 语音文件
  List<Record> _records = List();
  FlutterSound _flutterSound;
  StreamSubscription _playerSubscription;

  /// 样式
  var _divider = Container(
      margin: EdgeInsets.only(
          left: ScreenUtil().setWidth(16), right: ScreenUtil().setWidth(16)),
      child: Divider(height: 1.0));
  var _keyTextStyle =
      TextStyle(color: MyColors.FF666666, fontSize: ScreenUtil().setSp(16));

  @override
  void initState() {
    super.initState();
    _fetchPosition();
    _loadDictList(DOSSIER_TYPE);
    _loadDictList(URGENCY_LEVEL);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    var valueTextStyle =
        TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(16));
    var hintTextStyle =
        TextStyle(color: MyColors.FF999999, fontSize: ScreenUtil().setSp(16));

    var contentPadding = EdgeInsets.only(
        top: ScreenUtil().setHeight(-10), bottom: ScreenUtil().setHeight(10));

    return Column(
      children: <Widget>[
        Expanded(
            child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// 问题类型
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => SimpleDialog(
                          children: _buildDossierTypeItem(),
                          contentPadding: EdgeInsets.zero));
                },
                child: Container(
                  height: ScreenUtil().setHeight(56),
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(16),
                      right: ScreenUtil().setWidth(16)),
                  child: Row(
                    children: <Widget>[
                      Text('问题类型', style: _keyTextStyle),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(4),
                            right: ScreenUtil().setWidth(4)),
                        child: Text(_selDossierType?.label ?? '必选',
                            style: _selDossierType != null
                                ? valueTextStyle
                                : hintTextStyle,
                            textAlign: TextAlign.end),
                      )),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
              _divider,

              /// 问题名称
              Container(
                  child: Text('问题名称', style: _keyTextStyle),
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(16),
                      top: ScreenUtil().setHeight(10))),
              Padding(
                padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16),
                    ScreenUtil().setHeight(16), ScreenUtil().setWidth(16), 0.0),
                child: TextField(
                  controller: _nameEditController,
                  style: valueTextStyle,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(_descNode),
                  decoration: InputDecoration(
                    hintText: '必填',
                    contentPadding: contentPadding,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: MyColors.FFD9D9D9)),
                    hasFloatingPlaceholder: false,
                  ),
                ),
              ),

              /// 所属任务/所属点位(当地图上报时才显示)
              Offstage(
                offstage: _patrolTask == null,
                child: Column(
                  children: <Widget>[
                    // 所属任务
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: ScreenUtil().setHeight(56),
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(16),
                            right: ScreenUtil().setWidth(16)),
                        child: Row(
                          children: <Widget>[
                            Text('所属任务', style: _keyTextStyle),
                            Expanded(
                                child: Container(
                              margin: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(4),
                                  right: ScreenUtil().setWidth(4)),
                              child: Text(_patrolTask?.name ?? '',
                                  style: valueTextStyle,
                                  textAlign: TextAlign.end),
                            )),
                            Icon(Icons.keyboard_arrow_right)
                          ],
                        ),
                      ),
                    ),
                    _divider,
                    // 所属点位
                    InkWell(
                      onTap: () {},
                      child: Container(
                        height: ScreenUtil().setHeight(56),
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(16),
                            right: ScreenUtil().setWidth(16)),
                        child: Row(
                          children: <Widget>[
                            Text('所属点位', style: _keyTextStyle),
                            Expanded(
                                child: Container(
                              margin: EdgeInsets.only(
                                  left: ScreenUtil().setWidth(4),
                                  right: ScreenUtil().setWidth(4)),
                              child: Text(_selDossierType?.label ?? '',
                                  style: valueTextStyle,
                                  textAlign: TextAlign.end),
                            )),
                            Icon(Icons.keyboard_arrow_right)
                          ],
                        ),
                      ),
                    ),
                    _divider,
                  ],
                ),
              ),

              /// 紧急程度
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => SimpleDialog(
                          children: _buildUrgencyLevelItem(),
                          contentPadding: EdgeInsets.zero));
                },
                child: Container(
                  height: ScreenUtil().setHeight(56),
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(16),
                      right: ScreenUtil().setWidth(16)),
                  child: Row(
                    children: <Widget>[
                      Text('紧急程度', style: _keyTextStyle),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setWidth(4),
                            right: ScreenUtil().setWidth(4)),
                        child: Text(_selUrgencyLevel?.label ?? '必选',
                            style: _selUrgencyLevel != null
                                ? valueTextStyle
                                : hintTextStyle,
                            textAlign: TextAlign.end),
                      )),
                      Icon(Icons.keyboard_arrow_right)
                    ],
                  ),
                ),
              ),
              _divider,

              /// 问题地址
              Container(
                  child: Text('问题地址', style: _keyTextStyle),
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(16),
                      top: ScreenUtil().setHeight(10))),
              InkWell(
                onTap: () {
                  if (_locationResult.isEmpty) {
                    ToastUtil.showShort('请等待获取当前位置');
                    return;
                  }
                  _stopPlayOnPaused();
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => SearchAddressPage(
                                  latLng: LatLng(_locationResult[0].latitude,
                                      _locationResult[0].longitude))))
                      .then((poiItem) {
                    if (poiItem != null) {
                      setState(() {
                        _poiItem = poiItem;
                      });
                    }
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(top: ScreenUtil().setHeight(6)),
                  padding: EdgeInsets.fromLTRB(
                      ScreenUtil().setWidth(16),
                      ScreenUtil().setHeight(10),
                      ScreenUtil().setWidth(16),
                      ScreenUtil().setHeight(10)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                              _locationResult.isEmpty
                                  ? '获取定位中...'
                                  : _poiItem == null
                                      ? _locationResult[0].address
                                      : _poiItem.snippet,
                              style: valueTextStyle)),
                      Container(
                        margin: EdgeInsets.only(left: ScreenUtil().setWidth(6)),
                        padding: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(10),
                            ScreenUtil().setHeight(2),
                            ScreenUtil().setWidth(14),
                            ScreenUtil().setHeight(2)),
                        decoration: BoxDecoration(
                            color: MyColors.FFCBDAE3,
                            borderRadius: BorderRadius.all(
                                Radius.circular(ScreenUtil().setHeight(14)))),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.location_on, color: MyColors.FF5988A4),
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
              _divider,

              /// 问题描述
              Container(
                  child: Text('问题描述', style: _keyTextStyle),
                  margin: EdgeInsets.only(
                      left: ScreenUtil().setWidth(16),
                      top: ScreenUtil().setHeight(10))),
              Padding(
                padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(16),
                    ScreenUtil().setHeight(16), ScreenUtil().setWidth(16), 0.0),
                child: TextField(
                  controller: _descEditController,
                  style: valueTextStyle,
                  focusNode: _descNode,

                  textInputAction: TextInputAction.done,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: '请填写',
                    contentPadding: contentPadding,
                    border: InputBorder.none,
                  ),
                ),
              ),

              /// 照片/语音
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        left: ScreenUtil().setWidth(16),
                        right: ScreenUtil().setWidth(10)),
                    child: OutlineButton(
                      onPressed: _loadAssets,
                      borderSide: BorderSide(color: MyColors.FFD9D9D9),
                      highlightedBorderColor: MyColors.FFD9D9D9,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.camera_alt, color: MyColors.FF666666),
                          Text('照片', style: _keyTextStyle)
                        ],
                      ),
                    ),
                  ),
                  OutlineButton(
                    onPressed: () {
                      _stopPlayOnPaused();
                      Navigator.push(context,
                              MaterialPageRoute(builder: (_) => RecordPage()))
                          .then((record) {
                        if (record != null) {
                          setState(() {
                            _records.add(record);
                          });
                          // 滑动到底部
                          _scrollController.animateTo(1000,
                              duration: Duration(microseconds: 200),
                              curve: Curves.ease);
                        }
                      });
                    },
                    borderSide: BorderSide(color: MyColors.FFD9D9D9),
                    highlightedBorderColor: MyColors.FFD9D9D9,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.keyboard_voice, color: MyColors.FF666666),
                        Text('语音', style: _keyTextStyle)
                      ],
                    ),
                  )
                ],
              ),

              /// 图片展示
              Offstage(
                offstage: _images.isEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _divider,
                    Container(
                      margin: EdgeInsets.only(
                          top: ScreenUtil().setHeight(10),
                          left: ScreenUtil().setWidth(16)),
                      child:
                          Text('图片（${_images.length}张）', style: _keyTextStyle),
                    ),
                    SingleChildScrollView(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                      scrollDirection: Axis.horizontal,
                      child: Row(children: _buildPicturesView()),
                    ),
                  ],
                ),
              ),

              /// 语音展示
              Offstage(
                offstage: _records.isEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildVoiceView(),
                ),
              ),
            ],
          ),
        )),
        Divider(height: 1.0),
        Container(
            width: ScreenUtil.screenWidth,
            margin: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(16),
                ScreenUtil().setHeight(10),
                ScreenUtil().setWidth(16),
                ScreenUtil().setHeight(10)),
            child: RaisedButton(
              color: MyColors.FF2EAFFF,
              padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
              onPressed: _reportPatrolDossier,
              child: Text(
                '确认上报',
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(18)),
              ),
            ))
      ],
    );
  }

  /// 获取定位
  _fetchPosition() async {
    final options = LocationClientOptions(
        isOnceLocation: true, locatingWithReGeocode: true);
    if (await Permissions().requestPermission()) {
      _aMapLocation
          .startLocate(options)
          .map(_locationResult.add)
          .listen((_) => setState(() {}));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('未获取定位权限')));
    }
  }

  /// 请求字典值
  /// type：要请求的字典值的字段
  _loadDictList(String type) {
    NetUtil.instance.get(Api.instance.dictList, (res) {
      var list = BaseRespList<Dict>(res, (jsonRes) => Dict.fromJson(jsonRes))
          .resultObj;
      setState(() {
        switch (type) {
          case DOSSIER_TYPE:
            _dossierTypes.addAll(list);
            break;
          case URGENCY_LEVEL:
            _urgencyLevels.addAll(list);
            break;
        }
      });
    }, params: {'type': '$type'});
  }

  /// 渲染问题类型弹出框列表项
  List<Widget> _buildDossierTypeItem() {
    var list = List<Widget>();
    for (var dossierType in _dossierTypes) {
      var selected = _selDossierType?.id == dossierType.id;
      list
        ..add(SimpleDialogOption(
          child: Container(
            padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(10),
                bottom: ScreenUtil().setHeight(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(dossierType.label,
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
              _selDossierType = dossierType;
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

  /// 渲染紧急程度弹出框列表项
  List<Widget> _buildUrgencyLevelItem() {
    var list = List<Widget>();
    for (var urgencyLevel in _urgencyLevels) {
      var selected = _selUrgencyLevel?.id == urgencyLevel.id;
      list
        ..add(SimpleDialogOption(
          child: Container(
            padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(10),
                bottom: ScreenUtil().setHeight(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(urgencyLevel.label,
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
              _selUrgencyLevel = urgencyLevel;
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

  /// 图片选择
  Future<void> _loadAssets() async {
    List<Asset> resultList = List<Asset>();

    if (_images.length >= 9) {
      ToastUtil.showLongInCenter('你当前已选择9张图片(最多9张)，无法继续选择');
      return;
    }

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 9 - _images.length,
        enableCamera: true,
        options: CupertinoOptions(takePhotoIcon: "chat"),
      );
    } catch (e) {
      print(e.message);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _images.addAll(resultList);
      _keys.clear();
      _images.forEach((image) {
        _keys.add(GlobalKey());
      });
    });
    // 滑动到底部
    _scrollController.animateTo(1000,
        duration: Duration(microseconds: 200), curve: Curves.ease);
  }

  /// 渲染图片视图
  List<Widget> _buildPicturesView() {
    var widgets = List<Widget>();
    for (int i = 0; i < _images.length; i++) {
      widgets.add(Container(
        margin: EdgeInsets.only(right: ScreenUtil().setWidth(6)),
        child: Stack(alignment: AlignmentDirectional.topEnd, children: <Widget>[
          // 这里设置Key是参考https://github.com/Sh1d0w/multi_image_picker/issues/36
          AssetView(_images[i], key: _keys[i]),
          InkWell(
            child: Icon(Icons.close, color: Colors.white),
            onTap: () {
              setState(() {
                _images.removeAt(i);
                _keys.clear();
                _images.forEach((image) {
                  _keys.add(GlobalKey());
                });
              });
            },
          )
        ]),
      ));
    }
    return widgets;
  }

  /// 构建语音视图
  List<Widget> _buildVoiceView() {
    List<Widget> widgets = List();
    widgets
      ..add(_divider)
      ..add(Container(
        margin: EdgeInsets.only(
            top: ScreenUtil().setHeight(10), left: ScreenUtil().setWidth(16)),
        child: Container(
          child: Text('语音', style: _keyTextStyle),
          margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
        ),
      ));

    for (Record record in _records) {
      widgets.add(InkWell(
        splashColor: Colors.transparent, // 取消点击效果
        onTap: () {
          switch (record.status) {
            case 0:
              for (Record record2 in _records) {
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
              for (Record record2 in _records) {
                if (record2.status == 1 && record2.name != record.name) {
                  _stopPlayer(record2);
                }
              }
              _resumePlayer(record);
              break;
          }
        },
        child: Container(
          height: ScreenUtil().setHeight(35),
          width: ScreenUtil.screenWidthDp,
          margin: EdgeInsets.fromLTRB(ScreenUtil().setWidth(20), 0.0,
              ScreenUtil().setWidth(20), ScreenUtil().setHeight(10)),
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
          color: MyColors.FFBDE5EF,
          child: Row(
            children: <Widget>[
              Icon(Icons.record_voice_over,
                  color: MyColors.FF4D7DAD, size: ScreenUtil().setWidth(20)),
              Container(
                child: Text(
                  '${record.duration ~/ 1000}"',
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
              IconButton(
                  icon: Icon(Icons.close,
                      size: ScreenUtil().setWidth(25),
                      color: MyColors.FF4D7DAD),
                  padding: EdgeInsets.zero,
                  splashColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      _records.remove(record);
                    });
                  })
            ],
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
            record.progress = e.currentPosition / e.duration;
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

  /// 确认上报
  _reportPatrolDossier() async {
    if (_selDossierType == null) {
      ToastUtil.showShort('请选择问题类型');
      return;
    }
    if (_nameEditController.text.trim().isEmpty) {
      ToastUtil.showShort('请填写问题名称');
      return;
    }
    if (_selUrgencyLevel == null) {
      ToastUtil.showShort('请选择紧急程度');
      return;
    }
    if (_locationResult.isEmpty) {
      ToastUtil.showShort('请等待获取事件地址');
      return;
    }
    if (_descEditController.text.trim().isEmpty) {
      ToastUtil.showShort('请填写问题描述');
      return;
    }
    FormData formData = FormData.from({
      'name': _nameEditController.text,
      'type': _selDossierType.value,
      'source': '2',
      'taskId': _patrolTask?.id ?? '',
      'pointId': _selPatrolPoint?.id ?? '',
      'level': _selUrgencyLevel.value,
      'describe': _descEditController.text,
      'address':
          _poiItem == null ? _locationResult[0].address : _poiItem.snippet,
      'longitude': _poiItem == null
          ? _locationResult[0].longitude
          : _poiItem.latLonPoint.longitude,
      'latitude': _poiItem == null
          ? _locationResult[0].latitude
          : _poiItem.latLonPoint.latitude,
      'status': '1',
      'uploadBy.id': UserManager.instance.user.id
    });

    for (int i = 0; i < _images.length; i++) {
      ByteData byteData = await _images[i].requestOriginal(quality: 50);
      List<int> imageData = byteData.buffer.asUint8List();
      formData.add(
          'file$i', UploadFileInfo.fromBytes(imageData, _images[i].name));
    }

    for (int j = 0; j < _records.length; j++) {
      formData.add('file${_images.length + j}',
          UploadFileInfo(File(_records[j].path), _records[j].name));
    }

    showDialog(
        context: context,
        builder: (BuildContext context) => LoadingDialog(text: '提交中...'));

    NetUtil().post(Api().reportDossier, (res) {
      var baseResp = BaseResp<String>(res, null);
      ToastUtil.showShort(baseResp.tipMessage ?? '提交成功');
      Navigator.pop(context);
      // 重置页面数据
      setState(() {
        _selDossierType = null;
        _nameEditController.clear();
        _selUrgencyLevel = null;
        _descEditController.clear();
        _images.clear();
        _records.clear();
      });
      EventManager.instance.eventBus
          .fire(EventCode(EventCode.REPORT_DOSSIER_TASK_SUCCESS));
    }, params: formData);
  }
}
