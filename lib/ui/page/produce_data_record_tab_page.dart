import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/model/produce_data.dart';
import 'package:flutter_gzxjyh/ui/widget/empty_view.dart';
import 'package:flutter_gzxjyh/utils/screen_util.dart';

/// 填报记录
class ProduceDataRecordTabPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProduceDataRecordTabState();
}

class ProduceDataRecordTabState extends State<ProduceDataRecordTabPage>
    with AutomaticKeepAliveClientMixin {
  bool _isLoading = true;
  List<ProduceData> _list = List();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadProduceData();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Offstage(
          child: EmptyView(),
          offstage: _list.isNotEmpty,
        ),
        RefreshIndicator(
            child: ListView.builder(
              itemBuilder: _renderItem,
              itemCount: _list.length * 2,
            ),
            onRefresh: _onRefresh)
      ],
    );
  }

  /// 下拉刷新
  Future<Null> _onRefresh() async {
    _loadProduceData();
    return null;
  }

  /// 渲染Item
  Widget _renderItem(BuildContext context, int index) {
    if (index.isOdd) {
      return Padding(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(12), right: ScreenUtil().setWidth(12)),
        child: Divider(
          color: const Color(0xffd9d9d9),
          height: ScreenUtil().setHeight(1),
        ),
      );
    }

    index = index ~/ 2;
    ProduceData produceData = _list[index];
    return InkWell(
      child: Container(
        height: ScreenUtil().setHeight(84),
        padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              "${produceData.name}",
              style: TextStyle(
                color: const Color(0xff101010),
                fontSize: ScreenUtil().setSp(16),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  produceData.statusName,
                  style: TextStyle(
                    color: const Color(0xff999999),
                    fontSize: ScreenUtil().setSp(14),
                  ),
                ),
                Text(
                  produceData.createDate,
                  style: TextStyle(
                    color: const Color(0xff999999),
                    fontSize: ScreenUtil().setSp(14),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      onTap: () {
        //TODO 进入详情
//        Navigator.push(
//            context,
//            MaterialPageRoute(
//                builder: (_) => MaterialOrderDetailPage(id: materialApply.id)));
      },
    );
  }

  /// 获取变更记录列表
  _loadProduceData() {
    NetUtil.instance.get(Api.instance.loadProduceData, (body) {
      List<ProduceData> list = BaseRespList<ProduceData>(
          body, (jsonRes) => ProduceData.fromJson(jsonRes)).resultObj;
      setState(() {
        _isLoading = false;
        _list.clear();
        _list.addAll(list);
      });
    }, params: {'qType': "1"});
  }
}
