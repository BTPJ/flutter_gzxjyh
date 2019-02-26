import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 上拉加载更多的Widget
class LoadingMore extends StatelessWidget {
  /// 是否有更多数据
  final bool haveMore;

  const LoadingMore({Key key, this.haveMore = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Offstage(
            child: CupertinoActivityIndicator(),
            offstage: !haveMore,
          ),
          Padding(
            padding: EdgeInsets.only(left: 6.0),
            child: Text(haveMore ? '正在加载中...' : '没有更多数据',
                style: TextStyle(color: const Color(0xff999999))),
          )
        ],
      ),
    );
  }
}
