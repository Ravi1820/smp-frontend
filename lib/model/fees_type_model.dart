class FeesTypeModel {
  int? id;
  String? feesType;

  FeesTypeModel({this.id, this.feesType});

  FeesTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    feesType = json['feesType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['feesType'] = this.feesType;
    return data;
  }
}
