class Apartment {
  int id;
  String name;
  String emailId;
  String mobile;
  String landline;
  String address_1;
  String address_2;
  String state;
  int pinCode;
  String country;
  String status;

  Apartment({
    required this.id,
    required this.name,
    required this.emailId,
    required this.mobile,
    required this.landline,
    required this.address_1,
    required this.address_2,
    required this.state,
    required this.pinCode,
    required this.country,
    required this.status,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
    return Apartment(
      id: json['id'] ?? "Unknown",
      name: json['name'] ?? "Unknown",
      emailId: json['emailId'] ?? "Unknown",
      mobile: json['mobile'] ?? "Unknown",
      landline: json['landline'] ?? "Unknown",
      address_1: json['address_1'] ?? "Unknown",
      address_2: json['address_2'] ?? "Unknown",
      state: json['state'] ?? "Unknown",
      pinCode: json['pinCode'] ?? "Unknown",
      country: json['country'] ?? "Unknown",
      status: json['status'] ?? "Unknown",
    );
  }
}

class Block {
  int id;
  int blockNumber;
  String blockName;
  int apartmentId;
  String status;
  Apartment apartment;

  Block({
    required this.id,
    required this.blockNumber,
    required this.blockName,
    required this.apartmentId,
    required this.status,
    required this.apartment,
  });

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      id: json['id'] ?? "Unknown",
      blockNumber: json['blockNumber'] ?? "Unknown",
      blockName: json['blockName'] ?? "Unknown",
      apartmentId: json['apartmentId'] ?? "Unknown",
      status: json['status'] ?? "Unknown",
      apartment: Apartment.fromJson(json['apartment']),
    );
  }
}

class Floor {
  int id;
  int floorNumber;
  String floorName;
  int blockId;
  String status;
  Block blocks;

  Floor({
    required this.id,
    required this.floorNumber,
    required this.floorName,
    required this.blockId,
    required this.status,
    required this.blocks,
  });

  factory Floor.fromJson(Map<String, dynamic> json) {
    return Floor(
      id: json['id'] ?? "Unknown",
      floorNumber: json['floorNumber'] ?? "Unknown",
      floorName: json['floorName'] ?? "Unknown",
      blockId: json['blockId'] ?? "Unknown",
      status: json['status'] ?? "Unknown",
      blocks: Block.fromJson(json['blocks']),
    );
  }
}

class User {
  int id;
  String emailId;
  String userName;
  // String mobile;
  // String password;
  // String fullName;
  // String age;
  // String blockNumber;
  // String flatNumber;
  // String address;
  // String gender;
  // String pinCode;
  // String status;
  // int apartmentId;
  // DateTime? lastLogin;
  // DateTime? shiftStartTime;
  // DateTime? shiftEndTime;
  // String state;
  Apartment apartment;

  User({
    required this.id,
    required this.emailId,
    required this.userName,
    // required this.mobile,
    // required this.password,
    // required this.fullName,
    // required this.age,
    // required this.blockNumber,
    // required this.flatNumber,
    // required this.address,
    // required this.gender,
    // required this.pinCode,
    // required this.status,
    // required this.apartmentId,
    // required this.lastLogin,
    // required this.shiftStartTime,
    // required this.shiftEndTime,
    // required this.state,
    required this.apartment,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? "Unknown",
      emailId: json['emailId'] ?? "Unknown",
      userName: json['userName'] ?? "Unknown",
      // mobile: json['mobile'] ?? "Unknown",
      // password: json['password'] ?? "Unknown",
      // fullName: json['fullName'] ?? "Unknown",
      // age: json['age'] ?? "Unknown",
      // blockNumber: json['blockNumber'] ?? "Unknown",
      // flatNumber: json['flatNumber'] ?? "Unknown",
      // address: json['address'] ?? "Unknown",
      // gender: json['gender'] ?? "Unknown",
      // pinCode: json['pinCode'] ?? "Unknown",
      // status: json['status'] ?? "Unknown",
      // apartmentId: json['apartmentId'] ?? "Unknown",
      // lastLogin:
      //     json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
      // shiftStartTime: json['shiftStartTime'] != null
      //     ? DateTime.parse(json['shiftStartTime'])
      //     : null,
      // shiftEndTime: json['shiftEndTime'] != null
      //     ? DateTime.parse(json['shiftEndTime'])
      //     : null,
      // state: json['state'] ?? "Unknown",
      apartment: Apartment.fromJson(json['apartment']),
    );
  }
}

class Role {
  int id;
  String roleName;
  bool isActive;

  Role({
    required this.id,
    required this.roleName,
    required this.isActive,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] ?? "Unknown",
      roleName: json['roleName'] ?? "Unknown",
      isActive: json['isActive'] ?? "Unknown",
    );
  }
}

class MovieViewModel {
  int id;
  int flatNumber;
  String flatName;
  int floorId;
  int userId;
  String status;
  Floor floor;
  User user;

  MovieViewModel({
    required this.id,
    required this.flatNumber,
    required this.flatName,
    required this.floorId,
    required this.userId,
    required this.status,
    required this.floor,
    required this.user,
  });

  factory MovieViewModel.fromJson(Map<String, dynamic> json) {
    return MovieViewModel(
      id: json['id'] ?? "Unknown",
      flatNumber: json['flatNumber'] ?? "Unknown",
      flatName: json['flatName'] ?? "Unknown",
      floorId: json['floorId'] ?? "Unknown",
      userId: json['userId'] ?? "Unknown",
      status: json['status'] ?? "Unknown",
      floor: Floor.fromJson(json['floor']),
      user: User.fromJson(json['user']),
    );
  }

  static List<MovieViewModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MovieViewModel.fromJson(json)).toList();
  }
}
