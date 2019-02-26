import 'dart:async';

import 'package:flutter/material.dart';

/// 竖向轮播的文本跑马灯效果
/// 参考：https://pub.flutter-io.cn/packages/flutter_vertical_marquee
class Marquee extends StatefulWidget {
  final List<String> textList;
  final List<TextSpan> textSpanList;
  final double fontSize;
  final Color textColor;
  final Duration scrollDuration;
  final Duration stopDuration;
  final bool tapToNext;
  final MarqueeController controller;

  const Marquee({
    Key key,
    this.textList = const [],
    this.textSpanList = const [],
    this.fontSize = 14.0,
    this.textColor = Colors.black,
    this.scrollDuration = const Duration(seconds: 1),
    this.stopDuration = const Duration(seconds: 3),
    this.tapToNext = false,
    this.controller,
  }) : super(key: key);

  @override
  _MarqueeState createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  double percent = 0.0;
  int current = 0;

  List<String> get textList => widget.textList;

  List<TextSpan> get textSpanList => widget.textSpanList;

  Timer stopTimer;

  AnimationController animationController;

  MarqueeController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
    stopTimer =
        Timer.periodic(widget.stopDuration + widget.scrollDuration, (timer) {
      next();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    stopTimer.cancel();
    super.dispose();
  }

  void next() {
    var listener = () {
      var value = animationController.value;
      setState(() {
        percent = value;
        _refreshControllerValue();
      });
    };

    animationController.addListener(listener);
    animationController
        .animateTo(1.0, duration: widget.scrollDuration * (1 - percent))
        .then((t) {
      animationController.removeListener(listener);
      animationController.value = 0.0;
      setState(() {
        percent = 0.0;
        current = nextPosition;
        _refreshControllerValue();
      });
    });
  }

  void _refreshControllerValue() {
    controller?.position = current;
    if (percent > 0.5) {
      controller?.position = nextPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(!(textList.isNotEmpty && textSpanList.isNotEmpty),
        "textList and textSpanList cannot have elements at the same time.",);

    if ((textList == null || textList.isEmpty) &&
        (textSpanList == null || textSpanList.isEmpty)) {
      return Container();
    }

    if (textList.length == 1) {
      return Center(
        child: Text(
          textList[0],
          style: TextStyle(
            fontSize: widget.fontSize,
            color: widget.textColor,
          ),
        ),
      );
    }

    if (textSpanList.length == 1) {
      return Center(
        child: Text.rich(
          textSpanList[0],
          style: TextStyle(
            fontSize: widget.fontSize,
            color: widget.textColor,
          ),
        ),
      );
    }

    Widget _widget = ClipRect(
      child: CustomPaint(
        child: Container(),
        painter: _MarqueePainter(
          widget.textList,
          textSpanList: textSpanList,
          fontSize: widget.fontSize,
          textColor: widget.textColor,
          verticalSpace: 0.0,
          percent: percent,
          current: current,
        ),
      ),
    );

    if (widget.tapToNext) {
      _widget = GestureDetector(
        onTap: next,
        child: _widget,
      );
    }

    return _widget;
  }

  int get nextPosition {
    List list;
    if (textSpanList.isNotEmpty) {
      list = textSpanList;
    } else {
      list = textList;
    }

    var next = current + 1;
    if (next >= list.length) {
      next = 0;
    }
    return next;
  }
}

class _MarqueePainter extends CustomPainter {
  List<String> textList;
  List<TextSpan> textSpanList;
  double verticalSpace;
  double fontSize;
  Color textColor;

  int current = 0;

  double percent = 0.0;

  _MarqueePainter(
    this.textList, {
    this.textSpanList,
    this.fontSize,
    this.textColor,
    this.verticalSpace,
    this.percent = 0.0,
    this.current,
  });

  TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr, textAlign: TextAlign.center);

  @override
  void paint(Canvas canvas, Size size) {
    _paintCurrent(size, canvas);
    _paintNext(size, canvas);
  }

  TextSpan getTextSpan(int position) {
    if (textSpanList.isNotEmpty) {
      return textSpanList[position];
    }

    String text = textList[position];
    return TextSpan(
      text: text,
      style: TextStyle(
        fontSize: fontSize,
        color: textColor,
      ),
    );
  }

  void _paintCurrent(Size size, Canvas canvas) {
    textPainter.text = getTextSpan(current);
    textPainter.textAlign = TextAlign.center;
    textPainter.maxLines = 1;
    textPainter.ellipsis = "...";

    textPainter.layout(maxWidth: size.width);
    textPainter.paint(canvas, _getTextOffset(textPainter, size));
  }

  _paintNext(Size size, Canvas canvas) {
    textPainter.text = getTextSpan(nextPosition);
    textPainter.textAlign = TextAlign.center;
    textPainter.maxLines = 1;
    textPainter.ellipsis = "...";

    textPainter.layout(maxWidth: size.width);
    textPainter.paint(canvas, _getTextOffset(textPainter, size, isNext: true));
  }

  Offset _getTextOffset(
    TextPainter textPainter,
    Size size, {
    bool isNext = false,
  }) {
    var width = textPainter.width;
    if (width >= size.width) {
      width = size.width;
    }
    var height = textPainter.height;

    /// 居左
    // var dx = size.width / 2 - width / 2;
    var dy = size.height / 2 - height / 2 - size.height * percent;
    if (isNext) {
      dy = dy + size.height;
    }
    // return Offset(dx, dy);
    return Offset(0, dy);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  int get nextPosition {
    List list;
    if (textSpanList.isNotEmpty) {
      list = textSpanList;
    } else {
      list = textList;
    }

    var next = current + 1;
    if (next >= list.length) {
      next = 0;
    }
    return next;
  }
}

class MarqueeController {
  int position;
}
