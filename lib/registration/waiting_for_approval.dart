import 'dart:async';
import 'dart:convert';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/success_alert.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/login.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/AlertListener.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/SharedPreferenceUtils.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/loader.dart';
import 'package:SMP/widget/waiting_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:SMP/widget/footers.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/Utils.dart';

class WaitingForApprovalScreen extends StatefulWidget {
  WaitingForApprovalScreen({super.key, required this.isFirstLogin});

  bool isFirstLogin;

  @override
  State<WaitingForApprovalScreen> createState() {
    return _WaitingForApprovalScreen();
  }
}

class _WaitingForApprovalScreen extends State<WaitingForApprovalScreen>
    with NavigatorListener, AlertListener, ApiListener {
  int userId = 0;
  bool _is24HoursExceeded = false;
  Timer? timer;
  Timer? timer1;

  bool _isNetworkConnected = false, _isLoading = true;
  bool _isTimerActive = false;

  @override
  initState() {
    super.initState();
    _getUserProfile();
    _startTimer();
  }

  String _formattedTime() {
    int hours = _secondsRemaining ~/ 3600;
    int minutes = (_secondsRemaining % 3600) ~/ 60;
    int seconds = _secondsRemaining % 60;
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateDate();
    });
    timer1 = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
          timer1?.cancel();
          _isTimerActive = false;
          _is24HoursExceeded = true; // Set the flag when 24 hours are exceeded

          Utils.printLog("_secondsRemaining:$_secondsRemaining");
        } else {
          timer1?.cancel();
          _isTimerActive = false;
        }
      });
    });
    _isTimerActive = true;
  }

  String totalDate = "";
  int _secondsRemaining = 0;

  void _updateDate() {
    setState(() {
      _isLoading = true;
    });

    if (currentDateTime != null && rejectedReason.isEmpty) {
      int differenceInSeconds = Utils.updateDate(currentDateTime!);

      setState(() {
        _secondsRemaining = 86340 - differenceInSeconds;

        if (_secondsRemaining <= 0) {
          _secondsRemaining = 0;
          isButtonEnabled = true;
          timer1?.cancel();
          _isTimerActive = false;
        } else {
          isButtonEnabled = false;
        }
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? currentDateTime = '';
  bool isButtonEnabled = false;
  String rejectedReason = "";
  String rejectedMessage = "";

  _getUserProfile() async {
    try {
      // Fetch data from shared preferences asynchronously
      final currentDateTimes = await SharedPreferenceUtils.getStringValuesSF(
          Strings.CURRENT_DATE_TIME);
      final rejectedReasons = await SharedPreferenceUtils.getStringValuesSF(
          Strings.REJECTED_REASON);
      final rejectedMessages = await SharedPreferenceUtils.getStringValuesSF(
          Strings.REJECTED_MESSAGE);

      Utils.printLog("Registration Time $currentDateTimes");

      setState(() {
        if (currentDateTimes != null) {
          currentDateTime = currentDateTimes;
        }
        if (rejectedReasons != null && rejectedMessages != null) {
          rejectedReason = rejectedReasons;
          rejectedMessage = rejectedMessages;
        }
      });
    } catch (e) {
      Utils.printLog("Error fetching user profile: $e");
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Widget _getRejectedMessage(BuildContext context, String? rejectedMessage) {
      if (rejectedMessage != null && rejectedMessage.isNotEmpty) {
        return Text(
          rejectedMessage,
          style: AppStyles.heading(context),
          textAlign: TextAlign.center,
        );
      } else {
        return Text(
          Strings.APPROVAL_PENDING_TEXT,
          style: AppStyles.heading(context),
        );
      }
    }

    Widget _getRejectedReasonOrApproval(
        BuildContext context, String? rejectedReason, String formattedTime) {
      if (isButtonEnabled) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: FontSizeUtil.SIZE_08),
          child: Text(
            Strings.APPROVAL_PENDING_TEXT01,
            style: AppStyles.blockText(context),
            textAlign: TextAlign.center,
          ),
        );
      }else   if (rejectedReason != null && rejectedReason.isNotEmpty) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Note : ",
              style: AppStyles.heading(context),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                rejectedReason,
                style: AppStyles.redText(context),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      }  else {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: FontSizeUtil.SIZE_08),
            child: Text(
              Utils.getApprovalPendingText(formattedTime),
              style: AppStyles.blockText(context),
              textAlign: TextAlign.center,
            ),
          );
      }
    }

    Function()? goToProfile;
    double height = MediaQuery.of(context).size.height;

    goToProfile = () {};

    return WillPopScope(
      onWillPop: () => _onWillPopScope(context),
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: WaitingAppBar(
            title: Strings.DASHBOARD_HEADER,
            disabled: true,
            logout: () async {
              Utils.showLogoutDialog(context, this);
            },
          ),
        ),
        body: AbsorbPointer(
          absorbing: _isLoading,
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/sppek.jpeg",
                            width: FontSizeUtil.CONTAINER_SIZE_150,
                            height: FontSizeUtil.CONTAINER_SIZE_150,
                            gaplessPlayback: true,
                          ),
                          SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                          _getRejectedMessage(context, rejectedMessage),
                          SizedBox(height: FontSizeUtil.CONTAINER_SIZE_30),
                          _getRejectedReasonOrApproval(
                              context, rejectedReason, _formattedTime()),
                          SizedBox(height: FontSizeUtil.CONTAINER_SIZE_20),
                          if (isButtonEnabled)
                            Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: FontSizeUtil.CONTAINER_SIZE_25,
                                      horizontal:
                                          FontSizeUtil.CONTAINER_SIZE_90),
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _sendNotificationForApproval();
                                        _isLoading = false;
                                      });
                                      FocusScope.of(context).unfocus();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff1B5694),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            FontSizeUtil.CONTAINER_SIZE_15),
                                      ),
                                      padding: EdgeInsets.all(
                                          FontSizeUtil.CONTAINER_SIZE_15),
                                    ),
                                    child: const Text(
                                      Strings.REOSEND_APPROVEAL,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  const FooterScreen(),
                ],
              ),
              if (_isLoading) const Positioned(child: LoadingDialog()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    timer1?.cancel();
    super.dispose();
  }

  Future<bool> _onWillPopScope(BuildContext context) async {
    bool? exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(Strings.WARNING_TEXT),
          content: const Text(Strings.CLOSE_TEXT),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(Strings.NO_TEXT),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                SystemNavigator.pop(); // Close the app
              },
              child: const Text(Strings.YES_TEXT),
            ),
          ],
        );
      },
    );
    return exitApp ?? false;
  }

  _sendNotificationForApproval() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final newOwnerTenantId = prefs.getInt("newOwnerTenantId");

    Utils.getNetworkConnectedStatus().then((status) {
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;

        if (_isNetworkConnected) {
          _isLoading = true;
          String responseType = "assignTask";
          String sendNotificationForApprovalURL =
              '${Constant.sendNotificationForApprovalUrl}?userId=$newOwnerTenantId';
          NetworkUtils.postUrlNetWorkCall(
              sendNotificationForApprovalURL, this, responseType);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  @override
  onNavigatorBackPressed() {}

  @override
  onSuccess(response, String responseType) async {
    try {
      setState(() async {
        if (responseType == "assignTask") {
          _isLoading = false;
          ResponceModel responceModel =
              ResponceModel.fromJson(json.decode(response));
          if (responceModel.status == "success") {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString(Strings.CURRENT_DATE_TIME, responceModel.date!);
            successDialog(context, responceModel.message!, const LoginScreen());
          }
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Utils.printLog("Error === $response");
    }
  }

  @override
  onRightButtonAction(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(Strings.CURRENT_DATE_TIME);
    prefs.remove(Strings.REJECTED_REASON);
    prefs.remove(Strings.REJECTED_MESSAGE);
    Utils.clearLogoutData(context);
  }
}
