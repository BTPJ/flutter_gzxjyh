import 'package:event_bus/event_bus.dart';

/// EventBus管理类
class EventManager {
  static EventManager _instance;

  static EventManager get instance => _getInstance();

  factory EventManager() => _getInstance();

  EventBus _eventBus = EventBus();

  EventBus get eventBus => _eventBus;

  EventManager._internal();

  /// 获取单例
  static EventManager _getInstance() {
    if (_instance == null) {
      _instance = EventManager._internal();
    }
    return _instance;
  }
}
