import 'package:fluttertoast/fluttertoast.dart';

/// Toast管理类
class ToastUtil {
  /// 显示短时长的Toast(默认在底部)
  static showShort(String msg) {
    Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_SHORT);
  }

  /// 显示长时长的Toast(默认在底部)
  static showLong(String msg) {
    Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_LONG);
  }

  /// 显示短时长的Toast(在中间)
  static showShortInCenter(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
  }

  /// 显示长时长的Toast(在中间)
  static showLongInCenter(String msg) {
    Fluttertoast.showToast(
        msg: msg, toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.CENTER);
  }
}
