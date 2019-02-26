import 'package:flutter_gzxjyh/model/user.dart';

/// 用户管理类(全局单例)
class UserManager {
  static UserManager _instance;

  static UserManager get instance => _getInstance();

  factory UserManager() => _getInstance();

  UserManager._internal();

  User _user;

  /// 获取单例
  static UserManager _getInstance() {
    if (_instance == null) {
      _instance = UserManager._internal();
    }
    return _instance;
  }

  /// 存储全局用户
  storeUser(User user) {
    _user = user;
  }

  /// 获取全局用户
  User get user => _user;
}
