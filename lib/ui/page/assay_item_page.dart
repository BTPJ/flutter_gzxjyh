import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/constant/my_colors.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/assay_format.dart';
import 'package:flutter_gzxjyh/model/assay_item_format.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/ui/widget/empty_view.dart';
import 'package:flutter_gzxjyh/utils/screen_util.dart';

/// 添加分析项
class AssayItemPage extends StatefulWidget {
  /// 要回显的之前选择的污水厂
  final List<AssayItemFormat> mCheckedList;

  const AssayItemPage({Key key, this.mCheckedList}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AssayItemPageState();
}

class AssayItemPageState extends State<AssayItemPage> {
  bool _isLoading = true;
  List<AssayItemFormat> _list = List();

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyColors.FFF0F0F0,
        titleSpacing: ScreenUtil().setWidth(-36),
        title: Text("添加分析项",
            style: TextStyle(
                color: MyColors.FF666666, fontSize: ScreenUtil().setSp(17))),
        leading: Container(),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close, color: MyColors.FF101010),
              onPressed: () => Navigator.pop(context))
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
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
        Column(
          children: <Widget>[
            Expanded(
              child: RefreshIndicator(
                  child: ListView.builder(
                    itemBuilder: _renderItem,
                    itemCount: _list.length * 2 - 1,
                  ),
                  onRefresh: _onRefresh),
            ),
            Divider(height: 1.0),
            InkWell(
              child: Container(
                width: ScreenUtil.screenWidth,
                height: ScreenUtil().setHeight(44),
                margin: EdgeInsets.only(
                    left: ScreenUtil().setWidth(20),
                    top: ScreenUtil().setWidth(15),
                    bottom: ScreenUtil().setWidth(15),
                    right: ScreenUtil().setWidth(20)),
                color: MyColors.FF1296DB,
                child: Center(
                  child: Text("确认",
                      style: TextStyle(
                        color: MyColors.FFFFFFFF,
                        fontSize: ScreenUtil().setSp(18),
                      )),
                ),
              ),

              /// 确认
              onTap: () {
                Navigator.pop(context, widget.mCheckedList);
              },
            )
          ],
        ),
      ],
    );
  }

  /// 渲染Item
  Widget _renderItem(BuildContext context, int index) {
    if (index.isOdd && index != _list.length * 2 - 1) {
      return Container(
        padding: EdgeInsets.only(
            left: ScreenUtil().setWidth(20), right: ScreenUtil().setWidth(20)),
        child: Divider(height: 1.0),
      );
    }

    index = index ~/ 2;

    return InkWell(
      child: Container(
        padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(15),
            bottom: ScreenUtil().setHeight(15),
            left: ScreenUtil().setWidth(20),
            right: ScreenUtil().setWidth(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
                _list[index].itemInfo != null
                    ? _list[index].itemInfo.name
                    : _list[index].assayTypeDto.name,
                style: TextStyle(
                  color: MyColors.FF000000,
                  fontSize: ScreenUtil().setSp(16),
                )),
            getCheckImage(_list[index].hasChecked
                ? 'images/ic_circle_check_blue.png'
                : 'images/ic_circle_check_gray.png'),
          ],
        ),
      ),

      /// 条目点击
      onTap: () {
        if (_list[index].hasChecked) {
          _list[index].hasChecked = false;
          widget.mCheckedList.remove(_list[index]);
        } else {
          _list[index].hasChecked = true;
          widget.mCheckedList.add(_list[index]);
        }

        setState(() {});
      },
    );

//    return CheckboxListTile(
//      value: _list[index].hasChecked,
//      activeColor: MyColors.FF1296DB,
//      onChanged: (value) {
//        setState(() {
//          _list[index].hasChecked = value;
//        });
//      },
//      title: Text(_list[index].itemInfo != null
//          ? _list[index].itemInfo.name
//          : _list[index].assayTypeDto.name),
//    );
  }

  /// 下拉刷新方法,为list重新赋值
  Future<Null> _onRefresh() async {
    _isLoading = true;
    _loadAssayItemList();
  }

  /// 加载化验详情列表
  _loadAssayItemList() {
    NetUtil.instance.get(Api.instance.loadAssayItemList, (body) {
      AssayFormat assayFormat = BaseResp<AssayFormat>(
          body, (jsonRes) => AssayFormat.fromJson(jsonRes)).resultObj;
      _bindData(assayFormat);
    });
  }

  _bindData(AssayFormat assayFormat) {
    List<AssayItemFormat> mList = List();

    for (var item in assayFormat.itemList) {
      AssayItemFormat itemFormat = AssayItemFormat();
      itemFormat.itemInfo = item;
      mList.add(itemFormat);
    }
    for (var type in assayFormat.typeList) {
      AssayItemFormat itemFormat = AssayItemFormat();
      itemFormat.assayTypeDto = type;
      mList.add(itemFormat);
    }

    for (var assayItemFormat in mList) {
      for (var mChecked in widget.mCheckedList) {
        if (assayItemFormat.itemInfo != null &&
            mChecked.itemInfo != null &&
            assayItemFormat.itemInfo?.id == mChecked.itemInfo?.id) {
          assayItemFormat.hasChecked = true;
          break;
        } else if (assayItemFormat.assayTypeDto != null &&
            mChecked.assayTypeDto != null &&
            assayItemFormat.assayTypeDto?.assayType ==
                mChecked.assayTypeDto?.assayType) {
          assayItemFormat.hasChecked = true;
          break;
        }
      }
    }

    setState(() {
      _isLoading = false;
      _list.clear();
      _list.addAll(mList);
    });
  }

  /// 根据image路径获取图片
  Image getCheckImage(path) => Image.asset(path,
      width: ScreenUtil().setWidth(24), height: ScreenUtil().setHeight(24));
}
