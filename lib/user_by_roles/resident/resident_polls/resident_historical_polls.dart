import 'dart:convert';

import 'package:SMP/contants/base_api.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../contants/constant_url.dart';
import '../../../model/vote_model.dart';
import '../../../network/NetworkUtils.dart';
import '../../../presenter/api_listener.dart';
import '../../../utils/Strings.dart';
import '../../../utils/Utils.dart';

class ResidentAllVoteOptionScreen extends StatefulWidget {
  const ResidentAllVoteOptionScreen({Key? key}) : super(key: key);

  @override
  State<ResidentAllVoteOptionScreen> createState() =>
      _ResidentAllVoteOptionScreenState();
}

class _ResidentAllVoteOptionScreenState
    extends State<ResidentAllVoteOptionScreen> with ApiListener {
  @override
  Map<String, double> percentageMap = {};
  List<Map<String, dynamic>> combinedOptions = [];
  int? selectedTileIndex;
  bool _isNetworkConnected = false;
  bool _isLoading = false;

  int selected = 0;

  List histpricalPollLists = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();
    loadIssueData();
  }

  loadIssueData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var apartId = prefs.getInt('apartmentId');
      var id = prefs.getInt('id');
      Utils.getNetworkConnectedStatus().then((status) {
        Utils.printLog("network status : $status");
        setState(() {
          _isNetworkConnected = status;
          _isLoading = status;
          if (_isNetworkConnected) {
            String responseType = "pendingIssue";
            String resolvedIssue =
                '${Constant.historicalPollURL}?apartmentId=$apartId';
            NetworkUtils.getNetWorkCall(resolvedIssue, responseType, this);
          } else {
            Utils.printLog("else called");
            _isLoading = false;
            Utils.showCustomToast(context);
          }
        });
      });
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  onFailure(status) {
    setState(() {
      _isLoading = false;
    });
    // Utils.sessonExpired(context,  "Session is expired. Please login again");
    if (status == 401) {
      Utils.sessonExpired(context);
    } else {
      Utils.showToast(Strings.API_ERROR_MSG_TEXT);
    }
  }

  @override
  onSuccess(response, String responseType) async {
    try {
      setState(() {
        _isLoading = false;

        if (responseType == 'pendingIssue') {
          Utils.printLog("Succcess === $response");
          List<VoteModel> resolvedIssueList = (json.decode(response) as List)
              .map((item) => VoteModel.fromJson(item))
              .toList();

          setState(() {
            histpricalPollLists = resolvedIssueList;
          });
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Utils.printLog("Error === $response");
    }
  }

  String? token;
  int? userId;

  Future<void> _choose(int valueID, List<dynamic> formattedOptions) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final percentageUrl = Uri.parse(
        '${Constant.baseUrl}smp/resident/getPercentageOfVote?pollId=$valueID');
    final percentageResponse = await http.get(
      percentageUrl,
      headers: {
        'Authorization': 'Bearer $token', // Add token to the headers
      },
    );

    if (percentageResponse.statusCode == 200) {
      final percentageBody = jsonDecode(percentageResponse.body);

      if (percentageBody is Map<String, dynamic>) {
        setState(() {
          percentageMap = percentageBody.map(
            (key, value) => MapEntry(key, double.parse(value.toString())),
          );

          combinedOptions = formattedOptions
              .map((vote) => {
                    'option': vote,
                    'percentage': percentageMap[vote] ?? 0.0,
                  })
              .toList();
        });
      }
    } else {
      throw Exception("Unable to perform request!");
    }
  }

  Color getColorForPercentage(double percentage) {
    if (percentage >= 100) {
      return Colors.green;
    } else if (percentage >= 90 && percentage < 100) {
      return Colors.green;
    } else if (percentage >= 80 && percentage < 90) {
      return Colors.green;
    } else if (percentage >= 70 && percentage < 80) {
      return Colors.green;
    } else if (percentage >= 60 && percentage < 70) {
      return Colors.green;
    } else if (percentage >= 50 && percentage < 60) {
      return Colors.green;
    } else if (percentage >= 40 && percentage < 50) {
      return Colors.green;
    } else if (percentage >= 30 && percentage < 40) {
      return Colors.green;
    } else if (percentage >= 20 && percentage < 30) {
      return Colors.green;
    } else if (percentage >= 10 && percentage < 20) {
      return Colors.green;
    } else if (percentage >= 1 && percentage < 10) {
      return Colors.green;
    } else {
      return Colors.white;
    }
  }

  Future<void>? _fetchDataFuture;

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (histpricalPollLists.isNotEmpty) {
      content = Container(
          height: MediaQuery.of(context).size.height - kToolbarHeight,
          child: ListView.builder(
            key: Key('builder ${selectedTileIndex.toString()}'),
            shrinkWrap: false,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: histpricalPollLists.length,
            itemBuilder: (context, index) {
              final user = histpricalPollLists[index];

              return Padding(
                padding:  EdgeInsets.all(FontSizeUtil.SIZE_08),
                child: Container(
                  decoration: AppStyles.decoration(context),
                  child: Column(children: <Widget>[
                    ExpansionTile(
                      key: Key(index.toString()),
                      initiallyExpanded: index == selectedTileIndex,
                      title:
                          Text(user.voteFor, style: AppStyles.heading(context)),
                      onExpansionChanged: (bool isExpanded) {
                        if (isExpanded) {
                          setState(() {
                            selectedTileIndex = index;
                            _fetchDataFuture = _choose(user.id!, user.options);
                          });
                        } else {
                          setState(() {
                            selectedTileIndex = -1;
                            _fetchDataFuture = null;
                          });
                        }
                      },
                      children: <Widget>[
                        if (_fetchDataFuture != null)
                          FutureBuilder<void>(
                            future: _fetchDataFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox(
                                    height: FontSizeUtil.CONTAINER_SIZE_10,
                                    width: FontSizeUtil.CONTAINER_SIZE_10,
                                    child:const CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                // Display the data once the future completes
                                return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  // controller: _scrollController,
                                  shrinkWrap: true,
                                  itemCount: combinedOptions.length,
                                  itemBuilder: (context, index) {
                                    final option =
                                        combinedOptions[index]['option'];
                                    final percentage =
                                        combinedOptions[index]['percentage'];
                                    final hasVotedForOption = user.voted &&
                                        option == user.responseMsg;
                                    return Padding(
                                      padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                                      child: InkWell(
                                        onTap: () {
                                          // setState(() {
                                          //   // selectedOption = option;
                                          // });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_16),
                                          height: FontSizeUtil.CONTAINER_SIZE_60,

                                           decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.blue),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            FontSizeUtil.CONTAINER_SIZE_10),
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        getColorForPercentage(
                                                            percentage),
                                                        Colors.transparent,
                                                      ],
                                                      stops: [
                                                        percentage / FontSizeUtil.CONTAINER_SIZE_100,
                                                        percentage / FontSizeUtil.CONTAINER_SIZE_100
                                                      ],
                                                      begin:
                                                          Alignment.centerLeft,
                                                      end:
                                                          Alignment.centerRight,
                                                    ),
                                                  ),

                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  option,
                                                  style:  TextStyle(
                                                    fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                                    color:const Color.fromRGBO(
                                                        27, 86, 148, 1.0),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'Votes: $percentage%',
                                                style:  TextStyle(
                                                  fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                                  color:const Color.fromRGBO(
                                                      27, 86, 148, 1.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                                child: Text(
                                  "Start Date: ${DateFormat('y-MM-dd').format(user.startDate)}",
                                  style: AppStyles.heading1(context),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                                child: Text(
                                  "Start Time: ${DateFormat('HH:mm a').format(user.startDate)}",
                                  style: AppStyles.heading1(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:  EdgeInsets.all(FontSizeUtil.SIZE_08),
                                child: Text(
                                  "End Date: ${DateFormat('y-MM-dd').format(user.endDate)}",
                                  style: AppStyles.heading1(context),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:  EdgeInsets.all(FontSizeUtil.SIZE_08),
                                child: Text(
                                  "End Time: ${DateFormat('HH:mm a').format(user.endDate)}",
                                  style: AppStyles.heading1(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ]),
                ),
              );
            },
          ));
    } else {
      content = _isLoading
          ? Container()
          : Center(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  Strings.NO_HISTORICAL_POLL_TEXT,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff1B5694),
                  ),
                ),
              ),
            );
    }

    return Scaffold(
      body: AbsorbPointer(
        absorbing: _isLoading,
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.white,
                  ],
                ),
              ),
              child: Column(children: [
                Expanded(child: content),
              ]),
            ),
            if (_isLoading)  Positioned(top: FontSizeUtil.CONTAINER_SIZE_130, child: LoadingDialog()),
          ],
        ),
      ),
    );
  }
}
