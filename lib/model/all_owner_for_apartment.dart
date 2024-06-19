// class  {
  class AllOwnerForApartment {
  String? message;
  String? status;
  List<Value>? value;

  AllOwnerForApartment({this.message, this.status, this.value});

  AllOwnerForApartment.fromJson(Map<String, dynamic> json) {
  message = json['message'];
  status = json['status'];
  if (json['value'] != null) {
  value = <Value>[];
  json['value'].forEach((v) {
  value!.add(new Value.fromJson(v));
  });
  }
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['message'] = this.message;
  data['status'] = this.status;
  if (this.value != null) {
  data['value'] = this.value!.map((v) => v.toJson()).toList();
  }
  return data;
  }
  }

  class Value {
  int? id;
  String? mobileNumber;
  String? profilePicture;
  String? flatNumber;
  String? blockName;
  String? floorName;
  String? role;
  String? pushNotificationDeviceId;
  String? fullName;
  String? status;

  Value(
  {this.id,
  this.mobileNumber,
  this.profilePicture,
  this.flatNumber,
  this.blockName,
  this.floorName,
  this.role,
  this.pushNotificationDeviceId,
  this.fullName,
  this.status});

  Value.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  mobileNumber = json['mobileNumber']??"";
  profilePicture = json['profilePicture']??"";
  flatNumber = json['flatNumber']??"";
  blockName = json['blockName']??"";
  floorName = json['floorName']??"";
  role = json['role']??"";
  pushNotificationDeviceId = json['pushNotificationDeviceId']??"";
  fullName = json['fullName']??"";
  status = json['status']??"";
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = this.id;
  data['mobileNumber'] = this.mobileNumber;
  data['profilePicture'] = this.profilePicture;
  data['flatNumber'] = this.flatNumber;
  data['blockName'] = this.blockName;
  data['floorName'] = this.floorName;
  data['role'] = this.role;
  data['pushNotificationDeviceId'] = this.pushNotificationDeviceId;
  data['fullName'] = this.fullName;
  data['status'] = this.status;
  return data;
  }
  }