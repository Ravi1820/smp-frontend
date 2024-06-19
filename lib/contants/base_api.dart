import 'package:SMP/contants/constant_url.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/Utils.dart';

class BaseApi {
  static String BASE_API = "http://192.168.1.9:8082";
  static Future<String?> get baseUrl async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();

    return BASE_API;
  }
}

class BaseApiImage {
  static String baseImageUrl(int apartmentId, String imageType) {
    String? baseUrlImage =
        "${Constant.baseUrl}smp/resident/getSMPImages?apartmentId=$apartmentId&imageType=$imageType&imageName=";

    Utils.printLog("Image Url $baseUrlImage");
    return baseUrlImage;
  }
}
