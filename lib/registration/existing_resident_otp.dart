import 'dart:async';
import 'dart:convert';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/model/api_responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/registration/existing_owner_registration.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/loader.dart';
import 'package:SMP/widget/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ExistingOwnerRegistrationOTPScreen extends StatefulWidget {
  const ExistingOwnerRegistrationOTPScreen({
    super.key,
    required this.userId,
    required this.apartmentId,
    required this.emailId,
  });

  final int userId;
  final int? apartmentId;
  final String emailId;

  @override
  State<ExistingOwnerRegistrationOTPScreen> createState() {
    return _ExistingOwnerRegistrationOTPScreenState();
  }
}

class _ExistingOwnerRegistrationOTPScreenState
    extends State<ExistingOwnerRegistrationOTPScreen> with ApiListener {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController textEditingController = TextEditingController();
  bool _isLoading = false;
  late Timer _timer;
  int _secondsRemaining = 300;

  bool _isNetworkConnected = false, isLoading = true;

  bool _isTimerActive = false;

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    _startTimer();
    getData();

    super.initState();
  }

  int apatmentId = 0;
  String email = '';
  int userId = 0;

  getData() {
    setState(() {
      apatmentId = widget.apartmentId!;
      email = widget.emailId;
      userId = widget.userId;
    });
  }

  @override
  void dispose() {
    setState(() {
      errorController!.close();
      _timer.cancel();
      textEditingController.clear();
      currentText='';
    });
    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // String _formattedTime() {
  //   int minutes = _secondsRemaining ~/ 60;
  //   int seconds = _secondsRemaining % 60;
  //   return 'OTP will expiry in  $minutes:${seconds.toString().padLeft(2, '0')} minutes';
  // }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
          _isTimerActive = false;
        }
      });
    });
    _isTimerActive = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(kToolbarHeight),
      //   child: CustomAppBar(
      //     title: 'OTP Validation',
      //     menuOpen: () {
      //       _scaffoldKey.currentState!.openDrawer();
      //     },
      //     disabled: true,

      //     // profile: () {},
      //   ),
      // ),
      body: AbsorbPointer(
        absorbing: _isLoading,
        child: GestureDetector(
          onTap: () {},
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: <Widget>[
                    const SizedBox(height: 30),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 5,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: const LogoScreen()),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: Text(
                        'OTP Verification',
                        style: AppStyles.heading(context),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 8),
                      child: RichText(
                        text: const TextSpan(
                          text: Strings.ENTER_OTP_CODE,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 30,
                        ),
                        child: PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                          length: 5,

                          blinkWhenObscuring: true,
                          animationType: AnimationType.fade,

                          pinTheme: PinTheme(


                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular( FontSizeUtil.SIZE_05),
                            fieldHeight:  FontSizeUtil.CONTAINER_SIZE_50,
                            fieldWidth:  FontSizeUtil.CONTAINER_SIZE_40,

                            activeFillColor: Colors.white,
                            inactiveFillColor: const Color(0xFFEFEDED),
                            inactiveColor: const Color.fromARGB(255, 44, 44, 44),
                            // disabledActiveFillColor: Colors.grey,
                            selectedFillColor: Colors.lightGreen,
                          ),
                          cursorColor: Colors.black,
                          animationDuration: const Duration(milliseconds: 300),
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: textEditingController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly,
                            LengthLimitingTextInputFormatter(
                                5),
                          ],
                          boxShadows: const [
                            BoxShadow(
                              offset: Offset(0, 1),
                              color: Colors.black12,
                              blurRadius: 10,
                            )
                          ],
                          onCompleted: (v) {
                            debugPrint("Completed");
                          },
                          // onTap: () {
                          //   print("Pressed");
                          // },
                          onChanged: (value) {
                            debugPrint(value);
                            setState(() {
                              currentText = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            debugPrint("Allowing to paste $text");
                            return true;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        hasError ? "*Please ender the valid OTP" : "",
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: _isTimerActive
                          ? Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    // _formattedTime(),
                                    "OTP will expiry in $_secondsRemaining seconds",
                                    style: AppStyles.heading1(context),
                                  ),
                                ),
                              ],
                            )
                          : GestureDetector(
                              onTap: _isLoading
                                  ? null // Disable button when loading
                                  : () async {
                                      setState(() {
                                        _isLoading = true;
                                      });

                                      _verifyEmailData();
                                    },
                              child: _isLoading
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Resend",
                                          style: AppStyles.disabled(context),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Resend",
                                          style: AppStyles.heading1(context),
                                        ),
                                      ],
                                    ),
                            ),
                    ),
                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 30),
                          decoration: BoxDecoration(
                              color: Colors.green.shade300,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.green.shade200,
                                    offset: const Offset(1, -2),
                                    blurRadius: 5),
                                BoxShadow(
                                    color: Colors.green.shade200,
                                    offset: const Offset(-1, 2),
                                    blurRadius: 5)
                              ]),
                          child: ButtonTheme(
                            height: 50,
                            child: TextButton(
                              onPressed: () {
                                formKey.currentState!.validate();
                                if (currentText.length != 5) {
                                  errorController!.add(ErrorAnimationType.shake);
                                  setState(() => hasError = true);
                                } else {
                                  setState(
                                    () {
                                      hasError = false;

                                      _registerOtpData();
                                    },
                                  );
                                }
                              },
                              child: const Center(
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (_isLoading) // Display the loader if _isLoading is true
                          const Positioned(child: LoadingDialog()),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                          child: TextButton(
                            child: const Text("Clear"),
                            onPressed: () {
                              textEditingController.clear();
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const FooterScreen()
            ],
          ),
        ),
      ),
    );
  }

  void _verifyEmailData() {
    Utils.getNetworkConnectedStatus().then((status) {
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        print(_isNetworkConnected);
        if (_isNetworkConnected) {
          _isLoading = true;
          String responseType = "verifyEmail";

          String loginURL =
              '${Constant.verifyEmailURL}?email=$email&apartmentId=$apatmentId';

          NetworkUtils.postUrlNetWorkCall(loginURL, this, responseType);
        }
        else {
          Utils.printLog("else called");
          _isLoading = false;
          // Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
          Utils.showCustomToast(context);
        }
      });
    });
  }

  void _registerOtpData() {
    Utils.getNetworkConnectedStatus().then((status) {
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        print(_isNetworkConnected);
        if (_isNetworkConnected) {
          _isLoading = true;
          String responseType = "verifyOtp";

          String loginURL =
              '${Constant.verifyOtpURL}?userId=$userId&otp=$currentText';

          NetworkUtils.getNetWorkCall(loginURL, responseType, this);
        }
        else {
          Utils.printLog("else called");

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
    if(status==401){
      Utils.sessonExpired(context);
    }else{
    Utils.showToast(Strings.API_ERROR_MSG_TEXT);
    }
  }

  @override
  onSuccess(response, responseType) async {
    Utils.printLog("text === $response");
    setState(() {
      _isLoading = false;
    });
    try {
      if (responseType == 'verifyOtp') {
        print("verify email");
        ApiResponceModel responceModel =
            ApiResponceModel.fromJson(json.decode(response));
        if (responceModel.status == "error") {
          errorAlert(
            context,
            "error",
          );
        } else {
           print("verify email else part");
          Navigator.of(context).push(createRoute(
            ExistingOwnerRegistrationScreen(
              userName: responceModel.value!.fullName!,
              email: responceModel.value!.emailId,
              apatmentId: apatmentId,
            ),
          ));
        }

        //   var res = jsonDecode(response);
        //   var message = res['successMessage'];
        //   _secondsRemaining = 300;
        //   _startTimer();

        //   if (message == "Please enter valid email") {
        //     errorAlert(
        //       context,
        //       message,
        //     );
        //   } else {
        //     Fluttertoast.showToast(
        //       msg: message,
        //       toastLength: Toast.LENGTH_SHORT,
        //       gravity: ToastGravity.CENTER,
        //       timeInSecForIosWeb: 1,
        //       backgroundColor: Colors.green,
        //       textColor: Colors.white,
        //       fontSize: 16.0,
        //     );
        //   }
        // } else if (responseType == 'verifyOtp') {
        //   // Check if the response is a String
        //   if (response is String) {
        //     // Convert the String to a Map
        //     Map<String, dynamic> responseMap = json.decode(response);
        //     UserModel loginModel = UserModel.fromJson(responseMap);
        //     print(loginModel.fullName);

        //     Fluttertoast.showToast(
        //       msg: "Congratulations",
        //       toastLength: Toast.LENGTH_SHORT,
        //       gravity: ToastGravity.CENTER,
        //       timeInSecForIosWeb: 1,
        //       backgroundColor: Colors.green,
        //       textColor: Colors.white,
        //       fontSize: 16.0,
        //     );

        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => ExistingOwnerRegistrationScreen(
        //             userName: loginModel.fullName,
        //             email: loginModel.emailId,
        //             apatmentId: apatmentId),
        //       ),
        //     );
        //   } else if (response is Map<String, dynamic>) {
        //     // If response is already a Map, directly parse it
        //     UserModel loginModel = UserModel.fromJson(response);
        //     print(loginModel.fullName);

        //     Fluttertoast.showToast(
        //       msg: "Congratulations",
        //       toastLength: Toast.LENGTH_SHORT,
        //       gravity: ToastGravity.CENTER,
        //       timeInSecForIosWeb: 1,
        //       backgroundColor: Colors.green,
        //       textColor: Colors.white,
        //       fontSize: 16.0,
        //     );
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => ExistingOwnerRegistrationScreen(
        //           userName: loginModel.fullName,
        //           email: loginModel.emailId,
        //           apatmentId: apatmentId,
        //         ),
        //       ),
        //     );
        //   } else {
        //     // Handle unexpected response type
        //     print("Unexpected response type: ${response.runtimeType}");
        //   }
      } else {}
    } catch (error) {
      print("Error parsing JSON: $error");
    }
  }
}
