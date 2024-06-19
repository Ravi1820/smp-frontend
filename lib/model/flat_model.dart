class FlatModel {
  int? id;
  String? flatNumber;
  int? floorId;
  int? blockId;
  int? floorNumber;
  int? totalNumberOfResidents;
  Owner? owner;
  Tenant? tenant;
  List<FamilyMemberDetails>? familyMemberDetails;

  FlatModel(
      {this.id,
      this.flatNumber,
      this.floorId,
      this.blockId,
      this.floorNumber,
      this.totalNumberOfResidents,
      this.owner,
      this.tenant,
      this.familyMemberDetails});

  FlatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    flatNumber = json['flatNumber'] ?? "";
    floorId = json['floorId'];
    blockId = json['blockId'];
    floorNumber = json['floorNumber'];

    totalNumberOfResidents = json['totalNumberOfResidents'];
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
    tenant =
        json['tenant'] != null ? new Tenant.fromJson(json['tenant']) : null;
    if (json['familyMemberDetails'] != null) {
      familyMemberDetails = <FamilyMemberDetails>[];
      json['familyMemberDetails'].forEach((v) {
        familyMemberDetails!.add(new FamilyMemberDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['flatNumber'] = this.flatNumber;
    data['floorId'] = this.floorId;
    data['floorNumber'] = this.floorNumber;

    data['blockId'] = this.blockId;
    data['totalNumberOfResidents'] = this.totalNumberOfResidents;
    if (this.owner != null) {
      data['owner'] = this.owner!.toJson();
    }
    if (this.tenant != null) {
      data['tenant'] = this.tenant!.toJson();
    }
    if (this.familyMemberDetails != null) {
      data['familyMemberDetails'] =
          this.familyMemberDetails!.map((v) => v.toJson()).toList();
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

class FamilyMemberDetails {
  String? relation;
  int? memberId;
  String? fullName;
  String? age;
  String? profilePicture;
  String? gender;
  String? pushNotificationToken;

  FamilyMemberDetails(
      {this.relation,
      this.memberId,
      this.fullName,
      this.age,
      this.profilePicture,
      this.gender,
      this.pushNotificationToken});

  FamilyMemberDetails.fromJson(Map<String, dynamic> json) {
    relation = json['relation'] ?? "";
    memberId = json['memberId'];
    fullName = json['fullName'] ?? "";
    age = json['age'] ?? "";
    profilePicture = json['profilePicture'] ?? "";
    gender = json['gender'] ?? "";
    pushNotificationToken = json['pushNotificationToken'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['relation'] = this.relation;
    data['memberId'] = this.memberId;
    data['fullName'] = this.fullName;
    data['age'] = this.age;
    data['profilePicture'] = this.profilePicture;
    data['gender'] = this.gender;
    data['pushNotificationToken'] = this.pushNotificationToken;
    return data;
  }
}
