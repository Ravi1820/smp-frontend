class AllTypeVisitorModel {
  List<Value>? value;
  String? message;
  String? status;

  AllTypeVisitorModel({this.value, this.message, this.status});

  AllTypeVisitorModel.fromJson(Map<String, dynamic> json) {
    if (json['value'] != null) {
      value = <Value>[];
      json['value'].forEach((v) {
        value!.add(new Value.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.value != null) {
      data['value'] = this.value!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Value {
  int? visitorId;
  int? numberOfGuest;
  String? name;
  String? visitorType;
  String? purpose;
  String? status;
  String? mobile;
  String? chekinTime;
  String? checkOutTime;
  String? image;
  int? residentId;
  int? securityId;
  String? securityDeviceToken;
  String? securityName;
  String? residentName;
  String? residentBlock;
  String? residentFloor;
  String? residentFlat;
  String? residentDeviceToken;
  String? passcode;

  Value(
      {this.visitorId,
        this.numberOfGuest,
      this.name,
      this.visitorType,
      this.purpose,
      this.status,
      this.mobile,
      this.chekinTime,
      this.checkOutTime,
      this.image,
      this.residentId,
      this.securityId,
      this.securityDeviceToken,
      this.securityName,
      this.residentName,
      this.residentBlock,
      this.residentFloor,
      this.residentFlat,
      this.residentDeviceToken,
      this.passcode});

  Value.fromJson(Map<String, dynamic> json) {
    visitorId = json['visitorId'];
    numberOfGuest = json['numberOfGuest'] ?? 0;
    name = json['name'] ?? "";
    visitorType = json['visitorType'] ?? "";
    purpose = json['purpose'] ?? "";
    status = json['status'] ?? "";
    mobile = json['mobile'] ?? "";
    chekinTime = json['chekinTime'] ?? "";
    checkOutTime = json['checkOutTime'] ?? "";
    image = json['image'] ?? "";
    residentId = json['residentId'] ?? 0;
    securityId = json['securityId'] ?? 0;
    securityDeviceToken = json['securityDeviceToken'] ?? "";
    securityName = json['securityName'] ?? "";

    residentName = json['residentName'] ?? "";
    residentBlock = json['residentBlock'] ?? "";
    residentFloor = json['residentFloor'] ?? "";
    residentFlat = json['residentFlat'] ?? "";
    residentDeviceToken = json['residentDeviceToken'] ?? "";
    passcode = json['passcode'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visitorId'] = this.visitorId;
    data['numberOfGuest']=this.numberOfGuest;
    data['visitorType'] = this.visitorType;
    data['name'] = this.name;
    data['purpose'] = this.purpose;
    data['status'] = this.status;
    data['mobile'] = this.mobile;
    data['chekinTime'] = this.chekinTime;
    data['checkOutTime'] = this.checkOutTime;
    data['image'] = this.image;
    data['residentId'] = this.residentId;
    data['securityId'] = this.securityId;
    data['securityDeviceToken'] = this.securityDeviceToken;
    data['securityName'] = this.securityName;
    data['residentName'] = this.residentName;
    data['residentBlock'] = this.residentBlock;
    data['residentFloor'] = this.residentFloor;
    data['residentFlat'] = this.residentFlat;
    data['residentDeviceToken'] = this.residentDeviceToken;
    data['passcode'] = this.passcode;

    return data;
  }
}
