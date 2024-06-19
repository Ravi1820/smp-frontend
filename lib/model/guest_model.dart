// class GusetModel {
//   final String guestName;
//   final int id;
//   final int blockId;
//   final int floorId;
//   final int flatId;
//   final int ownerIdToMeet;
//   final String guestGender;
//   final String purposeToMeet;
//   final String guestMobile;
//   final String guestIdentityType;
//   final String fromAddress;
//   final String inTime;
//   final String outTime;
//   final String guestAddress;
//   final String remark;
//   final String guestIdentityNumber;

//   GusetModel({
//     required this.guestName,
//     required this.id,
//     required this.floorId,
//     required this.flatId,
//     required this.ownerIdToMeet,
//     required this.purposeToMeet,
//     required this.guestMobile,
//     required this.guestIdentityType,
//     required this.fromAddress,
//     required this.inTime,
//     required this.outTime,
//     required this.guestAddress,
//     required this.remark,
//     required this.guestGender,
//     required this.blockId,
//     required this.guestIdentityNumber,
//   });

//   factory GusetModel.fromJson(Map<String, dynamic> json) {
//     return GusetModel(
//       guestName: json["guestName"] ?? "Unknown",
//       id: json["id"] ?? -1,
//       blockId: json["blockId"] ?? -1,
//       floorId: json["floorId"] ?? -1,
//       flatId: json["flatId"] ?? -1,
//       ownerIdToMeet: json["ownerIdToMeet"] ?? -1,
//       guestGender: json["guestGender"] ?? "Unknown",
//       guestIdentityNumber: json["guestIdentityNumber"] ?? "Unknown",
//       purposeToMeet: json["purposeToMeet"] ?? "Unknown",
//       guestMobile: json["guestMobile"] ?? "Unknown",
//       guestIdentityType: json["guestIdentityType"] ?? "Unknown",
//       fromAddress: json["fromAddress"] ?? "Unknown",
//       inTime: json["inTime"] ?? "Unknown",
//       outTime: json["outTime"] ?? "Unknown",
//       guestAddress: json["guestAddress"] ?? "Unknown",
//       remark: json["remark"] ?? "Unknown",
//     );
//   }
// }

class GusetModel {
  List<Values>? values;
  String? status;
  String? message;

  GusetModel({this.values, this.status, this.message});

  GusetModel.fromJson(Map<String, dynamic> json) {
    if (json['values'] != null) {
      values = <Values>[];
      json['values'].forEach((v) {
        values!.add(new Values.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.values != null) {
      data['values'] = this.values!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class Values {
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
  String? securityUser;
  ResidentUser? residentUser;

  Values(
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

  Values.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    residentId = json['residentId'];
    visitorName = json['visitorName']?? "";
    gender = json['gender']?? "";
    fromAddress = json['fromAddress']?? "";
    guestMobile = json['guestMobile']?? "";
    proofType = json['proofType']?? "";
    proofDetails = json['proofDetails']?? "";
    purpose = json['purpose']?? "";
    image = json['image']?? "";
    checkedIn = json['checkedIn']?? "";
    checkedOut = json['checkedOut']?? "";
    visitorType = json['visitorType']?? "";
    securityId = json['securityId'];
    apartmentId = json['apartmentId'];
    status = json['status']?? "";
    securityUser = json['securityUser']?? "";
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
    data['securityUser'] = this.securityUser;
    if (this.residentUser != null) {
      data['residentUser'] = this.residentUser!.toJson();
    }
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
    apartmentId = json['apartmentId'] ?? 0;
    shiftStartTime = json['shiftStartTime'] ?? "";
    shiftEndTime = json['shiftEndTime'] ?? "";
    state = json['state'] ?? "";
    pushNotificationToken = json['pushNotificationToken'] ?? "";
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
