import 'dart:convert';

import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/contants/base_api.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/model/vote_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/resident/vote_poll.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/view_model/smp_view_model.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ResidentActiveVotePollScreen extends StatefulWidget {
  const ResidentActiveVotePollScreen({Key? key}) : super(key: key);

  @override
  State<ResidentActiveVotePollScreen> createState() =>
      _ResidentActiveVotePollScreenState();
}

class _ResidentActiveVotePollScreenState
    extends State<ResidentActiveVotePollScreen>
    with ApiListener, NavigatorListener {
  Map<String, double> percentageMap = {};
  List<Map<String, dynamic>> combinedOptions = [];
  int? selectedTileIndex;
  bool _isNetworkConnected = false, _isLoading = true;
  String? token;
  int? userId;

  int selected = 0;

  List activePollLists = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();
    _getALlActiveVote();
  }

  Future<void> _getALlActiveVote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apartId = prefs.getInt('apartmentId');
    var id = prefs.getInt('id');

    try {
      Utils.getNetworkConnectedStatus().then((status) {
        Utils.printLog("network status : $status");
        setState(() {
          userId = id;

          _isNetworkConnected = status;
          _isLoading = status;
          if (_isNetworkConnected) {
            String responseType = "activePoll";

            String resolvedIssue =
                '${Constant.residentActivePollURL}?apartmentId=$apartId&userId=$id';
            NetworkUtils.getNetWorkCall(resolvedIssue, responseType, this);
          } else {
            Utils.printLog("else called");
            _isLoading = false;
            Utils.showCustomToast(context);
          }
        });
      });

    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }

  }

  Future<void> _choose(int valueID, List<dynamic> formattedOptions) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    final percentageUrl = Uri.parse(
        '${Constant.baseUrl}smp/resident/getPercentageOfVote?pollId=$valueID');

    print(percentageUrl);
    final percentageResponse = await http.get(
      percentageUrl,
      headers: {
        'Authorization': 'Bearer $token', // Add token to the headers
      },
    );

    if (percentageResponse.statusCode == 200) {
      final percentageBody = jsonDecode(percentageResponse.body);
      print(percentageBody);

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
        print(combinedOptions);
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

  String? selectedOption;

  final selectedIndexes = [];

  Future<void>? _fetchDataFuture;

  @override
  Widget build(BuildContext context) {
    // final voteListLists = Provider.of<SmpListViewModel>(context);

    Widget content;

    if (activePollLists.isNotEmpty) {
      content = Container(
          height: MediaQuery.of(context).size.height - kToolbarHeight,
          child: ListView.builder(
            key: Key('builder ${selectedTileIndex.toString()}'),
            shrinkWrap: false,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: activePollLists.length,
            itemBuilder: (context, index) {
              final user = activePollLists[index];

              return Padding(
                padding:  EdgeInsets.all( FontSizeUtil.SIZE_08),
                child: Container(
                  decoration: AppStyles.decoration(context),
                  child: Column(children: <Widget>[
                    ExpansionTile(
                      key: Key(index.toString()),
                      initiallyExpanded: index == selectedTileIndex,
                      title: Text(
                        user.voteFor,
                        style: const TextStyle(
                          color: Color.fromRGBO(27, 86, 148, 1.0),
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onExpansionChanged: (bool isExpanded) {
                        if (isExpanded) {
                          setState(() {
                            selectedIndexes.clear();
                            selectedOption = null;

                            selectedTileIndex = index;
                            _fetchDataFuture = _choose(user.id, user.options);
                          });
                        } else {
                          setState(() {
                            selectedTileIndex = -1;
                            _fetchDataFuture = null;
                            selectedIndexes.clear();
                            selectedOption = null;
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
                                    height:  FontSizeUtil.SIZE_10,
                                    width:  FontSizeUtil.SIZE_10,
                                    child:const CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: combinedOptions.length,
                                  itemBuilder: (context, index) {
                                    final option =
                                        combinedOptions[index]['option'];

                                    final percentage =
                                        combinedOptions[index]['percentage'];
                                    final hasVotedForOption = user.voted &&
                                        option == user.responseMsg;

                                    print(
                                        "responce Messafe ==${user.responseMsg}");
                                    print("combinedOptions ==$option");
                                    print("responce voted ==${user.voted}");

                                    return Padding(
                                      padding: EdgeInsets.all( FontSizeUtil.SIZE_08),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (!user.voted) {
                                              selectedIndexes.clear();
                                              selectedOption = null;
                                              selectedIndexes.add(index);
                                              selectedOption =
                                                  combinedOptions[index]
                                                      ['option'];
                                            } else {
                                              final votedOptionIndex =
                                                  combinedOptions.indexWhere(
                                                      (opt) =>
                                                          opt['option'] ==
                                                          user.responseMsg);
                                              if (index != votedOptionIndex) {
                                                _showChangeVoteConfirmationDialog(
                                                  selectedOption =
                                                      combinedOptions[index]
                                                          ['option'],
                                                  user.id,
                                                  userId,
                                                );
                                              } else {
                                                _showAlreadyVoteConfirmationDialog();
                                              }
                                            }
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(16.0),
                                          height: 60,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.blue),
                                            borderRadius:
                                                BorderRadius.circular(FontSizeUtil.SIZE_10),
                                            gradient: LinearGradient(
                                              colors: [
                                                getColorForPercentage(
                                                    percentage),
                                                Colors.transparent,
                                              ],
                                              stops: [
                                                percentage / 100,
                                                percentage / 100
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Radio<int>(
                                                value: index,
                                                groupValue: user.voted
                                                    ? combinedOptions
                                                        .indexWhere((opt) =>
                                                            opt['option'] ==
                                                            user.responseMsg)
                                                    : selectedIndexes.isNotEmpty
                                                        ? selectedIndexes.first
                                                        : null,
                                                onChanged: user.voted
                                                    ? (value) {
                                                        user.voted ==
                                                                combinedOptions
                                                                    .indexWhere((opt) =>
                                                                        opt['option'] ==
                                                                        user.responseMsg)
                                                            ? _showChangeVoteConfirmationDialog(
                                                                selectedOption =
                                                                    combinedOptions[
                                                                            value ??
                                                                                0]
                                                                        [
                                                                        'option'],
                                                                user.id,
                                                                userId,
                                                              )
                                                            : null;
                                                      }
                                                    : (value) {
                                                        setState(() {
                                                          selectedIndexes
                                                              .clear();
                                                          selectedOption = null;

                                                          selectedIndexes
                                                              .add(value ?? 0);
                                                          selectedOption =
                                                              combinedOptions[
                                                                      value ??
                                                                          0]
                                                                  ['option'];
                                                        });
                                                      },
                                                activeColor:
                                                    const Color.fromARGB(
                                                        255, 14, 16, 160),
                                              ),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                              child: Text(
                                "Expiry Date: ${DateFormat('y-MM-dd hh:mm a').format(user.endDate)}",
                                style: AppStyles.heading1(context),
                              ),
                            ),
                          ],
                        ),
                        if (!user.voted)
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
                                        backgroundColor: const Color.fromARGB(
                                            211, 38, 209, 38),
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_20),
                                          side:  BorderSide(
                                            width: FontSizeUtil.SIZE_01,
                                            color:const Color.fromARGB(
                                                211, 38, 209, 38),
                                          ),
                                        ),
                                        padding:  EdgeInsets.symmetric(
                                            horizontal: FontSizeUtil.CONTAINER_SIZE_15,),
                                      ),
                                      onPressed: () {
                                        if (selectedOption != null &&
                                            !user.voted) {
                                          _showConfirmationDialog(
                                            selectedOption!,
                                            user.id,
                                            userId,
                                          );
                                        } else {
                                          errorAlert(context,
                                              "Please select an option.");
                                        }
                                      },
                                      child: const Text("Vote",style: TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ),
                               SizedBox(
                                width: FontSizeUtil.CONTAINER_SIZE_10,
                              ),
                              Center(
                                child: Padding(
                                  padding:  EdgeInsets.all(FontSizeUtil.SIZE_08),
                                  child: SizedBox(
                                    height: FontSizeUtil.CONTAINER_SIZE_30,
                                    child: ElevatedButton(
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            226, 182, 36, 36),
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_20),
                                          side:  BorderSide(
                                            width: FontSizeUtil.SIZE_01,
                                            color:const Color.fromARGB(
                                                226, 182, 36, 36),
                                          ),
                                        ),
                                        padding:  EdgeInsets.symmetric(
                                            horizontal: FontSizeUtil.CONTAINER_SIZE_15),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          // isExpanded = !isExpanded;
                                          selectedTileIndex = null;
                                          selectedIndexes.clear();
                                          selectedOption = null;
                                        });
                                      },
                                      child: const Text("Ignore",style: TextStyle(color: Colors.white),),
                                    ),
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

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .push(createRoute(DashboardScreen(isFirstLogin: false)));
        return false;
      },
      child: Scaffold(
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
                child: Column(children: [Expanded(child: content)]),
              ),
              if (_isLoading) Positioned(top: FontSizeUtil.CONTAINER_SIZE_100, child: LoadingDialog()),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog(
      String selectedOption, pollId, userId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Icon(
                Icons.question_mark,
                size: FontSizeUtil.CONTAINER_SIZE_65,
                color: Colors.green,
              ),
               SizedBox(height: FontSizeUtil.CONTAINER_SIZE_16),
              const Text(
                'Confirmation',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: FontSizeUtil.CONTAINER_SIZE_16),
              Text(
                'Are you sure,\n you want to vote for \n$selectedOption?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:const Color.fromRGBO(27, 86, 148, 1.0),
                  fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: FontSizeUtil.CONTAINER_SIZE_30,
                    child: ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(211, 38, 209, 38),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_20),
                          side:  BorderSide(
                            width: FontSizeUtil.SIZE_01,
                            color: Color.fromARGB(211, 38, 209, 38),
                          ),
                        ),
                        padding:  EdgeInsets.symmetric(
                            horizontal: FontSizeUtil.CONTAINER_SIZE_15, ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);

                        _addVote(userId, pollId, selectedOption);
                      },
                      child: const Text("Yes",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
                 SizedBox(
                  width: FontSizeUtil.CONTAINER_SIZE_10,
                ),
                Center(
                  child: SizedBox(
                    height: FontSizeUtil.CONTAINER_SIZE_30,
                    child: ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(226, 182, 36, 36),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_20),
                          side:  BorderSide(
                            width: FontSizeUtil.SIZE_01,
                            color:const  Color.fromARGB(226, 182, 36, 36),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: FontSizeUtil.CONTAINER_SIZE_15,),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("No",style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  _addVote(userId, pollId, selectedOption) {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;

        if (_isNetworkConnected) {
          _isLoading = true;
          String responseType = "addVote";

          String addGuestURL =
              '${Constant.addVoteByOwnerURL}?userId=$userId&votePollId=$pollId&vote=$selectedOption';

          NetworkUtils.putUrlNetWorkCall(
            addGuestURL,
            this,
            responseType,
          );
        }
        else{
          print("else called");
          _isLoading =false;
          Utils.showCustomToast(context);

        }
      });
    });
  }

  _updateVote(userId, pollId, selectedOption) {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;

        if (_isNetworkConnected) {
          _isLoading = true;
          String responseType = "editVote";

          String addGuestURL =
              '${Constant.editVoteByOwnerURL}?userId=$userId&votePollId=$pollId&vote=$selectedOption';

          NetworkUtils.putUrlNetWorkCall(
            addGuestURL,
            this,
            responseType,
          );
        }
        else{
          print("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
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
        if (responseType == 'activePoll') {
          List<VoteModel> resolvedIssueList = (json.decode(response) as List)
              .map((item) => VoteModel.fromJson(item))
              .toList();

          // setState(() {
          activePollLists = resolvedIssueList;
          // });
        } else if (responseType == 'addVote') {
          _isLoading = false;

          ResponceModel responceModel =
              ResponceModel.fromJson(json.decode(response));

          Utils.printLog("Success text === $responceModel");

          if (responceModel.status == "success") {
            successDialogWithListner(context, responceModel.message!,
                const ResidentVotePollScreen(), this);
          } else {
            errorAlert(
              context,
              responceModel.message!,
            );
          }
        } else if (responseType == 'editVote') {
          _isLoading = false;

          ResponceModel responceModel =
              ResponceModel.fromJson(json.decode(response));

          Utils.printLog("Success text === $responceModel");

          if (responceModel.status == "success") {
            successDialogWithListner(context, responceModel.message!,
                const ResidentVotePollScreen(), this);
          } else {
            errorAlert(
              context,
              responceModel.message!,
            );
          }
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      Utils.printLog("Error text === $response");
    }
  }

  Future<void> _showAlreadyVoteConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.warning,
                size: 64,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              Text(
                'You have already voted, \nyou cannot vote same post again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(27, 86, 148, 1.0),
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: 30,
                    child: ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(211, 38, 209, 38),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: const BorderSide(
                            width: 1,
                            color: Color.fromARGB(211, 38, 209, 38),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        // _updateVote(userId, pollId, selectedOption);
                      },
                      child: const Text("Okay",style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _showChangeVoteConfirmationDialog(
      String selectedOption, pollId, userId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.question_mark,
                size: 64,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              const Text(
                'Confirmation',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'You have already voted, \nDo you want to change your vote to \n$selectedOption',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(27, 86, 148, 1.0),
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: 30,
                    child: ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(211, 38, 209, 38),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: const BorderSide(
                            width: 1,
                            color: Color.fromARGB(211, 38, 209, 38),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _updateVote(userId, pollId, selectedOption);
                      },
                      child: const Text("Yes",style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Center(
                  child: SizedBox(
                    height: 30,
                    child: ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(226, 182, 36, 36),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: const BorderSide(
                            width: 1,
                            color: Color.fromARGB(226, 182, 36, 36),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 0),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("No",style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  onNavigatorBackPressed() {
    selectedTileIndex = -1;
    _getALlActiveVote();

    // _fetchDataFuture = _choose(selectedPollId, selectedPollOption);
  }
}
