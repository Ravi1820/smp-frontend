// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:SMP/contants/push_notificaation_key.dart';
import 'package:SMP/view_model/chat_view_model.dart';
import 'package:SMP/view_model/device_token_view_model.dart';
import 'package:SMP/view_model/global_search_view_model.dart';
import 'package:SMP/view_model/issue_view_model.dart';
import 'package:SMP/view_model/message_view_model.dart';
import 'package:SMP/view_model/notice_board_view_model.dart';
import 'package:SMP/view_model/pending_visitors_view_model.dart';
import 'package:SMP/view_model/profile_view_model.dart';
import 'package:http_parser/http_parser.dart';

import 'package:SMP/contants/base_api.dart';
import 'package:SMP/services/webservice.dart';
import 'package:SMP/view_model/admin_view_model.dart';
import 'package:SMP/view_model/block_view_model.dart';
import 'package:SMP/view_model/flat_view_model.dart';
import 'package:SMP/view_model/floor_view_model.dart';
import 'package:SMP/view_model/guest_view_model.dart';
// import 'package:SMP/view_model/inventory_view_model.dart';
import 'package:SMP/view_model/visitor_view_model.dart';
import 'package:SMP/view_model/vote_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../contants/constant_url.dart';

class SmpListViewModel extends ChangeNotifier {

  List<IssueViewModel> fetchResidentIssue = [];

  List<ProfileViewModel> fetchProfile = [];

  List<GuestViewModel> guestList = [];

  List<GlobalSearchViewModel> globalSearch = [];

  List<VoteViewModel> historicalVoteList = [];

  List<VoteViewModel> voteList = [];
  List<VoteViewModel> voteListByAdmin = [];
  List<VoteViewModel> schuduleVoteListByAdmin = [];

  List<VoteViewModel> activeVoteList = [];

  List<BlockViewModel> blockList = [];
  List<FloorViewModel> floorList = [];
  List<FlatViewModel> flatList = [];
  List<FlatViewModel> flatListBasedOnBlockAndFloor = [];

  List<AdminViewModel> adminsList = [];

  List<IssueViewModel> issueListByStatus = [];

  List<IssueViewModel> issueList = [];

  List<VisitorViewModel> visitorList = [];
  List<VisitorViewModel> visitorListById = [];
  List<NotiveBoardViewModel> noticeList = [];

  List<DeviceTokenViewModel> deviceTokenList = [];

  List<MessageViewModel> messageList = [];
  List<ChatViewModel> chatMessageList = [];



  Future<void> fetchMessages(senderId, receiverId, apartmentId) async {
    final results =
        await Webservice().fetchMessages(senderId, receiverId, apartmentId);
    messageList = results.map((item) => MessageViewModel(movie: item)).toList();
    notifyListeners();
  }

  Future<void> fetchChatMessages(receiverId, apartmentId) async {
    final results =
        await Webservice().fetchChatMessages(receiverId, apartmentId);
    chatMessageList =
        results.map((item) => ChatViewModel(movie: item)).toList();
    notifyListeners();
  }



  Future<void> fetchGlobalSearchedApartments(query, apartmentId) async {
    final results =
        await Webservice().fetchGlobalSearchedApartment(query, apartmentId);
    globalSearch =
        results.map((item) => GlobalSearchViewModel(movie: item)).toList();
    notifyListeners();
  }


  Future<http.Response> addFeesTypeExcel(
      File? selectedImage, int id, feesID, descriptionName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (selectedImage == null) {
      print('No file selected.');
    }
    var stream = selectedImage!.readAsBytes().asStream();
    var length = await selectedImage.length();
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
            "${Constant.baseUrl}smp/admin/uploadMonthlyMaintenanceFee"),
      );
      print(request.url);
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['apartmentId'] = id.toString();

      request.fields['feesTypeId'] = feesID.toString();
      request.fields['feesDescription'] = descriptionName;

      var multiPartFile = http.MultipartFile.fromBytes(
        'picture',
        await stream.toBytes(),
        filename: selectedImage.path.split('/').last,
        contentType: MediaType('application',
            'vnd.openxmlformats-officedocument.spreadsheetml.sheet'),
      );

      request.files.add(multiPartFile);

      final response = await request.send();
      final responseJson = await response.stream.bytesToString();

      final httpResponse = http.Response(responseJson, response.statusCode);

      return httpResponse;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<http.Response> addExcel(File? selectedImage, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (selectedImage == null) {
      print('No file selected.');
    }
    var stream = selectedImage!.readAsBytes().asStream();
    var length = await selectedImage.length();
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${Constant.baseUrl}smp/user/excelUpload"),
      );
      print(request.url);
      request.headers['Authorization'] =
          'Bearer $token'; // Add token to headers

      request.fields['apartmentId'] = id.toString();

      var multiPartFile = http.MultipartFile.fromBytes(
        'file',
        await stream.toBytes(),
        filename: selectedImage.path.split('/').last,
        contentType: MediaType('application',
            'vnd.openxmlformats-officedocument.spreadsheetml.sheet'),
      );

      request.files.add(multiPartFile);

      final response = await request.send();
      final responseJson = await response.stream.bytesToString();

      final httpResponse = http.Response(responseJson, response.statusCode);

      return httpResponse;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<http.Response> uploadFlatBlockFloorExcel(
      File? selectedImage, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (selectedImage == null) {
      print('No file selected.');
    }
    var stream = selectedImage!.readAsBytes().asStream();
    var length = await selectedImage.length();
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("${Constant.baseUrl}smp/user/excelUpload"),
      );

      request.fields['apartmentId'] = id.toString();

      var multiPartFile = http.MultipartFile.fromBytes(
        'file',
        await stream.toBytes(),
        filename: selectedImage.path.split('/').last,
        contentType: MediaType('application',
            'vnd.openxmlformats-officedocument.spreadsheetml.sheet'),
      );

      request.files.add(multiPartFile);

      final response = await request.send();
      final responseJson = await response.stream.bytesToString();

      final httpResponse = http.Response(responseJson, response.statusCode);

      return httpResponse;
    } catch (error) {
      print(error);
      rethrow;
    }
  }


  Future<void> fetchVoteList() async {
    final results = await Webservice().fetchVoteList();
    voteList = results.map((item) => VoteViewModel(movie: item)).toList();
    notifyListeners();
  }

  Future<void> fetchSchuduleVoteListByAdmin(apartment) async {
    final results = await Webservice().fetchSchuduleVoteListByAdmin(apartment);
    schuduleVoteListByAdmin =
        results.map((item) => VoteViewModel(movie: item)).toList();
    notifyListeners();
  }

  Future<void> fetchVoteListByAdmin(apartId) async {
    final results = await Webservice().fetchVoteListByAdmin(apartId);
    voteListByAdmin =
        results.map((item) => VoteViewModel(movie: item)).toList();
    notifyListeners();
  }

  Future<void> fetchActiveVoteList(apartment, userId) async {
    final results = await Webservice().fetchActiveVoteList(apartment, userId);
    activeVoteList = results.map((item) => VoteViewModel(movie: item)).toList();
    notifyListeners();
  }

  Future<http.Response> updateSecurityUser(
    String fullName,
    String age,
    String emailId,
    String mobile,
    String address,
    String pinCode,
    String gender,
    int apartmentId,
    String state,
    int id,
    dynamic imageUrl,
    File? filePath,
  ) async {
    // print(filePath);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      var data = {
        "fullName": fullName,
        "emailId": emailId,
        "mobile": mobile,
        "address": address,
        "age": age,
        "pinCode": pinCode,
        "gender": gender,
        "apartmentId": apartmentId,
        "state": state
      };

      http.MultipartFile multiport;

      var request = http.MultipartRequest(
        "PUT",
        Uri.parse(
            "${Constant.baseUrl}smp/admin/updateSecurity?userId=$id"),
      );

      if (filePath != null) {
        print("File $filePath");
        var stream = http.ByteStream(filePath.openRead());
        var length = await filePath.length();
        multiport = http.MultipartFile(
          'picture',
          stream,
          length,
          filename: filePath.path.split('/').last,
        );
        request.files.add(multiport);
      }

      print(jsonEncode(data));

      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Authorization'] =
          'Bearer $token'; // Add token to headers

      request.fields['securityData'] = jsonEncode(data);

      final response = await request.send();

      final responseJson = await response.stream.bytesToString();

      final httpResponse = http.Response(responseJson, response.statusCode);

      return httpResponse;
    } catch (error) {
      print(error);
      rethrow;
    }
  }





  //Remove Below Code
  Future<http.Response> sendMessage(
      String message, sednerId, receiverId, apartmentId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
            "${Constant.baseUrl}smp/user/sendMessage?senderId=$sednerId&receiverId=$receiverId&content=$message&apartmentId=$apartmentId"),
      );
      print(request.url);
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Authorization'] =
          'Bearer $token'; // Add token to headers

      final response = await request.send();
      final responseJson = await response.stream.bytesToString();
      final httpResponse = http.Response(responseJson, response.statusCode);
      return httpResponse;
    } catch (error) {
      print(error);
      rethrow;
    }
  }


  Future<http.Response> createTeamMember(String hospitalName, id, token) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
            "${Constant.baseUrl}smp/user/addMangmentTeamByAdmin?userId=$id&apartmentId=$token&roleName=$hospitalName"),
      );
      request.headers['Content-Type'] = 'multipart/form-data';
      final response = await request.send();
      final responseJson = await response.stream.bytesToString();
      final httpResponse = http.Response(responseJson, response.statusCode);
      return httpResponse;
    } catch (error) {
      print(error);
      rethrow;
    }
  }


  //Remove Below Code
  Future<http.Response> deleteMultiplePolls(
    pollId,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    String result = pollId.toString(); // Convert the list to a string
    result = result.substring(1, result.length - 1);
    print(result);
    try {
      var request = http.MultipartRequest(
        "DELETE",
        Uri.parse(
            "${Constant.baseUrl}smp/admin/deleteSelectedVotePolls?votePollIdList=$result"),
      );
      print(request.url);
      final response = await request.send();
      final responseJson = await response.stream.bytesToString();
      final httpResponse = http.Response(responseJson, response.statusCode);
      return httpResponse;
    } catch (error) {
      print(error);
      rethrow;
    }
  }



}
