// class MyPastApprovalsModel {
//   List<Values>? values;
//   String? status;
//   String? message;
//
//   MyPastApprovalsModel({this.values, this.status, this.message});
//
//   MyPastApprovalsModel.fromJson(Map<String, dynamic> json) {
//     if (json['values'] != null) {
//       values = <Values>[];
//       json['values'].forEach((v) {
//         values!.add(new Values.fromJson(v));
//       });
//     }
//     status = json['status'];
//     message = json['message'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.values != null) {
//       data['values'] = this.values!.map((v) => v.toJson()).toList();
//     }
//     data['status'] = this.status;
//     data['message'] = this.message;
//     return data;
//   }
// }
//
// class Values {
//   String? image;
//   String? mobile;
//   String? emailId;
//   int? requestId;
//   String? blockName;
//   String? flatName;
//   String? ownerName;
//   String? status;
//   String? appliedRoleFor;
//
//   Values(
//       {this.image,
//         this.mobile,
//         this.emailId,
//         this.requestId,
//         this.blockName,
//         this.flatName,
//         this.ownerName,
//         this.status,
//         this.appliedRoleFor});
//
//   Values.fromJson(Map<String, dynamic> json) {
//     image = json['image'];
//     mobile = json['mobile'];
//     emailId = json['emailId'];
//     requestId = json['requestId'];
//     blockName = json['blockName'];
//     flatName = json['flatName'];
//     ownerName = json['ownerName'];
//     status = json['status'];
//     appliedRoleFor = json['appliedRoleFor'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['image'] = this.image;
//     data['mobile'] = this.mobile;
//     data['emailId'] = this.emailId;
//     data['requestId'] = this.requestId;
//     data['blockName'] = this.blockName;
//     data['flatName'] = this.flatName;
//     data['ownerName'] = this.ownerName;
//     data['status'] = this.status;
//     data['appliedRoleFor'] = this.appliedRoleFor;
//     return data;
//   }
// }
class MyPastApprovalsModel {
  List<Values>? values;
  String? status;
  String? message;

  MyPastApprovalsModel({this.values, this.status, this.message});

  MyPastApprovalsModel.fromJson(Map<String, dynamic> json) {
    if (json['values'] != null) {
      values = <Values>[];
      json['values'].forEach((v) {
        values!.add(new Values.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.values != null) {
      data['values'] = this.values!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class Values {
  String? image;
  String? mobile;
  String? emailId;
  int? requestId;
  String? blockName;
  String? flatName;
  String? ownerName;
  String? status;
  String? appliedRoleFor;
  String? profilePicture;
  String? document;

  Values(
      {this.image,
      this.mobile,
      this.emailId,
      this.requestId,
      this.blockName,
      this.flatName,
      this.ownerName,
      this.status,
      this.appliedRoleFor,
      this.profilePicture,
      this.document});

  Values.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? "";
    mobile = json['mobile'] ?? "";
    emailId = json['emailId'] ?? "";
    requestId = json['requestId'] ?? 0;
    blockName = json['blockName'] ?? "";
    flatName = json['flatName'] ?? "";
    ownerName = json['ownerName'] ?? "";
    status = json['status'] ?? "";
    appliedRoleFor = json['appliedRoleFor'] ?? "";
    profilePicture = json['profilePicture'] ?? "";
    document = json['document'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['mobile'] = this.mobile;
    data['emailId'] = this.emailId;
    data['requestId'] = this.requestId;
    data['blockName'] = this.blockName;
    data['flatName'] = this.flatName;
    data['ownerName'] = this.ownerName;
    data['status'] = this.status;
    data['appliedRoleFor'] = this.appliedRoleFor;
    data['profilePicture'] = this.profilePicture;
    data['document'] = this.document;
    return data;
  }
}
