import 'package:flutter/material.dart';
import 'package:flutter_gzxjyh/http/api.dart';
import 'package:flutter_gzxjyh/http/net_util.dart';
import 'package:flutter_gzxjyh/model/base_resp.dart';
import 'package:flutter_gzxjyh/model/contact.dart';
import 'package:flutter_gzxjyh/ui/widget/empty_view.dart';
import 'package:flutter_gzxjyh/utils/toast_util.dart';
import 'package:flutter_gzxjyh/utils/screen_util.dart';
import 'package:url_launcher/url_launcher.dart';

/// 巡检人员主界面-通讯录
class ContactPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ContactState();
}

class ContactState extends State<ContactPage> {
  /// 通讯录列表
  List<Contact> _list;

  /// 是否正在加载
  var _loading = true;

  @override
  void initState() {
    // TODO: 初始化
    super.initState();
    _getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('通讯录'),
          backgroundColor: const Color(0xff2eafff),
          centerTitle: true,
        ),
        body: _loading
            ? Center(child: CircularProgressIndicator())
            : Stack(
                children: <Widget>[
                  Offstage(
                    child: Center(child: EmptyView()),
                    offstage: _list != null,
                  ),
                  RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      itemBuilder: _renderRow,
                      itemCount: _list.length * 2,
                    ),
                  )
                ],
              ));
  }

  /// 渲染ListItem
  Widget _renderRow(BuildContext context, int index) {
    if (index.isOdd) {
      // 奇数行为分割线
      return Padding(
        child: Divider(height: 1.0, color: const Color(0xffd9d9d9)),
        padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(20), 0.0, ScreenUtil().setWidth(20), 0.0),
      );
    }
    index = index ~/ 2; // 取整
    Contact contact = _list[index];
    var itemRow = Container(
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(20),
          ScreenUtil().setWidth(10),
          ScreenUtil().setWidth(20),
          ScreenUtil().setWidth(10)),
      width: ScreenUtil.screenWidth,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${contact.name}  ${contact.phoneNum}',
                    style: TextStyle(
                        color: const Color(0xff101010),
                        fontSize: ScreenUtil().setSp(16))),
                Offstage(
                    child: Text(contact.remarks ?? '',
                        style: TextStyle(
                            color: const Color(0xff999999),
                            fontSize: ScreenUtil().setSp(14))),
                    offstage:
                        contact.remarks == null || contact.remarks.isEmpty)
              ],
            ),
          ),
          Icon(Icons.call),
        ],
      ),
    );
    return InkWell(
      child: itemRow,
      onTap: () {
        //TODO Item点击事件
        var phoneNum = contact.phoneNum;
        if (phoneNum == null || phoneNum.isEmpty) {
          ToastUtil.showShortInCenter('该人员无电话信息');
        } else {
          _callPhone(contact.phoneNum);
        }
      },
    );
  }

  /// 网络获取通讯录数据
  _getContacts() {
    NetUtil.instance.get(Api.instance.contactList, (body) {
      _loading = false;
      var list =
          BaseRespList<Contact>(body, (res) => Contact.fromJson(res)).resultObj;
      setState(() {
        _list = list;
      });
    });
  }

  Future<Null> _onRefresh() async {
    //TODO 下拉刷新
    _getContacts();
    return null;
  }

  _callPhone(String num) async {
    var url = 'tel:$num';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ToastUtil.showShortInCenter('无法拨打电话');
    }
  }
}
