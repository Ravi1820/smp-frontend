// class ApprovedVisitorListModel {
//   String? message;
//   String? status;
//   List<Values>? values;

//   ApprovedVisitorListModel({this.message, this.status, this.values});

//   ApprovedVisitorListModel.fromJson(Map<String, dynamic> json) {
//     message = json['message'];
//     status = json['status'];
//     if (json['values'] != null) {
//       values = <Values>[];
//       json['values'].forEach((v) {
//         values!.add(new Values.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['message'] = this.message;
//     data['status'] = this.status;
//     if (this.values != null) {
//       data['values'] = this.values!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Values {
//   int? visitorId;
//   String? name;
//   String? purpose;
//   String? address;
//   String? mobileNumber;
//   String? idProof;
//   String? idProofNumber;
//   String? gender;
//   String? checkInTime;
//   String? image;
//   int? userId;
//   String? residentToken;
//   String? securityToken;
//   String? residentName;
//   String? flatNumber;
//   String? floorNumber;
//   String? blockName;

//   Values(
//       {this.visitorId,
//         this.name,
//         this.purpose,
//         this.address,
//         this.mobileNumber,
//         this.idProof,
//         this.idProofNumber,
//         this.gender,
//         this.checkInTime,
//         this.image,
//         this.userId,
//         this.residentToken,
//         this.securityToken,
//         this.residentName,
//         this.flatNumber,
//         this.floorNumber,
//         this.blockName});

//   Values.fromJson(Map<String, dynamic> json) {
//     visitorId = json['visitorId'];
//     name = json['name'] ??"";
//     purpose = json['purpose'] ??"";
//     address = json['address'] ??"";
//     mobileNumber = json['mobileNumber'] ??"";
//     idProof = json['idProof'] ??"";
//     idProofNumber = json['idProofNumber'] ??"";
//     gender = json['gender'] ??"";
//     checkInTime = json['checkInTime'] ??"";
//     image = json['image'] ??"";
//     userId = json['userId'];
//     residentToken = json['residentToken'] ??"";
//     securityToken = json['securityToken'] ??"";
//     residentName = json['residentName'] ??"";
//     flatNumber = json['flatNumber'] ??"";
//     floorNumber = json['floorNumber'] ??"";
//     blockName = json['blockName'] ??"";
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['visitorId'] = this.visitorId;
//     data['name'] = this.name;
//     data['purpose'] = this.purpose;
//     data['address'] = this.address;
//     data['mobileNumber'] = this.mobileNumber;
//     data['idProof'] = this.idProof;
//     data['idProofNumber'] = this.idProofNumber;
//     data['gender'] = this.gender;
//     data['checkInTime'] = this.checkInTime;
//     data['image'] = this.image;
//     data['userId'] = this.userId;
//     data['residentToken'] = this.residentToken;
//     data['securityToken'] = this.securityToken;
//     data['residentName'] = this.residentName;
//     data['flatNumber'] = this.flatNumber;
//     data['floorNumber'] = this.floorNumber;
//     data['blockName'] = this.blockName;
//     return data;
//   }
// }

class ApprovedVisitorListModel {
  String? message;
  String? status;
  List<Values>? values;

  ApprovedVisitorListModel({this.message, this.status, this.values});

  ApprovedVisitorListModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['values'] != null) {
      values = <Values>[];
      json['values'].forEach((v) {
        values!.add(Values.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.values != null) {
      data['values'] = this.values!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Values {
  int? visitorId;
  String? name;
  String? purpose;
  String? address;
  String? mobileNumber;
  String? idProof;
  String? idProofNumber;
  String? gender;
  String? checkInTime;
  String? checkOutTime;
  String? image;
  int? userId;
  String? residentToken;
  String? securityToken;
  String? residentName;
  String? flatNumber;
  String? floorNumber;
  String? blockName;

  Values(
      {this.visitorId,
      this.name,
      this.purpose,
      this.address,
      this.mobileNumber,
      this.idProof,
      this.idProofNumber,
      this.gender,
      this.checkInTime,
      this.checkOutTime,
      this.image,
      this.userId,
      this.residentToken,
      this.securityToken,
      this.residentName,
      this.flatNumber,
      this.floorNumber,
      this.blockName});

  Values.fromJson(Map<String, dynamic> json) {
    visitorId = json['visitorId'] ?? 0;
    name = json['name'] ?? "";
    purpose = json['purpose'] ?? "";
    address = json['address'] ?? "";
    mobileNumber = json['mobileNumber'] ?? "";
    idProof = json['idProof'] ?? "";
    idProofNumber = json['idProofNumber'] ?? "";
    gender = json['gender'] ?? "";
    checkInTime = json['checkInTime'] ?? "";
    checkOutTime = json['checkOutTime'] ?? "";
    image = json['image'] ?? "";
    userId = json['userId'] ?? 0;
    residentToken = json['residentToken'] ?? "";
    securityToken = json['securityToken'] ?? "";
    residentName = json['residentName'] ?? "";
    flatNumber = json['flatNumber'] ?? "";
    floorNumber = json['floorNumber'] ?? "";
    blockName = json['blockName'] ?? "";
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
    data['checkInTime'] = this.checkInTime;
    data['checkOutTime'] = this.checkOutTime;
    data['image'] = this.image;
    data['userId'] = this.userId;
    data['residentToken'] = this.residentToken;
    data['securityToken'] = this.securityToken;
    data['residentName'] = this.residentName;
    data['flatNumber'] = this.flatNumber;
    data['floorNumber'] = this.floorNumber;
    data['blockName'] = this.blockName;
    return data;
  }
}
