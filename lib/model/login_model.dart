class LoginModel {
  String? status;
  Value? value;
  String? message;
  String? date;
  int? userId;
  String? rejectReason;
  int? newUserId;

  LoginModel(
      {this.status,
      this.date,
      this.rejectReason,
      this.newUserId,
      this.value,
      this.message,
      this.userId});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    date = json['date'] ?? '';
    newUserId = json['user_id'] ?? 0;
    rejectReason = json['reject_reason'] ?? "";
    value = json['value'] != null ? new Value.fromJson(json['value']) : null;
    message = json['message'];
    userId = json['userId'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['date'] = this.date;
    if (this.value != null) {
      data['value'] = this.value!.toJson();
    }
    data['message'] = this.message;
    data['userId'] = this.userId;
    // data['userId'] = this.userId;
    return data;
  }
}

class Value {
  String? token;
  List<String>? roles;
  UserInfo? userInfo;
  bool? addGuestAllowed;

  Value({this.token, this.roles, this.addGuestAllowed, this.userInfo});

  Value.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    addGuestAllowed = json['addGuestAllowed'] ?? false;

    roles = json['roles'].cast<String>();
    userInfo = json['userInfo'] != null
        ? new UserInfo.fromJson(json['userInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['addGuestAllowed'] = this.addGuestAllowed;

    data['roles'] = this.roles;
    if (this.userInfo != null) {
      data['userInfo'] = this.userInfo!.toJson();
    }
    return data;
  }
}

class UserInfo {
  int? id;
  String? userName;
  String? email;
  String? mobile;
  String? address;
  String? status;
  String? picture;
  int? apartmentId;
  String? apartmentName;
  String? gender;
  String? age;
  String? state;
  String? pinCode;
  String? blockName;
  String? flatNumber;
  String? flatId;
  int? blockCount;

  UserInfo(
      {this.id,
      this.userName,
      this.email,
      this.mobile,
      this.address,
      this.status,
      this.picture,
      this.apartmentId,
      this.apartmentName,
      this.gender,
      this.age,
      this.state,
      this.pinCode,
      this.blockName,
      this.flatNumber,
      this.flatId,
      this.blockCount});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'] ?? "";
    email = json['email'] ?? "";
    mobile = json['mobile'] ?? "";
    address = json['address'] ?? "";
    status = json['status'] ?? "";
    picture = json['picture'] ?? "";
    apartmentId = json['apartmentId'] ?? 0;
    apartmentName = json['apartmentName'] ?? "";
    gender = json['gender'] ?? "";
    age = json['age'] ?? "";
    state = json['state'] ?? "";
    pinCode = json['pinCode'] ?? "";
    blockName = json['blockName'] ?? "";
    flatNumber = json['flatNumber'] ?? "";
    flatId = json['flatId'] ?? "";

    blockCount = json['blockCount'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    data['status'] = this.status;
    data['picture'] = this.picture;
    data['apartmentId'] = this.apartmentId;
    data['apartmentName'] = this.apartmentName;
    data['gender'] = this.gender;
    data['age'] = this.age;
    data['state'] = this.state;
    data['pinCode'] = this.pinCode;
    data['blockName'] = this.blockName;
    data['flatName'] = this.flatNumber;
    data['flatId'] = this.flatId;

    data['blockCount'] = this.blockCount;

    return data;
  }
}
