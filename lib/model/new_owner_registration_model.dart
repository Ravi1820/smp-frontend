class NewOwnerRegistrationModel {
  int? userId;
  String? date;
  String? message;
  String? status;

  NewOwnerRegistrationModel({this.userId,this.status, this.date, this.message});

  NewOwnerRegistrationModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    date = json['date'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['date'] = this.date;
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}