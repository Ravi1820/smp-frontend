import 'package:SMP/model/apartment_global_search.dart';

class ApartmentGlobalSearchViewModel {
  final FlatInfo movie;

  ApartmentGlobalSearchViewModel({required this.movie});

  int get id {
    return movie.id;
  }

  int get flatNumber {
    return movie.flatNumber;
  }

  String get flatName {
    return movie.flatName;
  }

  // int get floorNumber {
  //   return movie.floor.floorNumber;
  // }

  // String get floorName {
  //   return movie.floor.floorName;
  // }

  // String get userName {
  //   return movie.user.userName;
  // }

  // int get blockNumber {
  //   return movie.floor.blocks.blockNumber;
  // }

  // String get blockName {
  //   return movie.floor.blocks.blockName;
  // }

  // String get apartmentName {
  //   return movie.floor.blocks.apartment.name;
  // }

  // static List<GlobalApartmentSearchViewModel> fromJson(jsonDecode) {}
  // int get flatId {
  //   return movie.flatId;
  // }

  // int get ownerIdToMeet {
  //   return movie.ownerIdToMeet;
  // }

  // String get guestName {
  //   return movie.guestName;
  // }

  // String get guestGender {
  //   return movie.guestGender;
  // }

  // String get purposeToMeet {
  //   return movie.purposeToMeet;
  // }

  // String get guestMobile {
  //   return movie.guestMobile;
  // }

  // String get guestIdentityType {
  //   return movie.guestIdentityType;
  // }

  // String get fromAddress {
  //   return movie.fromAddress;
  // }

  // String get inTime {
  //   return movie.inTime;
  // }

  // String get outTime {
  //   return movie.outTime;
  // }

  // String get guestAddress {
  //   return movie.guestAddress;
  // }

  // String get remark {
  //   return movie.remark;
  // }

  // String get guestIdentityNumber {
  //   return movie.guestIdentityNumber;
  // }
}
