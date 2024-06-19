class CheckoutVisitorListModel {
  String? status;
  String? message;
  List<Value>? value;

  CheckoutVisitorListModel({this.status, this.message, this.value});

  CheckoutVisitorListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['value'] != null) {
      value = <Value>[];
      json['value'].forEach((v) {
        value!.add(new Value.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.value != null) {
      data['value'] = this.value!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Value {
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

  Value(
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

  Value.fromJson(Map<String, dynamic> json) {
    visitorId = json['visitorId'];
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
    userId = json['userId'];
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
