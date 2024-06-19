import 'dart:convert';

import 'package:SMP/components/admin_pending_card.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/model/resolved_issue_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/user_by_roles/admin/help/view_issue.dart';
import 'package:SMP/user_by_roles/resident/add_issue.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResidentPendingIssueScreen extends StatefulWidget {
  const ResidentPendingIssueScreen({Key? key}) : super(key: key);

  @override
  State<ResidentPendingIssueScreen> createState() =>
      _ResidentPendingIssueScreenState();
}

class _ResidentPendingIssueScreenState extends State<ResidentPendingIssueScreen>
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
            String issueStatus = "open";

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

          //
          // List<ResolvedIssueModel> resolvedIssueList =
          // (json.decode(response) as List)
          //     .map((item) => ResolvedIssueModel.fromJson(item))
          //     .toList();
          //
          // setState(() {
          //   resolvedListLists = resolvedIssueList;
          // });

          var jsonResponse = json.decode(response);
          ResolvedIssueModel notice = ResolvedIssueModel.fromJson(jsonResponse);
          if (notice.status == 'success' && notice.value != null) {
            resolvedListLists = notice.value!;
          }

          // List<ResolvedIssueModel> resolvedIssueList =
          //     (json.decode(response) as List)
          //         .map((item) => ResolvedIssueModel.fromJson(item))
          //         .toList();
          //
          // setState(() {
          //   resolvedListLists = resolvedIssueList;
          // });
        }
      });
    } catch (error) {
      Utils.printLog("Error === $response");
    }
  }

  Future<List<Value>> getList() async {
    print("Loading Raised Issue");
    List<Value> filteredList = List.from(resolvedListLists);
// print
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
                                        } else if (snapshot.connectionState ==
                                                ConnectionState.waiting ||
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
                                              child: PendingIssiesGridViewCard(
                                                press: editUserChoice,
                                                users: originalUsers,
                                                baseImageIssueApi:
                                                    baseImageIssueApi,
                                                // selectedIssues: selectedIssues
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                    if (_isLoading) // Display the loader if _isLoading is true
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
            // Navigator.of(context).push(createRoute(const AddIssue()));
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

// class ResidentAllResolvedOption extends StatefulWidget {
//   final BuildContext context;
//   final int? userId;

//   const ResidentAllResolvedOption({
//     Key? key,
//     required this.context,
//     required this.userId,
//   }) : super(key: key);

//   @override
//   State<ResidentAllResolvedOption> createState() =>
//       _ResidentAllResolvedOptionState();
// }

// class _ResidentAllResolvedOptionState extends State<ResidentAllResolvedOption>
  

//     return

// }
