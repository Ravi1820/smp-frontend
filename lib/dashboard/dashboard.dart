import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:SMP/components/notices_list.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/contants/error_dialog.dart';
import 'package:SMP/contants/language/ScannerAlertBox.dart';
import 'package:SMP/dashboard/admin_dashboard.dart';
import 'package:SMP/dashboard/back_end_dashboard.dart';
import 'package:SMP/dashboard/securty_dashboard.dart';
import 'package:SMP/dashboard/tenant_dashboard.dart';
import 'package:SMP/model/device_token_model.dart';
import 'package:SMP/model/notice_board_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/AlertListener.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/help/manage_complaints.dart';
import 'package:SMP/user_by_roles/admin/inventory/get_goods_by_date.dart';
import 'package:SMP/user_by_roles/admin/manage_team/management_team_list.dart';
import 'package:SMP/user_by_roles/admin/owner_list/admin_block_list.dart';
import 'package:SMP/user_by_roles/admin/owner_list/admin_resident_list.dart';
import 'package:SMP/user_by_roles/admin/security-lists/security-lists.dart';
import 'package:SMP/user_by_roles/admin/vote_poll/admin_vote_poll.dart';
import 'package:SMP/user_by_roles/resident/add_guest_by_resident.dart';
import 'package:SMP/user_by_roles/resident/fees_type.dart';
import 'package:SMP/user_by_roles/resident/my_visitors/my_visitors_list.dart';
import 'package:SMP/user_by_roles/resident/resident_amenity_management/book_amenity.dart';
import 'package:SMP/user_by_roles/resident/resident_raised_issues/view_issue_list.dart';
import 'package:SMP/user_by_roles/resident/vote_poll.dart';
import 'package:SMP/user_by_roles/security/approval.dart';
import 'package:SMP/user_by_roles/security/approval_list.dart';
import 'package:SMP/user_by_roles/security/global_serach_by_security.dart';
import 'package:SMP/user_by_roles/security/register_visitor.dart';
import 'package:SMP/user_by_roles/security/varify_approval.dart';
import 'package:SMP/user_by_roles/security/visitors_list.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/widget/loader.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/AppDataManager.dart';
import '../presenter/drawer_back_listener.dart';
import '../utils/size_utility.dart';
import 'owner_dashboard.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key, required this.isFirstLogin});

  bool isFirstLogin;

  @override
  State<DashboardScreen> createState() {
    print("isFirstLogin $isFirstLogin");
    return _Dashboard();
  }
}

class _Dashboard extends State<DashboardScreen>
    with
        ApiListener,
        NavigatorListener,
        AlertListener,
        DrawerBackListener,
        WidgetsBindingObserver {
  late Future<http.Response> imageResponse;
  late List data;
  List imagesUrl = [];
  int treatingDoctersList = 0;
  int dutyDoctersList = 0;
  int nurseStationDoctersList = 0;
  bool _isNetworkConnected = false, _isLoading = false;
  Stopwatch? _stopwatch;
  final GlobalKey _gLobalkey = GlobalKey();
  String newSosPin = "";
  String userName = "";
  String userType = "";
  String emailId = '';
  int userId = 0;
  List noticeList = [];
  List allDeviceId = [];
  String restSosPin = "";
  String sosMessage = "";

  bool isFirstLogin = false;

  String _noticeChanged = '';
  String _deviceTokensStored = '';
  String _issueCountChanged = '';
  bool addGuestAllowed =false;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _stopwatch = Stopwatch();

    isFirstLogin = widget.isFirstLogin;
    _getUserProfile();
    _getNoticePushUpdate();

    _getDeviceIdPushUpdate();
    _setSOSPin();
    _choose1();
  }

  _setSOSPin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sosPin = prefs.getString("sosPinNumber");
    newSosPin = sosPin!;
    Utils.printLog("sosPIN stored as $newSosPin");
  }

  Future<void> _checkDeviceTokensStored() async {
    Utils.printLog('deviceTokensStored:${_deviceTokensStored}');
    if (isFirstLogin || _deviceTokensStored == "true") {
      // Otherwise, fetch data from API
      _getAllDeviceId();
    } else {
      Utils.printLog('i am sqflite called from sqlite');
      allDeviceId =
          await appDataManager.databaseHelper.getAllPushNotificationTokens();
      Utils.printLog('allDeviceID from database :${allDeviceId}');
    }
  }

  Future<void> _checkIssueCountChanged() async {
    Utils.printLog('Issue count Changes:${_issueCountChanged}');
    if (isFirstLogin || _issueCountChanged == "true") {
      _getIssueCount();
    } else {
      Utils.printLog('Im From Utils ${FontSizeUtil.ISSUE_COUNT}');
      issueCount = FontSizeUtil.ISSUE_COUNT;
    }
  }

  _getNoticeData() async {
    Utils.printLog(
        "_getNoticeData isFirstLogin:$isFirstLogin noticeChanged:$_noticeChanged");
    if (isFirstLogin || _noticeChanged == 'true') {
      _getNoticeList();
    } else {
      setState(() {
        noticeList = Utils.ALLNOTICES;
      });
    }
  }

  String deviceId = '';

  _choose1() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission();

    final token = await fcm.getToken();
    print(token);
    if (token != null && token.isNotEmpty) {
      setState(() {
        deviceId = token;
      });
    }
  }

  void _startTimer() {
    _stopwatch!.start();
  }

  void _stopTimerAndPrint() {
    _stopwatch!.stop();
    print("Time taken: ${_stopwatch!.elapsedMilliseconds} milliseconds");
  }

  int issueCount = 0;
  int apartmentId = 0;
  String imageUrl = '';
  String profilePicture = '';
  String baseImageIssueApi = '';
  String? apartmentName = '';
  String userName1 = '';
  String mobile = '';
  String address = '';
  String age = '';
  String fullName = '';
  String gender = '';
  String state = '';
  String pinCode = '';
  int? blockCount;

  _getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final roles = prefs.getString(Strings.ROLES);

    var apartId = prefs.getInt(Strings.APARTMENTID);
    final userNam = prefs.getString(Strings.USERNAME);
    final email = prefs.getString(Strings.EMAIL);
    var id = prefs.getInt(Strings.ID);
    var profilePicture = prefs.getString(Strings.PROFILEPICTURE);
    var addGuestAllow = prefs.getBool(Strings.ADDGUESTALLOWED);

    Utils.printLog("UserRoles $roles");
    Utils.printLog("UserApartment $apartmentId");
    Utils.printLog("UserName $userName");
    Utils.printLog("UserPicture $profilePicture");
    Utils.printLog("UserId $id");

    Utils.printLog("User Role Type $userType");

    if (roles == 'ROLE_ADMIN') {
      _getIssueChanged();
    }

    setState(() {
      emailId = email!;
      userName = userNam!;
      blockCount = prefs.getInt(Strings.BLOCKCOUNT);
      apartmentName = prefs.getString(Strings.APARTMENTNAME);
      addGuestAllowed = addGuestAllow!;
      userType = roles!;
      apartmentId = apartId!;
      userId = id!;
      imageUrl = profilePicture!;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> handleDrawerItemTap1(String item) async {
    Utils.printLog(item);
    Utils.printLog(Strings.CONTACT_OWNERS);
    if (item == Strings.CONTACT_OWNERS) {
      Navigator.of(context).push(createRoute(const GlobalSearchBySecurity()));
    }

    if (item == Strings.ASSOCIATION_ADMINISTRATION) {
      Navigator.of(context).push(createRoute(const ManagementTeamList()));
    }

    if (item == Strings.VEHICLE_MANAGEMENT_LABEL) {
      Navigator.of(context).push(createRoute(const ApprovalScreen()));
    }

    if (item == Strings.MANAGE_ISSUES) {
      Navigator.of(context).push(createRoute(const ViewListScreen()));
    }

    if (item == "Society Dues") {
      Navigator.of(context).push(createRoute(const FeesType()));
    }

    if (item == Strings.VISITORS_LIST_LABEL) {
      Navigator.of(context)
          .push(createRoute(VisitorsList(title: "Visitors List")));
    }

    if (item == Strings.ADD_VISITOR) {
      Navigator.of(context)
          .push(createRoute(const RegisterVisitorBySecurity()));
    }

    if (item == Strings.PRE_APPROVAL_ENTRIES) {
      Navigator.of(context).push(createRoute(const CalculatorScreen()));
    }

    if (item == Strings.PRE_APPROVE_GUEST) {
      Navigator.of(context).push(createRoute(const AddGuestByResident()));
    }
    if (item == Strings.PENDING_APPROVAL_LIST) {
      Navigator.of(context).push(createRoute(const ApprovalList()));
    }

    if (item == Strings.MANAGE_RESIDENT || item == Strings.VIEW_RESIDENT) {
      Utils.printLog("block count==$blockCount");
      if (blockCount != null && blockCount! > 2) {
        Navigator.of(context).push(createRoute(const CategoryScreen()));
      } else {
        Navigator.of(context).push(createRoute(AdminResidentListScreen(
          id: 0,
          blockName: "",
          blockCount: blockCount,
          screenName: Strings.DASHBOARD_SCREEN,
        )));
      }
    }
    if (item == Strings.SECUTITY_LIST || item == Strings.MANAGE_STAFF) {
      Navigator.of(context).push(createRoute(const SecurityLists()));
    }

    if (item == Strings.MY_VISITORS) {
      Navigator.of(context).push(createRoute(const MyVisitorsListScreen()));
    }
    if (item == Strings.VIEW_POLLS) {
      Navigator.of(context).push(createRoute(const ResidentVotePollScreen()));
    }

    if (item == Strings.MANAGE_COMPLAINTS) {
      Navigator.of(context).push(createRoute(const ManageComplaints()));
    }

    if (item == Strings.MANAGE_INVENTORARY) {
      Navigator.of(context).push(createRoute(const GetGoodsByDate()));
    }

    if (item == Strings.MANAGE_POLLS) {
      Navigator.of(context).push(createRoute(const AdminVotePollScreen()));
    }

    if (item == Strings.BOOK_AMENITY) {
      Navigator.of(context).push(createRoute(BookAmenity()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Function()? goToProfile;
    double height = MediaQuery.of(context).size.height;
    Function()? sos;
    sos = () async {
      print(allDeviceId);
      _showSoS(
        context,
      );
    };
    goToProfile = () {};
    Widget content = AbsorbPointer(
      absorbing: _isLoading,
      child: const Align(
        alignment: Alignment.center,
        child: Center(
            child: CircularProgressIndicator(
          color: Color.fromARGB(255, 4, 77, 114),
        )),
      ),
    );

    if (userType == Strings.ROLEADMIN_1) {
      content = Padding(
          padding:  EdgeInsets.all(FontSizeUtil.SIZE_08),
          child: AdminDashboard(
              handleDrawerItemTap1: handleDrawerItemTap1,
              issueCount: issueCount));
    }

    if (userType == Strings.ROLESECURITY1) {
      content = Padding(
        padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_12),
        child: SecurityDashboard(handleDrawerItemTap1: handleDrawerItemTap1),
      );
    }
    if (userType == Strings.ROLEOWNER || userType == Strings.ROLETENANT) {
      content = addGuestAllowed? Padding(
        padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_12),
        child: OwnerDashboard(handleDrawerItemTap1: handleDrawerItemTap1),
      ): Padding(
        padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_12),
        child: TenantDashboard(handleDrawerItemTap1: handleDrawerItemTap1),
      );
    }

    return WillPopScope(
      onWillPop: () => _onWillPopScope(context),
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: apartmentName!,
            menuOpen: (userType != "ROLE_SECURITY")
                ? () {
                    _scaffoldKey.currentState!.openDrawer();
                  }
                : null,
            profile: goToProfile,
            disabled: true,
            sos: (userType == "ROLE_FLAT_OWNER" ||
                    userType == "ROLE_FLAT_TENANT")
                ? sos
                : null,

            screen: Strings.DASHBOARD_SCREEN,

            // listener: this,
          ),
        ),
        drawer:
            userType != "ROLE_SECURITY" ? DrawerScreen(listener: this) : null,
        body: AbsorbPointer(
          absorbing: _isLoading,
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(height: height / 3.5, child: content),
                  ),
                  Expanded(
                    flex: 1,
                    child: noticeList.isNotEmpty
                        ? NoticeCard(
                            notificationLists: noticeList,
                          )
                        : _isLoading
                            ? Container() // Show loading indicator while loading
                            : FutureBuilder<void>(
                                future: Future.delayed(const Duration(
                                    seconds:
                                        1)), // Delayed future for 1 seconds
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container(); // Show loading indicator during delay
                                  } else {
                                    return Center(
                                      child: Text(
                                        "No notices",
                                        style: AppStyles.heading(context),
                                      ),
                                    ); // Show "No notices" message after delay
                                  }
                                },
                              ),
                  ),
                  const FooterScreen(),
                ],
              ),
              if (_isLoading) const Positioned(child: LoadingDialog()),
            ],
          ),
        ),
        floatingActionButton: Stack(
          children: [
            userType == "ROLE_SECURITY"
                ? Positioned(
                    bottom: 50,
                    right: 10,
                    child: FloatingActionButton(
                      heroTag: "btn2",
                      onPressed: () {
                        _openAddOptionDialog(context, this);
                      },
                      backgroundColor: const Color(0xff1B5694),
                      foregroundColor: Colors.white,
                      child: const Icon(Icons.qr_code),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget _buildTableRow(String leftText, String rightText) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
            child: Text(
              leftText,
              style: TextStyle(
                color: const Color.fromRGBO(27, 86, 148, 1.0),
                fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Text(":"),
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
            child: Text(
              rightText,
              style: const TextStyle(
                color: Color.fromRGBO(27, 86, 148, 1.0),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openAddOptionDialog(
    BuildContext context,
    NavigatorListener navigatorListner,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                            Strings.SCAN_USER_PROFILE,
                            style: TextStyle(
                              color: const Color.fromRGBO(27, 86, 148, 1.0),
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
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0x3018A7FF),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: const Color(0x8218A7FF),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: QRView(
                        key: _gLobalkey,
                        onQRViewCreated: (QRViewController controller) {
                          navigatorListner.onNavigatorBackPressed();

                          StreamSubscription? scanSubscription;

                          scanSubscription =
                              controller.scannedDataStream.listen((event) {
                            String? scannedData = event.code;
                            Navigator.of(context).pop();

                            navigatorListner.onNavigatorBackPressed();
                            List<String> userDetails = scannedData!.split(',');
                            String passcode = userDetails[0];
                            if (passcode == "12345") {
                              String userName = userDetails[1];
                              String apartName = userDetails[2];
                              if (apartmentName == apartName) {
                                String block = userDetails[3];
                                String flat = userDetails[4];
                                scanSubscription?.cancel();
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            "Resident Details",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 15),
                                          _buildTableRow("Name", userName),
                                          _buildTableRow(
                                              "Apartment", apartName),
                                          _buildTableRow("Block", block),
                                          _buildTableRow("Flat", flat),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.pop(
                                                    context); // Close the dialog
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: const Color.fromRGBO(
                                                      233, 83, 83, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: const Text(
                                                  'Ok',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        255, 255, 255, 1),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                errorAlert(context, "Wrong Apartment");
                                scanSubscription?.cancel();
                              }
                            } else {
                              scannerAlertBox(
                                  context,
                                  "This scanner is used for residents.\n Would you like to redirect to \npre-approval scanner?",
                                  const CalculatorScreen());
                              scanSubscription?.cancel();
                            }

                            scanSubscription?.cancel();
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSoS(BuildContext context) {
    String newOption = '';
    String newOption1 = '';

    String newPin = '';
    String newConfirmPin = '';
    bool showPassword = false;

    bool showResetPassword = false;
    bool showResetConfirmPassword = false;

    final TextEditingController _sosMessageController = TextEditingController();
    final TextEditingController _sosPasswordController =
        TextEditingController();
    final TextEditingController _sosResetPinController =
        TextEditingController();
    final TextEditingController _sosConfirmPinController =
        TextEditingController();

    bool showForgotPin = true;
    String sosPin = "12345";

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(builder: (stfContext, stfSetState) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            content: Container(
              width: 350,
              decoration: AppStyles.decoration(stfContext),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Expanded(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: Text(
                                  'SOS Alert',
                                  style: TextStyle(
                                    color: Color.fromRGBO(27, 86, 148, 1.0),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(stfContext).pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 30,
                                width: 30,
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
                      if (showForgotPin) // Show only if showForgotPin is true

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 10),
                              const Text(
                                'Enter Message',
                                style: TextStyle(
                                  color: Color.fromRGBO(27, 86, 148, 1.0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Stack(
                                alignment: Alignment.centerLeft,
                                children: <Widget>[
                                  const SizedBox(width: 8),
                                  FocusScope(
                                    child: Focus(
                                      onFocusChange: (hasFocus) {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                              // color: boxShadowColor,
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                          border: Border.all(
                                              // color: containerBorderColor1,
                                              ),
                                        ),
                                        height: 50,
                                        child: TextFormField(
                                          controller: _sosMessageController,
                                          keyboardType: TextInputType.multiline,
                                          scrollPadding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom *
                                                  6.10),
                                          maxLines: null,
                                          style: const TextStyle(
                                              color: Colors.black87),
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.only(top: 14),
                                            prefixIcon: Icon(
                                              Icons.description,
                                              color: Color(0xff4d004d),
                                            ),
                                            hintText: 'Enter Message',
                                            hintStyle: TextStyle(
                                                color: Colors.black38),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty ||
                                                value.trim().length <= 1 ||
                                                value.trim().length > 20) {
                                            } else {
                                              return null;
                                            }
                                            return null;
                                          },
                                          onChanged: (value) {
                                            newOption = value;
                                          },
                                          onSaved: (value) {},
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Enter Pin',
                                style: TextStyle(
                                  color: Color.fromRGBO(27, 86, 148, 1.0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Stack(
                                alignment: Alignment.centerLeft,
                                children: <Widget>[
                                  const SizedBox(width: 8),
                                  FocusScope(
                                    child: Focus(
                                      onFocusChange: (hasFocus) {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                              // color: boxShadowColor,
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                          border: Border.all(
                                              // color: containerBorderColor1,
                                              ),
                                        ),
                                        child: TextFormField(
                                          controller: _sosPasswordController,
                                          keyboardType: TextInputType.multiline,
                                          obscureText: !showPassword,
                                          scrollPadding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom *
                                                  6.10),
                                          textInputAction: TextInputAction.done,
                                          style: const TextStyle(
                                              color: Colors.black87),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.only(top: 14),
                                            prefixIcon: const Icon(
                                              Icons.lock,
                                              color: Color(0xff4d004d),
                                            ),
                                            hintText: 'Enter Pin',
                                            hintStyle: const TextStyle(
                                                color: Colors.black38),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                showPassword
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: const Color(0xff4d004d),
                                              ),
                                              onPressed: () {
                                                stfSetState(() {
                                                  showPassword = !showPassword;
                                                });
                                              },
                                            ),
                                          ),
                                          onChanged: (value) {
                                            newOption1 = value;
                                            print("newOption1 $newOption1");
                                            print("newSosPin $newSosPin");
                                            if (newOption1 != newSosPin) {}
                                          },
                                          onSaved: (value) {},
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  stfSetState(() {
                                    showForgotPin = !showForgotPin;
                                    _sosConfirmPinController.text = '';
                                    _sosResetPinController.text = '';
                                  });
                                },
                                child: const Text(
                                  'Forgot Pin  ',
                                  style: TextStyle(
                                    color: Color.fromRGBO(27, 86, 148, 1.0),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 30,
                                    child: ElevatedButton(
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          side: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 0, 123, 255),
                                              width: 2),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 0),
                                      ),
                                      onPressed: () async {
                                        String trimmedOption = newOption.trim();
                                        String trimmedOption1 =
                                            newOption1.trim();

                                        print(trimmedOption1);
                                        Utils.printLog(sosPin);
                                        Utils.printLog(
                                            "newSosPin = $newSosPin");
                                        if (trimmedOption.isNotEmpty) {
                                          if (trimmedOption1 == newSosPin) {
                                            _pushNotificationNetworkCall(
                                                trimmedOption);

                                            Navigator.of(stfContext).pop();
                                            // }
                                          } else {
                                            Utils.showToast(
                                                "Enter valid sos pin");
                                          }
                                        } else {
                                          Utils.showToast(
                                              "Sos message can't be empty ");
                                        }
                                      },
                                      child: const Text("Send"),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ],
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 10),
                              const Text(
                                'Enter Pin',
                                style: TextStyle(
                                  color: Color.fromRGBO(27, 86, 148, 1.0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Stack(
                                alignment: Alignment.centerLeft,
                                children: <Widget>[
                                  const SizedBox(width: 8),
                                  FocusScope(
                                    child: Focus(
                                      onFocusChange: (hasFocus) {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              // color: boxShadowColor,
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                          border: Border.all(
                                              // color: containerBorderColor1,
                                              ),
                                        ),
                                        height: 50,
                                        child: TextFormField(
                                          controller: _sosResetPinController,
                                          // keyboardType: TextInputType.multiline,
                                          obscureText: !showResetPassword,
                                          scrollPadding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom *
                                                  6.10),
                                          style: const TextStyle(
                                              color: Colors.black87),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.only(top: 14),
                                            prefixIcon: const Icon(
                                              Icons.description,
                                              color: Color(0xff4d004d),
                                            ),
                                            hintText: 'Enter Pin',
                                            hintStyle: const TextStyle(
                                                color: Colors.black38),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                showResetPassword
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: const Color(0xff4d004d),
                                              ),
                                              onPressed: () {
                                                stfSetState(() {
                                                  showResetPassword =
                                                      !showResetPassword;
                                                });
                                              },
                                            ),
                                          ),
                                          onChanged: (value) {
                                            newPin = value;
                                          },
                                          onSaved: (value) {},
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Confirm Pin',
                                style: TextStyle(
                                  color: Color.fromRGBO(27, 86, 148, 1.0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Stack(
                                alignment: Alignment.centerLeft,
                                children: <Widget>[
                                  const SizedBox(width: 8),
                                  FocusScope(
                                    child: Focus(
                                      onFocusChange: (hasFocus) {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              // color: boxShadowColor,
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                          border: Border.all(
                                              // color: containerBorderColor1,
                                              ),
                                        ),
                                        child: TextFormField(
                                          controller: _sosConfirmPinController,
                                          // keyboardType: TextInputType.multiline,
                                          scrollPadding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom *
                                                  6.10),
                                          obscureText:
                                              !showResetConfirmPassword,

                                          style: const TextStyle(
                                              color: Colors.black87),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.only(top: 14),
                                            prefixIcon: const Icon(
                                              Icons.lock,
                                              color: Color(0xff4d004d),
                                            ),
                                            hintText: 'Confirm Pin',
                                            hintStyle: const TextStyle(
                                                color: Colors.black38),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                showResetConfirmPassword
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: const Color(0xff4d004d),
                                              ),
                                              onPressed: () {
                                                stfSetState(() {
                                                  showResetConfirmPassword =
                                                      !showResetConfirmPassword;
                                                });
                                              },
                                            ),
                                          ),
                                          onChanged: (value) {
                                            newConfirmPin = value;
                                          },
                                          onSaved: (value) {},
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 30,
                                    child: ElevatedButton(
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          side: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 0, 123, 255),
                                              width: 2),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 0),
                                      ),
                                      onPressed: () async {
                                        String trimmedPin = newPin.trim();
                                        String trimmedConfirmPin =
                                            newConfirmPin.trim();

                                        Utils.printLog(trimmedPin);
                                        Utils.printLog(trimmedConfirmPin);
                                        if (trimmedPin != null &&
                                            trimmedPin.isNotEmpty &&
                                            trimmedPin == trimmedConfirmPin) {
                                          stfSetState(() async {
                                            sosPin = trimmedConfirmPin;
                                            restSosPin = trimmedConfirmPin;
                                            Utils.printLog(
                                                "resetSosPin: $restSosPin");
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setString(
                                                "sosPinNumber", restSosPin);
                                            Utils.printLog("stored already");
                                            showForgotPin = true;
                                            trimmedPin = '';
                                            trimmedConfirmPin = '';
                                            Utils.printLog(
                                                "after clear trimmedPin : $trimmedPin");
                                            Utils.printLog(
                                                "after clear trimmedConfirmPin : $trimmedConfirmPin");
                                            _sosConfirmPinController.clear;
                                            _sosResetPinController.clear;
                                            _setSOSPin();
                                            Utils.showToast(
                                                "Pin reset successfully");
                                            Navigator.pop(stfContext);
                                          });
                                        } else {
                                          Utils.showToast(
                                              "Please re-enter correct PIN");
                                        }
                                      },
                                      child: const Text("Submit pin"),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Future<bool> _onWillPopScope(BuildContext context) async {
    bool? exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Warning !!!"),
          content: const Text("Do you want to close the App?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                SystemNavigator.pop();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
    return exitApp ?? false;
  }

  void _getNoticeList() {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "noticeList";
          _isLoading = true;
          String allNoticeURL =
              '${Constant.notificationURL}?apartmentId=$apartmentId';
          _startTimer(); // Start the timer before making the API call

          NetworkUtils.getNetWorkCall(allNoticeURL, responseType, this);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
        _isLoading = status;
      });
    });
  }

  void _getAllDeviceId() {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;

        if (_isNetworkConnected) {
          String responseType = "allDevice";
          String allDeviceURL =
              '${Constant.allDeviceIdURL}?apartmentId=$apartmentId';
          _startTimer();

          NetworkUtils.getNetWorkCall(allDeviceURL, responseType, this);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  _pushNotificationNetworkCall(visitorId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final userName = prefs.getString(Strings.USERNAME);

    final blockName = prefs.getString(Strings.BLOCK_NAME);
    final flatName = prefs.getString(Strings.FLAT_NAME);
    print(userType);

    print("Resident");

    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd HH:mm a');
    String currentDate = formatter.format(now);
    print(currentDate);

    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        // _isLoading = status;
        if (_isNetworkConnected) {
          // _isLoading = true;
          var responseType = 'push';
          String keyName = "userownerOrTenantDeviceId";
          //
          final Map<String, dynamic> bodyData = <String, dynamic>{
            // "title": "$blockName, $flatName",
            // "message": "$userName, $visitorId",
            // "time": '$currentDate',
            // "sosBlock": blockName,
            // "sosFlat": flatName,
            // "sosUserName": userName,
            // "sosMessage": visitorId,
            // //"action": "SOS"

            "apartmentId": apartmentId,
            "userId": userId,
            "message": visitorId,
            "flat": flatName,
            "blockName": blockName,
            "roleName": "owner",
            "userName": userName
          };

          // final Map<String, dynamic> data = <String, dynamic>{
          // //  "registration_ids": allDeviceId,
          //   "data": bodyData,
          // };
          String partURL = Constant.pushNotificationURL;
          NetworkUtils.pushNotificationWorkCall(
              partURL, keyName, bodyData, this, responseType);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          //  Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
          Utils.showCustomToast(context);
        }
      });
    });
  }

  _getIssueCount() async {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        // _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "issueCount";

          String issueCountURL =
              '${Constant.issuesCountURL}?apartmentId=$apartmentId';
          _startTimer(); // Start the timer before making the API call

          NetworkUtils.getNetWorkCall(issueCountURL, responseType, this);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          //  Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
          Utils.showCustomToast(context);
        }
      });
    });
  }

  @override
  onFailure(status) {
    _stopTimerAndPrint(); // Stop the timer on successful API response

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      setState(() async {
        isFirstLogin = false;
        if (responseType == 'issueCount') {
          issueCount = jsonDecode(response);
          Utils.printLog(
              "previous count :${FontSizeUtil.ISSUE_COUNT} current issue count : ${issueCount}");
          FontSizeUtil.ISSUE_COUNT = issueCount;
          Utils.deleteFile(Strings.ISSUE_COUNT_FILE_NAME);
        } else if (responseType == 'push') {
          _setSOSPin();
          String successCount = response['status'];
          Utils.printLog(" Status : $successCount");
          if (successCount == "success") {
            Utils.printLog('Success count: $response');
            Utils.showToast("SOS sent successfully");
          } else {
            Utils.showToast("SOS not sent  successfully");
          }

          _isLoading = false;
        } else if (responseType == 'noticeList') {
          noticeList = [];
          Utils.ALLNOTICES = [];
          var jsonResponse = json.decode(response);
          _isLoading = false;
          Notice notice = Notice.fromJson(jsonResponse);
          if (notice.status == 'success' && notice.values != null) {
            noticeList = notice.values!;

            Utils.ALLNOTICES = noticeList;
            _noticeChanged = "false";
            Utils.deleteFile(Strings.NOTICE_FILE_NAME);
          }
        } else if (responseType == 'allDevice') {
          await appDataManager.databaseHelper.deleteAllPushNotificationTokens();
          List<DeviceTokenModel> deviceTokens = (json.decode(response) as List)
              .map((item) => DeviceTokenModel.fromJson(item))
              .where((element) => element.pushNotificationToken != null)
              .toList();

          List<String> allDeviceTokens = deviceTokens
              .map((device) => device.pushNotificationToken!)
              .toList();
          print("My Device Id $deviceId");
          allDeviceId =
              allDeviceTokens.where((token) => token != deviceId).toList();

          await appDataManager.databaseHelper
              .storePushNotificationToken(allDeviceId.toString());

          Utils.printLog(
              "Push notification tokens stored successfully: $allDeviceTokens");

          Utils.printLog("Success text === $allDeviceId");
          Utils.deleteFile(Strings.DEVICE_ID_FILE_NAME);
        } else if (responseType == 'logout') {
          Utils.printLog("Success Called on onsuccess response :: $response");
          Utils.clearLogoutData(context);
          await appDataManager.databaseHelper.deleteAllPushNotificationTokens();

          _isLoading = false;
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      if (responseType == 'issueCount') {
        Utils.printLog("Error Getting Issue Count === $response");
      } else if (responseType == 'noticeList') {
        Utils.printLog("Error Notice List === $response");
        _noticeChanged = "false";
        Utils.deleteFile(Strings.NOTICE_FILE_NAME);
      } else if (responseType == 'allDevice') {
        Utils.printLog("Error Getting all Device === $response");
      } else if (responseType == 'userInfo') {
        Utils.printLog("Error Getting User === $response");
      }
    }
  }

  @override
  onNavigatorBackPressed() async {
    Utils.printLog("onNavigatorBackPressed is called");
    _getNoticePushUpdate();
    _checkDeviceTokensStored();
  }

  @override
  onRightButtonAction(BuildContext context) {
    _getNetworkData();
  }

  @override
  onDrawerClosed(BuildContext context) {
    Utils.printLog("Log out button called");
    Utils.showLogoutDialog(context, this);
  }

  void _getNetworkData() {
    Utils.getNetworkConnectedStatus().then((status) {
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        print(_isNetworkConnected);
        if (_isNetworkConnected) {
          _isLoading = true;
          String responseType = "logout";

          String loginURL = '${Constant.logOutURL}?userId=$userId';

          NetworkUtils.postUrlNetWorkCall(loginURL, this, responseType);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          // Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
          Utils.showCustomToast(context);
        }
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    Utils.printLog("Onresume calledstate : $state");
    if (state == AppLifecycleState.resumed) {
      Utils.printLog("Onresume called");
      print('Found in SharedPrefs: ');
      _getNoticePushUpdate();
      _getDeviceIdPushUpdate();
      if (userType == 'ROLE_ADMIN') {
        _getIssueChanged();
      }
    }
  }

  _getNoticePushUpdate() {
    Utils.readCounter(Strings.NOTICE_FILE_NAME).then((value) => {
          Utils.printLog("Dashboard Fire base Notics ${value.toString()}"),
          setState(() {
            _noticeChanged = value.toString();
          }),
          _getNoticeData()
        });
  }

  _getDeviceIdPushUpdate() {
    Utils.readCounter(Strings.DEVICE_ID_FILE_NAME).then((value) => {
          Utils.printLog("Dashboard Fire base Notics ${value.toString()}"),
          setState(() {
            _deviceTokensStored = value.toString();
          }),
          _checkDeviceTokensStored()
        });
  }

  _getIssueChanged() {
    Utils.readCounter(Strings.ISSUE_COUNT_FILE_NAME).then((value) => {
          Utils.printLog("Dashboard Fire base Issues ${value.toString()}"),
          setState(() {
            _issueCountChanged = value.toString();
          }),
          _checkIssueCountChanged()
        });
  }
}
