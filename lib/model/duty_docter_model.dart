class DutyDocterModel {
  int? id;
  // String? email;
  String? fullName;
  // String? lastName;
  // String? avatar;

  DutyDocterModel({
    this.id,
    //  this.email,
    this.fullName,
    //  this.lastName,
    //   this.avatar,
  });

  DutyDocterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // email = json['email'];
    fullName = json['fullName'];
    // lastName = json['last_name'];
    // avatar = json['avatar'];
  }
}
