import 'dart:async';

import 'package:amap_base/amap_base.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/utils/toast_util.dart';

/// 上传位置的Timer
class ReportUserPositionTimer {
  /// Timer是否启动.
  bool _isActive = false;

  /// 高德定位相关
  final _aMapLocation = AMapLocation();
  List<Location> _locationResult = List();

  static ReportUserPositionTimer _instance;

  static ReportUserPositionTimer get instance => _getInstance();

  factory ReportUserPositionTimer() => _getInstance();

  ReportUserPositionTimer._internal() {
    _aMapLocation.init();
  }

  Timer _timer;

  /// 获取单例
  static ReportUserPositionTimer _getInstance() {
    if (_instance == null) {
      _instance = ReportUserPositionTimer._internal();
    }
    return _instance;
  }

  ///Timer是否启动.
  bool isActive() {
    return _isActive;
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

  /// 开启Timer
  startTimer() {
    if (_isActive) return;
    _isActive = true;
    _fetchPosition();
    Duration duration = Duration(minutes: 5);
    _timer = Timer.periodic(duration, (Timer timer) {
      if (_locationResult.isNotEmpty) {
        _reportUserLocation(
            _locationResult.last.longitude, _locationResult.last.latitude);
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

  /// 上传用户位置
  /// longitude：经度 latitude：纬度
  _reportUserLocation(double longitude, double latitude) {
    NetUtil().get(Api().reportUserLocation, (res) {},
        params: {'longitude': longitude, 'latitude': latitude});
  }
}
