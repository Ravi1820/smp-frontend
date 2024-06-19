// class ChatMessageModel {
//   int? id;
//   String? message;
//   int? senderId;
//   int? receiverId;
//   String? createdTime;
//   int? apartmentId;
//   Sender? sender;
//   List<Receivers>? receivers;

//   ChatMessageModel(
//       {this.id,
//       this.message,
//       this.senderId,
//       this.receiverId,
//       this.createdTime,
//       this.apartmentId,
//       this.sender,
//       this.receivers});

//   ChatMessageModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     message = json['message'];
//     senderId = json['senderId'];
//     receiverId = json['receiverId'];
//     createdTime = json['createdTime'];
//     apartmentId = json['apartmentId'];
//     sender =
//         json['sender'] != null ? new Sender.fromJson(json['sender']) : null;
//     if (json['receivers'] != null) {
//       receivers = <Receivers>[];
//       json['receivers'].forEach((v) {
//         receivers!.add(new Receivers.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['message'] = this.message;
//     data['senderId'] = this.senderId;
//     data['receiverId'] = this.receiverId;
//     data['createdTime'] = this.createdTime;
//     data['apartmentId'] = this.apartmentId;
//     if (this.sender != null) {
//       data['sender'] = this.sender!.toJson();
//     }
//     if (this.receivers != null) {
//       data['receivers'] = this.receivers!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Sender {
//   int? id;
//   String? emailId;
//   String? userName;
//   String? mobile;
//   String? password;
//   String? fullName;
//   String? age;
//   String? address;
//   String? profilePicture;
//   String? gender;
//   String? pinCode;
//   String? status;
//   int? apartmentId;
//   String? shiftStartTime;
//   String? shiftEndTime;
//   String? state;
//   String? pushNotificationToken;

//   Sender(
//       {this.id,
//       this.emailId,
//       this.userName,
//       this.mobile,
//       this.password,
//       this.fullName,
//       this.age,
//       this.address,
//       this.profilePicture,
//       this.gender,
//       this.pinCode,
//       this.status,
//       this.apartmentId,
//       this.shiftStartTime,
//       this.shiftEndTime,
//       this.state,
//       this.pushNotificationToken});

//   Sender.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     emailId = json['emailId']??"";
//     userName = json['userName']??"";
//     mobile = json['mobile']??"";
//     password = json['password']??"";
//     fullName = json['fullName']??"";
//     age = json['age']??"";
//     address = json['address']??"";
//     profilePicture = json['profilePicture']??"";
//     gender = json['gender']??"";
//     pinCode = json['pinCode']??"";
//     status = json['status']??"";
//     apartmentId = json['apartmentId'];
//     shiftStartTime = json['shiftStartTime']??"";
//     shiftEndTime = json['shiftEndTime'] ?? "";
//     state = json['state'] ?? "";
//     pushNotificationToken = json['pushNotificationToken'] ?? "";
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['emailId'] = this.emailId;
//     data['userName'] = this.userName;
//     data['mobile'] = this.mobile;
//     data['password'] = this.password;
//     data['fullName'] = this.fullName;
//     data['age'] = this.age;
//     data['address'] = this.address;
//     data['profilePicture'] = this.profilePicture;
//     data['gender'] = this.gender;
//     data['pinCode'] = this.pinCode;
//     data['status'] = this.status;
//     data['apartmentId'] = this.apartmentId;
//     data['shiftStartTime'] = this.shiftStartTime;
//     data['shiftEndTime'] = this.shiftEndTime;
//     data['state'] = this.state;
//     data['pushNotificationToken'] = this.pushNotificationToken;
//     return data;
//   }
// }

// class Receivers {
//   int? id;
//   String? emailId;
//   String? userName;
//   String? mobile;
//   String? password;
//   String? fullName;
//   String? age;
//   String? address;
//   String? profilePicture;
//   String? gender;
//   String? pinCode;
//   String? status;
//   int? apartmentId;
//   String? shiftStartTime;
//   String? shiftEndTime;
//   String? state;
//   String? pushNotificationToken;

//   Receivers(
//       {this.id,
//       this.emailId,
//       this.userName,
//       this.mobile,
//       this.password,
//       this.fullName,
//       this.age,
//       this.address,
//       this.profilePicture,
//       this.gender,
//       this.pinCode,
//       this.status,
//       this.apartmentId,
//       this.shiftStartTime,
//       this.shiftEndTime,
//       this.state,
//       this.pushNotificationToken});

//   Receivers.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     emailId = json['emailId'] ?? '';
//     userName = json['userName'] ?? '';
//     mobile = json['mobile'] ?? '';
//     password = json['password'] ?? '';
//     fullName = json['fullName'] ?? '';
//     age = json['age'] ?? '';
//     address = json['address'] ?? '';
//     profilePicture = json['profilePicture'] ?? '';
//     gender = json['gender'] ?? '';
//     pinCode = json['pinCode'] ?? '';
//     status = json['status'] ?? '';
//     apartmentId = json['apartmentId'];
//     shiftStartTime = json['shiftStartTime'] ?? '';
//     shiftEndTime = json['shiftEndTime'] ?? '';
//     state = json['state'] ?? '';
//     pushNotificationToken = json['pushNotificationToken'] ?? '';
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['emailId'] = this.emailId;
//     data['userName'] = this.userName;
//     data['mobile'] = this.mobile;
//     data['password'] = this.password;
//     data['fullName'] = this.fullName;
//     data['age'] = this.age;
//     data['address'] = this.address;
//     data['profilePicture'] = this.profilePicture;
//     data['gender'] = this.gender;
//     data['pinCode'] = this.pinCode;
//     data['status'] = this.status;
//     data['apartmentId'] = this.apartmentId;
//     data['shiftStartTime'] = this.shiftStartTime;
//     data['shiftEndTime'] = this.shiftEndTime;
//     data['state'] = this.state;
//     data['pushNotificationToken'] = this.pushNotificationToken;
//     return data;
//   }
// }

class ChatMessageModel {
  int? id;
  String? message;
  int? senderId;
  int? receiverId;
  String? createdTime;
  int? apartmentId;

  ChatMessageModel(
      {this.id,
      this.message,
      this.senderId,
      this.receiverId,
      this.createdTime,
      this.apartmentId});

  ChatMessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'] ?? "";
    senderId = json['senderId'] ?? "";
    receiverId = json['receiverId'] ?? "";
    createdTime = json['createdTime'] ?? "";
    apartmentId = json['apartmentId'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['senderId'] = this.senderId;
    data['receiverId'] = this.receiverId;
    data['createdTime'] = this.createdTime;
    data['apartmentId'] = this.apartmentId;
    return data;
  }
}
