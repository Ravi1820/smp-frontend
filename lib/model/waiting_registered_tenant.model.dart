//
//
// class WaitingRegisteredTenantModel {
//   List<Value>? value;
//   String? message;
//   String? status;
//
//   WaitingRegisteredTenantModel({this.value, this.message, this.status});
//
//   WaitingRegisteredTenantModel.fromJson(Map<String, dynamic> json) {
//     if (json['value'] != null) {
//       value = <Value>[];
//       json['value'].forEach((v) {
//         value!.add(new Value.fromJson(v));
//       });
//     }
//     message = json['message'];
//     status = json['status'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.value != null) {
//       data['value'] = this.value!.map((v) => v.toJson()).toList();
//     }
//     data['message'] = this.message;
//     data['status'] = this.status;
//     return data;
//   }
// }
//
// class Value {
//   int? requestId;
//   int? userId;
//   String? fullName;
//   int? blockId;
//   String? blockName;
//   int? flatId;
//   String? flatNumber;
//   String? role;
//   String? document;
//   String? email;
//   String? phone;
//   String? pushNotificationToken;
//
//   Value(
//       {this.requestId,
//         this.userId,
//         this.fullName,
//         this.blockId,
//         this.blockName,
//         this.flatId,
//         this.flatNumber,
//         this.role,
//         this.document,
//         this.email,
//         this.phone,
//         this.pushNotificationToken});
//
//   Value.fromJson(Map<String, dynamic> json) {
//     requestId = json['requestId']??0;
//     userId = json['userId']??0;
//     fullName = json['fullName']??"";
//     blockId = json['blockId']??0;
//     blockName = json['blockName']??"";
//     flatId = json['flatId']??0;
//     flatNumber = json['flatNumber']??"";
//     role = json['role']??"";
//     document = json['document']??"";
//     email = json['email']??"";
//     phone = json['phone']??"";
//     pushNotificationToken = json['pushNotificationToken']??"";
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['requestId'] = this.requestId;
//     data['userId'] = this.userId;
//     data['fullName'] = this.fullName;
//     data['blockId'] = this.blockId;
//     data['blockName'] = this.blockName;
//     data['flatId'] = this.flatId;
//     data['flatNumber'] = this.flatNumber;
//     data['role'] = this.role;
//     data['document'] = this.document;
//     data['email'] = this.email;
//     data['phone'] = this.phone;
//     data['pushNotificationToken'] = this.pushNotificationToken;
//     return data;
//   }
// }

class WaitingRegisteredTenantModel {
  String? message;
  String? status;
  List<Value>? value;

  WaitingRegisteredTenantModel({this.message, this.status, this.value});

  WaitingRegisteredTenantModel.fromJson(Map<String, dynamic> json) {
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
  int? requestId;
  int? userId;
  String? fullName;
  int? blockId;
  String? blockName;
  int? flatId;
  String? flatNumber;
  String? role;
  String? document;
  String? email;
  String? phone;
  String? pushNotificationToken;
  String? profilePicture;

  Value(
      {this.requestId,
      this.userId,
      this.fullName,
      this.blockId,
      this.blockName,
      this.flatId,
      this.flatNumber,
      this.role,
      this.document,
      this.email,
      this.phone,
      this.pushNotificationToken,
      this.profilePicture});

  Value.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'] ?? 0;
    userId = json['userId'] ?? 0;
    fullName = json['fullName'] ?? "";
    blockId = json['blockId'] ?? 0;
    blockName = json['blockName'] ?? "";
    flatId = json['flatId'] ?? 0;
    flatNumber = json['flatNumber'] ?? "";
    role = json['role'] ?? "";
    document = json['document'] ?? "";
    email = json['email'] ?? "";
    phone = json['phone'] ?? "";
    pushNotificationToken = json['pushNotificationToken'] ?? "";
    profilePicture = json['profilePicture'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestId'] = this.requestId;
    data['userId'] = this.userId;
    data['fullName'] = this.fullName;
    data['blockId'] = this.blockId;
    data['blockName'] = this.blockName;
    data['flatId'] = this.flatId;
    data['flatNumber'] = this.flatNumber;
    data['role'] = this.role;
    data['document'] = this.document;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['pushNotificationToken'] = this.pushNotificationToken;
    data['profilePicture'] = this.profilePicture;
    return data;
  }
}
