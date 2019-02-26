/// 用户通讯录
class Contact {
  /// 用户名
  String name;

  /// 手机号
  String phoneNum;

  /// 备注
  String remarks;

  Contact({this.name, this.phoneNum});

  Contact.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNum = json['phoneNum'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phoneNum'] = this.phoneNum;
    data['remarks'] = this.remarks;
    return data;
  }
}
