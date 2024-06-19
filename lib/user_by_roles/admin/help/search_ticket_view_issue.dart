import 'dart:convert';
import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/profile.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/help/search_issue_tickets.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchTicketViewIssue extends StatefulWidget {
  @override
  SearchTicketViewIssue(
      {super.key,
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
      required this.navigatorListener});

  int id;
  int userId;
  String description;
  String issueId;
  String createdTime;
  String issueResponce;
  String baseImageIssueApi;
  String? issueImage;
  String issueCatagory;
  String issueStatus;
  String issueAssignedBy;
  String issuePriority;
  String fullName;
  String? assignedTo;

  String residentPushNotificationToken;
  NavigatorListener? navigatorListener;

  @override
  State<SearchTicketViewIssue> createState() {
    return _SearchTicketViewIssueState();
  }
}

class _SearchTicketViewIssueState extends State<SearchTicketViewIssue>
    with ApiListener, NavigatorListener {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showEdit = false;
  bool _isNetworkConnected = false, _isLoading = false;

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
  String issueResponce = '';
  String? imageUrl = '';
  String? assignedTo = '';

  TextEditingController actionController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();

    getImage();

    setState(() {
      id = widget.id;

      issueStatus = widget.issueStatus;
      issueCatagory = widget.issueCatagory;
      issuePriority = widget.issuePriority;
      issueAssignedBy = widget.issueAssignedBy;
      issueResponce = widget.issueResponce;
      actionController.text = widget.issueResponce;

      issueId = widget.issueId;
      assignedTo = widget.assignedTo;
      createdTime = widget.createdTime;
      imageUrl = widget.issueImage;

      description = widget.description;
    });
    print(imageUrl);
    print(baseImageIssueApi);
  }

  final status = ['Open', 'In Progress', 'Resolved'];

  String? _selectedStatus;
  getImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('apartmentId');

    setState(() {
      baseImageIssueApi = BaseApiImage.baseImageUrl(id!, "issues");
    });
  }

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
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        children: [
                          Card(
                            margin: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_15),
                            child: Container(
                              decoration: AppStyles.decoration(context),
                              child: Padding(
                                padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: FontSizeUtil.SIZE_05, bottom: FontSizeUtil.SIZE_10),
                                          child: SelectableText(
                                              "${Strings.ISSUE_ID} $issueId",
                                              style:
                                                  AppStyles.heading(context),),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      children: <Widget>[
                                        Container(
                                          height: FontSizeUtil.CONTAINER_SIZE_200,
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.blueGrey,
                                                Colors.blueGrey,
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
                                                    height: FontSizeUtil.CONTAINER_SIZE_200,
                                                    width: double.infinity,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      // Handle image loading errors here
                                                      return Image.asset(
                                                        "assets/images/no-img.png",
                                                        fit: BoxFit.fill,
                                                        height: FontSizeUtil.CONTAINER_SIZE_200,
                                                        width: double.infinity,
                                                      );
                                                    },
                                                  )
                                                else
                                                  Image.asset(
                                                    "assets/images/no-img.png",
                                                    fit: BoxFit.fill,
                                                    height: FontSizeUtil.CONTAINER_SIZE_200,
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
                                              padding: const EdgeInsets.only(
                                                top: 18,
                                              ),
                                              child: Text(Strings.ISSUE_CATAGORY,
                                                  style: AppStyles.heading1(
                                                      context)),
                                            ),
                                            SizedBox(
                                              width: FontSizeUtil.CONTAINER_SIZE_10,
                                              child: Padding(
                                                padding:  EdgeInsets.only(
                                                  top:  FontSizeUtil.SIZE_18,
                                                ),
                                                child: Text(
                                                  issueCatagory
                                                          .substring(0, 1)
                                                          .toUpperCase() +
                                                      issueCatagory
                                                          .substring(1)
                                                          .toLowerCase(),
                                                  style:
                                                      AppStyles.noticeBlockText(
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
                                                top: FontSizeUtil.SIZE_18,
                                              ),
                                              child: Text(Strings.ISSUE_PRIORITY,
                                                  style: AppStyles.heading1(
                                                      context)),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: FontSizeUtil.SIZE_18,
                                              ),
                                              child: Text(
                                                  issuePriority
                                                          .substring(0, 1)
                                                          .toUpperCase() +
                                                      issuePriority
                                                          .substring(1)
                                                          .toLowerCase(),
                                                  style:
                                                      AppStyles.noticeBlockText(
                                                          context)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Table(
                                      children: <TableRow>[
                                        TableRow(
                                          children: <Widget>[
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: FontSizeUtil.SIZE_15,
                                                ),
                                                child: Text(Strings.ISSUE_REPORTED_BY,
                                                    style: headerLeftTitle),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: FontSizeUtil.SIZE_15,
                                                ),
                                                child: Text(issueAssignedBy,
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
                                                  top: FontSizeUtil.SIZE_15,
                                                ),
                                                child: Text(Strings.ISSUE_ASSIGNED_TO,
                                                    style: headerLeftTitle),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: FontSizeUtil.SIZE_15,
                                                ),
                                                child: Text(assignedTo!,
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
                                                  top: FontSizeUtil.SIZE_15,
                                                ),
                                                child: Text(Strings.ISSUE_STATUS,
                                                    style: headerLeftTitle),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: FontSizeUtil.SIZE_10,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    if (!showEdit)
                                                      Text(
                                                        issueStatus
                                                                .substring(0, 1)
                                                                .toUpperCase() +
                                                            issueStatus
                                                                .substring(1)
                                                                .toLowerCase(),
                                                        style: AppStyles
                                                            .noticeBlockText(
                                                                context),
                                                      )
                                                    else
                                                      Stack(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        children: <Widget>[
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      FontSizeUtil.SIZE_10),
                                                              boxShadow: const [
                                                                BoxShadow(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          100,
                                                                          100,
                                                                          100),
                                                                  blurRadius: 6,
                                                                  offset:
                                                                      Offset(
                                                                          0, 2),
                                                                ),
                                                              ],
                                                            ),
                                                            height: FontSizeUtil.CONTAINER_SIZE_50,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2.44,
                                                            child: Padding(
                                                              padding:  EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                  FontSizeUtil.SIZE_08),
                                                              child:
                                                                  DropdownButtonFormField<
                                                                      String>(
                                                                value:
                                                                    _selectedStatus,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                                items: status
                                                                    .asMap()
                                                                    .entries
                                                                    .map(
                                                                        (entry) {
                                                                  final gender =
                                                                      entry
                                                                          .value;
                                                                  return DropdownMenuItem<
                                                                      String>(
                                                                    value:
                                                                        gender,
                                                                    child: Row(
                                                                      children: [
                                                                         SizedBox(
                                                                            width:
                                                                            FontSizeUtil.SIZE_06),
                                                                        Text(
                                                                            gender),
                                                                      ],
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    _selectedStatus =
                                                                        value;
                                                                  });
                                                                },
                                                                hint:
                                                                    const Text(
                                                                  Strings.SELECT_ISSUE_STATUS_TEXT,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    if (!showEdit)
                                                      Container(
                                                        decoration:
                                                            AppStyles.circle1(
                                                                context),
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              showEdit =
                                                                  !showEdit;
                                                            });
                                                          },
                                                          child:  Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    FontSizeUtil.SIZE_03),
                                                            child: Icon(
                                                              Icons.edit,
                                                              color:
                                                                  Colors.white,
                                                              size: FontSizeUtil.SIZE_18,
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
                                        TableRow(
                                          children: <Widget>[
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: FontSizeUtil.CONTAINER_SIZE_10, bottom: FontSizeUtil.SIZE_05),
                                                child: Text(Strings.ISSUE_REPORTED_TIME,
                                                    style: headerLeftTitle),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: FontSizeUtil.CONTAINER_SIZE_10, bottom: FontSizeUtil.SIZE_05),
                                                child: createdTime.isNotEmpty
                                                    ? Text(
                                                        DateFormat(
                                                                'y-MM-dd hh:mm a')
                                                            .format(
                                                          DateTime.parse(
                                                              createdTime),
                                                        ),
                                                        style: AppStyles
                                                            .noticeBlockText(
                                                                context),
                                                      )
                                                    : Text(
                                                        createdTime,
                                                        style: AppStyles
                                                            .noticeBlockText(
                                                                context),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: <Widget>[
                                            TableCell(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    top: FontSizeUtil.CONTAINER_SIZE_10, bottom: FontSizeUtil.SIZE_05),
                                                child: Text(Strings.ISSUE_COMMANT,
                                                    style: headerLeftTitle),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding:  EdgeInsets.only(
                                                    top: FontSizeUtil.CONTAINER_SIZE_10, bottom: FontSizeUtil.SIZE_05),
                                                child: !showEdit
                                                    ? Text(issueResponce,
                                                        style: AppStyles
                                                            .noticeBlockText(
                                                                context))
                                                    : TextFormField(
                                                        controller:
                                                            actionController,
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,

                                                        maxLines: null,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black87),
                                                        decoration:
                                                              InputDecoration(
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  top: FontSizeUtil.CONTAINER_SIZE_15),
                                                          hintText:
                                                              Strings.ISSUE_ACTION_PLACEHOLDER,
                                                          hintStyle: const TextStyle(
                                                              color: Colors
                                                                  .black38),
                                                        ),
                                                      ),
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
                                            top: FontSizeUtil.CONTAINER_SIZE_10,
                                          ),
                                          child: Text(Strings.ISSUE_DESCRIPTION_TEXT,
                                              style:
                                                  AppStyles.heading1(context)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: FontSizeUtil.CONTAINER_SIZE_10,
                                    ),
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          height: FontSizeUtil.CONTAINER_SIZE_100,
                                          width: double.infinity,
                                          decoration:
                                              AppStyles.decoration(context),
                                          child: Padding(
                                            padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                                            child: Text(
                                              description,
                                              style: AppStyles.noticeBlockText(
                                                  context),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                            SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),

                          _selectedStatus != null
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff1B5694),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_15),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: FontSizeUtil.CONTAINER_SIZE_30,
                                      vertical: FontSizeUtil.CONTAINER_SIZE_15,
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (_selectedStatus != null) {
                                      String trimmedOption =
                                          actionController.text.trim();
                                      if (trimmedOption.isNotEmpty) {
                                        Utils.getNetworkConnectedStatus()
                                            .then((status) {
                                          setState(() {
                                            _isNetworkConnected = status;
                                            _isLoading = status;
                                            print(_isNetworkConnected);
                                            if (_isNetworkConnected) {
                                              _isLoading = true;
                                              String responseType =
                                                  "assignTask";
                                              var _selectedIssueStatus = '';
                                              if (_selectedStatus ==
                                                  "In Progress") {
                                                _selectedIssueStatus =
                                                    'InProgress';
                                              } else {
                                                _selectedIssueStatus =
                                                    _selectedStatus!;
                                              }

                                              String loginURL =
                                                  '${Constant.updateIssueStatueURL}?issueId=$id&status=$_selectedIssueStatus&action=$trimmedOption';

                                              NetworkUtils.putUrlNetWorkCall(
                                                  loginURL, this, responseType);
                                            }
                                            else {
                                              _isLoading = false;
                                              Utils.showCustomToast(context);
                                            }
                                          });
                                        });
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: Strings.ISSUE_ACTION_ERROR_MESSAGE,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      }
                                    } else {
                                      Utils.showToast(
                                          Strings.SELECT_ISSUE_STATUS_TEXT1);
                                    }
                                  },
                                  child: const Text(Strings.SAVE_BTN_TEXT,style:TextStyle(color:Colors.white),),
                                )
                              : Container()
                          // );
                        ],
                      ),
                    ),
                  ),
                  //  const SizedBox(height: 80,),
                  const FooterScreen(),
                ],
              ),
            ),
            if (_isLoading) const Positioned(child: LoadingDialog()),
          ],
        ),
      ),
    );
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
        if (responseType == 'assignTask') {
          ResponceModel responceModel =
              ResponceModel.fromJson(json.decode(response));

          if (responceModel.status == "success") {
            successDialogWithListner(context, responceModel.message!,
                const SearchIssueTicket(), this);
          } else {
            Utils.showToast(responceModel.message!);
          }
        }
      });
    } catch (error) {
      Utils.printLog("text === $response");
    }
  }

  @override
  onNavigatorBackPressed() {
    Navigator.pop(context);
    widget.navigatorListener!.onNavigatorBackPressed();
  }
}
