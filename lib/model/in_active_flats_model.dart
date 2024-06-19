

class InActiveFlatModel {
  int? id;
  String? flatNumber;
  int? floorId;
  int? blockId;
  int? totalNumberOfResidents;
  String? vacant;
  Owner? owner;
  Tenant? tenant;

  InActiveFlatModel({
    this.id,
    this.flatNumber,
    this.floorId,
    this.blockId,
    this.totalNumberOfResidents,
    this.vacant,
    this.owner,
    this.tenant,
  });

  InActiveFlatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    flatNumber = json['flatNumber'];
    floorId = json['floorId'];
    blockId = json['blockId'];
    vacant = json['vacant']?? "";
    totalNumberOfResidents = json['totalNumberOfResidents'];
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
    tenant =
        json['tenant'] != null ? new Tenant.fromJson(json['tenant']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['flatNumber'] = this.flatNumber;
    data['vacant']=this.vacant;
    data['floorId'] = this.floorId;
    data['blockId'] = this.blockId;
    data['totalNumberOfResidents'] = this.totalNumberOfResidents;
    if (this.owner != null) {
      data['owner'] = this.owner!.toJson();
    }
    if (this.tenant != null) {
      data['tenant'] = this.tenant!.toJson();
    }

    return data;
  }
}

class Owner {
  int? id;
  String? emailId;
  String? userName;
  String? mobile;
  String? password;
  String? fullName;
  String? age;
  String? address;
  String? profilePicture;
  String? gender;
  String? pinCode;
  String? status;
  int? apartmentId;
  String? shiftStartTime;
  String? shiftEndTime;
  String? state;
  String? pushNotificationToken;
  String? approveStatus;

  Owner(
      {this.id,
      this.emailId,
      this.userName,
      this.mobile,
      this.password,
      this.fullName,
      this.age,
      this.address,
      this.profilePicture,
      this.gender,
      this.pinCode,
      this.status,
      this.apartmentId,
      this.shiftStartTime,
      this.shiftEndTime,
      this.state,
      this.pushNotificationToken,
      this.approveStatus});

  Owner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    emailId = json['emailId'] ?? "";
    userName = json['userName'] ?? "";
    mobile = json['mobile'] ?? "";
    password = json['password'] ?? "";
    fullName = json['fullName'] ?? "";
    age = json['age'] ?? "";
    address = json['address'] ?? "";
    profilePicture = json['profilePicture'] ?? "";
    gender = json['gender'] ?? "";
    pinCode = json['pinCode'] ?? "";
    status = json['status'] ?? "";
    apartmentId = json['apartmentId'];
    shiftStartTime = json['shiftStartTime'] ?? "";
    shiftEndTime = json['shiftEndTime'] ?? "";
    state = json['state'] ?? "";
    pushNotificationToken = json['pushNotificationToken'] ?? "";
    approveStatus = json['approveStatus'] ?? "";
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
    data['address'] = this.address;
    data['profilePicture'] = this.profilePicture;
    data['gender'] = this.gender;
    data['pinCode'] = this.pinCode;
    data['status'] = this.status;
    data['apartmentId'] = this.apartmentId;
    data['shiftStartTime'] = this.shiftStartTime;
    data['shiftEndTime'] = this.shiftEndTime;
    data['state'] = this.state;
    data['pushNotificationToken'] = this.pushNotificationToken;
    data['approveStatus'] = this.approveStatus;
    return data;
  }
}

class Tenant {
  int? id;
  String? emailId;
  String? userName;
  String? mobile;
  String? password;
  String? fullName;
  String? age;
  String? address;
  String? profilePicture;
  String? gender;
  String? pinCode;
  String? status;
  int? apartmentId;
  String? shiftStartTime;
  String? shiftEndTime;
  String? state;
  String? pushNotificationToken;
  String? approveStatus;

  Tenant(
      {this.id,
      this.emailId,
      this.userName,
      this.mobile,
      this.password,
      this.fullName,
      this.age,
      this.address,
      this.profilePicture,
      this.gender,
      this.pinCode,
      this.status,
      this.apartmentId,
      this.shiftStartTime,
      this.shiftEndTime,
      this.state,
      this.pushNotificationToken,
      this.approveStatus});

  Tenant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    emailId = json['emailId'] ?? "";
    userName = json['userName'] ?? "";
    mobile = json['mobile'] ?? "";
    password = json['password'] ?? "";
    fullName = json['fullName'] ?? "";
    age = json['age'] ?? "";
    address = json['address'] ?? "";
    profilePicture = json['profilePicture'] ?? "";
    gender = json['gender'] ?? "";
    pinCode = json['pinCode'] ?? "";
    status = json['status'] ?? "";
    apartmentId = json['apartmentId'];
    shiftStartTime = json['shiftStartTime'] ?? "";
    shiftEndTime = json['shiftEndTime'] ?? "";
    state = json['state'] ?? "";
    pushNotificationToken = json['pushNotificationToken'] ?? "";
    approveStatus = json['approveStatus'] ?? "";
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
    data['address'] = this.address;
    data['profilePicture'] = this.profilePicture;
    data['gender'] = this.gender;
    data['pinCode'] = this.pinCode;
    data['status'] = this.status;
    data['apartmentId'] = this.apartmentId;
    data['shiftStartTime'] = this.shiftStartTime;
    data['shiftEndTime'] = this.shiftEndTime;
    data['state'] = this.state;
    data['pushNotificationToken'] = this.pushNotificationToken;
    data['approveStatus'] = this.approveStatus;
    return data;
  }
}
