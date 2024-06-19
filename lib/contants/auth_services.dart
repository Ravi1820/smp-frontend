import 'package:SMP/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    Utils.printLog("Is LOgin User $isLoggedIn");
    return isLoggedIn;
  }
}
