import 'package:intl/intl.dart';

/// 日期工具类
class DateUtil {
  // format格式
  /// 'yyyy-MM-dd HH:mm:ss.SSS'
  static const FORMAT_DEFAULT = 'yyyy-MM-dd HH:mm:ss.SSS';

  /// 'yyyy-MM-dd HH:mm:ss'
  static const FORMAT_NORMAL = 'yyyy-MM-dd HH:mm:ss';

  /// 'yyyy_MM_dd_HH_mm_ss'
  static const FORMAT_NORMAL_NAME = 'yyyy_MM_dd_HH_mm_ss';

  /// 'yyyy-MM-dd HH:mm'
  static const FORMAT_YEAR_MONTH_DAY_HOUR_MINUTE = 'yyyy-MM-dd HH:mm';

  /// 'yyyy-MM-dd'
  static const FORMAT_YEAR_MONTH_DAY = 'yyyy-MM-dd';

  /// 'yyyy-MM'
  static const FORMAT_YEAR_MONTH = 'yyyy-MM';

  /// 'yyyy'
  static const FORMAT_YEAR = 'yyyy';

  /// 'HH:mm:ss'
  static const FORMAT_HOUR_MINUTE_SECOND = 'HH:mm:ss';

  /// 'HH:mm'
  static const FORMAT_HOUR_MINUTE = 'HH:mm';

  /// 'ss'
  static const FORMAT_SECOND = 'ss';

  /// 'yyyy年MM月dd日'
  static const FORMAT_ZH_YEAR_MONTH_DAY = 'yyyy年MM月dd日';

  /// 'yyyy年MM月'
  static const FORMAT_ZH_YEAR_MONTH = 'yyyy年MM月';

  /// 'MM月dd日'
  static const FORMAT_ZH_MONTH_DAY = 'MM月dd日';

  /// 将DateTime类型转换为String类型的日期
  /// dateTime：要转换的日期类型
  /// format：转换的格式（默认DateUtil.FORMAT_NORMAL）
  static String dateTimeStr(DateTime dateTime,
      {String formatStr = FORMAT_NORMAL}) {
    if (dateTime == null) {
      return null;
    } else {
      return DateFormat(formatStr).format(dateTime);
    }
  }

  /// 将毫秒值转化为 yyyy-MM-dd HH:mm
  static String long2MinuteStr(int mills) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(mills);
    return "${_dateNumToString(dateTime.year)}-${_dateNumToString(dateTime.month)}-${_dateNumToString(dateTime.day)} ${_dateNumToString(dateTime.hour)}:${_dateNumToString(dateTime.second)}";
  }

  /// 将int型的date值转换成%0d格式（如3转成03）
  static String _dateNumToString(int dateNum) {
    if (dateNum.toString().length == 1) {
      return "0$dateNum";
    } else {
      return dateNum.toString();
    }
  }

  /// 获取与当前时间的间隔毫秒值
  /// 要比较的时间
  static int getMinutesSpaceFromNow(String dateStr) {
    return DateTime.tryParse(dateStr).millisecondsSinceEpoch -
        DateTime.now().millisecondsSinceEpoch;
  }
}
