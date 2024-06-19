import 'package:SMP/model/global_search.dart';

class GlobalSearchViewModel {
  final ApiResponse movie;

  GlobalSearchViewModel({required this.movie});

  // int get id {
  //   return movie.userInfo.userId;
  // }

  // List<dynamic> get residentImages {
  //   return movie.images;
  // }
  String? get flatNumber {
    return movie.flatInfo?.flatNumber;
  }

  String? get blockName {
    return movie.flatInfo?.blockName;
  }

  // String? get floorName {
  //   return movie.flatInfo?.floorName;
  // }

  int? get floorNumber {
    return movie.flatInfo?.floorNumber;
  }

  // String get blockName {
  //   return movie.flatInfo!.blockName;
  // }

  // String get floorName {
  //   return movie.flatInfo!.floorName;
  // }



  // String get name {
  //   return movie.userInfo.name;
  // }

  
  // String? get picture {
  //   return movie.userInfo.picture;
  // }


  // String get email {
  //   return movie.userInfo.email;
  // }

  // String get phone {
  //   return movie.userInfo.phone;
  // }

  // String get address {
  //   return movie.userInfo.address;
  // }
  //   String? get role {
  //   // Check if there are roleMasters and if the list is not empty
  //   if (movie.userInfo.roleMasters.isNotEmpty) {
  //     // Access the roleName of the first RoleMaster
  //     return movie.userInfo.roleMasters[0].roles[0].roleName;
  //   } else {
  //     // Handle the case where there are no roleMasters
  //     return null;
  //   }
  // }
}
