import 'package:SMP/model/admin_model.dart';

class AdminViewModel {
  final AdminModel movie;

  AdminViewModel({required this.movie});

  int get id {
    return movie.id;
  }

  String get fullName {
    return movie.fullName;
  }
}
