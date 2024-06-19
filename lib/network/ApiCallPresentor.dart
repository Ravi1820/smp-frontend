import 'dart:convert';
import 'dart:io';

// import 'package:go_swift/Util/Utils.dart';
// import 'package:go_swift/network/AppDataManager.dart';
// import 'package:go_swift/network/NetworkUtils.dart';
// import 'package:go_swift/presenter/ApiListener.dart';
// import 'package:go_swift/ui/base/BasePresentor.dart';
import 'package:SMP/network/AppDataManager.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/ui/base/BasePresentor.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:http/http.dart' as http;

class ApiCallPresentor extends BasePresentor<ApiListener> {
  Future getAPIData(String url, String responseType) async {
    checkViewAttached();
    Future.delayed(const Duration(seconds: 12));
    var response = await appDataManager.apiHelper.apiRequest(url);

    if (response != null && NetworkUtils.isReqSuccess(response)) {
      var jsonData = await utf8.decoder.bind(response).join();
      isViewAttached ? getView().onSuccess(jsonData, responseType) : null;
    } else {
      isViewAttached ? getView().onFailure(response.statusCode) : null;
    }
  }

  Future<http.Response?> updateAPIData(String url, String responseType) async {
    checkViewAttached();
    Future.delayed(const Duration(seconds: 12));
    var response = await appDataManager.apiHelper.apiUpdateRequest(url);

    if (response != null && NetworkUtils.isReqSuccess(response)) {
      Utils.printLog(
          "response code == ${response.statusCode}  response == ${response.toString()}");

      if (response.statusCode == 200 && NetworkUtils.isReqSuccess(response)) {
        try {
          var jsonData = response.body;

          Utils.printLog('Response status: $jsonData');
          if (isViewAttached) {
            getView().onSuccess(jsonData, responseType);
          }
        } catch (e) {
          Utils.printLog('Error decoding JSON: $e');
          if (isViewAttached) {
            getView().onFailure(response.statusCode);
          }
        }
      } else {
        Utils.printLog('Error response status code: ${response.statusCode}');
        Utils.printLog('Error response body: ${response.body}');
        if (isViewAttached) {
          getView().onFailure(response.statusCode);
        }
      }
    } else {
      Utils.printLog('Null response received');
      if (isViewAttached) {
        getView().onFailure(response.statusCode);
      }
    }
    return null;
  }

  Future<http.Response?> deleteAPIData(String url, String responseType) async {
    checkViewAttached();
    Future.delayed(const Duration(seconds: 12));
    var response = await appDataManager.apiHelper.apiDeleteRequest(url);

    if (response != null && NetworkUtils.isReqSuccess(response)) {
      Utils.printLog(
          "response code == ${response.statusCode}  response == ${response.toString()}");

      if (response.statusCode == 200 && NetworkUtils.isReqSuccess(response)) {
        try {
          var jsonData = response.body;

          Utils.printLog('Response status: $jsonData');
          if (isViewAttached) {
            getView().onSuccess(jsonData, responseType);
          }
        } catch (e) {
          Utils.printLog('Error decoding JSON: $e');
          if (isViewAttached) {
            getView().onFailure(response.statusCode);
          }
        }
      } else {
        Utils.printLog('Error response status code: ${response.statusCode}');
        Utils.printLog('Error response body: ${response.body}');
        if (isViewAttached) {
          getView().onFailure(response.statusCode);
        }
      }
    } else {
      Utils.printLog('Null response received');
      if (isViewAttached) {
        getView().onFailure(response.statusCode);
      }
    }
    return null;
  }
  //
  // Future<http.Response?> postRequest(
  //     String url, Map jsonMap, String responseType) async {
  //   checkViewAttached();
  //   Future.delayed(const Duration(seconds: 12));
  //   var response = await appDataManager.apiHelper.apiPostRequest(url, jsonMap);
  //
  //   if (response != null && NetworkUtils.isReqSuccess(response)) {
  //     Utils.printLog(
  //         "response code == ${response.statusCode}  response == ${response.toString()}");
  //
  //     if (response.statusCode == 200 && NetworkUtils.isReqSuccess(response)) {
  //       try {
  //         var jsonData = await json.decode(response.body);
  //
  //         Utils.printLog('Response status: $jsonData');
  //         isViewAttached ? getView().onSuccess(jsonData, responseType) : null;
  //       } catch (e) {
  //         Utils.printLog('Error decoding JSON: $e');
  //         isViewAttached ? getView().onFailure(response.statusCode) : null;
  //       }
  //     } else {
  //       Utils.printLog('Error response status code: ${response.statusCode}');
  //       Utils.printLog('Error response body: ${response.body}');
  //       isViewAttached ? getView().onFailure(response.statusCode) : null;
  //     }
  //   } else {
  //     Utils.printLog('Null response received');
  //     isViewAttached ? getView().onFailure(response.statusCode) : null;
  //   }
  //   return null;
  // }


  Future<http.Response?> postRequest(
      String url, dynamic jsonMap, String responseType) async {
    checkViewAttached();
    Future.delayed(const Duration(seconds: 12));
    var response;

    try {
      // Check if jsonMap is a List<Map<String, dynamic>>
      if (jsonMap is List<Map<String, dynamic>>) {
        response = await appDataManager.apiHelper.apiPostRequest(url, jsonMap);
      }
      // Check if jsonMap is a Map<String, dynamic>
      else if (jsonMap is Map<String, dynamic>) {
        response = await appDataManager.apiHelper.apiPostRequest(url, jsonMap);
      }
      else {
        throw Exception("Invalid jsonMap type. Expected List<Map<String, dynamic>> or Map<String, dynamic>.");
      }

      if (response != null && NetworkUtils.isReqSuccess(response)) {
        Utils.printLog(
            "response code == ${response.statusCode}  response == ${response.toString()}");

        if (response.statusCode == 200 && NetworkUtils.isReqSuccess(response)) {
          try {
            var jsonData = await json.decode(response.body);

            Utils.printLog('Response status: $jsonData');
            isViewAttached ? getView().onSuccess(jsonData, responseType) : null;
          } catch (e) {
            Utils.printLog('Error decoding JSON: $e');
            isViewAttached ? getView().onFailure(response.statusCode) : null;
          }
        } else {
          Utils.printLog('Error response status code: ${response.statusCode}');
          Utils.printLog('Error response body: ${response.body}');
          isViewAttached ? getView().onFailure(response.statusCode) : null;
        }
      } else {
        Utils.printLog('Null response received');
        isViewAttached ? getView().onFailure(response.statusCode) : null;
      }
    } catch (e) {
      Utils.printLog('Error: $e');
      isViewAttached ? getView().onFailure(response.statusCode) : null;
    }
    return null;
  }

  Future<http.Response?> postLoginRequest(
      String url, Map jsonMap, String responseType) async {
    checkViewAttached();
    Future.delayed(const Duration(seconds: 12));
    var response =
        await appDataManager.apiHelper.apiPostLoginRequest(url, jsonMap);

    if (response != null && NetworkUtils.isReqSuccess(response)) {
      Utils.printLog(
          "response code == ${response.statusCode}  response == ${response.toString()}");

      if (response.statusCode == 200 && NetworkUtils.isReqSuccess(response)) {
        try {
          var jsonData = await json.decode(response.body);

          Utils.printLog('Response status: $jsonData');
          isViewAttached ? getView().onSuccess(jsonData, responseType) : null;
        } catch (e) {
          Utils.printLog('Error decoding JSON: $e');
          isViewAttached ? getView().onFailure(response.statusCode) : null;
        }
      } else {
        Utils.printLog('Error response status code: ${response.statusCode}');
        Utils.printLog('Error response body: ${response.body}');
        isViewAttached ? getView().onFailure(response.statusCode) : null;
      }
    } else {
      Utils.printLog('Null response received');
      isViewAttached ? getView().onFailure(response.statusCode) : null;
    }
    return null;
  }

  Future<http.Response?> postMultipartRequest(
    String url,
    File image,
    Map<String, dynamic> jsonMap,
    keyName,
    String responseType,
  ) async {
    checkViewAttached();
    Future.delayed(const Duration(seconds: 12));
    var response = await appDataManager.apiHelper
        .apiMultiPartPostRequest(url, jsonMap, image, keyName);

    if (response != null && NetworkUtils.isReqSuccess(response)) {
      Utils.printLog(
          "response code == ${response.statusCode}  response == ${response.toString()}");

      if (response.statusCode == 200 && NetworkUtils.isReqSuccess(response)) {
        try {
          var jsonData = response.body;
          Utils.printLog('Response status: $jsonData');
          isViewAttached ? getView().onSuccess(jsonData, responseType) : null;
        } catch (e) {
          Utils.printLog('Error decoding JSON: $e');
          Utils.printLog(
              'Response body: ${response.body}'); // Log the response body
          isViewAttached ? getView().onFailure(response.statusCode) : null;
        }
        // try {
        //   var jsonData = await json.decode(response.body);

        //   Utils.printLog('Response status: $jsonData');
        //   isViewAttached ? getView().onSuccess(jsonData, responseType) : null;
        // } catch (e) {
        //   Utils.printLog('Error decoding JSON: $e');
        //   isViewAttached ? getView().onFailure() : null;
        // }
      } else {
        Utils.printLog('Error response status code: ${response.statusCode}');
        Utils.printLog('Error response body: ${response.body}');
        isViewAttached ? getView().onFailure(response.statusCode) : null;
      }
    } else {
      Utils.printLog('Null response received');
      isViewAttached ? getView().onFailure(response.statusCode) : null;
    }
    return null;
  }

  Future<http.Response?> putsMultipartRequest(
    String url,
    File? image,
    Map<String, dynamic> jsonMap,
    keyName,
    String responseType,
  ) async {
    checkViewAttached();
    Future.delayed(const Duration(seconds: 12));
    var response = await appDataManager.apiHelper
        .apiMultiPartPutsRequest(url, jsonMap, image, keyName);

    if (response != null && NetworkUtils.isReqSuccess(response)) {
      Utils.printLog(
          "response code == ${response.statusCode}  response == ${response.toString()}");

      if (response.statusCode == 200 && NetworkUtils.isReqSuccess(response)) {
        try {
          var jsonData = response.body;
          Utils.printLog('Response status: $jsonData');
          isViewAttached ? getView().onSuccess(jsonData, responseType) : null;
        } catch (e) {
          Utils.printLog('Error decoding JSON: $e');
          Utils.printLog(
              'Response body: ${response.body}'); // Log the response body
          isViewAttached ? getView().onFailure(response.statusCode) : null;
        }
        // try {
        //   var jsonData = await json.decode(response.body);

        //   Utils.printLog('Response status: $jsonData');
        //   isViewAttached ? getView().onSuccess(jsonData, responseType) : null;
        // } catch (e) {
        //   Utils.printLog('Error decoding JSON: $e');
        //   isViewAttached ? getView().onFailure() : null;
        // }
      } else {
        Utils.printLog('Error response status code: ${response.statusCode}');
        Utils.printLog('Error response body: ${response.body}');
        isViewAttached ? getView().onFailure(response.statusCode) : null;
      }
    } else {
      Utils.printLog('Null response received');
      isViewAttached ? getView().onFailure(response.statusCode) : null;
    }
    return null;
  }


  // for UpdatePoll
  Future<http.Response?> updatePollPutMultipartRequest(
    String url,
    Map<String, dynamic> jsonMap,
    String responseType,
    String key
  ) async {
    checkViewAttached();
    Future.delayed(const Duration(seconds: 12));
    var response = await appDataManager.apiHelper.updatePollMultiPartRequest(
      url,
      jsonMap,
      key
    );

    if (response != null && NetworkUtils.isReqSuccess(response)) {
      Utils.printLog(
          "response code == ${response.statusCode}  response == ${response.toString()}");

      if (response.statusCode == 200 && NetworkUtils.isReqSuccess(response)) {
        try {
          print('Response body: ${response.body}');

          // Check if the response is a valid JSON string
          if (response.body.isNotEmpty) {
            var jsonData = response.body;
            Utils.printLog('Response status: $jsonData');
            isViewAttached ? getView().onSuccess(jsonData, responseType) : null;
          } else {
            Utils.printLog('Empty JSON response');
            isViewAttached ? getView().onFailure(response.statusCode) : null;
          }
        } catch (e) {
          Utils.printLog('Error decoding JSON: $e');
          isViewAttached ? getView().onFailure(response.statusCode) : null;
        }
      } else {
        Utils.printLog('Error response status code: ${response.statusCode}');
        Utils.printLog('Error response body: ${response.body}');
        isViewAttached ? getView().onFailure(response.statusCode) : null;
      }
    } else {
      Utils.printLog('Null response received');
      isViewAttached ? getView().onFailure(response.statusCode) : null;
    }
    return null;
  }

  Future<http.Response?> putMultipartRequest(
    String url,
    Map<String, dynamic> jsonMap,
    String responseType,
  ) async {
    checkViewAttached();
    Future.delayed(const Duration(seconds: 12));
    var response = await appDataManager.apiHelper.apiMultiPartPutRequest(
      url,
      jsonMap,
    );

    if (response != null && NetworkUtils.isReqSuccess(response)) {
      Utils.printLog(
          "response code == ${response.statusCode}  response == ${response.toString()}");

      if (response.statusCode == 200 && NetworkUtils.isReqSuccess(response)) {
        try {
          print('Response body: ${response.body}');

          // Check if the response is a valid JSON string
          if (response.body.isNotEmpty) {
            var jsonData = response.body;
            Utils.printLog('Response status: $jsonData');
            isViewAttached ? getView().onSuccess(jsonData, responseType) : null;
          } else {
            Utils.printLog('Empty JSON response');
            isViewAttached ? getView().onFailure(response.statusCode) : null;
          }
        } catch (e) {
          Utils.printLog('Error decoding JSON: $e');
          isViewAttached ? getView().onFailure(response.statusCode) : null;
        }
      } else {
        Utils.printLog('Error response status code: ${response.statusCode}');
        Utils.printLog('Error response body: ${response.body}');
        isViewAttached ? getView().onFailure(response.statusCode) : null;
      }
    } else {
      Utils.printLog('Null response received');
      isViewAttached ? getView().onFailure(response.statusCode) : null;
    }
    return null;
  }

  Future<http.Response?> postMultipartUrlRequest(String url,
      Map<String, dynamic> jsonMap, String responseType, String keyName) async {
    checkViewAttached();
    Future.delayed(const Duration(seconds: 12));
    var response = await appDataManager.apiHelper
        .apiMultiPartPostUrlRequest(url, jsonMap, keyName);

    if (response != null && NetworkUtils.isReqSuccess(response)) {
      Utils.printLog(
          "response code == ${response.statusCode}  response == ${response.toString()}");

      if (response.statusCode == 200 && NetworkUtils.isReqSuccess(response)) {
        try {
          print('Response body: ${response.body}');

          // Check if the response is a valid JSON string
          if (response.body.isNotEmpty) {
            var jsonData = response.body;
            Utils.printLog('Response status: $jsonData');
            isViewAttached ? getView().onSuccess(jsonData, responseType) : null;
          } else {
            Utils.printLog('Empty JSON response');
            isViewAttached ? getView().onFailure(response.statusCode) : null;
          }
        } catch (e) {
          Utils.printLog('Error decoding JSON: $e');
          isViewAttached ? getView().onFailure(response.statusCode) : null;
        }
      } else {
        Utils.printLog('Error response status code: ${response.statusCode}');
        Utils.printLog('Error response body: ${response.body}');
        isViewAttached ? getView().onFailure(response.statusCode) : null;
      }
    } else {
      Utils.printLog('Null response received');
      isViewAttached ? getView().onFailure(response.statusCode) : null;
    }
    return null;
  }

// Future<http.Response?> postMultipartUrlRequest(
//   String url,
//   Map<String, dynamic> jsonMap,
//   String responseType,
// ) async {
//   checkViewAttached();
//   Future.delayed(const Duration(seconds: 12));
//   var response =
//       await appDataManager.apiHelper.apiMultiPartPostUrlRequest(url, jsonMap);

//   if (response != null && NetworkUtils.isReqSuccess(response)) {
//     Utils.printLog(
//         "response code == ${response.statusCode}  response == ${response.toString()}");

//     if (response.statusCode == 200 && NetworkUtils.isReqSuccess(response)) {
//       try {
//         var jsonData = await json.decode(response.body);

//         Utils.printLog('Response status: $jsonData');
//         isViewAttached ? getView().onSuccess(jsonData, responseType) : null;
//       } catch (e) {
//         Utils.printLog('Error decoding JSON: $e');
//         isViewAttached ? getView().onFailure() : null;
//       }
//     } else {
//       Utils.printLog('Error response status code: ${response.statusCode}');
//       Utils.printLog('Error response body: ${response.body}');
//       isViewAttached ? getView().onFailure() : null;
//     }
//   } else {
//     Utils.printLog('Null response received');
//     isViewAttached ? getView().onFailure() : null;
//   }
//   return null;
// }

//  Future<http.Response?> postMultipartRequest(
//       String url,image, Map jsonMap, String responseType) async {
//     checkViewAttached();
//     Future.delayed(const Duration(seconds: 12));
//     var response = await appDataManager.apiHelper.apiMultiPartPostRequest(url,image, jsonMap);

//     if (response != null && NetworkUtils.isReqSuccess(response)) {
//       Utils.printLog(
//           "response code == ${response.statusCode}  response == ${response.toString()}");

//       if (response.statusCode == 200 && NetworkUtils.isReqSuccess(response)) {
//         try {
//           // var jsonData = await json.decode(response.body);
//           var jsonData = await json.decode(response.body);

//           Utils.printLog('Response status: $jsonData');
//           isViewAttached ? getView().onSuccess(jsonData, responseType) : null;
//         } catch (e) {
//           Utils.printLog('Error decoding JSON: $e');
//           isViewAttached ? getView().onFailure() : null;
//         }
//       } else {
//         Utils.printLog('Error response status code: ${response.statusCode}');
//         Utils.printLog('Error response body: ${response.body}');
//         isViewAttached ? getView().onFailure() : null;
//       }
//     } else {
//       Utils.printLog('Null response received');
//       isViewAttached ? getView().onFailure() : null;
//     }
//     return null;
//   }

  Future<http.Response?> postUrlRequest(String url, String responseType) async {
    checkViewAttached();
    Future.delayed(const Duration(seconds: 12));
    var response = await appDataManager.apiHelper.apiUrlPostRequest(url);

    if (response != null && NetworkUtils.isReqSuccess(response)) {
      Utils.printLog(
          "response code == ${response.statusCode}  response == ${response.toString()}");

      if (response.statusCode == 200 && NetworkUtils.isReqSuccess(response)) {
        try {
          var jsonData = response.body;

          Utils.printLog('Response status: $jsonData');
          isViewAttached ? getView().onSuccess(jsonData, responseType) : null;
        } catch (e) {
          Utils.printLog('Error decoding JSON: $e');
          isViewAttached ? getView().onFailure(response.statusCode) : null;
        }
      } else {
        Utils.printLog('Error response status code: ${response.statusCode}');
        Utils.printLog('Error response body: ${response.body}');
        isViewAttached ? getView().onFailure(response.statusCode) : null;
      }
    } else {
      Utils.printLog('Null response received');
      isViewAttached ? getView().onFailure(response.statusCode) : null;
    }
    return null;
  }

  Future<http.Response?> putUrlRequest(String url, String responseType) async {
    checkViewAttached();
    Future.delayed(const Duration(seconds: 12));
    var response = await appDataManager.apiHelper.apiUrlPutRequest(url);

    if (response != null && NetworkUtils.isReqSuccess(response)) {
      Utils.printLog(
          "response code == ${response.statusCode}  response == ${response.toString()}");

      if (response.statusCode == 200 && NetworkUtils.isReqSuccess(response)) {
        try {
          var jsonData = response.body;

          Utils.printLog('Response status: $jsonData');
          isViewAttached ? getView().onSuccess(jsonData, responseType) : null;
        } catch (e) {
          Utils.printLog('Error decoding JSON: $e');
          isViewAttached ? getView().onFailure(response.statusCode) : null;
        }
      } else {
        Utils.printLog('Error response status code: ${response.statusCode}');
        Utils.printLog('Error response body: ${response.body}');
        isViewAttached ? getView().onFailure(response.statusCode) : null;
      }
    } else {
      Utils.printLog('Null response received');
      isViewAttached ? getView().onFailure(response.statusCode) : null;
    }
    return null;
  }

  Future<http.Response?> putMultipartUrlRequest(
      String url, image, String responseType) async {
    checkViewAttached();
    Future.delayed(const Duration(seconds: 12));
    var response =
        await appDataManager.apiHelper.apiUrlPutMultipartRequest(url, image);

    if (response != null && NetworkUtils.isReqSuccess(response)) {
      Utils.printLog(
          "response code == ${response.statusCode}  response == ${response.toString()}");

      if (response.statusCode == 200 && NetworkUtils.isReqSuccess(response)) {
        try {
          var jsonData = response.body;

          Utils.printLog('Response status: $jsonData');
          isViewAttached ? getView().onSuccess(jsonData, responseType) : null;
        } catch (e) {
          Utils.printLog('Error decoding JSON: $e');
          isViewAttached ? getView().onFailure(response.statusCode) : null;
        }
      } else {
        Utils.printLog('Error response status code: ${response.statusCode}');
        Utils.printLog('Error response body: ${response.body}');
        isViewAttached ? getView().onFailure(response.statusCode) : null;
      }
    } else {
      Utils.printLog('Null response received');
      isViewAttached ? getView().onFailure(response.statusCode) : null;
    }
    return null;
  }

  Future asyncFileUpload(
      String url, keyName, String requestData, File? file, responceType) async {
    checkViewAttached();
    Future.delayed(Duration(seconds: 12));
    var response = await appDataManager.apiHelper
        .asyncFileUpload(url, keyName, requestData, file);
    print("response===${response.statusCode}");
    if (response != null && NetworkUtils.isReqSuccess(response)) {
      Utils.printLog("response code ==${response.statusCode}");
      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      Utils.printLog('ResponseString==$responseString');
      isViewAttached ? getView().onSuccess(responseString, responceType) : null;
    } else {
      isViewAttached ? getView().onFailure(response.statusCode) : null;
    }
  }

  Future asyncFilePutUpload(
      String url, keyName, File? file, responceType) async {
    checkViewAttached();
    Future.delayed(Duration(seconds: 12));
    var response =
        await appDataManager.apiHelper.asyncPutFileUpload(url, keyName, file);
    print("response===${response.statusCode}");
    if (response != null && NetworkUtils.isReqSuccess(response)) {
      Utils.printLog("response code ==${response.statusCode}");
      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      Utils.printLog('ResponseString==$responseString');
      isViewAttached ? getView().onSuccess(responseString, responceType) : null;
    } else {
      isViewAttached ? getView().onFailure(response.statusCode) : null;
    }
  }

  Future asyncFilePutUrlUpload(
      String url, keyName, upiId, File? file, responceType) async {
    checkViewAttached();
    Future.delayed(Duration(seconds: 12));
    var response = await appDataManager.apiHelper
        .asyncPutUlrFileUpload(url, keyName, upiId, file);
    print("response===${response.statusCode}");
    if (response != null && NetworkUtils.isReqSuccess(response)) {
      Utils.printLog("response code ==${response.statusCode}");
      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      Utils.printLog('ResponseString==$responseString');
      isViewAttached ? getView().onSuccess(responseString, responceType) : null;
    } else {
      isViewAttached ? getView().onFailure(response.statusCode) : null;
    }
  }

  Future asyncPostFileUpload(
      String url, keyName, String requestData, File? file, responceType) async {
    checkViewAttached();
    Future.delayed(Duration(seconds: 12));
    var response = await appDataManager.apiHelper
        .asyncPostFileUpload(url, keyName, requestData, file);
    print("response===${response.statusCode}");
    if (response != null && NetworkUtils.isReqSuccess(response)) {
      Utils.printLog("response code ==${response.statusCode}");
      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      Utils.printLog('ResponseString==$responseString');
      isViewAttached ? getView().onSuccess(responseString, responceType) : null;
    } else {
      isViewAttached ? getView().onFailure(response.statusCode) : null;
    }
  }




  Future asyncPostMultipleFileUpload(
      String url, keyName, String requestData, File? file,File? idProof, responceType) async {
    checkViewAttached();
    Future.delayed(Duration(seconds: 12));
    var response = await appDataManager.apiHelper
        .asyncPostMultipleFileUploads(url, keyName, requestData, file,idProof);
    print("response===${response.statusCode}");
    if (response != null && NetworkUtils.isReqSuccess(response)) {
      Utils.printLog("response code ==${response.statusCode}");
      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      Utils.printLog('ResponseString==$responseString');
      isViewAttached ? getView().onSuccess(responseString, responceType) : null;
    } else {
      isViewAttached ? getView().onFailure(response.statusCode) : null;
    }
  }



  Future asyncPushNotificationPost(
      String url, Map requestData, String responseType) async {
    checkViewAttached();
    Future.delayed(const Duration(seconds: 12));
    var response = await appDataManager.apiHelper.asyncPushNotificationCall(url, requestData);

    if (response != null && NetworkUtils.isReqSuccess(response)) {
      Utils.printLog(
          "response code == ${response.statusCode}  response == ${response.toString()}");

      if (response.statusCode == 200 && NetworkUtils.isReqSuccess(response)) {
        try {
          var jsonData = await json.decode(response.body);

          Utils.printLog('Response status: $jsonData');
          isViewAttached ? getView().onSuccess(jsonData, responseType) : null;
        } catch (e) {
          Utils.printLog('Error decoding JSON: $e');
          isViewAttached ? getView().onFailure(response.statusCode) : null;
        }
      } else {
        Utils.printLog('Error response status code: ${response.statusCode}');
        Utils.printLog('Error response body: ${response.body}');
        isViewAttached ? getView().onFailure(response.statusCode) : null;
      }
    } else {
      Utils.printLog('Null response received');
      isViewAttached ? getView().onFailure(response.statusCode) : null;
    }
    return null;
  }

  Future asyncExcelUpload(String url, apartId, feesTypeId, descriptionName,
      File? file, responceType) async {
    checkViewAttached();
    Future.delayed(Duration(seconds: 12));
    var response = await appDataManager.apiHelper
        .asyncExcelUpload(url, apartId, feesTypeId, descriptionName, file);
    // print("response===${response.statusCode}");
    print("response===$response");

    if (response != null && NetworkUtils.isReqSuccess(response)) {
      Utils.printLog("response code ==${response.statusCode}");
      //Get the response from the server
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      Utils.printLog('ResponseString==$responseString');
      isViewAttached ? getView().onSuccess(responseString, responceType) : null;
    } else {
      isViewAttached ? getView().onFailure(response.statusCode) : null;
    }
  }
}
