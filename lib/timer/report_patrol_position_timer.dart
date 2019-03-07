import 'dart:async';

import 'package:amap_base/amap_base.dart';
import 'package:flutter_gzxjyh/event/event_code.dart';
import 'package:flutter_gzxjyh/event/event_manager.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/utils/toast_util.dart';

/// 上传位置的Timer
class ReportPatrolPositionTimer {
  /// Timer是否启动.
  bool _isActive = false;

  /// 高德定位相关
  final _aMapLocation = AMapLocation();
  List<Location> _locationResult = List();

  static ReportPatrolPositionTimer _instance;

  static ReportPatrolPositionTimer get instance => _getInstance();

  factory ReportPatrolPositionTimer() => _getInstance();

  ReportPatrolPositionTimer._internal() {
    _aMapLocation.init();
  }

  Timer _timer;

  /// 获取单例
  static ReportPatrolPositionTimer _getInstance() {
    if (_instance == null) {
      _instance = ReportPatrolPositionTimer._internal();
    }
    return _instance;
  }

  /// 获取定位
  _fetchPosition() async {
    final options = LocationClientOptions(locatingWithReGeocode: true);
    if (await Permissions().requestPermission()) {
      _aMapLocation
          .startLocate(options)
          .map(_locationResult.add)
          .listen((_) {});
    } else {
      ToastUtil.showShort('未获取定位权限');
    }
  }

  ///Timer是否启动.
  bool isActive() {
    return _isActive;
  }

  /// 开启Timer
  startTimer(String taskId) {
    if (_isActive) return;
    _isActive = true;
    _fetchPosition();
    Duration duration = Duration(minutes: 5);
    _timer = Timer.periodic(duration, (Timer timer) {
      if (_locationResult.isNotEmpty) {
        _reportPatrolLocation(taskId, _locationResult.last.longitude,
            _locationResult.last.latitude);
      }
    });
  }

  /// 关闭Timer
  void cancel() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    _aMapLocation.stopLocate();
    _isActive = false;
  }

  /// 上传巡检员位置
  /// longitude：经度 latitude：纬度
  _reportPatrolLocation(String taskId, double longitude, double latitude) {
    NetUtil().get(Api().reportPatrolLocation, (res) {
      var baseResp = BaseResp<String>(res,null);
      if(baseResp?.tipMessage!=null&&baseResp.tipMessage.isNotEmpty){
        print('到达巡检点');
        EventManager().eventBus.fire(EventCode(EventCode.ARRIVE_TO_PATROL_POINT));
      }
    }, params: {
      'taskId': taskId,
      'longitude': longitude,
      'latitude': latitude
    });
  }
}
