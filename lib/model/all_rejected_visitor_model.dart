class AllRejectedVisitorModel {
  String? status;
  String? message;
  List<Value>? value;

  AllRejectedVisitorModel({this.status, this.message, this.value});

  AllRejectedVisitorModel.fromJson(Map<String, dynamic> json) {
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
  String? visitorName;
  String? purpose;
  String? mobileNumber;
  String? image;
  String? residentName;
  String? flatNumber;
  String? floorName;
  String? blockName;

  Value(
      {this.visitorId,
      this.visitorName,
      this.purpose,
      this.mobileNumber,
      this.image,
      this.residentName,
      this.flatNumber,
      this.floorName,
      this.blockName});

  Value.fromJson(Map<String, dynamic> json) {
    visitorId = json['visitorId'];
    visitorName = json['visitorName'] ?? "";
    purpose = json['purpose'] ?? "";
    mobileNumber = json['mobileNumber'] ?? "";
    image = json['image'] ?? "";
    residentName = json['residentName'] ?? "";
    flatNumber = json['flatNumber'] ?? "";
    floorName = json['floorName'] ?? "";
    blockName = json['blockName'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visitorId'] = this.visitorId;
    data['visitorName'] = this.visitorName;
    data['purpose'] = this.purpose;
    data['mobileNumber'] = this.mobileNumber;
    data['image'] = this.image;
    data['residentName'] = this.residentName;
    data['flatNumber'] = this.flatNumber;
    data['floorName'] = this.floorName;
    data['blockName'] = this.blockName;
    return data;
  }
}
