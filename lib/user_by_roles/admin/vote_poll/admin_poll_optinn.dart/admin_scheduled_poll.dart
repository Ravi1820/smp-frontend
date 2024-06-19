import 'dart:convert';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/contants/success_alert.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/model/vote_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/vote_poll/create_poll.dart';
import 'package:SMP/user_by_roles/admin/vote_poll/edit_vote_polls.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AdminShcudlueVoteOptionScreen extends StatefulWidget {
  const AdminShcudlueVoteOptionScreen({Key? key}) : super(key: key);

  @override
  State<AdminShcudlueVoteOptionScreen> createState() =>
      _AdminShcudlueVoteOptionScreenState();
}

class _AdminShcudlueVoteOptionScreenState
    extends State<AdminShcudlueVoteOptionScreen>
    with ApiListener, NavigatorListener {
  Map<String, double> percentageMap = {};
  List<Map<String, dynamic>> combinedOptions = [];
  int? selectedTileIndex;
  late List<bool> selectedOptions = [];
  Stopwatch? _stopwatch;
  int selected = 0;
  var selectedIndexes = [];
  List<dynamic> selectedPollOption = [];
  int selectedPollId = 0;
  bool _isNetworkConnected = false;
  List<VoteModel> voteViewModel1 = [];
  bool isLoading = true;
  Future<void>? _fetchDataFuture;
  Future<void>? originalFetchDataFuture;



  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _chooseVoteList();
    updateSelectedOptionsLength();
  }

  void updateSelectedOptionsLength() {
    selectedOptions = List.generate(voteViewModel1.length, (index) => false);
  }

  _chooseVoteList() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var apartId = prefs.getInt('apartmentId');
      var id = prefs.getInt('id');
      Utils.getNetworkConnectedStatus().then((status) {
        Utils.printLog("network status : $status");
        setState(() {
          _isNetworkConnected = status;
          isLoading = status;
          if (_isNetworkConnected) {
            String responseType = "scheduledPoll";
            String resolvedIssue =
                '${Constant.scheduledPollURL}?apartmentId=$apartId';
            NetworkUtils.getNetWorkCall(resolvedIssue, responseType, this);
          } else {
            Utils.printLog("else called");
            isLoading = false;
            Utils.showCustomToast(context);
          }
        });
      });
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    print("Refreshing");
    await _chooseVoteList();
  }


  Future<void> _choose(int valueID, List<dynamic> formattedOptions) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final percentageUrl = Uri.parse(
        '${Constant.baseUrl}smp/resident/getPercentageOfVote?pollId=$valueID');
    Utils.printLog("Url :: $percentageUrl");
    final percentageResponse = await http.get(
      percentageUrl,
      headers: {
        'Authorization': 'Bearer $token',
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


  @override
  Widget build(BuildContext context) {
    Widget content;

    if (voteViewModel1.isNotEmpty) {
      content = Container(
        height: MediaQuery.of(context).size.height - kToolbarHeight,
        child: ListView.builder(
          primary: true,
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: false,
          key: Key('builder ${selectedTileIndex.toString()}'),
          itemCount: voteViewModel1.length,
          itemBuilder: (context, index) {
            final poll = voteViewModel1[index];

            return Padding(
              padding: EdgeInsets.symmetric(
                  vertical: FontSizeUtil.SIZE_08,
                  horizontal: FontSizeUtil.CONTAINER_SIZE_10),
              child: Container(
                decoration: AppStyles.decoration(context),
                child: Column(
                  children: <Widget>[
                    ExpansionTile(
                      key: Key(index.toString()),
                      initiallyExpanded: index == selectedTileIndex,
                      title: Container(
                        decoration: const BoxDecoration(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Checkbox(
                              value: selectedIndexes.contains(poll.id),
                              onChanged: (_) {
                                setState(() {
                                  if (selectedIndexes.contains(poll.id)) {
                                    selectedIndexes.remove(poll.id);
                                  } else {
                                    selectedIndexes.add(poll.id);
                                  }
                                });
                              },
                            ),
                            Expanded(
                                child: Text(poll.voteFor,
                                    style: AppStyles.heading(context))),
                          ],
                        ),
                      ),
                      onExpansionChanged: (bool isExpanded) {
                        if (isExpanded) {
                          setState(() {
                            selectedTileIndex = index;
                            _fetchDataFuture = _choose(poll.id, poll.options);
                            selectedPollId = poll.id;
                            selectedPollOption = poll.options;
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
                                    child: const CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return ListView.builder(
                                  primary: false,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: combinedOptions.length,
                                  itemBuilder: (context, index) {
                                    final option =
                                        combinedOptions[index]['option'];
                                    final percentage =
                                        combinedOptions[index]['percentage'];
                                    final hasVotedForOption = poll.voted &&
                                        option == poll.responseMsg;
                                    return Padding(
                                      padding:
                                          EdgeInsets.all(FontSizeUtil.SIZE_08),
                                      child: InkWell(
                                        onTap: () {},
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              FontSizeUtil.CONTAINER_SIZE_16),
                                          height:
                                              FontSizeUtil.CONTAINER_SIZE_60,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.blue),
                                            borderRadius: BorderRadius.circular(
                                                FontSizeUtil.CONTAINER_SIZE_10),
                                            color: hasVotedForOption
                                                ? Colors.grey
                                                : null,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  option,
                                                  style: TextStyle(
                                                    fontSize: FontSizeUtil
                                                        .CONTAINER_SIZE_16,
                                                    color: const Color.fromRGBO(
                                                        27, 86, 148, 1.0),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'Votes: $percentage%',
                                                style: TextStyle(
                                                  fontSize: FontSizeUtil
                                                      .CONTAINER_SIZE_16,
                                                  color: const Color.fromRGBO(
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
                              padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                              child: Text(
                                "Start Date: ${DateFormat('y-MM-dd').format(poll.startDate)}",
                                style: AppStyles.heading1(context),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                                child: Text(
                                  "Start Time: ${DateFormat('HH:mm:a').format(poll.startDate)}",
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
                            Padding(
                              padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                              child: Text(
                                "Expiry Date: ${DateFormat('y-MM-dd').format(poll.endDate)}",
                                style: AppStyles.heading1(context),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(FontSizeUtil.SIZE_06),
                                child: Text(
                                  "Expiry Time: ${DateFormat('HH:mm:a').format(poll.endDate)}",
                                  style: AppStyles.heading1(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                                child: SizedBox(
                                  height: FontSizeUtil.CONTAINER_SIZE_30,
                                  child: ElevatedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color(0xff1B5694),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            FontSizeUtil.CONTAINER_SIZE_20),
                                        side: BorderSide(
                                          width: FontSizeUtil.SIZE_01,
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            FontSizeUtil.CONTAINER_SIZE_15,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditPollScreen(
                                            pollId: poll.id,
                                            purpose: poll.voteFor,
                                            navigatorListener: this,
                                            startDate: poll.startDate,
                                            endDate: poll.endDate,
                                            options: poll.options,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      Strings.POLL_EDIT_BUTTON_TEXT,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: FontSizeUtil.CONTAINER_SIZE_10,
                            ),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                                child: SizedBox(
                                  height: FontSizeUtil.CONTAINER_SIZE_30,
                                  child: ElevatedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          226, 182, 36, 36),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            FontSizeUtil.CONTAINER_SIZE_20),
                                        side: const BorderSide(
                                          width: 1,
                                          color:
                                              Color.fromARGB(226, 182, 36, 36),
                                        ),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            FontSizeUtil.CONTAINER_SIZE_15,
                                      ),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.error,
                                                  // Change the icon to error
                                                  size: FontSizeUtil
                                                      .CONTAINER_SIZE_65,
                                                  color: Colors
                                                      .red, // Change the color to red for error
                                                ),
                                                SizedBox(
                                                    height: FontSizeUtil
                                                        .CONTAINER_SIZE_16),
                                                SizedBox(
                                                    height: FontSizeUtil
                                                        .CONTAINER_SIZE_16),
                                                Text(
                                                  Strings
                                                      .DELETE_POLL_CONFIRM_TEXT,
                                                  style: TextStyle(
                                                    color: const Color.fromRGBO(
                                                        27, 86, 148, 1.0),
                                                    fontSize: FontSizeUtil
                                                        .CONTAINER_SIZE_16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                            actions: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: FontSizeUtil
                                                        .CONTAINER_SIZE_30,
                                                    child: ElevatedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  FontSizeUtil
                                                                      .CONTAINER_SIZE_20),
                                                          side: BorderSide(
                                                            width: FontSizeUtil
                                                                .SIZE_01,
                                                          ),
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: FontSizeUtil
                                                              .CONTAINER_SIZE_15,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        _deleteSinglePollData(
                                                            poll.id);
                                                        _deleteOption(poll.id);

                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(Strings.YES_TEXT),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: FontSizeUtil
                                                        .CONTAINER_SIZE_10,
                                                  ),
                                                  SizedBox(
                                                    height: FontSizeUtil
                                                        .CONTAINER_SIZE_30,
                                                    child: ElevatedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  FontSizeUtil
                                                                      .CONTAINER_SIZE_20),
                                                          side: BorderSide(
                                                            width: FontSizeUtil
                                                                .SIZE_01,
                                                          ),
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: FontSizeUtil
                                                              .CONTAINER_SIZE_15,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child:
                                                          const Text(Strings.DELETE_POLL_CANCEL_TEXT),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text(
                                      Strings.POLL_DELETE_BUTTON_TEXT,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: FontSizeUtil.CONTAINER_SIZE_10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    } else {
      content = isLoading
          ? Container()
          : Center(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  Strings.NO_SCHEDULED_POLL_TEXT,
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
        absorbing: isLoading,
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
                  if (selectedIndexes.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                          child: GestureDetector(
                              onTap: () {
                                if (selectedIndexes.isEmpty) {
                                  errorAlert(context, Strings.SELECT_POLL_WARNING_TEXT);
                                } else {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.error,
                                              size: FontSizeUtil
                                                  .CONTAINER_SIZE_65,
                                              color: Colors.red,
                                            ),
                                            SizedBox(
                                                height: FontSizeUtil
                                                    .CONTAINER_SIZE_16),
                                            SizedBox(
                                                height: FontSizeUtil
                                                    .CONTAINER_SIZE_16),
                                            Text(
                                              Strings.DELETE_POLL_CONFIRM_TEXT,
                                              style: TextStyle(
                                                color: const Color.fromRGBO(
                                                    27, 86, 148, 1.0),
                                                fontSize: FontSizeUtil
                                                    .CONTAINER_SIZE_16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: FontSizeUtil
                                                    .CONTAINER_SIZE_30,
                                                child: ElevatedButton(
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromRGBO(
                                                            27, 86, 148, 1.0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(FontSizeUtil
                                                              .CONTAINER_SIZE_20),
                                                      side: const BorderSide(
                                                        width: 1,
                                                      ),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: FontSizeUtil
                                                          .CONTAINER_SIZE_15,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    String result =
                                                        selectedIndexes
                                                            .toString();
                                                    result = result.substring(
                                                        1, result.length - 1);
                                                    print(result);

                                                    _deleteMultipleOption(
                                                        result);

                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(Strings.DELETE_POLL_OK_TEXT),
                                                ),
                                              ),
                                              SizedBox(
                                                width: FontSizeUtil
                                                    .CONTAINER_SIZE_10,
                                              ),
                                              SizedBox(
                                                height: FontSizeUtil
                                                    .CONTAINER_SIZE_30,
                                                child: ElevatedButton(
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              FontSizeUtil.CONTAINER_SIZE_20),
                                                      side:  BorderSide(
                                                        width:  FontSizeUtil.SIZE_01,
                                                      ),
                                                    ),
                                                    padding: EdgeInsets
                                                            .symmetric(
                                                        horizontal:  FontSizeUtil.CONTAINER_SIZE_15,
                                                        ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(Strings.DELETE_POLL_CANCEL_TEXT),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Color.fromARGB(255, 25, 10, 155),
                              )),
                        ),
                      ],
                    ),
                  Expanded(child: content),
                ])),
            if (isLoading) const Positioned(child: LoadingDialog()),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding:  EdgeInsets.only(left:  FontSizeUtil.CONTAINER_SIZE_50),
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

  _deletePollData() {
    voteViewModel1.removeWhere((item) => selectedIndexes.contains(item.id));
    selectedIndexes.clear();
  }

  _deleteSinglePollData(userId) {
    voteViewModel1.removeWhere((item) => userId == item.id);
    selectedIndexes.clear();
  }

  Future<void> _deleteMultipleOption(index) async {
    print("Delete $index");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apartId = prefs.getInt('apartmentId');
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        isLoading = status;

        if (_isNetworkConnected) {
          isLoading = true;
          String responseType = "deleteMultiplePollOptions";

          String deleteVotePollURL =
              '${Constant.deleteMultiplePollURL}?votePollIdList=$index';

          NetworkUtils.deleteNetWorkCall(deleteVotePollURL, responseType, this);
          _deletePollData();
        } else {
          Utils.printLog("else called");
          isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  Future<void> _deleteOption(index) async {
    print("Delete $index");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apartId = prefs.getInt('apartmentId');
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        isLoading = status;

        if (_isNetworkConnected) {
          isLoading = true;
          String responseType = "deletePollOptions";

          String deleteVotePollURL =
              '${Constant.deletePollURL}?votePollId=$index';

          NetworkUtils.deleteNetWorkCall(deleteVotePollURL, responseType, this);
        } else {
          Utils.printLog("else called");
          isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  @override
  onFailure(status) {
    setState(() {
      isLoading = false;
    });
    if (status == 401) {
      Utils.sessonExpired(context);
    } else {
      Utils.showToast(Strings.API_ERROR_MSG_TEXT);
    }
  }

  @override
  onSuccess(response, res) async {
    Utils.printLog("text === $response");

    try {
      setState(() {
        isLoading = false;
      });
      if (res == 'scheduledPoll') {
        Utils.printLog("Succcess === $response");

        List<VoteModel> resolvedIssueList = (json.decode(response) as List)
            .map((item) => VoteModel.fromJson(item))
            .toList();

        setState(() {
          voteViewModel1 = resolvedIssueList;
        });
      } else if (res == "deletePollOptions") {
        ResponceModel responceModel =
            ResponceModel.fromJson(json.decode(response));

        if (responceModel.status == "success") {
          updateSelectedOptionsLength();

          setState(() {
            // options.removeAt(selectedOptionIndex);
          });

          successAlert(
            context,
            responceModel.message!,
          );
        } else {
          errorAlert(
            context,
            responceModel.message!,
          );
        }
        setState(() {
          isLoading = false;
        });
      } else if (res == "deleteMultiplePollOptions") {
        var message = response.toString();
        successAlert(
          context,
          message,
        );
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print("Error 1");
      // errorAlert(
      //   context,
      //   response.toString(),
      // );
    }
  }

  @override
  onNavigatorBackPressed() {
    selectedTileIndex = -1;

    _chooseVoteList();

    _fetchDataFuture = _choose(selectedPollId, selectedPollOption);
  }
}
