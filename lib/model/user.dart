/// 用户
class User {
  /// 姓名
  String name;

  /// ID
  String id;

  /// 手机
  String mobile;

  /// 登录名
  String loginName;

  /// 邮箱
  String email;

  /// 归属部门名
  String officeName;

  /// 归属部门Id
  String officeId;

  /// 手机
  String phone;

  /// 归属单位名
  String companyName;

  /// 用户类型（1：巡检人员，2：养护人员）
  String positionId;

  /// 职位名
  String positionName;

  /// 备注
  String remarks;

  User(
      {this.name,
      this.id,
      this.mobile,
      this.loginName,
      this.email,
      this.officeName,
      this.officeId,
      this.phone,
      this.companyName,
      this.positionId,
      this.positionName,
      this.remarks});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    mobile = json['mobile'];
    loginName = json['loginName'];
    email = json['email'];
    officeName = json['officeName'];
    officeId = json['officeId'];
    phone = json['phone'];
    companyName = json['companyName'];
    positionId = json['positionId'];
    positionName = json['positionName'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['mobile'] = this.mobile;
    data['loginName'] = this.loginName;
    data['email'] = this.email;
    data['officeName'] = this.officeName;
    data['officeId'] = this.officeId;
    data['phone'] = this.phone;
    data['companyName'] = this.companyName;
    data['positionId'] = this.positionId;
    data['positionName'] = this.positionName;
    data['remarks'] = this.remarks;
    return data;
  }
}
