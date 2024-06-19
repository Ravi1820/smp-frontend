import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:SMP/contants/base_api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/Utils.dart';

class ApiHelper {
  static Future<String?> fetchPost(String URL) async {
    var url = Uri.https((await BaseApi.baseUrl)!, URL, {'q': '{http}'});
    final response = await http.get(
      url,
      //headers: {HttpHeaders.authorizationHeader: "Basic your_api_token_here"},
    );
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      //return dynamic.fromJson(responseJson);
      //return responseJson;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load data.');
    }
    return null;
  }

  _getUserApi() async {
    var httpClient = new HttpClient();
    var uri = new Uri.https('api.github.com', '/users/1');
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    var responseBody = await utf8.decoder
        .bind(response)
        .join(); //json.decode(response.toString());//await response.transform(UTF8.decoder).join();
    return responseBody;
  }

  Future apiRequest(String url) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // final token = Utils.token; //prefs.getString("token");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    // print("Get MethodUser Token== $token");

    HttpClient httpClient = HttpClient();
    Utils.printLog("get call started==url==$url");
    HttpClientResponse? response;
    try {
      HttpClientRequest request;

      request = await httpClient.getUrl(Uri.parse(
        url,
      ));
      request.headers.set('Accept', 'application/json');
      request.headers.set('Content-type', 'application/json');

      if (token != null) {
        request.headers.set('Authorization', "Bearer $token");
      }
      response = await request.close();
      print("Network call success.");
    } on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response('Error', 408);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==${excetion}");
      return http.Response('Error', 409);
    }
    return response;
  }

  Future<http.Response> apiPostLoginRequest(String url, Map jsonMap) async {
    Utils.printLog("call started==url==$url");

    var response;

    try {
      var body = json.encode(jsonMap);
      Utils.printLog("body====$body");
      response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"}, body: body);
      Utils.printLog("Network call success. response==${response.statusCode}");
    } on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response('Error', 408);
    }
    catch (excetion) {
      Utils.printLog("Network call failed, excetion==${excetion}");
      return http.Response('Error', 409);
    }
    return response;
  }

  Future<http.Response> apiPostRequest(String url, dynamic jsonMap) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    print("User Token $token");

    print("call started==url==$url");
    var response;

    try {
      // Check if jsonMap is a List<Map<String, dynamic>>
      if (jsonMap is List<Map<String, dynamic>>) {
        var body = json.encode(jsonMap);
        print("List body====$body");

        if (token != null) {
          response = await http.post(Uri.parse(url),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token', // Add token to the headers
              },
              body: body);
        } else {
          response = await http.post(Uri.parse(url), body: body);
          // throw Exception("Token not found");
        }
      } else if (jsonMap is Map<String, dynamic>) {
        // If jsonMap is a Map<String, dynamic>
        var body = json.encode(jsonMap);
        print("Map body====$body");

        // Check if token is available
        if (token != null) {
          response = await http.post(Uri.parse(url),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token', // Add token to the headers
              },
              body: body);
        } else {
          response = await http.post(Uri.parse(url), body: body);
          // throw Exception("Token not found");
        }
      } else {
        throw Exception(
            "Invalid jsonMap type. Expected List<Map<String, dynamic>> or Map<String, dynamic>.");
      }

      print("Network call success. response==${response.statusCode}");
    } on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response('Error', 408);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==${excetion}");
      return http.Response('Error', 409);
    }

    return response;
  }

  Future<http.Response> apiMultiPartPostRequest(
      String url, Map<String, dynamic> jsonMap, image, String keyName) async {
    print(jsonMap);

    // final token = Utils.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    var httpResponse;
    try {
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();

      var body = json.encode(jsonMap);

      print("body====$body");

      print("body====$keyName");

      print("call started==url==$url");

      var request = http.MultipartRequest(
        "POST",
        Uri.parse(url),
      );
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Authorization'] =
          'Bearer $token'; // Add token to headers

      request.fields[keyName] = jsonEncode(jsonMap);

      var multiport = http.MultipartFile(
        'picture',
        stream,
        length,
        filename: image.path.split('/').last,
      );
      request.files.add(multiport);

      final response = await request.send();

      final responseJson = await response.stream.bytesToString();

      httpResponse = http.Response(responseJson, response.statusCode);
      print("Network call success. response==${httpResponse.statusCode}");
    } on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response('Error', 408);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==${excetion}");
      return http.Response('Error', 409);
    }
    return httpResponse;
  }

  Future<http.Response> apiMultiPartPutsRequest(
    String url,
    Map<String, dynamic> jsonMap,
    image,
    String keyName,
  ) async {
    print(jsonMap);
    final token = Utils.token;
    var httpResponse;
    try {
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();

      var body = json.encode(jsonMap);

      print("body====$body");

      print("body====$keyName");

      print("call started==url==$url");

      var request = http.MultipartRequest(
        "PUT",
        Uri.parse(url),
      );

      // Add token to the request headers
      request.headers['Authorization'] = 'Bearer $token';

      request.headers['Content-Type'] = 'multipart/form-data';

      request.fields[keyName] = jsonEncode(jsonMap);

      var multiport = http.MultipartFile(
        'picture',
        stream,
        length,
        filename: image.path.split('/').last,
      );
      request.files.add(multiport);

      final response = await request.send();

      final responseJson = await response.stream.bytesToString();

      httpResponse = http.Response(responseJson, response.statusCode);
      print("Network call success. response==${httpResponse.statusCode}");
    } on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response('Error', 408);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==${excetion}");
      return http.Response('Error', 409);
    }
    return httpResponse;
  }

  Future<http.Response> apiUrlPutMultipartRequest(String url, image) async {
    print("call started==url==$url");
    var httpResponse;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = Utils.token;
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();
      print("call started==url==$url");

      var request = http.MultipartRequest(
        "PUT",
        Uri.parse(url),
      );
      request.headers['Authorization'] = 'Bearer $token'; // Add your token here

      var multiport = http.MultipartFile(
        'picture',
        stream,
        length,
        filename: image.path.split('/').last,
      );

      request.files.add(multiport);

      final response = await request.send();

      final responseJson = await response.stream.bytesToString();

      httpResponse = http.Response(responseJson, response.statusCode);
      print("Network call success. response==${httpResponse.statusCode}");
    } on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response('Error', 408);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==${excetion}");
      return http.Response('Error', 409);
    }
    return httpResponse;
  }

  Future<http.Response> apiMultiPartPutRequest(
    String url,
    Map<String, dynamic> jsonMap,
  ) async {
    final token = Utils.token;

    print("call started==url==$url");
    var response;

    try {
      var body = json.encode(jsonMap);
      print("body====$body");
      response = await http.put(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );
      print("Network call success. response==${response.statusCode}");
    } on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response('Error', 408);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==${excetion}");
      return http.Response('Error', 409);
    }
    return response;
  }

  Future<http.Response> apiMultiPartPostUrlRequest(
    String url,
    Map<String, dynamic> jsonMap,
    String keyName,
  ) async {
    var httpResponse;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      var body = json.encode(jsonMap);

      print("body====$body");
      print("call started==url==$url");
      print("KeyName====$keyName");

      var request = http.MultipartRequest(
        "POST",
        Uri.parse(url),
      );
      request.headers['Content-Type'] = 'multipart/form-data';

      request.headers['Accept'] = 'application/json';
      // Set the authorization token in the request headers
      request.headers['Authorization'] = 'Bearer $token';

      request.fields[keyName] = jsonEncode(jsonMap);

      final response = await request.send();

      final responseJson = await response.stream.bytesToString();

      httpResponse = http.Response(responseJson, response.statusCode);
      print("Network call success. response==${httpResponse.statusCode}");

    }  on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response('Error', 408);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==${excetion}");
      return http.Response('Error', 409);
    }
    return httpResponse;
  }

  Future<http.Response> apiUrlPostRequest(
    String url,
  ) async {
    final token = Utils.token;

    print("call started==url==$url");
    var response;
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      };
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
      response = await http.post(
        Uri.parse(url),
        headers: headers,
      );

      print("Network call success. response==${response.statusCode}");
    }  on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response('Error', 408);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==${excetion}");
      return http.Response('Error', 409);
    }

    return response;
  }

  Future<http.Response> apiUrlPutRequest(String url) async {
    final token = Utils.token;
    print("call put==url==$url");

    var response;
    try {
      if (token != null) {
        response = await http.put(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      } else {
        response = await http.put(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );
      }
      print("Network call success. response==${response.statusCode}");
    }  on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response('Error', 408);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==${excetion}");
      return http.Response('Error', 409);
    }
    return response;
  }

  Future<http.Response> apiUpdateRequest(String url) async {
    final token = Utils.token;
    print("call started==url==$url");
    var response;
    try {
      response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Add the token to the headers
        },
      );
      print("Network call success. response==${response.statusCode}");
    }  on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response('Error', 408);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==${excetion}");
      return http.Response('Error', 409);
    }
    return response;
  }

  Future<http.Response> apiDeleteRequest(
    String url,
  ) async {
    print("call started==url==$url");
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = Utils.token;

    print(url);

    var response;
    try {
      response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':
              'Bearer $token', // Add the token to the Authorization header
        },
      );
      print("Network call success. response==${response.statusCode}");
    }  on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response('Error', 408);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==${excetion}");
      return http.Response('Error', 409);
    }
    return response;
  }

  Future asyncExcelUpload(
      String url, apartId, feesTypeId, descriptionName, File? file) async {
    var response;
    final token = Utils.token;

    try {
      Utils.printLog('URL : $url ');
      var request = http.MultipartRequest("POST", Uri.parse(url));

      // Add text fields
      Utils.printLog("apartmentId : ${apartId}");
      Utils.printLog("feesTypeId : ${feesTypeId}");
      Utils.printLog("feesDescription : ${descriptionName}");

      request.fields['apartmentId'] = apartId.toString();
      request.fields['feesTypeId'] = feesTypeId.toString();
      request.fields['feesDescription'] = descriptionName;

      // Add token to request headers
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'application/form-data';

      request.headers['Accept'] = 'application/json';
      if (file != null) {
        // Create multipart using filepath, string or bytes
        var pic = await http.MultipartFile.fromPath("picture", file.path);
        // Add multipart to request
        request.files.add(pic);
      } else {
        request.fields['picture'] = '';
      }

      response = await request.send();
      print(response);
    }  on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response('Error', 408);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==${excetion}");
      return http.Response('Error', 409);
    }
    return response;
  }

  Future asyncFileUpload(
      String url, keyName, String requestData, File? file) async {
    var response;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString("token");
    final token = Utils.token;

    try {
      Utils.printLog('URL : $url ');
      //create multipart request for POST or PATCH method
      var request = http.MultipartRequest("PUT", Uri.parse(url));
      //add text fields

      Utils.printLog("Data : ${requestData}");
      Utils.printLog("Key Neme : ${keyName}");
      request.headers['Authorization'] = 'Bearer $token';
      request.fields[keyName] = requestData;
      request.headers['Content-Type'] = 'application/form-data';
      if (file != null) {
        var pic = await http.MultipartFile.fromPath("picture", file.path);
        request.files.add(pic);
      } else {
        print("Uploading null");

        request.fields['picture'] = '';
      }
      response = await request.send();
      print(response);
    }  on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response('Error', 408);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==${excetion}");
      return http.Response('Error', 409);
    }
    return response;
  }

  //updatePoll

  Future<http.Response> updatePollMultiPartRequest(
      String url, Map<String, dynamic> jsonMap, String keyName) async {
    final token = Utils.token;
    var httpResponse;
    try {
      var body = json.encode(jsonMap);

      print("body====$body");

      print("body====$keyName");

      print("call started==url==$url");

      var request = http.MultipartRequest(
        "PUT",
        Uri.parse(url),
      );

      // Add token to the request headers
      request.headers['Authorization'] = 'Bearer $token';

      request.headers['Content-Type'] = 'multipart/form-data';

      request.fields[keyName] = jsonEncode(jsonMap);

      final response = await request.send();

      final responseJson = await response.stream.bytesToString();

      httpResponse = http.Response(responseJson, response.statusCode);
      print("Network call success. response==${httpResponse.statusCode}");


    }  on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response('Error', 408);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==${excetion}");
      return http.Response('Error', 409);
    }
    return httpResponse;
  }

  Future<dynamic> asyncPutFileUpload(
      String url, String keyName, File? file) async {
    var response;
    final token = Utils.token;

    try {
      Utils.printLog('URL : $url ');
      var request = http.MultipartRequest("PUT", Uri.parse(url));

      // Add the token to the request headers
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'application/form-data';
      request.headers['Accept'] = 'application/json';
      if (file != null) {
        var pic = await http.MultipartFile.fromPath(keyName, file.path);
        request.files.add(pic);
      } else {
        // If file is null, you can still send an empty parameter
        request.fields[keyName] = '';
      }

      response = await request.send();
    }  on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response('Error', 408);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==${excetion}");
      return http.Response('Error', 409);
    }
    return response;
  }

  Future<dynamic> asyncPutUlrFileUpload(
      String url, String keyName, upiId, File? file) async {
    var response;
    final token = Utils.token;

    try {
      Utils.printLog('URL : $url ');
      var request = http.MultipartRequest("PUT", Uri.parse(url));
      Utils.printLog('Body : $upiId ');

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'application/form-data';
      request.headers['Accept'] = 'application/json';

      if (upiId.isNotEmpty) {
        print("upiId $upiId");
        request.fields["upiId"] = upiId;
      } else {
        print("No UPiId");

        request.fields["upiId"] = 'N/A';
      }

      if (file != null) {
        var pic = await http.MultipartFile.fromPath("picture", file.path);
        request.files.add(pic);
      } else {
        request.fields["picture"] = '';
      }
      response = await request.send();
    } on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response('Error', 408);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==${excetion}");
      return http.Response('Error', 409);
    }
    return response;
  }



  Future asyncPostMultipleFileUploads(
      String url,
      String keyName,
      String requestData,
      File? file,
      File? ifProof,
      ) async {
    var response;
    final token = Utils.token;

    try {
      Utils.printLog('URL : $url ');
      var request = http.MultipartRequest("POST", Uri.parse(url));

      // Add text fields
      Utils.printLog("Data : ${requestData}");
      Utils.printLog("Key Name : ${keyName}");
      Utils.printLog("Profile Key : ${file}");
      Utils.printLog("Document Key : ${ifProof}");
      request.fields[keyName] = requestData;

      // Add token to request headers
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'application/form-data';
      request.headers['Accept'] = 'application/json';
      if (file != null) {
        // Create multipart using filepath, string or bytes
        var pic = await http.MultipartFile.fromPath("picture", file.path);
        // Add multipart to request
        request.files.add(pic);
      } else {
        request.fields['picture'] = '';
      }
      if (ifProof != null) {
        // Create multipart using filepath, string or bytes
        var pic = await http.MultipartFile.fromPath("documentPicture", ifProof.path);
        // Add multipart to request
        request.files.add(pic);
      } else {
        request.fields['documentPicture'] = '';
      }

      response = await request.send();
      print(response);
    } on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response('Error', 408);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==${excetion}");
      return http.Response('Error', 409);
    }
    return response;
  }


  Future asyncPostFileUpload(
    String url,
    String keyName,
    String requestData,
    File? file,
  ) async {
    var response;
    final token = Utils.token;

    try {
      Utils.printLog('URL : $url ');
      var request = http.MultipartRequest("POST", Uri.parse(url));

      // Add text fields
      Utils.printLog("Data : ${requestData}");
      Utils.printLog("Key Name : ${keyName}");
      request.fields[keyName] = requestData;

      // Add token to request headers
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'application/form-data';
      request.headers['Accept'] = 'application/json';
      if (file != null) {
        // Create multipart using filepath, string or bytes
        var pic = await http.MultipartFile.fromPath("picture", file.path);
        // Add multipart to request
        request.files.add(pic);
      } else {
        request.fields['picture'] = '';
      }

      response = await request.send();
      print(response);
    } on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response('Error', 408);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==${excetion}");
      return http.Response('Error', 409);
    }
    return response;
  }

  Future asyncPushNotificationCall(String url, Map requestData) async {
    print("call started==url==$url");
    var response;
    try {
      var body = json.encode(requestData);
      print("body====$body");

      response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: body);
      print("Network call success. response==${response.statusCode}");
    } on TimeoutException catch (_) {
      Utils.printLog('Timed out');
      return http.Response('Error', 408);
    } catch (excetion) {
      Utils.printLog("Network call failed, excetion==${excetion}");
      return http.Response('Error', 409);
    }

    return response;
  }
}
