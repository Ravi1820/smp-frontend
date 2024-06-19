class DeviceTokenModel {
  final int userId;
  final String? pushNotificationToken;

  DeviceTokenModel({
    required this.userId,
    required this.pushNotificationToken,
  });

  factory DeviceTokenModel.fromJson(Map<String, dynamic> json) {
    return DeviceTokenModel(
      userId: json['userId'],
      pushNotificationToken: json['pushNotificationToken'],
    );
  }
}
