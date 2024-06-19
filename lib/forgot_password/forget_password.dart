import 'dart:convert';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/forgot_password/reset_password.dart';
import 'package:SMP/login.dart';
import 'package:SMP/model/movies.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/appartment_data_listener.dart';
import 'package:SMP/user_by_roles/admin/select_details/apartment_list.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:SMP/widget/footers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() {
    return _ForgetPasswordScreenState();
  }
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen>
    with ApiListener, AppartmentDataListener {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _selectedApartmentName;

  bool showErrorMessage = false;
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  String? _selectedHospitalId;
  bool _isLoading = false;
  int? _selectedApartmentID;
  bool _isNetworkConnected = false, isLoading = true;

  @override
  void initState() {
    _getApartmentData();
    super.initState();
    clearTocken();
  }

  clearTocken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
  }

  bool showEmailErrorMessage = false;

  bool isValidEmail(String email) {
    const pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  List apartmentList = [];

  void _getApartmentData() {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        String responseType = "email";
        if (_isNetworkConnected) {
          isLoading = true;
          NetworkUtils.getNetWorkCall(
              Constant.apartmentListURL, responseType, this);
        } else {
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  @override
  Widget build(context) {
    return WillPopScope(
      onWillPop: () async {
        Utils.navigateToPushAndRemoveUntilScreen(context , const LoginScreen());
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
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
                    padding:  EdgeInsets.symmetric(
                      horizontal: FontSizeUtil.CONTAINER_SIZE_25,
                      vertical: FontSizeUtil.CONTAINER_SIZE_150,
                    ),
                    child: Center(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // buildAvatar(),
                             Text(
                              Strings.FORGOT_PASSWORD_HEADER,
                              style: TextStyle(
                                color:const Color.fromRGBO(27, 86, 148, 1.0),
                                fontSize: FontSizeUtil.CONTAINER_SIZE_30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                             SizedBox(height: FontSizeUtil.CONTAINER_SIZE_30),
                             Text(
                              Strings.SEND_OTP_LABEL,
                              style: TextStyle(
                                color:const Color.fromRGBO(27, 86, 148, 1.0),
                                fontSize: FontSizeUtil.CONTAINER_SIZE_15,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),

                             SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                 SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                                RichText(
                                  text:  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: Strings.CHOOSE_APARTMENT_LABEL,
                                        style: TextStyle(
                                          color:const Color.fromRGBO(27, 86, 148, 1.0),
                                          fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '*',
                                        style: TextStyle(
                                          color:const Color.fromRGBO(255, 0, 0, 1),
                                          fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                                Stack(
                                  alignment: Alignment.centerLeft,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          createRoute(
                                            AprtmentList(dataListener: this),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              FontSizeUtil.CONTAINER_SIZE_10),
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
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(
                                                  FontSizeUtil.CONTAINER_SIZE_10),
                                              child: _selectedApartmentName !=
                                                      null
                                                  ? Text(
                                                      _selectedApartmentName!,
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )
                                                  :  Text(
                                                      Strings
                                                          .CHOOSE_APARTMENT_LABEL1,
                                                      style:
                                                          TextStyle(fontSize: FontSizeUtil.CONTAINER_SIZE_16),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: FontSizeUtil.SIZE_08),
                                              child:const Icon(
                                                Icons.arrow_forward,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                                 Text(
                                  Strings.EMAIL_ID_LABEL,
                                  style: TextStyle(
                                    color:const Color.fromRGBO(27, 86, 148, 1.0),
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
                                            color: Color.fromARGB(
                                                255, 100, 100, 100),
                                            blurRadius: 6,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      height: FontSizeUtil.CONTAINER_SIZE_55,
                                      child: TextFormField(
                                        keyboardType: TextInputType.emailAddress,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r"[a-zA-Z0-9._%+-@]+|\s"),
                                          ),
                                        ],
                                        style: const TextStyle(
                                            color: Colors.black87),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              top:
                                                  FontSizeUtil.CONTAINER_SIZE_15),
                                          prefixIcon: const Icon(
                                            Icons.mail,
                                            color: Color(0xff4d004d),
                                          ),
                                          hintText: Strings.EMAIL_ID_LABEL,
                                          hintStyle: const TextStyle(
                                              color: Colors.black38),
                                        ),
                                        onChanged: (value) {
                                          if (isValidEmail(value)) {
                                            setState(() {
                                              showEmailErrorMessage = false;
                                            });
                                          } else {
                                            setState(() {
                                              showEmailErrorMessage = true;
                                            });
                                          }
                                        },
                                        validator: (value) {
                                          if (value == null ||
                                              !value.contains('@') ||
                                              value.isEmpty ||
                                              value.trim().length > 50) {
                                            setState(() {
                                              showEmailErrorMessage = true;
                                            });
                                          } else {
                                            setState(() {
                                              showEmailErrorMessage = false;
                                            });
                                            return null;
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          _enteredEmail = value!;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                if (showEmailErrorMessage)
                                  Text(
                                    Strings.EMAIL_ADDRESS_ERROR_TEXT,
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: FontSizeUtil.CONTAINER_SIZE_15),
                                  ),
                                SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                              ],
                            ),
                            SizedBox(height: FontSizeUtil.CONTAINER_SIZE_30),
                            Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: FontSizeUtil.CONTAINER_SIZE_25,
                                      horizontal: FontSizeUtil.CONTAINER_SIZE_50),
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      if (_formKey.currentState!.validate() &&
                                          _selectedApartmentID != null) {
                                        _formKey.currentState!.save();
                                        _verifyEmailData();
                                      } else {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        errorAlert(
                                          context,
                                          Strings.ALERT_ERROR,
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff1B5694),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_15),
                                      ),
                                      padding:  EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_15),
                                    ),
                                    child: Text(
                                      Strings.VERIFY_TEXT,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize:  FontSizeUtil.CONTAINER_SIZE_18,
                                      ),
                                    ),
                                  ),
                                ),
                                if (_isLoading) // Display the loader if _isLoading is true
                                  const Positioned(child: LoadingDialog()),
                              ],
                            ),
                             SizedBox(height: FontSizeUtil.CONTAINER_SIZE_90),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                child: FooterScreen(),
              ),
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
              '${Constant.verifyEmailOtpURL}?email=$_enteredEmail&apartmentId=$_selectedApartmentID';

          NetworkUtils.postUrlNetWorkCall(loginURL, this, responseType);
        } else {
          print("else called");
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
    if (status == 401) {
      Utils.sessonExpired(context);
    } else {
      Utils.showToast(Strings.API_ERROR_MSG_TEXT);
    }
  }

  @override
  onSuccess(response, responseType) async {
    Utils.printLog("text === $response");

    try {
      if (responseType == 'email') {
        List<ApartmentModel> movieList = (json.decode(response) as List)
            .map((item) => ApartmentModel.fromJson(item))
            .toList();

        setState(() {
          apartmentList = movieList;
        });
      } else if (responseType == 'verifyEmail') {
        ResponceModel responceModel =
            ResponceModel.fromJson(json.decode(response));
        if (responceModel.status == "error") {
          Utils.showToast(responceModel.message!);
        } else {
          Navigator.of(context).push(createRoute(
            ResetPasswordScreen(
              userName: responceModel.userId!,
              apatmentId: _selectedApartmentID,
              email: _enteredEmail,
            ),
          ));
        }
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print("Error parsing JSON: $error");
    }
  }

  @override
  onDataClicked(id, name, available, dataType) {
    setState(() {
      if (dataType == Strings.APPARTMENT_NAME) {
        _selectedApartmentName = name;
        _selectedApartmentID = id;
      }
    });
  }
}
