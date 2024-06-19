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
import 'package:SMP/user_by_roles/admin/my_approval/my_approval.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewTenantOwnerScreen extends StatefulWidget {
  @override
  ViewTenantOwnerScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.emailId,
    required this.mobile,
    required this.status,
    required this.screen,
    required this.documentImage,

    // blockName: user.blockName,
    //           // "flatId": 5,
    //           flatNumber: user.flatNumber,
    required this.flatNumber,
    required this.blockName,
    required this.navigatorListener,
    required this.role,
    // required this.issueAssignedBy,
    // required this.issueImage,
    // required this.residentPushNotificationToken,
    // required this.baseImageIssueApi,
    // required this.createdTime,
    // required this.assignedTo,
    // required this.issueResponce,
  });

  int userId;

  // int userId;
  String? userName;
  String? emailId;
  String? screen;
  String? mobile;
  String? role;
  String? documentImage;

  String status;
  String? flatNumber;
  String blockName;
  NavigatorListener? navigatorListener;

  // String issueAssignedBy;
  // String issuePriority;
  // String fullName;
  // String? assignedTo;
  // String? issueResponce;

  // String residentPushNotificationToken;

  @override
  State<ViewTenantOwnerScreen> createState() {
    return _ViewTenantOwner();
  }
}

class _ViewTenantOwner extends State<ViewTenantOwnerScreen>
    with ApiListener, NavigatorListener {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
  String status = '';

  String? imageUrl = '';
  String? mobile = '';
  String? emailId = '';

  String? userName = '';
  String? flatNumber = '';
  String? blockName = '';
  String? documentImage = '';
String? role = '';
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();

    getImage();

    setState(() {
      documentImage = widget.documentImage;

      flatNumber = widget.flatNumber;
      blockName = widget.blockName;

      //  issueCatagory=    userName
      userName = widget.userName;
      emailId = widget.emailId;
      mobile = widget.mobile;
      status = widget.status;

      role = widget.role;

    });
    print(imageUrl);
    print(baseImageIssueApi);
  }

  getImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apartmentId = prefs.getInt('apartmentId');

    setState(() {
      baseImageIssueApi = BaseApiImage.baseImageUrl(apartmentId!, "profile");
    });
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
            title: 'Registration Details',
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
                              margin: const EdgeInsets.all(15),
                              child: Container(
                                decoration: AppStyles.decoration(context),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5, bottom: 10),
                                            child: SelectableText(
                                                "Name : $userName",
                                                style:
                                                    AppStyles.heading(context)),
                                          ),
                                        ],
                                      ),


                                      Stack(
                                        children: <Widget>[
                                          Container(
                                            height: 200,
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
                                                  if (documentImage != null &&
                                                      documentImage!.isNotEmpty)
                                                    Image.network(
                                                      '$baseImageIssueApi${documentImage.toString()}',
                                                      fit: BoxFit.fitWidth,
                                                      height: 200,
                                                      width: double.infinity,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        // Handle image loading errors here
                                                        return Image.asset(
                                                          "assets/images/no-img.png",
                                                          fit: BoxFit.fill,
                                                          height: 200,
                                                          width: double.infinity,
                                                        );
                                                      },
                                                    )
                                                  else
                                                    Image.asset(
                                                      "assets/images/no-img.png",
                                                      fit: BoxFit.fill,
                                                      height: 200,
                                                      width: double.infinity,
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),


                                      Table(

                                        columnWidths:const {
                                          0: FlexColumnWidth(1.9),
                                          1: FlexColumnWidth(4),

                                        },
                                        children: <TableRow>[
                                          TableRow(
                                            children: <Widget>[
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                    top: 18,
                                                  ),
                                                  child: Text("Role",
                                                      style: headerLeftTitle),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                    top: 15,
                                                  ),
                                                  child: Text(role!,
                                                      style: AppStyles.noticeHeader1(
                                                          context)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                    top: 15,
                                                  ),
                                                  child: Text("Email ",
                                                      style: headerLeftTitle),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                    top: 15,
                                                  ),
                                                  child: Text(emailId!,
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
                                                  padding: const EdgeInsets.only(
                                                    top: 15,
                                                  ),
                                                  child: Text("Phone ",
                                                      style: headerLeftTitle),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                    top: 15,
                                                  ),
                                                  child: Text(mobile!,
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
                                                  padding: const EdgeInsets.only(
                                                    top: 15,
                                                  ),
                                                  child: Text("Flat Number ",
                                                      style: headerLeftTitle),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                    top: 15,
                                                  ),
                                                  child: Text(flatNumber!,
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
                                                  padding: const EdgeInsets.only(
                                                    top: 15,
                                                  ),
                                                  child: Text("Block Name",
                                                      style: headerLeftTitle),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                    top: 15,
                                                  ),
                                                  child: Text(blockName!,
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
                                                  padding: const EdgeInsets.only(
                                                    top: 15,
                                                  ),
                                                  child: Text("Status",
                                                      style: headerLeftTitle),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                    top: 15,
                                                  ),
                                                  child: Text(status!,
                                                      style: AppStyles
                                                          .noticeBlockText(
                                                          context)),
                                                ),
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (widget.screen == "current")
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: SizedBox(
                                        height: 30,
                                        child: ElevatedButton(
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: const Color.fromARGB(
                                                211, 38, 209, 38),
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              side: const BorderSide(
                                                width: 1,
                                                color: Color.fromARGB(
                                                    211, 38, 209, 38),
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 0),
                                          ),
                                          onPressed: () {
                                            // setState(() {
                                            //   securityDeviceToken = notifications[index]
                                            //       .securityDeviceToken;

                                            //   residentName =
                                            //       notifications[index].residentName;

                                            //   visitorName = notifications[index].name;
                                            // });

                                            // var userId =
                                            //     notifications[index].user.id;
                                            var userId = widget.userId;

                                            _approveRejectNetworkCall(
                                                'approve', userId);
                                          },
                                          child: const Text("Approve"),
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
                                            backgroundColor: const Color.fromARGB(
                                                226, 182, 36, 36),
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              side: const BorderSide(
                                                width: 1,
                                                color: Color.fromARGB(
                                                    226, 182, 36, 36),
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 0),
                                          ),
                                          onPressed: () {
                                            // var userId = notifications[index].userid;
                                            var userId = widget.userId;

                                            _approveRejectNetworkCall(
                                                'reject', userId);
                                          },
                                          child: const Text("Reject"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const FooterScreen(),
                  ],
                ),
              ),
              if (_isLoading) const Positioned(child: LoadingDialog()),
            ],
          ),
        ),
      ),
    );
  }

  _approveRejectNetworkCall(var isApproved, var notificationId) async {
    print(isApproved);
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "isApproved";
          String isApprovedUrl =
              '${Constant.approvedRejectURL}?userId=${notificationId}&status=$isApproved';

          NetworkUtils.postUrlNetWorkCall(isApprovedUrl, this, responseType);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
        //  Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
          Utils.showCustomToast(context);
          print( Utils.showCustomToast(context));
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
        if (responseType == "isApproved") {
          _isLoading = false;
          ResponceModel responceModel =
              ResponceModel.fromJson(json.decode(response));
          if (responceModel.status == "success") {
            successDialogWithListner(context, responceModel.message!,
                const ResidentMyApprovalList(), this);
          } else {
            Utils.showToast(responceModel.message!);
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

  @override
  onNavigatorBackPressed() {
    Navigator.pop(context);
    widget.navigatorListener!.onNavigatorBackPressed();
  }
}
