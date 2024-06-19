// import 'ApiHelper.dart';
import
'package:SMP/network/ApiHelper.dart'
;
import
'DataBase_Helper.dart'
;
AppDataManager appDataManager = AppDataManager();
class AppDataManager {
  static final AppDataManager
  _appDataManager
  = AppDataManager._internal();
  final ApiHelper apiHelper = ApiHelper();
  final DatabaseHelper databaseHelper = DatabaseHelper();
// SharedPrefsHelper sharedPrefsHelper=new SharedPrefsHelper();
  factory AppDataManager() {
    return
      _appDataManager
    ;
  }
  AppDataManager._internal();
  Future<void> storePushNotificationToken(String deviceId) async {
    await databaseHelper.storePushNotificationToken(deviceId);
  }
  Future<List<String>> getAllDeviceIds() async {
    return await databaseHelper. getAllPushNotificationTokens();
  }
}