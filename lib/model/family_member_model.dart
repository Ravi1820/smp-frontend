class ResidentModel {


  Values? values;
  String? message;
  String? status;

  ResidentModel({this.values, this.message, this.status});

  ResidentModel.fromJson(Map<String, dynamic> json) {
    values =
    json['values'] != null ? new Values.fromJson(json['values']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.values != null) {
      data['values'] = this.values!.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Values {
  int? residentId;
  String? blockName;
  int? floorNumber;
  String? flatId;
  String? name;
  List<FamilyDetails>? familyDetails;
  // Null? vehicelResponses;

  Values({this.residentId,
    this.blockName,
    this.floorNumber,
    this.flatId,
    this.name,
    this.familyDetails,});

  Values.fromJson(Map<String, dynamic> json) {
    residentId = json['residentId'];
    blockName = json['blockName'];
    floorNumber = json['floorNumber'];
    flatId = json['flatId'];
    name = json['name'];
    if (json['familyDetails'] != null) {
      familyDetails = <FamilyDetails>[];
      json['familyDetails'].forEach((v) {
        familyDetails!.add(new FamilyDetails.fromJson(v));
      });
    }
    // vehicelResponses = json['vehicelResponses'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['residentId'] = this.residentId;
    data['blockName'] = this.blockName;
    data['floorNumber'] = this.floorNumber;
    data['flatId'] = this.flatId;
    data['name'] = this.name;
    if (this.familyDetails != null) {
      data['familyDetails'] =
          this.familyDetails!.map((v) => v.toJson()).toList();
    }
    // data['vehicelResponses'] = this.vehicelResponses;
    return data;
  }
}

class FamilyDetails {
  String? emailId;
  String? mobile;
  String? relation;
  int? memberId;
  String? fullName;
  String? age;
  String? profilePicture;
  String? gender;
  String? memberType;
  String? pushNotificationToken;
  int? actualOwnerId;
  int? familyTableId;

  FamilyDetails({this.emailId,
    this.mobile,
    this.relation,
    this.memberId,
    this.fullName,
    this.age,
    this.profilePicture,
    this.gender,
    this.memberType,
    this.pushNotificationToken,
    this.actualOwnerId,
    this.familyTableId});

  FamilyDetails.fromJson(Map<String, dynamic> json) {
    emailId = json['emailId'] ?? "";
    mobile = json['mobile'] ?? "";
    relation = json['relation'] ?? "";
    memberId = json['memberId'];
    fullName = json['fullName'] ?? "";
    age = json['age'] ?? "";
    profilePicture = json['profilePicture'] ?? "";
    gender = json['gender'] ?? "";
    memberType = json['memberType'] ?? "";
    pushNotificationToken = json['pushNotificationToken'] ?? "";
    actualOwnerId = json['actualOwnerId'] ?? 0;
    familyTableId = json['familyTableId'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emailId'] = this.emailId;
    data['mobile'] = this.mobile;
    data['relation'] = this.relation;
    data['memberId'] = this.memberId;
    data['fullName'] = this.fullName;
    data['age'] = this.age;
    data['profilePicture'] = this.profilePicture;
    data['gender'] = this.gender;
    data['memberType'] = this.memberType;
    data['pushNotificationToken'] = this.pushNotificationToken;
    data['actualOwnerId'] = this.actualOwnerId;
    data['familyTableId'] = this.familyTableId;
    return data;
  }

}


//   String? status;
//   Values? values;
//   String? message;
//
//   ResidentModel({this.status, this.values, this.message});
//
//   ResidentModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     values =
//     json['values'] != null ? new Values.fromJson(json['values']) : null;
//     message = json['message'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.values != null) {
//       data['values'] = this.values!.toJson();
//     }
//     data['message'] = this.message;
//     return data;
//   }
// }
//
// class Values {
//   int? residentId;
//   String? blockName;
//   int? floorNumber;
//   String? flatId;
//   String? name;
//   List<FamilyDetails>? familyDetails;
//   String? vehicelResponses;
//
//   Values(
//       {this.residentId,
//         this.blockName,
//         this.floorNumber,
//         this.flatId,
//         this.name,
//         this.familyDetails,
//         this.vehicelResponses});
//
//   Values.fromJson(Map<String, dynamic> json) {
//     residentId = json['residentId'];
//     blockName = json['blockName'];
//     floorNumber = json['floorNumber'];
//     flatId = json['flatId'];
//     name = json['name'];
//     if (json['familyDetails'] != null) {
//       familyDetails = <FamilyDetails>[];
//       json['familyDetails'].forEach((v) {
//         familyDetails!.add(new FamilyDetails.fromJson(v));
//       });
//     }
//     vehicelResponses = json['vehicelResponses'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['residentId'] = this.residentId;
//     data['blockName'] = this.blockName;
//     data['floorNumber'] = this.floorNumber;
//     data['flatId'] = this.flatId;
//     data['name'] = this.name;
//     if (this.familyDetails != null) {
//       data['familyDetails'] =
//           this.familyDetails!.map((v) => v.toJson()).toList();
//     }
//     data['vehicelResponses'] = this.vehicelResponses;
//     return data;
//   }
// }
// // "emailId": null,
// // "mobile": null,
//
// class FamilyDetails {
//   String? relation;
//   String? emailId;
//   String? mobile;
//   int? memberId;
//   String? fullName;
//   String? age;
//   String? profilePicture;
//   String? gender;
//   String? memberType;
//   String? pushNotificationToken;
//   int? actualOwnerId;
//   int? familyTableId;
//
//   FamilyDetails(
//       {this.relation,
//         this.memberId,
//         this.emailId,
//         this.mobile,
//         this.fullName,
//         this.age,
//         this.profilePicture,
//         this.gender,
//         this.memberType,
//         this.pushNotificationToken,
//         this.actualOwnerId,
//         this.familyTableId});
//
//   FamilyDetails.fromJson(Map<String, dynamic> json) {
//     relation = json['relation']??"";
//     memberId = json['memberId']??0;
//     fullName = json['fullName']??"";
//     mobile = json['mobile']??"";
//     emailId = json['emailId']??"";
//     age = json['age']??"";
//     profilePicture = json['profilePicture']??"";
//     gender = json['gender']??"";
//     memberType = json['memberType']??"";
//     pushNotificationToken = json['pushNotificationToken']??"";
//     actualOwnerId = json['actualOwnerId']??0;
//     familyTableId = json['familyTableId']??0;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['relation'] = this.relation;
//     data['memberId'] = this.memberId;
//     data['emailId'] = this.emailId;
//
//     data['mobile'] = this.mobile;
//
//     data['fullName'] = this.fullName;
//     data['age'] = this.age;
//     data['profilePicture'] = this.profilePicture;
//     data['gender'] = this.gender;
//     data['memberType'] = this.memberType;
//     data['pushNotificationToken'] = this.pushNotificationToken;
//     data['actualOwnerId'] = this.actualOwnerId;
//     data['familyTableId'] = this.familyTableId;
//     return data;
//   }
// }
