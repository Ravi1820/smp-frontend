// class UserInfo {
//   final int userId;
//   final String name;
//   final String email;
//   final String phone;
//   final String? picture; // Make picture nullable
//   final String? status; // Make status nullable
//   final String address;

//   UserInfo({
//     required this.userId,
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.picture,
//     this.status,
//     required this.address,
//     // required this.roleMasters, // Initialize the new field
//   });

//   factory UserInfo.fromJson(Map<String, dynamic> json) {
//     return UserInfo(
//       userId: json['userId'],
//       name: json['name'],
//       email: json['email'],
//       phone: json['phone'],
//       picture: json['picture'],
//       status: json['status'] ?? 'unknown',
//       address: json['address'],
//     );
//   }
// }

// class FlatInfo {
//   final int flatNumber;
//   final String blockName;
//   final String floorName;
//   final int? floorNumber;

//   FlatInfo({
//     required this.flatNumber,
//     required this.blockName,
//     required this.floorName,
//     required this.floorNumber,
//   });

//   factory FlatInfo.fromJson(Map<String, dynamic> json) {
//     return FlatInfo(
//       flatNumber: json['flatNumber'] ?? 0,
//       blockName: json['blockName'] ?? 'Unknown',
//       floorName: json['floorName'] ?? 'Unknown',
//       floorNumber: json['floorNumber'] ?? 0,
//     );
//   }
// }

// class ApiResponse {
//   final UserInfo userInfo;
//   final FlatInfo? flatInfo;
//   // images
//   List<dynamic> images; // Add this property

//   ApiResponse({
//     required this.userInfo,
//     required this.flatInfo,
//     required this.images,
//   });

//   factory ApiResponse.fromJson(Map<String, dynamic> json) {
//     return ApiResponse(
//       userInfo: UserInfo.fromJson(json['userInfo']),
//       flatInfo:
//           json['flatInfo'] != null ? FlatInfo.fromJson(json['flatInfo']) : null,
//       images: [], // Initialize the images list
//     );
//   }
// }

class ApiResponse {
  UserInfo? userInfo;
  FlatInfo? flatInfo;

  ApiResponse({this.userInfo, this.flatInfo});

  ApiResponse.fromJson(Map<String, dynamic> json) {
    userInfo = json['userInfo'] != null
        ? new UserInfo.fromJson(json['userInfo'])
        : null;
    flatInfo = json['flatInfo'] != null
        ? new FlatInfo.fromJson(json['flatInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userInfo != null) {
      data['userInfo'] = this.userInfo!.toJson();
    }
    if (this.flatInfo != null) {
      data['flatInfo'] = this.flatInfo!.toJson();
    }
    return data;
  }
}

class UserInfo {
  int? userId;
  String? name;
  String? email;
  String? phone;
  String? status;
  String? address;
  String? picture;
  String? pushnotificationToken;

  UserInfo(
      {this.userId,
      this.name,
      this.email,
      this.phone,
      this.status,
      this.address,
      this.picture,
      this.pushnotificationToken});

  UserInfo.fromJson(Map<String, dynamic> json) {
    userId = json['userId'] ?? 0;
    name = json['name'] ?? "";
    email = json['email'] ?? "";
    phone = json['phone'] ?? "";
    status = json['status'] ?? "";
    address = json['address'] ?? "";
    picture = json['picture'] ?? "";
    pushnotificationToken = json['pushnotificationToken'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['status'] = this.status;
    data['address'] = this.address;
    data['picture'] = this.picture;
    data['pushnotificationToken'] = this.pushnotificationToken;
    return data;
  }
}

class FlatInfo {
  String? flatNumber;
  String? blockName;
  int? floorNumber;

  FlatInfo({this.flatNumber, this.blockName, this.floorNumber});

  FlatInfo.fromJson(Map<String, dynamic> json) {
    flatNumber = json['flatNumber'] ?? "";
    blockName = json['blockName'] ?? "";
    floorNumber = json['floorNumber'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flatNumber'] = this.flatNumber;
    data['blockName'] = this.blockName;
    data['floorNumber'] = this.floorNumber;
    return data;
  }
}
