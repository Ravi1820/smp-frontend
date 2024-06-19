class AllApprovedVisitorModel {
  List<Values>? values;
  String? message;
  String? status;

  AllApprovedVisitorModel({this.values, this.message, this.status});

  AllApprovedVisitorModel.fromJson(Map<String, dynamic> json) {
    if (json['values'] != null) {
      values = <Values>[];
      json['values'].forEach((v) {
        values!.add(new Values.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.values != null) {
      data['values'] = this.values!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Values {
  int? visitorId;
  String? name;
  String? purpose;
  String? status;
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
  String? securityName;
  String? residentName;
  String? flatNumber;
  String? floorNumber;
  String? blockName;
  String? visitorType;

  Values(
      {this.visitorId,
      this.name,
      this.purpose,
      this.status,
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
        this.securityName,
      this.residentName,
      this.flatNumber,
      this.floorNumber,
      this.blockName,
      this.visitorType});

  Values.fromJson(Map<String, dynamic> json) {
    visitorId = json['visitorId'];
    name = json['name'] ?? "";
    purpose = json['purpose'] ?? "";
    status = json['status'] ?? "";
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
    securityName = json ['securityName'] ?? "";
    securityToken = json['securityToken'] ?? "";
    residentName = json['residentName'] ?? "";
    flatNumber = json['flatNumber'] ?? "";
    floorNumber = json['floorNumber'] ?? "";
    blockName = json['blockName'] ?? "";
    visitorType = json['visitorType'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visitorId'] = this.visitorId;
    data['name'] = this.name;
    data['purpose'] = this.purpose;
    data['status'] = this.status;
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
    data['securityName'] = this.securityName;
    data['residentName'] = this.residentName;
    data['flatNumber'] = this.flatNumber;
    data['floorNumber'] = this.floorNumber;
    data['blockName'] = this.blockName;
    data['visitorType'] = this.visitorType;
    return data;
  }
}
