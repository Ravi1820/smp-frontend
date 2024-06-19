import 'dart:async';
import 'dart:convert';

import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/contants/push_notificaation_key.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/contants/error_dialog.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/user_by_roles/security/button_values.dart';
import 'package:SMP/widget/loader.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with ApiListener, NavigatorListener {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String number1 = ""; // . 0-9
  String operand = ""; // + - * /
  String number2 = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    _smpStorage();
  }

  String? token;
  int? userId;

  TextEditingController controller1 = TextEditingController();
  String data = '';
  final GlobalKey _gLobalkey = GlobalKey();

  QRViewController? controller;
  Barcode? result;
  bool showQRView = false;
  bool scanningInProgress = true; // Initially set to true
  bool apiCallMade = false;


  bool _isNetworkConnected = false, _isLoading = false;

  void _smpStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var id = prefs.getInt('id');

    setState(() {
      token = token!;
      userId = id!;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }


  _addGuestApiByPasscode(passcode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;

        if (_isNetworkConnected) {
          _isLoading = true;
          String responseType = "access";

          String addGuestURL =
              '${Constant.approveBySecurityURL}?passcode=$passcode';

          passcode = NetworkUtils.putUrlNetWorkCall(
            addGuestURL,
            this,
            responseType,
          );
        }
      });
    });
  }


  _addGuestApi(passcode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;

        if (_isNetworkConnected) {
          _isLoading = true;
          String responseType = "access";

          String addGuestURL =
              '${Constant.approveBySecurityURL}?passcode=$passcode';

          passcode = NetworkUtils.putUrlNetWorkCall(
            addGuestURL,
            this,
            responseType,
          );
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
      Utils.printLog("Success text === $response");
      setState(() async {
        if (responseType == 'access') {
          ResponceModel responceModel =
              ResponceModel.fromJson(json.decode(response));
          if (responceModel.status == "success") {
            clearAll();
            successDialogWithListner(context, responceModel.message!,
                const CalculatorScreen(), this);
          } else {
            clearAll();
            errorAlert(
              context,
              responceModel.message!,
            );
          }
          _isLoading = false;
        } else if (responseType == 'accessByPasscode') {
          ResponceModel responceModel =
              ResponceModel.fromJson(json.decode(response));
          if (responceModel.status == "success") {
            clearAll();
            successDialogWithListner(context, responceModel.message!,
                const CalculatorScreen(), this);
          } else {
            clearAll();
            errorAlert(
              context,
              responceModel.message!,
            );
          }
          _isLoading = false;
        }
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      Utils.printLog("Error text === $response");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {

        Navigator.of(context)
            .push(createRoute(DashboardScreen(isFirstLogin: false)));
        // Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: Strings.PPR_APPROVE_ENTRIES_HEADER,
            profile: () async {},
          ),
        ),
        body: AbsorbPointer(
          absorbing: _isLoading,
          child: Stack(
            children: <Widget>[
              Container(
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
                  padding: EdgeInsets.symmetric(vertical: FontSizeUtil.CONTAINER_SIZE_90),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding:  EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                          child: Container(
                            alignment: Alignment.topCenter,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(162, 63, 158, 235),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              border: Border.all(
                                color: const Color.fromARGB(255, 0, 137, 250),
                              ),
                            ),
                            height: FontSizeUtil.CONTAINER_SIZE_60,
                            width: double.infinity,
                            child: Text(
                              "$number1$operand$number2".isEmpty
                                  ? "0"
                                  : "$number1$operand$number2",
                              style:  TextStyle(
                                fontSize: FontSizeUtil.CONTAINER_SIZE_50,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                         SizedBox(
                          height: FontSizeUtil.CONTAINER_SIZE_50,
                        ),
                        Wrap(
                          children: Btn.buttonValues
                              .map(
                                (value) => SizedBox(
                                  width: value == Btn.del
                                      ? screenSize.width / 4
                                      : (screenSize.width / 4),
                                  height: screenSize.width / 6,
                                  child: buildButton(value),
                                ),
                              )
                              .toList(),
                        ),
                        SizedBox(
                          height: FontSizeUtil.CONTAINER_SIZE_20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.03,
                            horizontal: MediaQuery.of(context).size.width * 0.27,
                          ),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              var enteredValue = '$number1$operand$number2';
                              print(enteredValue);
                              if (enteredValue.length == 5) {
                                // Proceed with API call
                                await _addGuestApi(enteredValue);
                              } else {
                                // Show error toast
                                Utils.showToast(Strings.VERIFY_QR_ERROR_TEXT);
                              }

                              // _addGuestApi(enteredValue);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff1B5694),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_15),
                              ),
                              padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.05,
                              ),
                            ),
                            child: Text(
                              Strings.VERIFY_QR_TEXT,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: FontSizeUtil.CONTAINER_SIZE_120,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_isLoading) const Positioned(child: LoadingDialog()),
              const FooterScreen()
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding:  EdgeInsets.only(bottom: FontSizeUtil.CONTAINER_SIZE_30),
          child: FloatingActionButton(
            onPressed: () {
              _openAddOptionDialog(context,this);
            },
            backgroundColor: const Color(0xff1B5694),
            foregroundColor: Colors.white,
            child:  Icon(
              Icons.qr_code,
              size: FontSizeUtil.CONTAINER_SIZE_40,
            ),
          ),
        ),
      ),
    );
  }

  void _openAddOptionDialog(BuildContext context,  NavigatorListener navigatorListner,) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.only(
              // top: MediaQuery.of(context).padding.top + kToolbarHeight,
              // bottom: MediaQuery.of(context).padding.bottom,
              ),
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
                          padding: EdgeInsets.only(left: FontSizeUtil.CONTAINER_SIZE_30),
                          child: Text(
                            Strings.SCAN_QR_TEXT,
                            style: TextStyle(
                              color:const Color.fromRGBO(27, 86, 148, 1.0),
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
                        padding:  EdgeInsets.all(FontSizeUtil.SIZE_08),
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
                      borderRadius: BorderRadius.circular(FontSizeUtil.SIZE_05),
                      border: Border.all(
                        color: const Color(0x8218A7FF),
                        width: FontSizeUtil.SIZE_03,
                      ),
                    ),
                    child: Center(
                      child:


                      QRView(
                        key: _gLobalkey,
                        onQRViewCreated: (QRViewController controller) {
                          navigatorListner.onNavigatorBackPressed();

                          StreamSubscription? scanSubscription;

                          scanSubscription =
                              controller.scannedDataStream.listen((event) {
                                String? scannedData = event.code;
                                Navigator.of(context).pop();
                                navigatorListner.onNavigatorBackPressed();
                                if (scannedData !=null && scannedData.isNotEmpty) {
                                  scanSubscription?.cancel();
                                  _addGuestApiByPasscode(event.code);
                                } else {
                                  errorAlert(context, "You are not a valid user");
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

  Widget buildButton(value) {
    return Padding(
      padding: EdgeInsets.all(FontSizeUtil.SIZE_04),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white24,
          ),
          borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_100),
        ),
        child: InkWell(
          onTap: () => {
            onBtnTap(value),
          },
          child: Center(
            child: Text(
              value,
              style:  TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: FontSizeUtil.CONTAINER_SIZE_25,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.clr) {
      clearAll();
      return;
    }

    appendValue(value);
  }

  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  void delete() {
    if (number2.isNotEmpty) {
      // 12323 => 1232
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }

    setState(() {});
  }

  void appendValue(String value) {
    // Check if the value is numeric
    if (int.tryParse(value) == null) {
      // Handle non-numeric input
      if (operand.isNotEmpty && number2.isNotEmpty) {
        // Handle operation when both operands are present
      }
      operand = value; // Set operand
    } else if (number1.isEmpty || operand.isEmpty) {
      // Append value to number1 if it's empty or if operand is not set
      if (number1.length < 5) {
        // Check if number1 length is less than 5
        number1 += value;
      }
    } else if (number2.isEmpty || operand.isNotEmpty) {
      // Append value to number2 if it's empty or if operand is set
      if (number2.length < 5) {
        // Check if number2 length is less than 5
        if ((number2.isEmpty || number2 == Btn.n0)) {
          value = "0.";
        }
        number2 += value;
      }
    }

    setState(() {}); // Update the UI
  }

  Color getBtnColor(value) {
    return [Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.del,
          ].contains(value)
            ? Colors.orange
            : const Color.fromARGB(221, 0, 119, 255);
  }

  @override
  onNavigatorBackPressed() {
    clearAll();
  }
}
