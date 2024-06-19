
class ResidentVisitorsModel {
  int? id;
  int? residentId;
  String? visitorName;
  String? gender;
  String? fromAddress;
  String? guestMobile;
  String? proofType;
  String? proofDetails;
  String? purpose;
  String? image;
  String? checkedIn;
  String? checkedOut;
  String? visitorType;
  int? securityId;
  int? apartmentId;
  String? status;
  SecurityUser? securityUser;
  ResidentUser? residentUser;

  ResidentVisitorsModel(
      {this.id,
        this.residentId,
        this.visitorName,
        this.gender,
        this.fromAddress,
        this.guestMobile,
        this.proofType,
        this.proofDetails,
        this.purpose,
        this.image,
        this.checkedIn,
        this.checkedOut,
        this.visitorType,
        this.securityId,
        this.apartmentId,
        this.status,
        this.securityUser,
        this.residentUser});

  ResidentVisitorsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    residentId = json['residentId'];
    visitorName = json['visitorName']??"";
    gender = json['gender']??"";
    fromAddress = json['fromAddress']??"";
    guestMobile = json['guestMobile']??"";
    proofType = json['proofType']??"";
    proofDetails = json['proofDetails']??"";
    purpose = json['purpose']??"";
    image = json['image']??"";
    checkedIn = json['checkedIn']??"";
    checkedOut = json['checkedOut']??"";
    visitorType = json['visitorType']??"";
    securityId = json['securityId']??0;
    apartmentId = json['apartmentId']??0;
    status = json['status']??"";
    securityUser = json['securityUser'] != null
        ? new SecurityUser.fromJson(json['securityUser'])
        : null;
    residentUser = json['residentUser'] != null
        ? new ResidentUser.fromJson(json['residentUser'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['residentId'] = this.residentId;
    data['visitorName'] = this.visitorName;
    data['gender'] = this.gender;
    data['fromAddress'] = this.fromAddress;
    data['guestMobile'] = this.guestMobile;
    data['proofType'] = this.proofType;
    data['proofDetails'] = this.proofDetails;
    data['purpose'] = this.purpose;
    data['image'] = this.image;
    data['checkedIn'] = this.checkedIn;
    data['checkedOut'] = this.checkedOut;
    data['visitorType'] = this.visitorType;
    data['securityId'] = this.securityId;
    data['apartmentId'] = this.apartmentId;
    data['status'] = this.status;
    if (this.securityUser != null) {
      data['securityUser'] = this.securityUser!.toJson();
    }
    if (this.residentUser != null) {
      data['residentUser'] = this.residentUser!.toJson();
    }
    return data;
  }
}

class SecurityUser {
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
  String? shiftStartTime;
  String? shiftEndTime;
  String? state;
  String? pushNotificationToken;

  SecurityUser(
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
        this.shiftStartTime,
        this.shiftEndTime,
        this.state,
        this.pushNotificationToken});

  SecurityUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    emailId = json['emailId']??"";
    userName = json['userName']??"";
    mobile = json['mobile']??"";
    password = json['password']??"";
    fullName = json['fullName']??"";
    age = json['age']??"";
    blockNumber = json['blockNumber']??"";
    flatNumber = json['flatNumber']??"";
    address = json['address']??"";
    profilePicture = json['profilePicture']??"";
    gender = json['gender']??"";
    pinCode = json['pinCode']??"";
    status = json['status']??"";
    apartmentId = json['apartmentId']??0;
    shiftStartTime = json['shiftStartTime']??"";
    shiftEndTime = json['shiftEndTime']??"";
    state = json['state']??"";
    pushNotificationToken = json['pushNotificationToken']??"";
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
    data['shiftStartTime'] = this.shiftStartTime;
    data['shiftEndTime'] = this.shiftEndTime;
    data['state'] = this.state;
    data['pushNotificationToken'] = this.pushNotificationToken;
    return data;
  }
}

class ResidentUser {
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
  String? shiftStartTime;
  String? shiftEndTime;
  String? state;
  String? pushNotificationToken;

  ResidentUser(
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
        this.shiftStartTime,
        this.shiftEndTime,
        this.state,
        this.pushNotificationToken});

  ResidentUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    emailId = json['emailId'];
    userName = json['userName'];
    mobile = json['mobile'];
    password = json['password'];
    fullName = json['fullName'];
    age = json['age'];
    blockNumber = json['blockNumber'];
    flatNumber = json['flatNumber'];
    address = json['address'];
    profilePicture = json['profilePicture'];
    gender = json['gender'];
    pinCode = json['pinCode'];
    status = json['status'];
    apartmentId = json['apartmentId'];
    shiftStartTime = json['shiftStartTime'];
    shiftEndTime = json['shiftEndTime'];
    state = json['state'];
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
    data['shiftStartTime'] = this.shiftStartTime;
    data['shiftEndTime'] = this.shiftEndTime;
    data['state'] = this.state;
    data['pushNotificationToken'] = this.pushNotificationToken;
    return data;
  }
}
