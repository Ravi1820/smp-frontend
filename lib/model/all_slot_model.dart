class AllSlotModel {
  int? id;
  String? lotNumber;

  AllSlotModel({this.id, this.lotNumber});

  AllSlotModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lotNumber = json['lotNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lotNumber'] = this.lotNumber;
    return data;
  }
}