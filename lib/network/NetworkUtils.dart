import 'dart:io';

import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/network/ApiCallPresentor.dart';
import 'package:SMP/presenter/api_listener.dart';

// import 'package:go_swift/Util/Constant.dart';
// import 'package:go_swift/network/ApiCallPresentor.dart';
// import 'package:go_swift/presenter/ApiListener.dart';

class NetworkUtils {
  static isReqSuccess(var response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return false;
    } else {
      return true;
    }
  }

  static getNetWorkCall(
      String partUrl, String responseType, ApiListener listner) async {
    String url = Constant.baseUrl + partUrl;

    ApiCallPresentor presentor = ApiCallPresentor();
    presentor.attachView(listner);
    presentor.getAPIData(url, responseType);
  }

  static updateNetWorkCall(
      String partUrl, String responseType, ApiListener listner) async {
    String url = Constant.baseUrl + partUrl;

    ApiCallPresentor presentor = ApiCallPresentor();
    presentor.attachView(listner);
    presentor.updateAPIData(url, responseType);
  }

  static deleteNetWorkCall(
      String partUrl, String responseType, ApiListener listner) async {
    String url = Constant.baseUrl + partUrl;
    // String url = "${await BaseApi.baseUrl}/$partUrl";

    ApiCallPresentor presentor = ApiCallPresentor();
    presentor.attachView(listner);
    presentor.deleteAPIData(url, responseType);
  }

  // static postNetWorkCall(
  //     String partUrl, Map jsonMap, ApiListener listner, responseType) async {
  //   String url = Constant.baseUrl + partUrl;
  //   // String url = "${await BaseApi.baseUrl}/$partUrl";
  //
  //   ApiCallPresentor presentor = ApiCallPresentor();
  //   presentor.attachView(listner);
  //   presentor.postRequest(url, jsonMap, responseType);
  // }


  static postNetWorkCall(
      String partUrl, dynamic jsonMap, ApiListener listener, responseType) async {
    String url = Constant.baseUrl + partUrl;
    ApiCallPresentor presenter = ApiCallPresentor();
    presenter.attachView(listener);

    if (jsonMap is Map<String,dynamic>) {
      // Handle the case when jsonMap is a Map<String, dynamic>
      presenter.postRequest(url, jsonMap, responseType);
    } else if (jsonMap is List<Map<String,dynamic>>) {

      presenter.postRequest(url, jsonMap, responseType);
    } else {
      throw ArgumentError('jsonMap must be either a Map<String, dynamic> or a List<Map<String, dynamic>>.');
    }
  }

  static postLoginNetWorkCall(
      String partUrl, Map jsonMap, ApiListener listner, responseType) async {
    String url = Constant.baseUrl + partUrl;
    // String url = "${await BaseApi.baseUrl}/$partUrl";

    ApiCallPresentor presentor = ApiCallPresentor();
    presentor.attachView(listner);
    presentor.postLoginRequest(url, jsonMap, responseType);
  }

  static postMultipartNetWorkCall(
    String partUrl,
    File image,
    Map<String, dynamic> jsonMap,
    ApiListener listener,
    keyName,
    String responseType,
  ) async {
    String url = Constant.baseUrl + partUrl;
    // String url = "${await BaseApi.baseUrl}/$partUrl";

    ApiCallPresentor presentor = ApiCallPresentor();
    presentor.attachView(listener);
    presentor.postMultipartRequest(url, image, jsonMap, keyName, responseType);
  }

  static postMultipartNetWorkUrlCall(
    String partUrl,
    Map<String, dynamic> jsonMap,
    ApiListener listener,
    String responseType,
    String keyName,
  ) async {
    String url = Constant.baseUrl + partUrl;
    // String url = "${await BaseApi.baseUrl}/$partUrl";

    ApiCallPresentor presentor = ApiCallPresentor();
    presentor.attachView(listener);
    presentor.postMultipartUrlRequest(url, jsonMap, responseType, keyName);
  }

  static postUrlNetWorkCall(
      String partUrl, ApiListener listner, responseType) async {
    String url = Constant.baseUrl + partUrl;
    // String url = "${await BaseApi.baseUrl}/$partUrl";

    ApiCallPresentor presentor = ApiCallPresentor();
    presentor.attachView(listner);
    presentor.postUrlRequest(url, responseType);
  }

  static putUrlNetWorkCall(
      String partUrl, ApiListener listner, responseType) async {
    String url = Constant.baseUrl + partUrl;
    // String url = "${await BaseApi.baseUrl}/$partUrl";

    ApiCallPresentor presentor = ApiCallPresentor();
    presentor.attachView(listner);
    presentor.putUrlRequest(url, responseType);
  }

  static putMultipartNetWorkUrlCall(
    String partUrl,
    Map<String, dynamic> jsonMap,
    ApiListener listener,
    String responseType,
  ) async {
    String url = Constant.baseUrl + partUrl;
    // String url = "${await BaseApi.baseUrl}/$partUrl";

    ApiCallPresentor presentor = ApiCallPresentor();
    presentor.attachView(listener);
    presentor.putMultipartRequest(url, jsonMap, responseType);
  }


  static updatePollPutNetworkCall(String partUrl, Map<String, dynamic> jsonMap, ApiListener listener, String responseType,String key) async {
    String url = Constant.baseUrl + partUrl;
    // String url = "${await BaseApi.baseUrl}/$partUrl";

    ApiCallPresentor presentor = ApiCallPresentor();
    presentor.attachView(listener);
    presentor.updatePollPutMultipartRequest(url, jsonMap, responseType,key);
    

  }

  static putMultipartNetWorkCall(
    String partUrl,
    File? image,
    Map<String, dynamic> jsonMap,
    ApiListener listener,
    keyName,
    String responseType,
  ) async {
    String url = Constant.baseUrl + partUrl;
    // String url = "${await BaseApi.baseUrl}/$partUrl";

    ApiCallPresentor presentor = ApiCallPresentor();
    presentor.attachView(listener);
    presentor.putsMultipartRequest(url, image, jsonMap, keyName, responseType);
  }

  //     static putUrlNetWorkCall(
  //     String partUrl,  ApiListener listner, responseType) async {
  //   String url = Constant.baseUrl + partUrl;
  //   ApiCallPresentor presentor = ApiCallPresentor();
  //   presentor.attachView(listner);
  //   presentor.putUrlRequest(url, responseType);
  // }

  static putMultipartUrlNetWorkCall(
      String partUrl, image, ApiListener listner, responseType) async {
    String url = Constant.baseUrl + partUrl;
    // String url = "${await BaseApi.baseUrl}/$partUrl";

    ApiCallPresentor presentor = ApiCallPresentor();
    presentor.attachView(listner);
    presentor.putMultipartUrlRequest(url, image, responseType);
  }

  // static fileUploadNetWorkCall(String partUrl, String requestData, File file, ApiListener listner) {
  //   String url = Constant.BASE_URL + partUrl;
  //   ApiCallPresentor _presentor = new ApiCallPresentor();
  //   _presentor.attachView(listner);
  //   _presentor.asyncFileUpload(url, requestData, file);
  // }

  static fileUploadNetWorkCall(String partUrl, String keyName, requestData,
      File? file, ApiListener listner, String responseType) async {
    String url = Constant.baseUrl + partUrl;
    // String url = "${await BaseApi.baseUrl}/$partUrl";

    ApiCallPresentor _presentor = new ApiCallPresentor();
    _presentor.attachView(listner);
    _presentor.asyncFileUpload(url, keyName, requestData, file, responseType);
  }

  static filePutUploadNetWorkCall(String partUrl, String keyName, File? file,
      ApiListener listner, String responseType) async {
    String url = Constant.baseUrl + partUrl;
    // String url = "${await BaseApi.baseUrl}/$partUrl";

    ApiCallPresentor _presentor = new ApiCallPresentor();
    _presentor.attachView(listner);
    _presentor.asyncFilePutUpload(url, keyName, file, responseType);
  }

  static filePutUrlUploadNetWorkCall(
      String partUrl,
      String keyName,
      String upiId,
      File? file,
      ApiListener listner,
      String responseType) async {
    String url = Constant.baseUrl + partUrl;
    // String url = "${await BaseApi.baseUrl}/$partUrl";

    ApiCallPresentor _presentor = new ApiCallPresentor();
    _presentor.attachView(listner);
    _presentor.asyncFilePutUrlUpload(url, keyName, upiId, file, responseType);
  }

  static filePostUploadNetWorkCall(String partUrl, String keyName, requestData,
      File? file, ApiListener listner, String responseType) async {

    String url = Constant.baseUrl + partUrl;
    ApiCallPresentor _presentor = new ApiCallPresentor();
    _presentor.attachView(listner);
    _presentor.asyncPostFileUpload(
        url, keyName, requestData, file, responseType);
  }


  static fileMultipleImagePostUploadNetWorkCall(String partUrl, String keyName, requestData,
      File? file, File? idProof, ApiListener listner, String responseType) async {

    String url = Constant.baseUrl + partUrl;
    ApiCallPresentor _presentor = new ApiCallPresentor();
    _presentor.attachView(listner);
    _presentor.asyncPostMultipleFileUpload(
        url, keyName, requestData, file,idProof, responseType);
  }



  static pushNotificationWorkCall(String parturl, String keyName, Map requestData,
       ApiListener listner, String responseType) async {
    String url = Constant.baseUrl + parturl;
    ApiCallPresentor _presentor = new ApiCallPresentor();
    _presentor.attachView(listner);
    _presentor.asyncPushNotificationPost(
        url, requestData, responseType);
  }

  static excelUploadNetWorkCall(String partUrl,  apartId,feesTypeId, descriptionName,
      File? file, ApiListener listner, String responseType) async {
    String url = Constant.baseUrl + partUrl;
    // String url = "${await BaseApi.baseUrl}/$partUrl";

    ApiCallPresentor _presentor = new ApiCallPresentor();
    _presentor.attachView(listner);
    _presentor.asyncExcelUpload(url, apartId,feesTypeId, descriptionName, file, responseType);
  }
}
