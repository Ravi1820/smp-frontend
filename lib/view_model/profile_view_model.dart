import 'package:SMP/model/profile_model.dart';

class ProfileViewModel {
  final Profile movie;

  ProfileViewModel({required this.movie});

 
  String? get blockNumber {
    return movie.blockNumber;
  }

  String? get pushNotificationToken {
    return movie.pushNotificationToken;
  }

  String? get flatNumber {
    return movie.flatNumber;
  }

  String? get userName {
    return movie.userName;
  }

  String? get state {
    return movie.state;
  }

  String? get gender {
    return movie.gender;
  }

  String? get mobile {
    return movie.mobile;
  }

  String? get fullName {
    return movie.fullName;
  }

  String? get age {
    return movie.age;
  }

  String? get pinCode {
    return movie.pinCode;
  }


  String? get address {
    return movie.address;
  }

  String? get shiftStartTime {
    return movie.shiftStartTime;
  }

  String? get shiftEndTime {
    return movie.shiftEndTime;
  }
}
