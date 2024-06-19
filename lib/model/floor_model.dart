// // class BlockModel {
// //   final String fullName;


// //   BlockModel({
// //     required this.fullName,

// //   });

// //   factory BlockModel.fromJson(Map<String, dynamic> json) {
// //     return BlockModel(
// //       fullName: json["fullName"] ?? "Unknown",
    
// //     );
// //   }
// // }


// class FloorModel{
//   final int id;
//   // final int blockNumber;
//   final String floorName;
//   // final int apartmentId;
//   // final String status;
//   // final ApartmentModel apartment;

//   FloorModel({
//     required this.id,
//     // required this.blockNumber,
//     required this.floorName,
//     // required this.apartmentId,
//     // required this.status,
//     // required this.apartment,
//   });

//   factory FloorModel.fromJson(Map<String, dynamic> json) {
//     return FloorModel(
//       id: json['id'],
//       // blockNumber: json['blockNumber'],
//       floorName: json['floorName'],
//       // apartmentId: json['apartmentId'],
//       // status: json['status'],
//       // apartment: ApartmentModel.fromJson(json['apartment']),
//     );
//   }
// }

// // class ApartmentModel {
// //   final int id;
// //   final String name;
// //   final String emailId;
// //   final String mobile;
// //   final String landline;
// //   final String address1;
// //   final String address2;
// //   final String state;
// //   final int pinCode;
// //   final String country;
// //   final String status;

// //   ApartmentModel({
// //     required this.id,
// //     required this.name,
// //     required this.emailId,
// //     required this.mobile,
// //     required this.landline,
// //     required this.address1,
// //     required this.address2,
// //     required this.state,
// //     required this.pinCode,
// //     required this.country,
// //     required this.status,
// //   });

// //   factory ApartmentModel.fromJson(Map<String, dynamic> json) {
// //     return ApartmentModel(
// //       id: json['id'],
// //       name: json['name'],
// //       emailId: json['emailId'],
// //       mobile: json['mobile'],
// //       landline: json['landline'],
// //       address1: json['address_1'],
// //       address2: json['address_2'],
// //       state: json['state'],
// //       pinCode: json['pinCode'],
// //       country: json['country'],
// //       status: json['status'],
// //     );
// //   }
// // }


class FloorModel {
  int? id;
  int? floorNumber;
  int? blockId;

  FloorModel({this.id, this.floorNumber, this.blockId});

  FloorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    floorNumber = json['floorNumber'];
    blockId = json['blockId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['floorNumber'] = this.floorNumber;
    data['blockId'] = this.blockId;
    return data;
  }
}



// class FloorModel {
//   final int id;
//   final int floorNumber;
//   final String floorName;
//   final int blockId;
//   // final String status;
 
//   FloorModel({
//     required this.id,
//     required this.floorNumber,
//     required this.floorName,
//     required this.blockId,
//     // required this.status,
//    });

//   factory FloorModel.fromJson(Map<String, dynamic> json) {
//     return FloorModel(
//       id: json["id"],
//       floorNumber: json["floorNumber"],
//       floorName: json["floorName"] ?? "N/A",
//       blockId: json["blockId"],
//       // status: json["status"],
//      );
//   }
// }
 