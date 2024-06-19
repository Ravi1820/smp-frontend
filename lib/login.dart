import 'dart:convert';

import 'package:SMP/contants/error_dialog.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/registration/waiting_for_approval.dart';
import 'package:SMP/user_by_roles/admin/verify_password.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/model/api_responce_model.dart';
import 'package:SMP/model/login_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/registration/email_verification.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/loader.dart';
import 'package:SMP/widget/logo.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/contants/translate.dart';
import 'package:SMP/forgot_password/forget_password.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _Login();
  }
}

class _Login extends State<LoginScreen> with ApiListener {
  List<String> userTypes = ['Resident', 'Admin', 'Back-end'];

  bool _isNetworkConnected = false, _isLoading = false;
  String? _selectedUserRole;

  bool showErrorMessage = false;
  bool showUserIDErrorMessage = false;
  bool showUserPhoneMessage = false;
  String? sosPin;


  bool showPassword = false;
  final roles = ['Admin', 'Resident', 'Security'];

  final _formKey = GlobalKey<FormState>();
  Color _containerBorderColor = Colors.white;
  Color _boxShadowColor = const Color.fromARGB(255, 100, 100, 100);
  Color _containerBorderColor1 = Colors.white;
  Color _boxShadowColor1 = const Color.fromARGB(255, 100, 100, 100);
  String? _apartmentNameErrorMessage;
  var _enteredPassword = '';
  var _enteredEmailId = '';

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  var deviceId = '';

  @override
  initState() {
    super.initState();

    _choose1();
  }

  //  var _enteredPassword = '';
  var _enteredCurrentPassword = '';

  bool showEmailErrorMessage = false;
  bool showPasswordErrorMessage = false;
  bool showConfirmErrorMessage = false;
  bool showCurrentPasswordErrorMessage = false;

  bool showCurrentPassword = false;

  bool showConfiremPassword = false;
  var _enteredConfirmPassword = '';

  var _enteredPhoneNumber = '';
  final TextEditingController emailAddressController = TextEditingController();

  _choose1() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission();

    final token = await fcm.getToken();
    print(token);
    if (token != null && token.isNotEmpty) {
      setState(() {
        deviceId = token;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.getString("email");

      if (email != null && email.isNotEmpty) {
        setState(() {
          emailAddressController.text = email;
        });
      }
    }
  }

  _sosPin() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
        sosPin = prefs.getString("sosPinNumber");
     if(sosPin !=null && sosPin!.isNotEmpty){
         Utils.printLog("sosPIn in LoginScreen : $sosPin");
      }
     else{
       prefs.setString("sosPinNumber","12345");
      // sosPin = prefs.getString("sosPinNumber")!;
       Utils.printLog("sosPIn in LoginScreen : $sosPin");
     }


  }

  String imageUrl = '';

  @override
  void dispose() {
    super.dispose();
  }

  void _getNetworkData() {
    Utils.getNetworkConnectedStatus().then((status) {
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        print(_isNetworkConnected);
        if (_isNetworkConnected) {
          _isLoading = true;
          String responseType = "login";
          String lowercaseUserRole = _selectedUserRole?.toLowerCase() ?? '';

          final Map<String, dynamic> data = <String, dynamic>{};
          data['emailId'] = _enteredEmailId;
          data['password'] = _enteredPassword;

          String loginURL =
              '${Constant.loginURL}?userRole=$lowercaseUserRole&deviceId=$deviceId';

          NetworkUtils.postLoginNetWorkCall(loginURL, data, this, responseType);
        }
        else {
          Utils.printLog("else called");
          _isLoading = false;
          //Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
          Utils.showCustomToast(context);
        }
      });
    });
  }

  void _logoutApiCall(userId) {
    Utils.getNetworkConnectedStatus().then((status) {
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        print(_isNetworkConnected);
        if (_isNetworkConnected) {
          _isLoading = true;
          String responseType = "logout";

          String lowercaseUserRole = _selectedUserRole?.toLowerCase() ?? '';

          final Map<String, dynamic> data = <String, dynamic>{};
          data['emailId'] = _enteredEmailId;
          data['password'] = _enteredPassword;

          String loginURL =
              '${Constant.logingLogOutURL}?userRole=$lowercaseUserRole&deviceId=$deviceId';

          NetworkUtils.postLoginNetWorkCall(loginURL, data, this, responseType);
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

  @override
  onFailure(status) {
    Utils.printLog("onfailuer status : $status");
    setState(() {
      _isLoading = false;
    });

    if (status == 401) {
      Utils.sessonExpired(context);
    } else if (status == 408) {
      Utils.showToast(Strings.TIME_OUT_MESSAGE);
    } else {
      errorAlert(context,
          "Role or Email or Password is wrong \n Please use correct credentials");
    }
  }

  @override
  onSuccess(response, res) async {
    try {
      Utils.printLog(
          "response :: $res   login response:${response.toString()}");
      setState(() {
        _isLoading = false;
      });
      if (res == 'registerResident') {
        setState(() {
          _isLoading = false;
        });

        ApiResponceModel responceModel =
            ApiResponceModel.fromJson(json.decode(response));
        if (responceModel.status == "error") {
          errorAlert(
            context,
            responceModel.message!,
          );
        } else {
          successDialog(context, responceModel.message!, const LoginScreen());

        }
      } else if (res == "logout") {

        LoginModel loginModel = LoginModel.fromJson(response);

        _getSuccessLoginDataStore(loginModel);
      } else if (res == "login") {
        _sosPin();
        Utils.printLog("response status:::$res");
        LoginModel loginModel = LoginModel.fromJson(response);
        Utils.printLog("status:::${loginModel.status}");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        switch (loginModel.status) {
          case Strings.STATUS_NOT_APPROVED:
            prefs.setInt(Strings.NEW_OWMER_TENNANT_ID , loginModel.newUserId!);
            prefs.setString(Strings.CURRENT_DATE_TIME, loginModel.date!);
            prefs.remove(Strings.REJECTED_REASON);
            prefs.remove(Strings.REJECTED_MESSAGE);
            prefs.remove(Strings.TOKEN);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    WaitingForApprovalScreen(isFirstLogin: true),
              ),
            );
            break;
          case Strings.STATUS_LOGGED_IN:
            _showAlreadyLoginConfirmationDialog(
                loginModel.message!, loginModel.userId!);
            break;
          case Strings.STATUS_ERROR:
            errorAlert(context, Strings.WRONG_LOGIN_MESSAGE);
            break;
          case Strings.STATUS_SUCCESS:
            _getSuccessLoginDataStore(loginModel);
            break;
          case Strings.STATUS_INACATIVE:
            Utils.printLog(Strings.STATUS_INACATIVE);
            errorAlert(context, loginModel.message!);
            break;
          case Strings.STATUS_REJECTED:
            Utils.printLog(Strings.STATUS_REJECTED);
            prefs.setString(Strings.REJECTED_REASON, loginModel.rejectReason!);
            prefs.setString(Strings.REJECTED_MESSAGE, loginModel.message!);
            prefs.remove(Strings.TOKEN);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    WaitingForApprovalScreen(isFirstLogin: true),
              ),
            );
             break;
        }
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _getSuccessLoginDataStore(LoginModel loginModel) async {
    if (loginModel.status == "success" &&
        loginModel.value!.token != null &&
        loginModel.value!.token!.isNotEmpty) {
      print("Login suceess with token == ${loginModel.value!.token!}");

      String picture = loginModel.value!.userInfo!.picture ?? "";
      String email = loginModel.value!.userInfo!.email ?? "";
      int apartmentId = loginModel.value!.userInfo!.apartmentId!;
      String userName = loginModel.value!.userInfo!.userName ?? "";
      String apartmentName = loginModel.value!.userInfo!.apartmentName ?? "";
      String blockName = loginModel.value!.userInfo!.blockName ?? "";
      String flatName = loginModel.value!.userInfo!.flatNumber ?? "";
      String flatId = loginModel.value!.userInfo!.flatId ?? "";
      bool addGuestAllowed = loginModel.value!.addGuestAllowed ?? false;
      String age = loginModel.value!.userInfo!.age ?? "";
      String mobile = loginModel.value!.userInfo!.mobile ?? "";
      String address = loginModel.value!.userInfo!.address ?? "";
      String pinCode = loginModel.value!.userInfo!.pinCode ?? "";
      String state = loginModel.value!.userInfo!.state ?? "";
      String gender = loginModel.value!.userInfo!.gender ?? "";
      int blockCount = loginModel.value!.userInfo!.blockCount!;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(Strings.ISLOGGEDIN, true);
      String result = loginModel.value!.roles!.toString();
      result = result.substring(1, result.length - 1);
      prefs.setString(Strings.TOKEN, loginModel.value!.token!);
      prefs.setString(Strings.PROFILEPICTURE, picture);
      prefs.setString(Strings.EMAIL, email);
      prefs.setString(Strings.ROLES, result);
      prefs.setString(Strings.BLOCK_NAME, blockName);
      prefs.setString(Strings.FLAT_NAME, flatName);
      prefs.setString(Strings.FLATID, flatId);
      prefs.setString(Strings.USERNAME, userName);
      prefs.setString(Strings.APARTMENTNAME, apartmentName);
      prefs.setString(Strings.MOBILE, mobile);
      prefs.setString(Strings.AGE, age);
      prefs.setString(Strings.ADDRESS, address);
      prefs.setString(Strings.GENDER, gender);
      prefs.setString(Strings.PINCODE, pinCode);
      prefs.setString(Strings.STATE, state);
      prefs.setBool(Strings.ADDGUESTALLOWED, addGuestAllowed);
      prefs.setInt(Strings.APARTMENTID, apartmentId);
      prefs.setInt(Strings.BLOCKCOUNT, blockCount);
      prefs.setInt(Strings.ID, loginModel.value!.userInfo!.id!);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(isFirstLogin: true),
        ),
      );
    }
  }

  Future<void> _showAlreadyLoginConfirmationDialog(message, value) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Icon(
                Icons.cancel,
                size: FontSizeUtil.CONTAINER_SIZE_64,
                color: Colors.orange,
              ),
              SizedBox(height: FontSizeUtil.CONTAINER_SIZE_16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color.fromRGBO(27, 86, 148, 1.0),
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: FontSizeUtil.CONTAINER_SIZE_30,
                    child: ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(211, 38, 209, 38),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_20),
                          side: BorderSide(
                            width: FontSizeUtil.SIZE_01,
                            color:const Color.fromARGB(211, 38, 209, 38),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: FontSizeUtil.CONTAINER_SIZE_15,),
                      ),
                      onPressed: () {
                        _logoutApiCall(value);
                        Navigator.pop(context);
                      },
                      child: const Text(Strings.LOGOUT_CONFIRM,style:TextStyle(
                          color:  Colors.white),),
                    ),
                  ),
                ),
                SizedBox(
                  width: FontSizeUtil.CONTAINER_SIZE_10,
                ),
                Center(
                  child: SizedBox(
                    height: FontSizeUtil.CONTAINER_SIZE_30,
                    child: ElevatedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor:const Color.fromARGB(210, 209, 38, 38),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_20),
                          side: const BorderSide(
                            width: 1,
                            color: Color.fromARGB(210, 209, 38, 38),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: FontSizeUtil.CONTAINER_SIZE_15),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(Strings.CANCEL_TEXT,style:TextStyle(
                          color:  Colors.white),),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(context) {
    Widget content = GestureDetector(
      child: const LogoScreen(),
    );

    TextStyle errorStyle = TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.03,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      color: const Color.fromARGB(255, 255, 0, 0),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AbsorbPointer(
        absorbing: _isLoading,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: AbsorbPointer(
            absorbing: _isLoading,
            child: Stack(
              children: <Widget>[
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      vertical: FontSizeUtil.CONTAINER_SIZE_60,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          content,
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Center(
                            child: Padding(
                              padding:  EdgeInsets.symmetric(
                                horizontal: FontSizeUtil.CONTAINER_SIZE_20,
                                vertical: FontSizeUtil.SIZE_04
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    LocalizationUtil.translate('roleHeader'),
                                    style:  TextStyle(
                                      color:const Color.fromRGBO(27, 86, 148, 1.0),
                                      fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height * 0.01,
                                  ),
                                  Stack(
                                    alignment: Alignment.centerLeft,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_10),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                  255, 100, 100, 100),
                                              blurRadius: 6,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        height: FontSizeUtil.CONTAINER_SIZE_50,
                                        child: DropdownButtonHideUnderline(
                                          child: ButtonTheme(
                                            alignedDropdown: true,
                                            child: DropdownButton<String>(
                                              isExpanded: true,
                                              value: _selectedUserRole,
                                              items: roles.map((item) {
                                                return DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(item),
                                                );
                                              }).toList(),
                                              onChanged: (value) async {
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                setState(() {
                                                  _selectedUserRole = value!;

                                                  if (_selectedUserRole !=
                                                      'Security') {
                                                    var email =
                                                        prefs.getString("email");

                                                    if (email != null &&
                                                        email.isNotEmpty) {
                                                      // setState(() {
                                                      emailAddressController
                                                          .text = email;
                                                      // });
                                                    }
                                                  } else {
                                                    prefs.remove("email");
                                                    emailAddressController
                                                        .clear();
                                                  }
        //
                                                });
                                              },
                                              hint: Text(
                                                LocalizationUtil.translate(
                                                    'rolePlaceholde'),
                                              ),
                                              selectedItemBuilder: (context) {
                                                return roles.map<Widget>((item) {
                                                  return Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                            Icons.accessibility),
                                                        SizedBox(width: FontSizeUtil.CONTAINER_SIZE_10),
                                                        Text(
                                                          item,
                                                          style: TextStyle(
                                                              fontSize: FontSizeUtil.CONTAINER_SIZE_16),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList();
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height * 0.02,
                                  ),

                                  Text(
                                    LocalizationUtil.translate('emailHeader'),
                                    style: TextStyle(
                                      color:const Color.fromRGBO(27, 86, 148, 1.0),
                                      fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // if (_selectedGender != 'Security')
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height * 0.01,
                                  ),
                                  // if (_selectedGender != 'Security')
                                  Stack(
                                    alignment: Alignment.centerLeft,
                                    children: <Widget>[
                                      FocusScope(
                                        child: Focus(
                                          onFocusChange: (hasFocus) {
                                            setState(() {
                                              _containerBorderColor = hasFocus
                                                  ? const Color.fromARGB(
                                                      255, 0, 137, 250)
                                                  : Colors.white;
                                              _boxShadowColor = hasFocus
                                                  ? const Color.fromARGB(
                                                      162, 63, 158, 235)
                                                  : const Color.fromARGB(
                                                      255, 100, 100, 100);
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: _boxShadowColor,
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                              border: Border.all(
                                                color: _containerBorderColor,
                                              ),
                                            ),
                                            height: FontSizeUtil.CONTAINER_SIZE_50,
                                            child: TextFormField(
                                              controller: emailAddressController,
                                              scrollPadding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                          .viewInsets
                                                          .bottom *
                                                      1.15),
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(
                                                  RegExp(
                                                      r"[a-zA-Z0-9._%+-@]+|\s"),
                                                ),
                                              ],
                                              style: const TextStyle(
                                                  color: Colors.black87),
                                              decoration:  InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.only(top: FontSizeUtil.CONTAINER_SIZE_14),
                                                prefixIcon:const Icon(
                                                  Icons.person_2,
                                                  color: Color(0xff4d004d),
                                                ),
                                                hintText: Strings.EMAIL_PLACEHOLDER,

                                                hintStyle:const TextStyle(
                                                    color: Colors.black38),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  setState(() {
                                                    showUserIDErrorMessage = true;
                                                  });
                                                } else {
                                                  setState(() {
                                                    showUserIDErrorMessage =
                                                        false;
                                                  });
                                                  return null;
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                emailAddressController.value =
                                                    TextEditingValue(
                                                        text: value.toLowerCase(),
                                                        selection:
                                                            emailAddressController
                                                                .selection);
                                                String? validationMessage;

                                                if (value.isEmpty) {
                                                  validationMessage =
                                                      Strings.EMAIL_ERROR_TEXT;
                                                }
                                                if (validationMessage != null) {
                                                  setState(() {
                                                    showUserIDErrorMessage = true;
                                                    // validationMessage;
                                                  });
                                                } else {
                                                  setState(() {
                                                    showUserIDErrorMessage =
                                                        false;
                                                    // null;
                                                  });
                                                }
                                              },
                                              onSaved: (value) {
                                                _enteredEmailId = value!;
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // if (_selectedGender != 'Security')
                                  if (showUserIDErrorMessage)
                                    Text(Strings.EMAIL_ERROR_TEXT,
                                        style: errorStyle),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height * 0.03,
                                  ),
                                  Text(
                                    LocalizationUtil.translate('passwordHeader'),
                                    style: TextStyle(
                                      color: const Color.fromRGBO(27, 86, 148, 1.0),
                                      fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height * 0.01,
                                  ),
                                  Stack(
                                    alignment: Alignment.centerLeft,
                                    children: <Widget>[
                                      FocusScope(
                                        child: Focus(
                                          onFocusChange: (hasFocus) {
                                            setState(() {
                                              _containerBorderColor1 = hasFocus
                                                  ? const Color.fromARGB(
                                                      255, 0, 137, 250)
                                                  : Colors.white;
                                              _boxShadowColor1 = hasFocus
                                                  ? const Color.fromARGB(
                                                      162, 63, 158, 235)
                                                  : const Color.fromARGB(
                                                      255, 100, 100, 100);
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: _boxShadowColor1,
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                              border: Border.all(
                                                color: _containerBorderColor1,
                                              ),
                                            ),
                                            height: FontSizeUtil.CONTAINER_SIZE_50,
                                            child: TextFormField(
                                              scrollPadding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                          .viewInsets
                                                          .bottom *
                                                      1.15),
                                              keyboardType: TextInputType.name,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(
                                                  RegExp(
                                                      r"[a-zA-Z0-9._%+-@]+|\s"),
                                                ),
                                              ],
                                              style: const TextStyle(
                                                  color: Colors.black87),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding:
                                                     EdgeInsets.only(
                                                        top: FontSizeUtil.CONTAINER_SIZE_14),
                                                prefixIcon: const Icon(
                                                  Icons.lock,
                                                  color: Color(0xff4d004d),
                                                ),
                                                hintText:
                                                    LocalizationUtil.translate(
                                                        'passwordPlaceholde'),
                                                hintStyle: const TextStyle(
                                                    color: Colors.black38),
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    showPassword
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    color:
                                                        const Color(0xff4d004d),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      showPassword =
                                                          !showPassword;
                                                    });
                                                  },
                                                ),
                                              ),
                                              obscureText: !showPassword,
                                              onChanged: (value) {
                                                String? validationMessage;

                                                if (value.isEmpty) {
                                                  validationMessage =
                                                     Strings.PASSWORD_ERROR_TEXT;
                                                }
                                                if (validationMessage != null) {
                                                  setState(() {
                                                    _apartmentNameErrorMessage =
                                                        validationMessage;
                                                  });
                                                } else {
                                                  setState(() {
                                                    _apartmentNameErrorMessage =
                                                        null;
                                                  });
                                                }
                                              },
                                              validator: (value) {
                                                String? validationMessage;

                                                if (value == null ||
                                                    value.isEmpty) {
                                                  validationMessage =
                                                      Strings.PASSWORD_ERROR_TEXT;
                                                }
                                                if (validationMessage != null) {
                                                  setState(() {
                                                    _apartmentNameErrorMessage =
                                                        validationMessage;
                                                  });
                                                } else {
                                                  setState(() {
                                                    _apartmentNameErrorMessage =
                                                        null;
                                                  });
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                _enteredPassword = value!;
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_apartmentNameErrorMessage != null)
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(_apartmentNameErrorMessage!,
                                          style: errorStyle),
                                    ),
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height * 0.01,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          buildForgetPassword(context),
                          Container(
                            padding:EdgeInsets.symmetric(
                                vertical: FontSizeUtil.CONTAINER_SIZE_10, horizontal:  FontSizeUtil.CONTAINER_SIZE_50),
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate() &&
                                    _apartmentNameErrorMessage == null &&
                                    _selectedUserRole != null &&
                                    showUserIDErrorMessage == false) {
                                  _formKey.currentState!.save();
                                  _getNetworkData();
                                } else {
                                  errorAlert(context,
                                      Strings.MANDATORY_FIELD_TEXT);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff1B5694),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_15),
                                ),
                                padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_15),
                              ),
                              child: Text(
                                LocalizationUtil.translate('loginBtnText'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.005,
                          ),
                          if(_selectedUserRole == Strings.DROPDOWN_RESIDENT_NAME)
                          Text(
                            Strings.FIRST_TIME_USER_TEXT,
                            style: AppStyles.heading1(context),
                          ),
                          if(_selectedUserRole == Strings.DROPDOWN_RESIDENT_NAME)
                            buildRegisterLink(context),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.07,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_isLoading) // Display the loader if _isLoading is true
                  const Positioned(child: LoadingDialog()),
                const Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    child: FooterScreen(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRegisterLink(
    BuildContext context,
  ) {
    final tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove("token");
        prefs.remove("selectedApartmentName");
        prefs.remove("selectedApartmentId");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ExistingOwnerEmailRegistrationScreen(),
          ),
        );
      };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: OutlinedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            side: const BorderSide(color: Colors.red, width: 1),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          ),
          onPressed: () {
            tapGestureRecognizer.onTap?.call();
          },
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Register",
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: tapGestureRecognizer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildForgetPassword(context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () async => {
          Utils.navigateToAnotherScreenWithPush(
              context, const ForgetPasswordScreen())
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.only(left: 0),
          textStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        child: Text(
          LocalizationUtil.translate('forgotPassword'),
          style: const TextStyle(
            color: Color(0xff1B5694),
          ),
        ),
      ),
    );
  }
}
