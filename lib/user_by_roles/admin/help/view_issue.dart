import 'dart:convert';

import 'package:SMP/contants/base_api.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/profile.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/drawer.dart';

import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../contants/constant_url.dart';
import '../../../contants/error_alert.dart';
import '../../../contants/success_dialog.dart';
import '../../../model/responce_model.dart';
import '../../../network/NetworkUtils.dart';
import '../../../presenter/navigator_lisitner.dart';
import '../../../utils/Strings.dart';
import '../../resident/resident_raised_issues/view_issue_list.dart';

class ViewIssue extends StatefulWidget {
  @override
  ViewIssue({
    super.key,
    required this.id,
    required this.issueId,
    required this.description,
    required this.issueCatagory,
    required this.userId,
    required this.fullName,
    required this.issueStatus,
    required this.issuePriority,
    required this.issueAssignedBy,
    required this.issueImage,
    required this.residentPushNotificationToken,
    required this.baseImageIssueApi,
    required this.createdTime,
    required this.assignedTo,
    required this.issueResponce,
    required this.navigatorListner,
  });

  int id;
  int userId;
  String description;
  String issueId;
  String createdTime;
  String baseImageIssueApi;
  String? issueImage;
  String issueCatagory;
  String issueStatus;
  String issueAssignedBy;
  String issuePriority;
  String fullName;
  String? assignedTo;
  String? issueResponce;

  String residentPushNotificationToken;
  NavigatorListener navigatorListner;

  @override
  State<ViewIssue> createState() {
    return _ViewIssue();
  }
}

class _ViewIssue extends State<ViewIssue> with ApiListener, NavigatorListener {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // bool _isLoading = false;
  int id = 0;
  String description = '';
  String issueCatagory = '';
  String issueStatus = '';
  String issuePriority = '';
  String issueAssignedBy = '';
  String baseImageIssueApi = '';
  String issueId = '';
  String createdTime = '';
  bool _isNetworkConnected = false, _isLoading = false;
  String? imageUrl = '';
  String? assignedTo = '';
  String? issueResponce = '';
  String? role;
  String? _selectedPriority;
  final Color _containerBorderColor1 = Colors.white;
  final Color _boxShadowColor1 = const Color.fromARGB(255, 100, 100, 100);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();

    getImage();
    loadIssueData();

    setState(() {
      id = widget.id;

      issueStatus = widget.issueStatus;
      issueCatagory = widget.issueCatagory;
      issuePriority = widget.issuePriority;
      issueAssignedBy = widget.issueAssignedBy;
      issueResponce = widget.issueResponce;
      issueId = widget.issueId;
      assignedTo = widget.assignedTo;
      createdTime = widget.createdTime;
      imageUrl = widget.issueImage;

      description = widget.description;
    });
    if (role != "ROLE_ADMIN" && issueStatus == "resolved") {
      _getAllPriority();
    }
  }

  loadIssueData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var roles = prefs.getString(Strings.ROLES);

    Utils.printLog(roles!);

    setState(() {
      role = roles!;
    });
  }

  getImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apartmentId = prefs.getInt('apartmentId');

    setState(() {
      baseImageIssueApi = BaseApiImage.baseImageUrl(apartmentId!, "issues");

      Utils.printLog(baseImageIssueApi);
    });
  }

  void cancelPressed(priorityId) {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "reopenIssue";

          String isApprovedUrl =
              '${Constant.reOpenIssueURL}?issueId=$id&priorityId=$priorityId';

          NetworkUtils.postUrlNetWorkCall(isApprovedUrl, this, responseType);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  Map<int, String> priorityList = {};

  void _getAllPriority() {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;

        if (_isNetworkConnected) {
          String responseType = "allRole";
          NetworkUtils.getNetWorkCall(
              Constant.getAllPriorityRoleURL, responseType, this);
        } else {
          Utils.printLog("else called");
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
        } else if (responseType == "allRole") {
          setState(() {
            _isLoading = false;
          });
          setState(() {
            final Map<String, dynamic> data = jsonDecode(response);

            Map<int, String> resultMap = {};

            data.forEach((key, value) {
              resultMap[int.parse(key)] = value;
            });
            priorityList = resultMap;
          });
        }
      });
    } catch (error) {
      Utils.printLog("Error === $response");
    }
  }

  List<String> userTypes = [
    'Status',
    'Priority',
  ];

  String selectedUserType = 'Status';

  bool showErrorMessage = false;
  bool showUserIDErrorMessage = false;

  void updateUserType(String newUserType) {
    setState(() {
      selectedUserType = newUserType;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle headerLeftTitle = TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.04,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      color: const Color(0xff1B5694),
    );
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: Strings.VIEW_ISSUE_HEADER,
            profile: () {
              Navigator.of(context).push(createRoute(const UserProfile()));
            },
          ),
        ),
        // drawer: const DrawerScreen(),
        backgroundColor: Colors.white,
        body: AbsorbPointer(
          absorbing: _isLoading,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Card(
                              margin: EdgeInsets.all(
                                  FontSizeUtil.CONTAINER_SIZE_15),
                              child: Container(
                                decoration: AppStyles.decoration(context),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      FontSizeUtil.CONTAINER_SIZE_10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: FontSizeUtil.SIZE_05,
                                                bottom: FontSizeUtil
                                                    .CONTAINER_SIZE_10),
                                            child: SelectableText(
                                                "${Strings.ISSUE_ID}$issueId",
                                                style:
                                                    AppStyles.heading(context)),
                                          ),
                                        ],
                                      ),
                                      Stack(
                                        children: <Widget>[
                                          Container(
                                            height:
                                                FontSizeUtil.CONTAINER_SIZE_200,
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.blueGrey,
                                                  Colors.blueGrey,
                                                  // Add more colors as needed
                                                ],
                                              ),
                                            ),
                                            child: ClipRRect(
                                              child: Stack(
                                                children: <Widget>[
                                                  if (imageUrl != null &&
                                                      imageUrl!.isNotEmpty)
                                                    Image.network(
                                                      '$baseImageIssueApi${imageUrl.toString()}',
                                                      fit: BoxFit.fitWidth,
                                                      height: FontSizeUtil
                                                          .CONTAINER_SIZE_200,
                                                      width: double.infinity,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Image.asset(
                                                          "assets/images/no-img.png",
                                                          fit: BoxFit.fill,
                                                          height: FontSizeUtil
                                                              .CONTAINER_SIZE_200,
                                                          width:
                                                              double.infinity,
                                                        );
                                                      },
                                                    )
                                                  else
                                                    Image.asset(
                                                      "assets/images/no-img.png",
                                                      fit: BoxFit.fill,
                                                      height: FontSizeUtil
                                                          .CONTAINER_SIZE_200,
                                                      width: double.infinity,
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: FontSizeUtil
                                                      .CONTAINER_SIZE_18,
                                                ),
                                                child: Text(
                                                    Strings.ISSUE_CATAGORY,
                                                    style: AppStyles.heading1(
                                                        context)),
                                              ),
                                              SizedBox(
                                                width: FontSizeUtil
                                                    .CONTAINER_SIZE_110,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: FontSizeUtil
                                                        .CONTAINER_SIZE_18,
                                                  ),
                                                  child: Text(
                                                    issueCatagory
                                                            .substring(0, 1)
                                                            .toUpperCase() +
                                                        issueCatagory
                                                            .substring(1)
                                                            .toLowerCase(),
                                                    style: AppStyles
                                                        .noticeBlockText(
                                                            context),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: FontSizeUtil
                                                      .CONTAINER_SIZE_18,
                                                ),
                                                child: Text(
                                                    Strings.ISSUE_PRIORITY,
                                                    style: AppStyles.heading1(
                                                        context)),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: FontSizeUtil
                                                      .CONTAINER_SIZE_18,
                                                ),
                                                child: Text(
                                                    issuePriority
                                                            .substring(0, 1)
                                                            .toUpperCase() +
                                                        issuePriority
                                                            .substring(1)
                                                            .toLowerCase(),
                                                    style: AppStyles
                                                        .noticeBlockText(
                                                            context)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Table(
                                        columnWidths: const {
                                          0: FlexColumnWidth(2),
                                          1: FlexColumnWidth(3),
                                        },
                                        children: <TableRow>[
                                          TableRow(
                                            children: <Widget>[
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: FontSizeUtil
                                                        .CONTAINER_SIZE_15,
                                                  ),
                                                  child: Text(
                                                      Strings
                                                          .ISSUE_REPORTED_BY_1,
                                                      style: headerLeftTitle),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: FontSizeUtil
                                                        .CONTAINER_SIZE_15,
                                                  ),
                                                  child: Text(
                                                      ': $issueAssignedBy',
                                                      style: AppStyles
                                                          .noticeBlockText(
                                                              context)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: FontSizeUtil
                                                        .CONTAINER_SIZE_15,
                                                  ),
                                                  child: Text(
                                                      Strings.ISSUE_ASSIGNED_TO,
                                                      style: headerLeftTitle),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: FontSizeUtil
                                                        .CONTAINER_SIZE_15,
                                                  ),
                                                  child: Text(
                                                      ': ${assignedTo!}',
                                                      style: AppStyles
                                                          .noticeBlockText(
                                                              context)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: FontSizeUtil
                                                        .CONTAINER_SIZE_15,
                                                  ),
                                                  child: Text("Status",
                                                      style: headerLeftTitle),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: FontSizeUtil
                                                        .CONTAINER_SIZE_15,
                                                  ),
                                                  child: Text(
                                                      ': ${issueStatus.substring(0, 1).toUpperCase()}${issueStatus.substring(1).toLowerCase()}',
                                                      style: AppStyles
                                                          .noticeBlockText(
                                                              context)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: FontSizeUtil
                                                          .CONTAINER_SIZE_10,
                                                      bottom:
                                                          FontSizeUtil.SIZE_05),
                                                  child: Text(
                                                      Strings
                                                          .ISSUE_REPORTED_TIME,
                                                      style: headerLeftTitle),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: FontSizeUtil
                                                            .CONTAINER_SIZE_10,
                                                        bottom: FontSizeUtil
                                                            .SIZE_05),
                                                    child: createdTime
                                                            .isNotEmpty
                                                        ? Text(
                                                            ': ${DateFormat('y-MM-dd hh:mm a').format(DateTime.parse(createdTime))}',
                                                            style: AppStyles
                                                                .noticeBlockText(
                                                                    context))
                                                        : Text(
                                                            ': ${createdTime}',
                                                            style: AppStyles
                                                                .noticeBlockText(
                                                                    context))),
                                              ),
                                            ],
                                          ),
                                          if (issueResponce!.isNotEmpty)
                                            TableRow(
                                              children: <Widget>[
                                                TableCell(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: FontSizeUtil
                                                            .CONTAINER_SIZE_10,
                                                        bottom: FontSizeUtil
                                                            .SIZE_05),
                                                    child: Text(
                                                        Strings.ISSUE_COMMANT,
                                                        style: headerLeftTitle),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10, bottom: 5),
                                                    child: Text(
                                                        ': ${issueResponce!}',
                                                        style: AppStyles
                                                            .noticeBlockText(
                                                                context)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: FontSizeUtil
                                                  .CONTAINER_SIZE_18,
                                            ),
                                            child: Text(
                                                Strings.ISSSUE_DESCRIPTION_TEXT,
                                                style: AppStyles.heading1(
                                                    context)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: FontSizeUtil.CONTAINER_SIZE_10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          height:
                                              FontSizeUtil.CONTAINER_SIZE_100,
                                          width: double.infinity,
                                          decoration:
                                              AppStyles.decoration(context),
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                FontSizeUtil.SIZE_08),
                                            child: Text(
                                              description,
                                              style: AppStyles.noticeBlockText(
                                                  context),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                            if (role != "ROLE_ADMIN" &&
                                issueStatus == "resolved" && priorityList.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: FontSizeUtil.SIZE_08),
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
                                            FontSizeUtil.CONTAINER_SIZE_10,
                                      ),
                                    ),
                                    onPressed: () {
                                      _openAddOptionDialog(
                                        context,
                                        _boxShadowColor1,
                                        _containerBorderColor1,
                                      );
                                    },
                                    child: const Text(
                                        Strings.REOPEN_ISSUE_BUTTON_TEXT),
                                  ),
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                    const FooterScreen(),
                  ],
                ),
              ),
              if (_isLoading) // Display the loader if _isLoading is true
                const Positioned(child: LoadingDialog()),
            ],
          ),
        ),
      ),
    );
  }

  void _openAddOptionDialog(
      BuildContext context, containerBorderColor1, boxShadowColor) {
    String newOption = '';
    bool isSaveButtonDisabled = true; // Track the state of the "Save" button

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: Container(
            width: FontSizeUtil.CONTAINER_SIZE_350,
            decoration: AppStyles.decoration(context),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: FontSizeUtil.CONTAINER_SIZE_30),
                              child: Text(
                                Strings.REOPEN_ISSUE_POP_UP_TEXT,
                                style: TextStyle(
                                  color: Color.fromRGBO(27, 86, 148, 1.0),
                                  fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                            child: Container(
                              height: FontSizeUtil.CONTAINER_SIZE_30,
                              width: FontSizeUtil.CONTAINER_SIZE_30,
                              decoration: AppStyles.circle1(context),
                              child: const Icon(
                                Icons.close_sharp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: FontSizeUtil.CONTAINER_SIZE_18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                          Text(
                            Strings.ISSUE_SELECT_PRIORITY_TEXT,
                            style: TextStyle(
                              color: const Color.fromRGBO(27, 86, 148, 1.0),
                              fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      FontSizeUtil.CONTAINER_SIZE_10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 100, 100, 100),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                height: FontSizeUtil.CONTAINER_SIZE_50,
                                child: DropdownButtonFormField<String>(
                                  value: _selectedPriority,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.accessibility),
                                  ),
                                  items: priorityList.entries.map((entry) {
                                    final gender = entry.value;
                                    return DropdownMenuItem<String>(
                                      value: gender,
                                      child: Row(
                                        children: [
                                          SizedBox(width: FontSizeUtil.SIZE_06),
                                          Text(gender),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedPriority = value;
                                    });
                                  },
                                  hint: const Text(
                                    Strings.ISSUE_SELECT_PRIORITY_TEXT,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: FontSizeUtil.CONTAINER_SIZE_30,
                                child: ElevatedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          FontSizeUtil.CONTAINER_SIZE_20),
                                      side: const BorderSide(
                                          color:
                                              Color.fromARGB(255, 0, 123, 255),
                                          width: 2),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          FontSizeUtil.CONTAINER_SIZE_15,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_selectedPriority != null) {
                                      int selectedPriorityId = 0;

                                      if (_selectedPriority == "High") {
                                        selectedPriorityId = 1;
                                      } else if (_selectedPriority ==
                                          "Medium") {
                                        selectedPriorityId = 2;
                                      } else if (_selectedPriority == "Low") {
                                        selectedPriorityId = 3;
                                      }
                                      print(
                                          "_selectedPriority ${selectedPriorityId}");
                                      cancelPressed(selectedPriorityId);
                                      Navigator.pop(context);
                                    } else {
                                      Utils.showToast(
                                          Strings.SELECT_PRIORITY_ERROR_TEXT);
                                    }

                                  },
                                  child: const Text(Strings.SUBMIT_TEXT),
                                ),
                              ),
                              SizedBox(width: FontSizeUtil.CONTAINER_SIZE_10),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  onNavigatorBackPressed() {
    Navigator.pop(context);
    widget.navigatorListner.onNavigatorBackPressed();
  }
}
