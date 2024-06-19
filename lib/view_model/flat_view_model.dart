// import 'package:SMP/model/flat_model.dart';

// class FlatViewModel {
//   final FlatModel movie;

//   FlatViewModel({required this.movie});

//   int? get id {
//     return movie.id;
//   }

//   int? get blockId {
//     return movie.blockId;
//   }

//   int? get ownerId {
//     return movie.users.id;
//   }

//   int? get flatNumber {
//     return movie.flatNumber;
//   }

//   int? get floorId {
//     return movie.floorId;
//   }

//   String get flatName {
//     return movie.flatName;
//   }

//   String get status {
//     return movie.users.status;
//   }

//   // String get floorName {
//   //   return movie.user.roleMasters.role;
//   // }

//   String? get role {
//     // Check if there are roleMasters and if the list is not empty
//     if (movie.users.roleMasters.isNotEmpty) {
//       // Access the roleName of the first RoleMaster
//       return movie.users.roleMasters[0].roles[0].roleName;
//     } else {
//       // Handle the case where there are no roleMasters
//       return null;
//     }
//   }

//   int get floorNumber {
//     return movie.floorNumber;
//   }

//   String get user {
//     return movie.users.fullName;
//   }

//   int get residentId {
//     return movie.users.id;
//   }

//   String get pushNotificationToken {
//     return movie.users.pushNotificationToken;
//   }

//   String? get profilePicture {
//     return movie.users.profilePicture;
//   }

//   String get mobile {
//     return movie.users.mobile;
//   }

//   String get emailId {
//     return movie.users.emailId;
//   }

//   String get fullName {
//     return movie.users.fullName;
//   }

//   String get address {
//     return movie.users.address;
//   }

//   String get age {
//     return movie.users.age;
//   }

//   String get state {
//     return movie.users.state;
//   }

//   String get pinCode {
//     return movie.users.pinCode;
//   }

//   String? get gender {
//     return movie.users!.gender;
//   }

//   String? get blockNumber {
//     return movie.users.block;
//   }

// }

import 'package:SMP/model/flat_model.dart';

class FlatViewModel {
  final FlatModel flat;

  FlatViewModel({required this.flat});

  int? get id {
    return flat.id;
  }

  String? get flatNumber {
    return flat.flatNumber;
  }

  int? get floorId {
    return flat.floorId;
  }

  int? get totalNumberOfResidents {
    return flat.totalNumberOfResidents;
  }

  String? get user {
    return flat.owner!.fullName;
  }

  int? get ownerId {
    return flat.owner!.id;
  }

  String? get pushNotificationToken {
    return flat.owner!.pushNotificationToken;
  }

  // List<Users>? get users {
  //   return flat.users;
  // }
}
