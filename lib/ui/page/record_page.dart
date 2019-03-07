import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/model/record.dart';
import 'package:flutter_gzxjyh/ui/widget/record_volume_view.dart';
import 'package:flutter_gzxjyh/utils/date_util.dart';
import 'package:flutter_gzxjyh/utils/toast_util.dart';
import 'package:flutter_gzxjyh/utils/screen_util.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

/// 录音界面（巡检人员主界面-首页-问题上报-问题上报子页面-语音）
class RecordPage extends StatefulWidget {
  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  static const RECORDING_IDLE = 0;
  static const RECORDING = 1;
  static const PLAYING_IDLE = 2;
  static const PLAYING = 3;
  static const PAUSING = 4;
  int _type = RECORDING_IDLE;

  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription;
  StreamSubscription _playerSubscription;
  FlutterSound _flutterSound;

  /// 录音显示的时间文本
  String _recorderText = '00';

  /// 录音文件存储的位置
  String _recordPath;
  String _recordName;
  double _recordTime;

  /// 播放显示的时间文本
  String _playerText = '00';

  /// 录音分贝值（0-120）
  double _dbLevel = 0;

  /// 录音时间是否过短
  bool _isTooShort = true;
  bool _wantStopRecord = false;

  @override
  void initState() {
    super.initState();
    _flutterSound = FlutterSound();
    _flutterSound.setSubscriptionDuration(0.1);
    _flutterSound.setDbPeakLevelUpdate(0.8);
    _flutterSound.setDbLevelEnabled(true);
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: Text('语音'),
      backgroundColor: MyColors.FF2EAFFF,
      centerTitle: true,
    );

    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        appBar: appBar,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
                _type == RECORDING_IDLE ||
                        _type == RECORDING ||
                        _type == PLAYING_IDLE
                    ? _recorderText
                    : _playerText,
                style: TextStyle(
                    color: _type == RECORDING || _type == PLAYING
                        ? MyColors.FF2EAFFF
                        : MyColors.FF999999,
                    fontSize: ScreenUtil().setSp(60))),
            Stack(alignment: Alignment.center, children: <Widget>[
              RecordVolumeView(progress: _dbLevel / 120 * 100),
              Offstage(
                offstage: !(_type == RECORDING_IDLE || _type == RECORDING),
                child: GestureDetector(
                  child: Icon(Icons.keyboard_voice,
                      color: Colors.white, size: ScreenUtil().setWidth(100)),
                  onPanDown: (_) {
                    // 按下录音键
                    _startRecorder();
                  },
                  onPanEnd: (_) {
                    // 放开录音键
                    _wantStopRecord = true;
                    if (!_isTooShort) {
                      _stopRecorder();
                    }
                  },
                ),
              ),
              Offstage(
                offstage: !(_type == PLAYING_IDLE ||
                    _type == PLAYING ||
                    _type == PAUSING),
                child: GestureDetector(
                  child: Icon(_type == PLAYING ? Icons.pause : Icons.play_arrow,
                      color: Colors.white, size: ScreenUtil().setWidth(100)),
                  onTap: () {
                    // 按下播放/暂停键
                    switch (_type) {
                      case PLAYING_IDLE:
                        _startPlayer();
                        break;
                      case PLAYING:
                        _pausePlayer();
                        break;
                      case PAUSING:
                        _resumePlayer();
                        break;
                    }
                  },
                ),
              ),
            ]),
            Opacity(
              opacity:
                  _type == PLAYING_IDLE || _type == PLAYING || _type == PAUSING
                      ? 1
                      : 0,
              child: Container(
                width: ScreenUtil.screenWidthDp,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: ScreenUtil.screenWidthDp * 0.4,
                      child: RaisedButton(
                          onPressed: () {
                            _recordPath = null;
                            if (_type == PLAYING || _type == PAUSING) {
                              _stopPlayer();
                            } else {
                              setState(() {
                                _type = RECORDING_IDLE;
                                _isTooShort = true;
                                _wantStopRecord = false;
                                _recorderText = '00';
                              });
                            }
                          },
                          child: Text('重新录制',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(17))),
                          color: MyColors.FF2EAFFF,
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(10),
                              bottom: ScreenUtil().setHeight(10))),
                    ),
                    Container(
                        width: ScreenUtil.screenWidthDp * 0.4,
                        child: RaisedButton(
                            onPressed: () => Navigator.pop(
                                context,
                                Record.fromParams(
                                    path: _recordPath,
                                    name: _recordName,
                                    duration: _recordTime)),
                            child: Text('确认',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(17))),
                            color: MyColors.FF2EAFFF,
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setHeight(10),
                                bottom: ScreenUtil().setHeight(10)))),
                  ],
                ),
              ),
            ),
            Text('长按开始录音,录音最多一分钟',
                style: TextStyle(
                    color: MyColors.FF999999, fontSize: ScreenUtil().setSp(15)))
          ],
        ),
      ),
    );
  }

  /// 开始录音
  _startRecorder() async {
    try {
      _recordName =
          '${DateUtil.dateTimeStr(DateTime.now(), formatStr: DateUtil.FORMAT_NORMAL_NAME)}.aac';
      Directory appDocDirectory = await getApplicationDocumentsDirectory();
      _recordPath = '${appDocDirectory.path}/$_recordName';
      String path = await _flutterSound.startRecorder(_recordPath);
      print('startRecorder: $path');

      // 使Toast仅展示一次的Flag
      bool showOnceFlag = true;
      _recorderSubscription = _flutterSound.onRecorderStateChanged.listen((e) {
        DateTime date =
            DateTime.fromMillisecondsSinceEpoch(e.currentPosition.toInt());
        if (_wantStopRecord) {
          if (e.currentPosition < 800 && showOnceFlag) {
            ToastUtil.showShortInCenter('录音时间过短');
            showOnceFlag = false;
            _recordPath = null;
            _isTooShort = true;
          }
          if (_isTooShort && e.currentPosition > 800) {
            _stopRecorder(auto: true);
          }
        }
        if (e.currentPosition > 1000) {
          _isTooShort = false;
        }
        if (e.currentPosition > 59000) {
          ToastUtil.showShortInCenter('录音最多一分钟');
          _stopRecorder();
        }

        String txt =
            DateUtil.dateTimeStr(date, formatStr: DateUtil.FORMAT_SECOND);
        _recordTime = e.currentPosition;

        setState(() {
          _recorderText = txt;
        });
      });
      _dbPeakSubscription =
          _flutterSound.onRecorderDbPeakChanged.listen((value) {
        // print("got update -> $value");
        setState(() {
          _dbLevel = value;
        });
      });

      setState(() {
        _type = RECORDING;
      });
    } catch (err) {
      print('startRecorder error: $err');
    }
  }

  /// 结束录音
  /// auto 是否是时间过短自动停止
  _stopRecorder({bool auto = false}) async {
    try {
      String result = await _flutterSound.stopRecorder();
      print('stopRecorder: $result');

      if (_recorderSubscription != null) {
        _recorderSubscription.cancel();
        _recorderSubscription = null;
      }
      if (_dbPeakSubscription != null) {
        _dbPeakSubscription.cancel();
        _dbPeakSubscription = null;
      }

      setState(() {
        if (auto) {
          _type = RECORDING_IDLE;
          _isTooShort = true;
          _wantStopRecord = false;
          _recorderText = '00';
        } else {
          _type = PLAYING_IDLE;
        }
        _dbLevel = 0;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  /// 开始播放录音
  _startPlayer() async {
    String path = await _flutterSound.startPlayer(_recordPath);
    await _flutterSound.setVolume(1.0);
    print('startPlayer: $path');

    try {
      _playerSubscription = _flutterSound.onPlayerStateChanged.listen((e) {
        if (e != null) {
          DateTime date = new DateTime.fromMillisecondsSinceEpoch(
              e.currentPosition.toInt());
          String txt =
              DateUtil.dateTimeStr(date, formatStr: DateUtil.FORMAT_SECOND);
          setState(() {
            _playerText = txt;
          });
          if (e.duration == e.currentPosition) {
            setState(() {
              _type = PLAYING_IDLE;
              _playerText = '00';
            });
          }
        }
      });
      setState(() {
        _type = PLAYING;
      });
    } catch (err) {
      print('error: $err');
    }
  }

  /// 暂停播放
  _pausePlayer() async {
    String result = await _flutterSound.pausePlayer();
    print('pausePlayer: $result');
    setState(() {
      _type = PAUSING;
    });
  }

  /// 继续播放
  _resumePlayer() async {
    String result = await _flutterSound.resumePlayer();
    print('resumePlayer: $result');
    setState(() {
      _type = PLAYING;
    });
  }

  /// 结束播放
  _stopPlayer() async {
    try {
      String result = await _flutterSound.stopPlayer();
      print('stopPlayer: $result');
      if (_playerSubscription != null) {
        _playerSubscription.cancel();
        _playerSubscription = null;
      }

      setState(() {
        _type = RECORDING_IDLE;
        _isTooShort = true;
        _wantStopRecord = false;
        _recorderText = '00';
      });
    } catch (err) {
      print('error: $err');
    }
  }

  /// 监听返回
  Future<bool> _onBack() {
    if (_recordPath != null) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('你有未上传的录音文件，是否确定返回?'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('取消')),
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text('确定')),
                ],
              ));
      return Future.value(false);
    }
    return Future.value(true);
  }
}
