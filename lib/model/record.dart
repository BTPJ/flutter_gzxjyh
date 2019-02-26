/// 录音
class Record {
  /// 路径
  String path;

  /// 名称
  String name;

  /// 总时长（s）
  double duration;

  /// 当前进度（0.0-1.0）
  double progress;

  /// 播放状态（0：未播放，1：播放中，2：暂停中）
  int status = 0;

  Record.fromParams({this.path, this.name, this.duration, this.progress});
}
