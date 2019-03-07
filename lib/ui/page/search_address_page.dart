import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:amap_base/amap_base.dart';
import 'package:flutter_gzxjyh/ui/widget/empty_view.dart';
import 'package:flutter_gzxjyh/utils/screen_util.dart';

/// 事件地址（定位）定位时选择附近位置用
class SearchAddressPage extends StatefulWidget {
  final LatLng latLng;

  const SearchAddressPage({Key key, @required this.latLng}) : super(key: key);

  @override
  _SearchAddressPageState createState() => _SearchAddressPageState();
}

class _SearchAddressPageState extends State<SearchAddressPage> {
  bool _isLoading = true;
  List<PoiItem> _poiItems = List();

  @override
  void initState() {
    super.initState();
    _searchPoiItems('');
  }

  @override
  Widget build(BuildContext context) {
    var appbar = AppBar(
      backgroundColor: MyColors.FF1296DB,
      leading: InkWell(
          child: Icon(Icons.close), onTap: () => Navigator.pop(context)),
      title: Text('事件地址'),
      centerTitle: true,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar,
      body: Column(
        children: <Widget>[
          Container(
            color: MyColors.FFF0F0F0,
            child: Container(
              margin: EdgeInsets.fromLTRB(
                  ScreenUtil().setWidth(16),
                  ScreenUtil().setHeight(10),
                  ScreenUtil().setWidth(16),
                  ScreenUtil().setHeight(10)),
              padding: EdgeInsets.only(
                  left: ScreenUtil().setWidth(12),
                  right: ScreenUtil().setWidth(12)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenUtil().setWidth(20)))),
              child: TextField(
                onChanged: (value) => _searchPoiItems(value),
                decoration: InputDecoration(
                    hintText: '搜索附近地址', border: InputBorder.none),
              ),
            ),
          ),
          Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _poiItems.isEmpty
                      ? EmptyView(msg: '附近暂无此地址')
                      : ListView.builder(
                          itemBuilder: _buildItem,
                          itemCount: _poiItems.length * 2))
        ],
      ),
    );
  }

  /// 构建渲染Item
  Widget _buildItem(BuildContext context, int index) {
    if (index.isOdd) {
      return Padding(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(16), right: ScreenUtil().setWidth(10)),
        child: Divider(height: 1.0),
      );
    }

    index = index ~/ 2;
    PoiItem poiItem = _poiItems[index];
    return InkWell(
      onTap: () => Navigator.pop(context, poiItem),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(16),
                ScreenUtil().setHeight(10),
                ScreenUtil().setWidth(16),
                ScreenUtil().setHeight(6)),
            child: Text(poiItem.title,
                style: TextStyle(
                    color: MyColors.FF333333,
                    fontSize: ScreenUtil().setSp(16))),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(16),
                ScreenUtil().setHeight(6),
                ScreenUtil().setWidth(16),
                ScreenUtil().setHeight(10)),
            child: Text(poiItem.snippet,
                style: TextStyle(
                    color: MyColors.FF666666,
                    fontSize: ScreenUtil().setSp(14))),
          )
        ],
      ),
    );
  }

  /// 搜索区域
  _searchPoiItems(String searchStr) {
    AMapSearch()
        .searchPoiBound(PoiSearchQuery(
            query: searchStr,
            location:
                LatLng(widget.latLng.latitude, widget.latLng.longitude),
            searchBound: SearchBound(
              center:
                  LatLng(widget.latLng.latitude, widget.latLng.longitude),
              range: 1500, // 半径
            )))
        .then((poiResult) {
      setState(() {
        _isLoading = false;
        _poiItems = poiResult.pois;
      });
    }).catchError((e) => print(e.toString()));
  }
}
