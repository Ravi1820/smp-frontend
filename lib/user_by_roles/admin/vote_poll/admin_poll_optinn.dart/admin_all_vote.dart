import 'dart:convert';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/model/vote_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/vote_poll/create_poll.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AdminAllVoteOptionScreen extends StatefulWidget {
  const AdminAllVoteOptionScreen({Key? key}) : super(key: key);

  @override
  State<AdminAllVoteOptionScreen> createState() =>
      _AdminAllVoteOptionScreenState();
}

class _AdminAllVoteOptionScreenState extends State<AdminAllVoteOptionScreen>
    with ApiListener, NavigatorListener {
  @override
  Map<String, double> percentageMap = {};
  List<Map<String, dynamic>> combinedOptions = [];
  int? selectedTileIndex;
  bool _isNetworkConnected = false;
  bool _isLoading = false;
  int selected = 0;
  List histpricalPollLists = [];
  String? token;
  int? userId;
  Future<void>? _fetchDataFuture;


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();
    _chooseVoteList();
  }

  _chooseVoteList() async {
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

            String activePollUrl =
                '${Constant.activeAdminPollURL}?apartmentId=$apartId';
            NetworkUtils.getNetWorkCall(activePollUrl, responseType, this);
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



  @override
  Widget build(BuildContext context) {
    Widget content;

    if (histpricalPollLists.isNotEmpty) {
      content = Container(
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        child: ListView.builder(
          key: Key('builder ${selectedTileIndex.toString()}'),
          primary: true,
          physics:const AlwaysScrollableScrollPhysics(),
          shrinkWrap: false,
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
                              return  SizedBox(
                                  height: FontSizeUtil.SIZE_10,
                                  width: FontSizeUtil.SIZE_10,
                                  child: const CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {

                              return ListView.builder(
                                physics:const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: combinedOptions.length,
                                itemBuilder: (context, index) {
                                  final option =
                                      combinedOptions[index]['option'];
                                  final percentage =
                                      combinedOptions[index]['percentage'];
                                  final hasVotedForOption =
                                      user.voted && option == user.responseMsg;
                                  return Padding(
                                    padding:  EdgeInsets.all(FontSizeUtil.SIZE_08),
                                    child: InkWell(
                                      onTap: () {

                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_16),
                                        height: FontSizeUtil.CONTAINER_SIZE_60,

                                         decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.blue),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            FontSizeUtil.SIZE_10),
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
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                  color: Color.fromRGBO(
                                                      27, 86, 148, 1.0),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Votes: $percentage%',
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                                color: Color.fromRGBO(
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Expiry Date: ${DateFormat('y-MM-dd').format(user.endDate)}",
                              style: AppStyles.heading1(context),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Time: ${DateFormat('hh:mm a').format(user.endDate)}",
                              style: AppStyles.heading1(context),
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
        ),
      );
    } else {
      content = _isLoading
          ? Container()
          : Center(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'There are no active polls',
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
              child: Column(
                children: <Widget>[
                  Expanded(child: content),

                ],
              ),
            ),
            if (_isLoading)  Positioned(top: FontSizeUtil.CONTAINER_SIZE_130, child:const LoadingDialog()),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: FontSizeUtil.CONTAINER_SIZE_50),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(createRoute(CreatePollScreen(navigatorListener: this)));
          },
          backgroundColor: const Color(0xff1B5694),
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  onNavigatorBackPressed() {
    _chooseVoteList();
  }
}
