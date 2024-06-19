class SecurityModel {
  int? id;
  int? roleId;
  int? userId;
  List<Roles>? roles;
  User? user;

  SecurityModel({this.id, this.roleId, this.userId, this.roles, this.user});

  SecurityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleId = json['roleId'];
    userId = json['userId'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(Roles.fromJson(v));
      });
    }
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['roleId'] = roleId;
    data['userId'] = userId;
    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class Roles {
  int? id;
  String? roleName;
  bool? isActive;

  Roles({this.id, this.roleName, this.isActive});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleName = json['roleName'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['roleName'] = roleName;
    data['isActive'] = isActive;
    return data;
  }
}

class User {
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
  bool? onDuty;

  User(
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
      this.pushNotificationToken,
      this.onDuty});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    emailId = json['emailId'] ?? '';
    userName = json['userName'] ?? '';
    mobile = json['mobile'] ?? '';
    password = json['password'] ?? '';
    fullName = json['fullName'] ?? '';
    age = json['age'] ?? '';
    blockNumber = json['blockNumber'] ?? '';
    flatNumber = json['flatNumber'] ?? '';
    address = json['address'] ?? '';
    profilePicture = json['profilePicture'] ?? '';
    gender = json['gender'] ?? '';
    pinCode = json['pinCode'] ?? '';
    status = json['status'] ?? '';
    apartmentId = json['apartmentId'] ?? 0;
    lastLogin = json['lastLogin'] ?? '';
    shiftStartTime = json['shiftStartTime'] ?? '';
    shiftEndTime = json['shiftEndTime'] ?? '';
    state = json['state'] ?? '';
    apartment = json['apartment'] != null
        ? new Apartment.fromJson(json['apartment'])
        : null;
    pushNotificationToken = json['pushNotificationToken'] ?? '';
    onDuty = json['onDuty'] ?? false;
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
    data['onDuty'] = this.onDuty;
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
    name = json['name'];
    emailId = json['emailId'];
    mobile = json['mobile'];
    landline = json['landline'];
    address1 = json['address1'];
    address2 = json['address2'];
    profilePicture = json['profilePicture'];
    state = json['state'];
    pinCode = json['pinCode'];
    country = json['country'];
    status = json['status'];
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
