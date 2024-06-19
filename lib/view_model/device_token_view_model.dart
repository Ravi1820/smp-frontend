import 'package:SMP/model/device_token_model.dart';

class DeviceTokenViewModel {
  final DeviceTokenModel movie;

  DeviceTokenViewModel({required this.movie});

  int get userId {
    return movie.userId;
  }

  String? get pushNotificationToken {
    return movie.pushNotificationToken;
  }
}
