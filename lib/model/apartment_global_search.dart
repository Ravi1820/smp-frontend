class ApartmentUserInfo {
  int id;
  String userName;
  String mobile;
  String fullName;
  String blockNumber;
  String flatNumber;

  Apartment apartment;

  ApartmentUserInfo({
    required this.id,
    required this.userName,
    required this.mobile,
    required this.fullName,
    required this.blockNumber,
    required this.flatNumber,
    required this.apartment,
  });

  factory ApartmentUserInfo.fromJson(Map<String, dynamic> json) {
    return ApartmentUserInfo(
      id: json['id'] ?? 0,
      userName: json['userName'] ?? "Unknown",
      mobile: json['mobile'] ?? "Unknown",
      fullName: json['fullName'] ?? "Unknown",
      blockNumber: json['blockNumber'] ?? "Unknown",
      flatNumber: json['flatNumber'] ?? "Unknown",
      apartment: Apartment.fromJson(json['apartment']),
    );
  }
}

class Apartment {
  int id;
  String name;

  Apartment({
    required this.id,
    required this.name,
  });

  factory Apartment.fromJson(Map<String, dynamic> json) {
    return Apartment(
      id: json['id'] ?? 0,
      name: json['name'] ?? "Unknown",
    );
  }
}

class FlatInfo {
  int id;
  int flatNumber;
  String flatName;
  // int floorId;
  // int userId;
  // Floor floor;
  // ApartmentUserInfo user;

  FlatInfo({
    required this.id,
    required this.flatNumber,
    required this.flatName,
    // required this.floorId,
    // required this.userId,
    // required this.floor,
    // required this.user,
  });

  factory FlatInfo.fromJson(Map<String, dynamic> json) {
    return FlatInfo(
      id: json['id'] ?? 0,
      flatNumber: json['flatNumber'] ?? 0,
      flatName: json['flatName'] ?? "Unknown",
      // floorId: json['floorId'] ?? 0,
      // userId: json['userId'] ?? 0,
      // floor: Floor.fromJson(json['floor']),
      // user: ApartmentUserInfo.fromJson(json['user']),
    );
  }
}

class Floor {
  int id;
  int floorNumber;
  String floorName;
   Block blocks;

  Floor({
    required this.id,
    required this.floorNumber,
    required this.floorName,
     required this.blocks,
  });

  factory Floor.fromJson(Map<String, dynamic> json) {
    return Floor(
      id: json['id'] ?? 0,
      floorNumber: json['floorNumber'] ?? 0,
      floorName: json['floorName'] ?? "Unknown",
       blocks: Block.fromJson(json['blocks']),
    );
  }
}

class Block {
  int id;
  int blockNumber;
  String blockName;
  int apartmentId;
  Apartment apartment;

  Block({
    required this.id,
    required this.blockNumber,
    required this.blockName,
    required this.apartmentId,
    required this.apartment,
  });

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      id: json['id'] ?? 0,
      blockNumber: json['blockNumber'] ?? 0,
      blockName: json['blockName'] ?? "Unknown",
      apartmentId: json['apartmentId'] ?? 0,
      apartment: Apartment.fromJson(json['apartment']),
    );
  }
}
