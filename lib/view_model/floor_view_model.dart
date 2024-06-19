import 'package:SMP/model/floor_model.dart';

class FloorViewModel {
  final FloorModel movie;

  FloorViewModel({required this.movie});

  int? get id {
    return movie.id;
  }

  int? get blockId {
    return movie.blockId;
  }

  // String? get floorName {
  //   return movie.floorName;
  // }
   int? get floorNumber {
    return movie.floorNumber;
  }
  //  String get mobile {
  //   return this.movie.mobile;
  // }
  //  String get landline {
  //   return this.movie.landline;
  // }
  //  String get address_1 {
  //   return this.movie.address_1;
  // }
  //  String get address_2 {
  //   return this.movie.address_2;
  // }
  //  String get state {
  //   return this.movie.state;
  // }
  //  int get pinCode {
  //   return this.movie.pinCode;
  // }
  //  String get country {
  //   return this.movie.country;
  // }
}
