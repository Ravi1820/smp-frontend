import 'package:SMP/model/global_apartment_search_model.dart';

class GlobalApartmentSearchViewModel {
  final MovieViewModel movie;

  GlobalApartmentSearchViewModel({required this.movie});
  // factory GlobalApartmentSearchViewModel.fromJson(Map<String, dynamic> json) {
  //   return GlobalApartmentSearchViewModel(
  //     movie: MovieViewModel.fromJson(
  //         json['movie']), // Assuming movie is a key in your JSON
  //   );
  // }

  int get id {
    return movie.id;
  }

  int get floorNumber {
    return movie.floor.floorNumber;
  }

  String get floorName {
    return movie.floor.floorName;
  }

  String get userName {
    return movie.user.userName;
  }

  int get blockNumber {
    return movie.floor.blocks.blockNumber;
  }

  String get blockName {
    return movie.floor.blocks.blockName;
  }

  String get apartmentName {
    return movie.floor.blocks.apartment.name;
  }

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
