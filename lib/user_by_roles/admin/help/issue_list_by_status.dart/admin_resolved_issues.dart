import 'dart:convert';

import 'package:SMP/components/admin_pending_card.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/success_alert.dart';
import 'package:SMP/model/admin_inprogress_issue_model.dart';
import 'package:SMP/model/admin_resolved_issue_model.dart';
import 'package:SMP/model/issue_list_model.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/model/staff_role_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/help/view_issue.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/loader.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Categories {
  final int id;
  final String name;

  Categories({
    required this.id,
    required this.name,
  });
}

class AdminResolvedIssueScreen extends StatefulWidget {
  const AdminResolvedIssueScreen({Key? key}) : super(key: key);

  @override
  State<AdminResolvedIssueScreen> createState() =>
      _AdminResolvedIssueScreenState();
}

class _AdminResolvedIssueScreenState extends State<AdminResolvedIssueScreen>
    with ApiListener, NavigatorListener {
  Future<List>? _futureIssues;

  String baseImageIssueApi = '';
  bool _isNetworkConnected = false, _isLoading = true;
  bool isLoading = true;
  List resolvedListLists = [];

  late int id = 1;
  List originalUsers = [];

  bool showErrorMessage = false;
  bool showUserIDErrorMessage = false;

  Map<int, String> statusMap = {};
  Map<int, String> priorityMap = {};
  List roles = [];

  String issueStatus = '';

  int selectedRoleId = 0;

  void editUserChoice(users) {
    setState(() {
      issueStatus = users.issueStatus.statusName;
    });
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
      navigatorListner: this,
    )));
  }

  final List<MultiSelectItem<Categories>> priorityList = [];
  StaffRoleModel? selectedValue;
  List<AdminResolvedIssueModel> selectedIssues = [];

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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apartId = prefs.getInt('apartmentId');
    var id = prefs.getInt('id');
    try {
      Utils.getNetworkConnectedStatus().then((status) {
        Utils.printLog("network status : $status");
        setState(() {
          _isNetworkConnected = status;
          _isLoading = status;
          if (_isNetworkConnected) {
            String responseType = "pendingIssue";
            String issueStatus = "Resolved";
            String resolvedIssue =
                '${Constant.getAllIssueByAdminURL}?status=$issueStatus&apartmentId=$apartId';
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

          List<AdminResolvedIssueModel> resolvedIssueList =
              (json.decode(response) as List)
                  .map((item) => AdminResolvedIssueModel.fromJson(item))
                  .toList();

          setState(() {
            resolvedListLists = resolvedIssueList;
          });
        }
      });
    } catch (error) {
      Utils.printLog("Error === $response");
    }
  }

  Future<List<AdminResolvedIssueModel>> getList() async {
    List<AdminResolvedIssueModel> filteredList = List.from(resolvedListLists);

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
                    Colors.white,
                    Colors.white,
                  ],
                ),
              ),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 1.450,
                      child: RefreshIndicator(
                        onRefresh: _handleRefresh,
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                SizedBox(
                                    height: FontSizeUtil.CONTAINER_SIZE_15),
                                Expanded(
                                  child: FutureBuilder<List>(
                                    future: _futureIssues,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError ||
                                          snapshot.data == null) {
                                        return Center(
                                          child: Text(
                                            'Error fetching data',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff1B5694),
                                            ),
                                          ),
                                        );
                                      } else {
                                        originalUsers = snapshot.data!;

                                        if (originalUsers.isNotEmpty) {
                                          return Container(
                                            decoration:
                                                AppStyles.decoration(context),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  FontSizeUtil.SIZE_08),
                                              child: PendingIssiesGridViewCard(
                                                press: editUserChoice,
                                                users: originalUsers,
                                                baseImageIssueApi:
                                                    baseImageIssueApi,
                                              ),
                                            ),
                                          );
                                        } else {
                                          return _isLoading
                                              ? Container()
                                              : Center(
                                                  child: Text(
                                                    Strings
                                                        .NO_RESOLVED_ISSUE_TEXT,
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
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            if (_isLoading)
                              const Positioned(child: LoadingDialog()),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: FontSizeUtil.SIZE_10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      //       ),
      //     ),
      //     if (_isLoading) // Display the loader if _isLoading is true
      //       const Positioned(child: LoadingDialog()),
      //   ],
      // ),
    );
  }

  @override
  onNavigatorBackPressed() {
    Navigator.pop(context);
    // // TODO: implement onBackPressed
    // throw UnimplementedError();
  }
}
