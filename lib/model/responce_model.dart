class ResponceModel {
  String? message;
  String? status;
  String? date;
  int? userId;
  int? value;

  ResponceModel({this.message, this.status,this.date, this.userId});

  ResponceModel.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? '';
    status = json['status'] ?? '';
    date = json['date'] ?? '';
    userId = json['userId'] ?? 0;
    value = json['value'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['date'] = this.date;
    data['userId'] = this.userId;
    data['value'] = this.value;

    return data;
  }
}
