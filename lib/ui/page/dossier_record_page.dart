import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/model/dossier_info.dart';
import 'package:flutter_gzxjyh/ui/widget/empty_view.dart';
import 'package:flutter_gzxjyh/ui/widget/loading_more.dart';
import 'package:flutter_gzxjyh/utils/screen_util.dart';

/// 巡检人员主界面-首页-问题上报-上报记录子页面
class DossierRecordPage extends StatefulWidget {
  @override
  _DossierRecordPageState createState() => _DossierRecordPageState();
}

class _DossierRecordPageState extends State<DossierRecordPage> {
  var _list = List<DossierInfo>();

  /// 是否正在加载
  bool _isLoading = true;

  /// 滑动控制器
  ScrollController _scrollController;

  /// 当前页数
  var _pageNo = 1;

  /// 每次请求的数量
  static const int _PAGE_SIZE = 10;

  /// 列表数量
  var _listTotalSize = 0;

  @override
  void initState() {
    super.initState();
    _initScrollController();
    _onRefresh();
  }

  /// 初始化ScrollController
  _initScrollController() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      // 最大的滚动距离
      var maxScrollPixels = _scrollController.position.maxScrollExtent;
      // 已向下滚动的距离
      var nowScrollPixels = _scrollController.position.pixels;
      // 对比判定是否滚动到底从而分页加载
      if (nowScrollPixels == maxScrollPixels && _list.length < _listTotalSize) {
        _onLoadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Offstage(child: EmptyView(), offstage: _list.isNotEmpty),
        RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
                // 保持ListView任何情况都能滚动，解决在RefreshIndicator的兼容问题(列表未铺满时无法上拉)
                physics: AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                itemBuilder: _buildItem,
                itemCount: _list.length * 2 + 1))
      ],
    );
  }

  /// 创建List Item布局
  Widget _buildItem(BuildContext context, int index) {
    if (index == _list.length * 2) {
      if (_listTotalSize > _PAGE_SIZE) {
        return LoadingMore(haveMore: _list.length < _listTotalSize);
      } else {
        /// 当列表不够上拉时，返回空布局
        return Container();
      }
    }

    if (index.isOdd) {
      return Padding(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(16), right: ScreenUtil().setWidth(16)),
        child: Divider(height: 1.0),
      );
    }

    index = index ~/ 2;
    DossierInfo dossier = _list[index];
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(40),
        margin: EdgeInsets.all(ScreenUtil().setWidth(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(dossier.name,
                style: TextStyle(
                    color: Colors.black, fontSize: ScreenUtil().setSp(16)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(dossier.statusName,
                    style: TextStyle(
                        color: MyColors.FF999999,
                        fontSize: ScreenUtil().setSp(14))),
                Text(dossier.updateDate,
                    style: TextStyle(
                        color: MyColors.FF999999,
                        fontSize: ScreenUtil().setSp(14))),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// 案卷上报记录
  _loadDossierTaskPageList(int pageNo) {
    NetUtil.instance.get(Api.instance.dossierPageList, (res) {
      _isLoading = false;
      var page = BaseResp<DossierInfoPage>(
          res, (jsonRes) => DossierInfoPage.fromJson(jsonRes)).resultObj;
      _listTotalSize = page.count;
      var list = page.list ?? List();
      setState(() {
        _list.addAll(list);
      });
    }, params: {
      'pageNo': '$pageNo',
      'pageSize': '$_PAGE_SIZE',
      'self': '1',
      'status': '1,2,3,4,5,6,7'
    });
  }

  /// 下拉刷新
  Future<void> _onRefresh() async {
    _pageNo = 1;
    _list.clear();
    _loadDossierTaskPageList(_pageNo);
  }

  /// 上拉加载
  _onLoadMore() {
    _pageNo++;
    _loadDossierTaskPageList(_pageNo);
  }
}
