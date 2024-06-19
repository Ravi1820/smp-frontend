class StaffRoleModel {
  final int id;
  final String roleName;
  bool selected = false;

  StaffRoleModel({
    required this.id,
    required this.roleName,
  });

  factory StaffRoleModel.fromJson(Map<String, dynamic> json) {
    return StaffRoleModel(
      id: json['id'],
      roleName: json['roleName'],
    );
  }
}
