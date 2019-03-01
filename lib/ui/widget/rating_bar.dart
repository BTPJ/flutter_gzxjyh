import 'package:flutter/material.dart';

typedef void RatingChangeCallback(double rating);

/// 自定义的评分RatingBar组件
/// 参考：https://pub.flutter-io.cn/packages/flutter_rating#-installing-tab-
class RatingBar extends StatelessWidget {
  /// 评分总数
  final int starCount;

  /// 评分数
  final double rating;

  /// 点击评分回调
  final RatingChangeCallback onRatingChanged;
  final Color color;
  final Color borderColor;
  final double size;
  final MainAxisAlignment mainAxisAlignment;

  const RatingBar(
      {Key key,
      this.starCount = 5,
      this.rating = 0,
      this.onRatingChanged,
      this.color,
      this.borderColor,
      this.size,
      this.mainAxisAlignment = MainAxisAlignment.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                List.generate(starCount, (index) => buildStar(context, index))),
      ),
    );
  }

  /// 构建星星布局
  buildStar(BuildContext context, int index) {
    Icon icon;
    double ratingStarSizeRelativeToScreen =
        MediaQuery.of(context).size.width / starCount;

    if (index >= rating) {
      icon = Icon(
        Icons.star_border,
        color: borderColor ?? Theme.of(context).buttonColor,
        size: size ?? ratingStarSizeRelativeToScreen,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
        size: size ?? ratingStarSizeRelativeToScreen,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
        size: size ?? ratingStarSizeRelativeToScreen,
      );
    }

    return InkWell(
      splashColor: Colors.transparent,
      radius: (size ?? ratingStarSizeRelativeToScreen) / 2,
      onTap:
          onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: Container(
        child: icon,
        height: (size ?? ratingStarSizeRelativeToScreen) * 1.5,
      ),
    );
  }
}
