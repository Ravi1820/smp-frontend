class ApiResponceModel {
  String? status;
  String? message;
  Value? value;

  ApiResponceModel({this.status, this.message, this.value});

  ApiResponceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? "";
    message = json['message'] ?? "";
    value = json['value'] != null ? new Value.fromJson(json['value']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.value != null) {
      data['value'] = this.value!.toJson();
    }
    return data;
  }
}

class Value {
  int? id;
  String? emailId;
  String? userName;
  String? mobile;
  String? password;
  String? fullName;
  String? age;
  String? blockNumber;
  String? flatNumber;
  String? address;
  String? profilePicture;
  String? gender;
  String? pinCode;
  String? status;
  int? apartmentId;
  String? lastLogin;
  String? shiftStartTime;
  String? shiftEndTime;
  String? state;
  Apartment? apartment;
  String? pushNotificationToken;

  Value(
      {this.id,
      this.emailId,
      this.userName,
      this.mobile,
      this.password,
      this.fullName,
      this.age,
      this.blockNumber,
      this.flatNumber,
      this.address,
      this.profilePicture,
      this.gender,
      this.pinCode,
      this.status,
      this.apartmentId,
      this.lastLogin,
      this.shiftStartTime,
      this.shiftEndTime,
      this.state,
      this.apartment,
      this.pushNotificationToken});

  Value.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    emailId = json['emailId'] ?? "";
    userName = json['userName'] ?? "";
    mobile = json['mobile'] ?? "";
    password = json['password'] ?? "";
    fullName = json['fullName'] ?? "";
    age = json['age'] ?? "";
    blockNumber = json['blockNumber'] ?? "";
    flatNumber = json['flatNumber'] ?? "";
    address = json['address'] ?? "";
    profilePicture = json['profilePicture'] ?? "";
    gender = json['gender'] ?? "";
    pinCode = json['pinCode'] ?? "";
    status = json['status'] ?? "";
    apartmentId = json['apartmentId'];
    lastLogin = json['lastLogin'] ?? "";
    shiftStartTime = json['shiftStartTime'] ?? "";
    shiftEndTime = json['shiftEndTime'] ?? "";
    state = json['state'] ?? "";
    apartment = json['apartment'] != null
        ? new Apartment.fromJson(json['apartment'])
        : null;
    pushNotificationToken = json['pushNotificationToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['emailId'] = this.emailId;
    data['userName'] = this.userName;
    data['mobile'] = this.mobile;
    data['password'] = this.password;
    data['fullName'] = this.fullName;
    data['age'] = this.age;
    data['blockNumber'] = this.blockNumber;
    data['flatNumber'] = this.flatNumber;
    data['address'] = this.address;
    data['profilePicture'] = this.profilePicture;
    data['gender'] = this.gender;
    data['pinCode'] = this.pinCode;
    data['status'] = this.status;
    data['apartmentId'] = this.apartmentId;
    data['lastLogin'] = this.lastLogin;
    data['shiftStartTime'] = this.shiftStartTime;
    data['shiftEndTime'] = this.shiftEndTime;
    data['state'] = this.state;
    if (this.apartment != null) {
      data['apartment'] = this.apartment!.toJson();
    }
    data['pushNotificationToken'] = this.pushNotificationToken;
    return data;
  }
}

class Apartment {
  int? id;
  String? name;
  String? emailId;
  String? mobile;
  String? landline;
  String? address1;
  String? address2;
  String? profilePicture;
  String? state;
  int? pinCode;
  String? country;
  String? status;

  Apartment(
      {this.id,
      this.name,
      this.emailId,
      this.mobile,
      this.landline,
      this.address1,
      this.address2,
      this.profilePicture,
      this.state,
      this.pinCode,
      this.country,
      this.status});

  Apartment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? '';
    emailId = json['emailId'] ?? '';
    mobile = json['mobile'] ?? '';
    landline = json['landline'] ?? '';
    address1 = json['address1'] ?? '';
    address2 = json['address2'] ?? '';
    profilePicture = json['profilePicture'] ?? '';
    state = json['state'] ?? '';
    pinCode = json['pinCode'] ?? 0;
    country = json['country'] ?? '';
    status = json['status'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['emailId'] = this.emailId;
    data['mobile'] = this.mobile;
    data['landline'] = this.landline;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['profilePicture'] = this.profilePicture;
    data['state'] = this.state;
    data['pinCode'] = this.pinCode;
    data['country'] = this.country;
    data['status'] = this.status;
    return data;
  }
}
