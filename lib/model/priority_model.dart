class ManagementRole {
  final int id;
  final String roleName;

  ManagementRole({
    required this.id,
    required this.roleName,
  });

  factory ManagementRole.fromJson(Map<String, dynamic> json) {
    return ManagementRole(
      id: json['id'],
      roleName: json['roleName'],
    );
  }
}
