class ApartmentModel {
  int? apartmentId;
  String? name;
  int? blockCount;

  ApartmentModel({this.apartmentId, this.name, this.blockCount});

  ApartmentModel.fromJson(Map<String, dynamic> json) {
    apartmentId = json['apartmentId'] ?? 0;
    name = json['name'] ?? "";
    blockCount = json['blockCount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['apartmentId'] = this.apartmentId;
    data['name'] = this.name;
    data['blockCount'] = this.blockCount;
    return data;
  }
}
