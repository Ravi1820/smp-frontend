import 'dart:convert';
import 'dart:io';
import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/model/api_responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/login.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:SMP/widget/footers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyPasswordScreen extends StatefulWidget {
  const VerifyPasswordScreen({
    super.key,
  });

  @override
  State<VerifyPasswordScreen> createState() {
    return _VerifyPasswordScreenState();
  }
}

class _VerifyPasswordScreenState extends State<VerifyPasswordScreen>
    with ApiListener {
  bool showErrorMessage = false;
  final _formKey = GlobalKey<FormState>();

  // var _enteredUserName = '';
  var _enteredConfirmPassword = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isNetworkConnected = false, isLoading = true;

  bool _isLoading = false;
  var _enteredPassword = '';
  var _enteredCurrentPassword = '';

  var _enteredEmail = '';
  var _enteredUserName = '';

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  int apartId = 0;

  @override
  void initState() {
    super.initState();
    _getUserProfile();
    // apartId = widget.apatmentId!;
    // _userNameController.text = widget.userName!;
    // _emailController.text = widget.email!;
  }

  int issueCount = 0;
  int apartmentId = 0;
  String imageUrl = '';
  String profilePicture = '';
  String baseImageIssueApi = '';
  String apartmentName = '';
  String userName1 = '';
  String mobile = '';
  String address = '';
  String emailId = '';
  String fullName = '';
  String gender = '';
  String state = '';
  String pinCode = '';
  var confirmPass;
  String? _currenrtErrorMessage;
  String? _passwordErrorMessage;
  bool showEmailErrorMessage = false;
  bool showPasswordErrorMessage = false;
  bool showConfirmErrorMessage = false;
  bool showCurrentPasswordErrorMessage = false;
  bool showCurrentPassword = false;
  bool showPassword = false;
  bool showConfiremPassword = false;
  File? _selectedImage;

  _getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final roles = prefs.getString('roles');
    var apartId = prefs.getInt('apartmentId');
    final userNam = prefs.getString('userName');
    final email = prefs.getString('email');
    var id = prefs.getInt('id');
    var profilePicture = prefs.getString('profilePicture');
    print("UserRoles $roles");
    print("UserApartment $apartmentId");
    // print("UserName $userName");
    print("UserPicture $profilePicture");
    print("UserId $id");

    setState(() {
      emailId = email!;
      // userName = userNam!;
      baseImageIssueApi = BaseApiImage.baseImageUrl(apartId!, "profile");
      // userType = roles!;
      apartmentId = apartId!;
      // userId = id!;
      imageUrl = profilePicture!;
    });
  }

  void _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });
  }

  bool isValidEmail(String email) {
    // Define a regular expression pattern for a valid email address
    const pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  @override
  Widget build(context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .push(createRoute(DashboardScreen(isFirstLogin: false)));
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: Strings.VERIFY_PASSWORD_HEADER,
            profile: () {},
          ),
        ),
        body: AbsorbPointer(
          absorbing: _isLoading,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: keyboardHeight),
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
                  padding: EdgeInsets.only(
                    left: FontSizeUtil.CONTAINER_SIZE_25,
                    right: FontSizeUtil.CONTAINER_SIZE_25,
                    top: FontSizeUtil.CONTAINER_SIZE_50,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: Strings.CURRENT_PASSWORD_TEXT,
                                    style: TextStyle(
                                      color: const Color.fromRGBO(
                                          27, 86, 148, 1.0),
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
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        FontSizeUtil.CONTAINER_SIZE_10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color:
                                            Color.fromARGB(255, 100, 100, 100),
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  height: FontSizeUtil.CONTAINER_SIZE_50,
                                  child: TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r"[a-zA-Z0-9._%+-@]+|\s"),
                                      ),
                                    ],
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _currentPasswordController,
                                    style:
                                        const TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          top: FontSizeUtil.CONTAINER_SIZE_14),
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        color: Color(0xff4d004d),
                                      ),
                                      hintText: Strings.CURRENT_PASSWORD_HINT,
                                      hintStyle: const TextStyle(
                                          color: Colors.black38),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          showCurrentPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: const Color(0xff4d004d),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            showCurrentPassword =
                                                !showCurrentPassword;
                                          });
                                        },
                                      ),
                                    ),
                                    obscureText: !showCurrentPassword,
                                    onChanged: (value) {
                                      String? validationMessage;

                                      if (value.isEmpty) {
                                        validationMessage =
                                            'Password cannot be empty';
                                      }
                                      if (validationMessage != null) {
                                        setState(() {
                                          _currenrtErrorMessage =
                                              validationMessage;
                                        });
                                      } else {
                                        setState(() {
                                          _currenrtErrorMessage = null;
                                        });
                                      }
                                    },
                                    validator: (value) {
                                      String? validationMessage;

                                      if (value == null || value.isEmpty) {
                                        validationMessage =
                                            Strings.CURRENT_PASSWORD_ERROR;
                                      }
                                      if (validationMessage != null) {
                                        setState(() {
                                          _currenrtErrorMessage =
                                              validationMessage;
                                        });
                                      } else {
                                        setState(() {
                                          _currenrtErrorMessage = null;
                                        });
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _enteredCurrentPassword = value!;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            if (_currenrtErrorMessage != null)
                              Text(
                                Strings.CURRENT_PASSWORD_ERROR_1,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: FontSizeUtil.CONTAINER_SIZE_15),
                              ),
                            SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: Strings.NEW_PASSWORD_TEXT,
                                    style: TextStyle(
                                      color: const Color.fromRGBO(
                                          27, 86, 148, 1.0),
                                      fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: const Color.fromRGBO(255, 0, 0, 1),
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
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        FontSizeUtil.CONTAINER_SIZE_10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color:
                                            Color.fromARGB(255, 100, 100, 100),
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  height: FontSizeUtil.CONTAINER_SIZE_50,
                                  child: TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r"[a-zA-Z0-9._%+-@]+|\s"),
                                      ),
                                    ],
                                    controller: _passwordController,
                                    style:
                                        const TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          top: FontSizeUtil.CONTAINER_SIZE_14),
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        color: Color(0xff4d004d),
                                      ),
                                      hintText: Strings.NEW_PASSWORD_HINT,
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
                                          setState(() {
                                            showPassword = !showPassword;
                                          });
                                        },
                                      ),
                                    ),
                                    obscureText: !showPassword,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value.isEmpty) {
                                          _passwordErrorMessage =
                                             Strings.NEW_PASSWORD_ERROR;
                                        } else if (value.length < 6) {
                                          _passwordErrorMessage =
                                             Strings.NEW_PASSWORD_LENGTH_ERROR;
                                        } else {
                                          _passwordErrorMessage = null;
                                        }
                                      });
                                    },
                                    validator: (value) {
                                      String? validationMessage;

                                      if (value == null || value.isEmpty) {
                                        validationMessage =
                                            Strings.NEW_PASSWORD_ERROR;
                                      }
                                      if (validationMessage != null) {
                                        setState(() {
                                          _passwordErrorMessage =
                                              validationMessage;
                                        });
                                      } else {
                                        setState(() {
                                          _passwordErrorMessage = null;
                                        });
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _enteredPassword = value!;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            if (_passwordErrorMessage != null)
                              Text(
                                _passwordErrorMessage!,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: FontSizeUtil.CONTAINER_SIZE_15),
                              ),
                            SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: Strings.CONFIRM_PASSWORD_TEXT,
                                    style: TextStyle(
                                      color: const Color.fromRGBO(
                                          27, 86, 148, 1.0),
                                      fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: const Color.fromRGBO(255, 0, 0, 1),
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
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color:
                                            Color.fromARGB(255, 100, 100, 100),
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  height: FontSizeUtil.CONTAINER_SIZE_50,
                                  child: TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r"[a-zA-Z0-9._%+-@]+|\s"),
                                      ),
                                    ],
                                    controller: _confirmPasswordController,
                                    scrollPadding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom *
                                          0.5,
                                    ),
                                    style:
                                        const TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          top: FontSizeUtil.CONTAINER_SIZE_14),
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        color: Color(0xff4d004d),
                                      ),
                                      hintText: Strings.CONFIRM_PASSWORD_HINT,
                                      hintStyle: const TextStyle(
                                          color: Colors.black38),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          showConfiremPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: const Color(0xff4d004d),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            showConfiremPassword =
                                                !showConfiremPassword;
                                          });
                                        },
                                      ),
                                    ),
                                    obscureText: !showConfiremPassword,
                                    onChanged: (value) {
                                      setState(() {
                                        showConfirmErrorMessage = value
                                                .isEmpty ||
                                            value != _passwordController.text;
                                      });
                                    },
                                    validator: (value) {
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _enteredConfirmPassword = value!;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            if (showConfirmErrorMessage)
                              Text(
                                Strings.CONFIRM_PASSWORD_LENGTH_ERROR,
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: FontSizeUtil.CONTAINER_SIZE_15),
                              ),
                            SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                          ],
                        ),
                        SizedBox(height: FontSizeUtil.CONTAINER_SIZE_30),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: FontSizeUtil.CONTAINER_SIZE_25,
                              horizontal: FontSizeUtil.CONTAINER_SIZE_50),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  _passwordErrorMessage == null &&
                                  _currenrtErrorMessage == null) {
                                if (_passwordController.text ==
                                    _confirmPasswordController.text) {
                                  _formKey.currentState!.save();
                                  _registerOtpData();
                                } else {
                                  errorAlert(
                                    context,
                                    Strings.CONFIRM_PASSWORD_LENGTH_ERROR,
                                  );
                                }
                              } else {
                                errorAlert(
                                  context,
                                  Strings.MANDATORY_WARNING_TEXT,
                                );
                              }
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
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: FontSizeUtil.CONTAINER_SIZE_18,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: FontSizeUtil.CONTAINER_SIZE_90),
                      ],
                    ),
                  ),
                ),
              ),
              if (_isLoading) const Positioned(child: LoadingDialog()),
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
    );
  }

  _registerOtpData() async {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          _isLoading = true;
          var responseType = 'registerResident';
          String partURL =
              '${Constant.resetPasswordURL}?newPassword=$_enteredPassword&emailId=$emailId&apartmentId=$apartmentId&oldPassword=$_enteredCurrentPassword';
          NetworkUtils.postUrlNetWorkCall(partURL, this, responseType);
        } else {
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
      if (responseType == 'registerResident') {
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
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.remove('isLoggedIn');
          Utils.showToast("${responceModel.message!}");
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
          );
        }
      }
    } catch (error) {
      print("Error parsing JSON: $error");
    }
  }
}
