class ResidentVehicleListModel {
  String? status;
  String? message;
  List<Value>? value;

  ResidentVehicleListModel({this.status, this.message, this.value});

  ResidentVehicleListModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? vehicleType;
  String? vehicleNumber;
  int? userId;
  String? vehicleImage;
  String? status;

  Value(
      {this.id,
        this.vehicleType,
        this.vehicleNumber,
        this.userId,
        this.vehicleImage,
        this.status});

  Value.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleType = json['vehicleType']??"";
    vehicleNumber = json['vehicleNumber']??"";
    userId = json['userId'];
    vehicleImage = json['vehicleImage']??"";
    status = json['status']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vehicleType'] = this.vehicleType;
    data['vehicleNumber'] = this.vehicleNumber;
    data['userId'] = this.userId;
    data['vehicleImage'] = this.vehicleImage;
    data['status'] = this.status;
    return data;
  }
}