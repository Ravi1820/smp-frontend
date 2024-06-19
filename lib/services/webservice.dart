// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:SMP/contants/base_api.dart';
import 'package:SMP/model/admin_model.dart';
import 'package:SMP/model/block_model.dart';
import 'package:SMP/model/chat_model.dart';
import 'package:SMP/model/device_token_model.dart';
import 'package:SMP/model/flat_model.dart';
import 'package:SMP/model/floor_model.dart';
import 'package:SMP/model/global_search.dart';
import 'package:SMP/model/guest_model.dart';
import 'package:SMP/model/inventory_model.dart';
import 'package:SMP/model/issue_list_model.dart';
import 'package:SMP/model/message_model.dart';
import 'package:SMP/model/movies.dart';
import 'package:SMP/model/notice_board_model.dart';
import 'package:SMP/model/owner_model.dart';
import 'package:SMP/model/pending_visitor_model.dart';
import 'package:SMP/model/profile_model.dart';
import 'package:SMP/model/security_model.dart';
import 'package:SMP/model/team_model.dart';
import 'package:SMP/model/visitors_models.dart';
import 'package:SMP/model/vote_model.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../contants/constant_url.dart';
import '../utils/Utils.dart';

class Webservice {
  Future<List<ApiResponse>> fetchGlobalSearchedApartment(
      query, apartmentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    print(query);
    try {
      final url = Uri.parse(
          '${Constant.baseUrl}smp/admin/globalSearchForApartment?data=$query&apartmentId=$apartmentId');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Add token to the headers
        },
      );
      if (response.statusCode == 200) {
        final String responseBody = response.body.trim();
        if (responseBody == "No Result Found") {
          print("No result found");
          return [];
        }
        final body = jsonDecode(response.body);
        final Iterable json = body;
        return json.map((movie) => ApiResponse.fromJson(movie)).toList();
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        throw Exception("Unable to perform request!");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("An error occurred: $e");
    }
  }

  Future<List<BlockModel>> fetchBLock(apartmentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    print(apartmentId);
    final url = Uri.parse(
        '${Constant.baseUrl}smp/admin/allBlockByApartmentId?apartmentId=$apartmentId');

    print(url);
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Add token to the headers
      },
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final Iterable json = body;
      return json.map((movie) => BlockModel.fromJson(movie)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Future<List<FloorModel>> fetchFloor(apartmentId, blockId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final url = Uri.parse(
        '${Constant.baseUrl}smp/backend/backendAllFloors?apartmentId=1&blockId=$blockId');
    print(url);
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Add token to the headers
      },
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final Iterable json = body;
      return json.map((movie) => FloorModel.fromJson(movie)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Future<List<MessageModel>> fetchMessages(
      senderId, receiverId, apartmentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final url = Uri.parse(
        '${Constant.baseUrl}smp/user/getMessagesForUserEndToEnd?senderId=$senderId&receiverId=$receiverId&apartId=$apartmentId');
    print(url);
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Add token to the headers
      },
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final Iterable json = body;
      return json.map((movie) => MessageModel.fromJson(movie)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Future<List<ChatModel>> fetchChatMessages(receiverId, apartmentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    print(receiverId);

    print(apartmentId);
    final url = Uri.parse(
        '${Constant.baseUrl}smp/user/getAllSenderDetails?receiverId=$receiverId&apartmentId=$apartmentId');
    print(url);

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Add token to the headers
      },
    );
    if (response.statusCode == 200) {
      print("Success Message");
      final body = jsonDecode(response.body);
      final Iterable json = body;
      return json.map((movie) => ChatModel.fromJson(movie)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Future<List<FlatModel>> fetchFlats(apartId, blockId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final url = Uri.parse(
        '${Constant.baseUrl}smp/backend/backendAllFlats?blockId=$blockId&apartmentId=$apartId');

    print(url);
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Add token to the headers
      },
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final Iterable json = body;
      return json.map((movie) => FlatModel.fromJson(movie)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Future<List<FlatModel>> fetchFlatsBasedOnBlockAndFloor(
      blockId, floorId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final url = Uri.parse(
        '${Constant.baseUrl}smp/admin/getAllInactiveflat?blockId=$blockId&floorId=$floorId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Add token to the headers
      },
    );
    if (response.statusCode == 200) {
      print("success getAllInactiveflat");
      final body = jsonDecode(response.body);
      final Iterable json = body;
      return json.map((movie) => FlatModel.fromJson(movie)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }


  Future<List<VoteModel>> fetchhistoricalVoteList(apartId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final url = Uri.parse(
        '${Constant.baseUrl}smp/admin/historicalVotePollByAdmin?apartmentId=$apartId');

    print(url);
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Add token to the headers
      },
    );
    if (response.statusCode == 200) {
      print("Success");

      final body = jsonDecode(response.body);
      final Iterable json = body;
      return json.map((movie) => VoteModel.fromJson(movie)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Future<List<VoteModel>> fetchVoteList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final url =
        Uri.parse('${Constant.baseUrl}smp/admin/getAllVotingPoll');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Add token to the headers
      },
    );
    if (response.statusCode == 200) {
      print("Success");

      final body = jsonDecode(response.body);
      final Iterable json = body;
      return json.map((movie) => VoteModel.fromJson(movie)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Future<List<VoteModel>> fetchSchuduleVoteListByAdmin(apartment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final url = Uri.parse(
        '${Constant.baseUrl}smp/admin/getAllScheduleVotePoll?apartmentId=$apartment');
    print(url);
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Add token to the headers
      },
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      print("Success $body");

      final Iterable json = body;
      return json.map((movie) => VoteModel.fromJson(movie)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Future<List<VoteModel>> fetchVoteListByAdmin(apartId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final url = Uri.parse(
        '${Constant.baseUrl}smp/admin/allActiveVotePollByAdmin?apartmentId=$apartId');
    print(url);
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Add token to the headers
      },
    );
    if (response.statusCode == 200) {
      // print("Success");

      final body = jsonDecode(response.body);
      print(body);
      final Iterable json = body;
      return json.map((movie) => VoteModel.fromJson(movie)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Future<List<VoteModel>> fetchActiveVoteList(apartId, userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final url = Uri.parse(
        '${Constant.baseUrl}smp/resident/getAllActiveVotePoll?apartmentId=$apartId&userId=$userId');
    Utils.printLog("Activ Poll Url${url}");

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Add token to the headers
      },
    );
    if (response.statusCode == 200) {
      print("Success");

      final body = jsonDecode(response.body);
      final Iterable json = body;
      return json.map((movie) => VoteModel.fromJson(movie)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }
}
