class UserModel {
  int? id;
  String? fullName;
  String? emailId;

  UserModel({this.id, this.fullName, this.emailId});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    emailId = json['emailId'];
  }
}
