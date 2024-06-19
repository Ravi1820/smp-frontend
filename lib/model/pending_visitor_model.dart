// class PendingVisitorsModel {
//   int? visitorId;
//   String? name;
//   String? purpose;
//   String? address;
//   int? waitingMunite;
//   String? image;
//   int? userId;
//   String? residentToken;
//   String? securityToken;

//   PendingVisitorsModel(
//       {this.visitorId,
//       this.name,
//       this.purpose,
//       this.address,
//       this.waitingMunite,
//       this.image,
//       this.userId,
//       this.residentToken,
//       this.securityToken});

//   PendingVisitorsModel.fromJson(Map<String, dynamic> json) {
//     visitorId = json['visitorId'];
//     name = json['name'];
//     purpose = json['purpose'];
//     address = json['address'];
//     waitingMunite = json['waitingMunite'];
//     image = json['image'];
//     userId = json['userId'];
//     residentToken = json['residentToken'];
//     securityToken = json['securityToken'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['visitorId'] = this.visitorId;
//     data['name'] = this.name;
//     data['purpose'] = this.purpose;
//     data['address'] = this.address;
//     data['waitingMunite'] = this.waitingMunite;
//     data['image'] = this.image;
//     data['userId'] = this.userId;
//     data['residentToken'] = this.residentToken;
//     data['securityToken'] = this.securityToken;
//     return data;
//   }
// }

// class PendingVisitorsModel {
//   int? visitorId;
//   String? name;
//   String? purpose;
//   String? address;
//   int? waitingMunite;
//   String? image;
//   int? userId;
//   String? residentToken;
//   String? securityToken;
//   String? residentName;
//
//   PendingVisitorsModel(
//       {this.visitorId,
//       this.name,
//       this.purpose,
//       this.address,
//       this.waitingMunite,
//       this.image,
//       this.userId,
//       this.residentToken,
//       this.securityToken,
//       this.residentName});
//
//   PendingVisitorsModel.fromJson(Map<String, dynamic> json) {
//     visitorId = json['visitorId'] ?? 0;
//     name = json['name'] ?? "";
//     purpose = json['purpose'] ?? "";
//     address = json['address'] ?? "";
//     waitingMunite = json['waitingMunite'] ?? 0;
//     image = json['image'] ?? "";
//     userId = json['userId'] ?? 0;
//     residentToken = json['residentToken'] ?? "";
//     securityToken = json['securityToken'] ?? "";
//     residentName = json['residentName'] ?? "";
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['visitorId'] = this.visitorId;
//     data['name'] = this.name;
//     data['purpose'] = this.purpose;
//     data['address'] = this.address;
//     data['waitingMunite'] = this.waitingMunite;
//     data['image'] = this.image;
//     data['userId'] = this.userId;
//     data['residentToken'] = this.residentToken;
//     data['securityToken'] = this.securityToken;
//     data['residentName'] = this.residentName;
//     return data;
//   }
// }

class PendingVisitorsModel {
  int? visitorId;
  String? name;
  String? purpose;
  String? address;
  String? mobileNumber;
  String? idProof;
  String? idProofNumber;
  String? gender;
  int? waitingMunite;
  String? image;
  int? userId;
  String? residentToken;
  String? securityToken;
  String? residentName;
  String? flatNumber;
  String? floorNumber;
  String? blockName;
  String? residentMobileNumber;

  PendingVisitorsModel({
    this.visitorId,
    this.name,
    this.purpose,
    this.address,
    this.mobileNumber,
    this.idProof,
    this.idProofNumber,
    this.gender,
    this.waitingMunite,
    this.image,
    this.userId,
    this.residentToken,
    this.securityToken,
    this.residentName,
    this.flatNumber,
    this.floorNumber,
    this.blockName,
    this.residentMobileNumber,
  });

  PendingVisitorsModel.fromJson(Map<String, dynamic> json) {
    visitorId = json['visitorId'];
    name = json['name'] ?? "";
    purpose = json['purpose'] ?? "";
    address = json['address'] ?? "";
    mobileNumber = json['mobileNumber'] ?? "";
    idProof = json['idProof'] ?? "";
    idProofNumber = json['idProofNumber'] ?? "";
    gender = json['gender'] ?? "";
    waitingMunite = json['waitingMunite'] ?? "";
    image = json['image'] ?? "";
    userId = json['userId'] ?? 0;
    residentToken = json['residentToken'] ?? "";
    securityToken = json['securityToken'] ?? "";
    residentName = json['residentName'] ?? "";
    flatNumber = json['flatNumber'] ?? "";
    floorNumber = json['floorNumber'] ?? "";
    blockName = json['blockName'] ?? "";

    residentMobileNumber = json['residentMobileNumber'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visitorId'] = this.visitorId;
    data['name'] = this.name;
    data['purpose'] = this.purpose;
    data['address'] = this.address;
    data['mobileNumber'] = this.mobileNumber;
    data['idProof'] = this.idProof;
    data['idProofNumber'] = this.idProofNumber;
    data['gender'] = this.gender;
    data['waitingMunite'] = this.waitingMunite;
    data['image'] = this.image;
    data['userId'] = this.userId;
    data['residentToken'] = this.residentToken;
    data['securityToken'] = this.securityToken;
    data['residentName'] = this.residentName;
    data['flatNumber'] = this.flatNumber;
    data['floorNumber'] = this.floorNumber;
    data['blockName'] = this.blockName;
    data['residentMobileNumber'] = this.residentMobileNumber;

    return data;
  }
}
