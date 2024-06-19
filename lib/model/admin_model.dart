class AdminModel {
  final String fullName;
  final int id;

  AdminModel({
    required this.fullName,
    required this.id,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    final fullName =
        json.containsKey("fullName") ? json["fullName"] as String : "Unknown";
    final id = json.containsKey("id") ? json["id"] as int : -1;
    return AdminModel(
      fullName: fullName,
      id: id,
    );
  }
}
