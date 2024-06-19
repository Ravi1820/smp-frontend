import 'dart:convert';

import 'package:SMP/components/resident_pending_issue_card.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/model/resolved_issue_model.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/user_by_roles/admin/help/view_issue.dart';
import 'package:SMP/user_by_roles/resident/add_issue.dart';
import 'package:SMP/user_by_roles/resident/resident_raised_issues/view_issue_list.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResidentResolvedIssueScreen extends StatefulWidget {
  const ResidentResolvedIssueScreen({Key? key}) : super(key: key);

  @override
  State<ResidentResolvedIssueScreen> createState() =>
      _ResidentResolvedIssueScreenState();
}

class _ResidentResolvedIssueScreenState
    extends State<ResidentResolvedIssueScreen>
    with ApiListener, NavigatorListener {
  Future<List>? _futureIssues;

  String baseImageIssueApi = '';
  bool _isNetworkConnected = false, _isLoading = true;
  bool isLoading = true;
  List resolvedListLists = [];

  late int id = 1;

  List originalUsers = [];

  void editUserChoice(users) {
    Navigator.of(context).push(createRoute(ViewIssue(
      id: users.id,
      residentPushNotificationToken: users.user.pushNotificationToken ?? "",
      description: users.description ?? "",
      baseImageIssueApi: baseImageIssueApi,
      issueImage: users.picture ?? "",
      issueId: users.issueUniqueId,
      createdTime: users.createdTime ?? "",
      issueCatagory: users.issueCatagory.catagoryName
              .replaceAll("ISSUE_CATAGORY_", "")
              .toLowerCase() ??
          "",
      fullName: users.user.fullName ?? "",
      userId: users.user.id,
      issueStatus: users.issueStatus.statusName
              .replaceAll("ISSUE_STATUS_", "")
              .toLowerCase() ??
          "",
      issuePriority: users.issuePriority.priorityName
              .replaceAll("ISSUE_PRIORITY_", "")
              .toLowerCase() ??
          "",
      issueAssignedBy: users.user.fullName ?? "",
      assignedTo: users.staffTeam.roleName ?? "",
      issueResponce: users.response ?? "",
      navigatorListner:this,
    )));
  }

  void cancelPressed(issue) {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "reopenIssue";

          String isApprovedUrl =
              '${Constant.reOpenIssueURL}?issueId=${issue.id}';

          NetworkUtils.postUrlNetWorkCall(isApprovedUrl, this, responseType);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  List<Value> selectedIssues = [];

  @override
  void initState() {
    super.initState();
    loadIssueData();
    _futureIssues = getList();
  }

  loadIssueData() async {
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
          _isLoading = status;
          if (_isNetworkConnected) {
            String responseType = "pendingIssue";
            String issueStatus = "resolved";

            String resolvedIssue =
                '${Constant.resolvedIssueURL}?status=$issueStatus&apartmentId=$apartId&residentId=$id';

            NetworkUtils.getNetWorkCall(resolvedIssue, responseType, this);
          } else {
            Utils.printLog("else called");
            _isLoading = false;
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

          var jsonResponse = json.decode(response);
          ResolvedIssueModel notice = ResolvedIssueModel.fromJson(jsonResponse);
          if (notice.status == 'success' && notice.value != null) {
            resolvedListLists = [];
            resolvedListLists = notice.value!;
          } else {
            resolvedListLists = [];
          }
        }
        if (responseType == "reopenIssue") {
          ResponceModel responceModel =
              ResponceModel.fromJson(json.decode(response));
          if (responceModel.status == "error") {
            errorAlert(context, responceModel.message!);
            _isLoading = false;
          } else {
            successDialogWithListner(
                context, responceModel.message!, const ViewListScreen(), this);
          }
        }
      });
    } catch (error) {
      Utils.printLog("Error === $response");
    }
  }

  Future<List<Value>> getList() async {
    print("Loading Raised Issue");
    List<Value> filteredList = List.from(resolvedListLists);
    return filteredList;
  }

  Future<void> _handleRefresh() async {
    print("Refreshing");
    loadIssueData();
  }

  bool isopen = false;
  bool isopen1 = false;

  @override
  Widget build(BuildContext context) {
    _futureIssues = getList();
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
                    Color.fromARGB(255, 255, 255, 255),
                    Color.fromARGB(255, 255, 255, 255),
                    Color.fromARGB(255, 255, 255, 255),
                    Color.fromARGB(255, 255, 255, 255),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 1.350,
                      child: RefreshIndicator(
                        onRefresh: _handleRefresh,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Column(
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    FutureBuilder<List>(
                                      future: _futureIssues,
                                      builder: (context, snapshot) {
                                        if (isLoading) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (snapshot.connectionState == ConnectionState.waiting ||
                                            snapshot.hasError ||
                                            snapshot.data == null) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          originalUsers = snapshot.data!;

                                          if (originalUsers.isEmpty) {
                                            return _isLoading
                                                ? Container()
                                                : Center(
                                                    child: Text(
                                                      'There are no issues',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.05,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: const Color(
                                                            0xff1B5694),
                                                      ),
                                                    ),
                                                  );
                                          } else {
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child:
                                                  ResidentPendingIssiesGridViewCard(
                                                press: editUserChoice,
                                                cancelPressed: cancelPressed,
                                                users: originalUsers,
                                                baseImageIssueApi:
                                                    baseImageIssueApi,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                    if (_isLoading)
                                      const Positioned(child: LoadingDialog()),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 50),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(createRoute(AddIssue(navigatorListener: this)));
          },
          backgroundColor: const Color(0xff1B5694),
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  onNavigatorBackPressed() {
    loadIssueData();
  }
}
