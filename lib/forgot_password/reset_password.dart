import 'dart:convert';
import 'dart:io';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/forgot_password/forget_password.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/colors_utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/login.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:SMP/widget/footers.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.userName,
    required this.email,
    required this.apatmentId,
    // required String emailId,
  });

  final int? userName;
  final String? email;
  final int? apatmentId;

  @override
  State<ResetPasswordScreen> createState() {
    return _ResetPasswordScreenState();
  }
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin, ApiListener {
  bool showErrorMessage = false;
  final _formKey = GlobalKey<FormState>();

  var _enteredConfirmPassword = '';

  bool _isNetworkConnected = false, isLoading = true;

  bool _isLoading = false;
  var _enteredPassword = '';
  var _enteredEmail = '';
  var _enteredOtp = '';

  var _enteredUserName = '';

  int userId = 0;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  int apartId = 0;

  @override
  void initState() {
    super.initState();
    apartId = widget.apatmentId!;
    userId = widget.userName!;
    _emailController.text = widget.email!;
  }

  var confirmPass;

  bool showEmailErrorMessage = false;
  bool showPasswordErrorMessage = false;
  bool showConfirmErrorMessage = false;

  String? showOtpErrorMessage;

  bool showPassword = false;
  bool showConfiremPassword = false;

  File? _selectedImage;
  String? _passwordErrorMessage;

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

    Widget content = GestureDetector(
      onTap: _takePicture,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(alignment: Alignment.center, child: const AvatarScreen()),
          Positioned(
            bottom: 7.0,
            right: 8.0,
            child: GestureDetector(
              onTap: _takePicture,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(
                        38, 105, 177, 1) // Change the color as needed
                    ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).push(createRoute(const ForgetPasswordScreen()));
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
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
                    SmpAppColors.white,
                    SmpAppColors.white,
                  ],
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: FontSizeUtil.CONTAINER_SIZE_25,
                  vertical: FontSizeUtil.CONTAINER_SIZE_100,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        Strings.RESET_PASSWORD_LABEL_TEXT,
                        style: TextStyle(
                          color: Color.fromRGBO(27, 86, 148, 1.0),
                          fontSize: FontSizeUtil.CONTAINER_SIZE_30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                          const Text(
                            Strings.EMAIL_ID_LABEL,
                            style: TextStyle(
                              color: Color.fromRGBO(27, 86, 148, 1.0),
                              fontSize: 16,
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
                                height: FontSizeUtil.CONTAINER_SIZE_55,
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r"[a-zA-Z0-9._%+-@]+|\s"),
                                      ),
                                    ],
                                    style:
                                        const TextStyle(color: Colors.black87),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          top: FontSizeUtil.CONTAINER_SIZE_14),
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
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: Strings.EMAIL_OTP,
                                  style: TextStyle(
                                    color:
                                        const Color.fromRGBO(27, 86, 148, 1.0),
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
                                      color: Color.fromARGB(255, 100, 100, 100),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                height: FontSizeUtil.CONTAINER_SIZE_55,
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(5),
                                  ],
                                  keyboardType: TextInputType.emailAddress,
                                  // controller: _passwordController,
                                  style: const TextStyle(color: Colors.black87),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        top: FontSizeUtil.CONTAINER_SIZE_14),
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Color(0xff4d004d),
                                    ),
                                    hintText: Strings.EMAIL_OTP,
                                    hintStyle:
                                        const TextStyle(color: Colors.black38),
                                  ),

                                  validator: (value) {
                                    String? validationMessage;

                                    if (value == null || value.isEmpty) {
                                      validationMessage =
                                          Strings.CURRENT_PASSWORD_ERROR;
                                    }
                                    if (validationMessage != null) {
                                      setState(() {
                                        showOtpErrorMessage = validationMessage;
                                      });
                                    } else {
                                      setState(() {
                                        showOtpErrorMessage = null;
                                      });
                                    }
                                    return null;
                                  },
                                  // obscureText: !showPassword,
                                  // validator: (value) {
                                  //   if (value == null || value.isEmpty) {
                                  //     return Strings.PASSWORD_ERROR_TEXT;
                                  //   }
                                  //   return null;
                                  // },
                                  onSaved: (value) {
                                    _enteredOtp = value!;
                                  },
                                ),
                              ),
                            ],
                          ),
                          if (showOtpErrorMessage != null)
                            Text(
                              Strings.OTP_ERROR_MESSAGE,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: FontSizeUtil.CONTAINER_SIZE_15),
                            ),
                          SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: Strings.NEW_PASSWORD_HINT,
                                  style: TextStyle(
                                    color:
                                        const Color.fromRGBO(27, 86, 148, 1.0),
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
                                      color: Color.fromARGB(255, 100, 100, 100),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                height: FontSizeUtil.CONTAINER_SIZE_55,
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        Strings.EMOJI_DENY_REGEX)
                                  ],
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _passwordController,
                                  style: const TextStyle(color: Colors.black87),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        top: FontSizeUtil.CONTAINER_SIZE_14),
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Color(0xff4d004d),
                                    ),
                                    hintText: Strings.NEW_PASSWORD_HINT,
                                    hintStyle:
                                        const TextStyle(color: Colors.black38),
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
                                            Strings.CURRENT_PASSWORD_ERROR;
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
                                          Strings.CURRENT_PASSWORD_ERROR;
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
                                  text: Strings.CONFIRM_PASSWORD_HINT,
                                  style: TextStyle(
                                    color: Color.fromRGBO(27, 86, 148, 1.0),
                                    fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 0, 0, 1),
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
                                      color: Color.fromARGB(255, 100, 100, 100),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                height: FontSizeUtil.CONTAINER_SIZE_55,
                                child: TextFormField(
                                  inputFormatters: [
                                    Utils.createEmailInputFormatter()
                                  ],
                                  controller: _confirmPasswordController,
                                  scrollPadding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom *
                                        0.5,
                                  ),
                                  // keyboardType: TextInputType.numberWithOptions(),
                                  style: const TextStyle(color: Colors.black87),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        top: FontSizeUtil.CONTAINER_SIZE_14),
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Color(0xff4d004d),
                                    ),
                                    hintText: Strings.CONFIRM_PASSWORD_HINT,
                                    hintStyle:
                                        const TextStyle(color: Colors.black38),
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
                                      showConfirmErrorMessage = value.isEmpty ||
                                          value != _passwordController.text;
                                    });
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
                              Strings.CONFIRM_PASSWORD_ERROR_TEXT,
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
                                _confirmPasswordController.text.length >= 6 &&
                                showOtpErrorMessage == null &&
                                _passwordErrorMessage == null &&
                                showConfirmErrorMessage == false) {
                              if (_passwordController.text ==
                                  _confirmPasswordController.text) {
                                _formKey.currentState!.save();
                                _registerOtpData();
                              } else {
                                errorAlert(
                                  context,
                                  Strings.PASSWORD_NOT_MATCHED,
                                );
                              }
                            } else {
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
                              borderRadius: BorderRadius.circular(
                                  FontSizeUtil.CONTAINER_SIZE_15),
                            ),
                            padding:
                                EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                          ),
                          child: Text(
                            Strings.VERIFY_TEXT,
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
    );
  }

  void _registerOtpData() {
    Utils.getNetworkConnectedStatus().then((status) {
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        print(_isNetworkConnected);
        if (_isNetworkConnected) {
          _isLoading = true;
          String responseType = "registerResident";

          String loginURL =
              '${Constant.verifyForgetURL}?userId=$userId&otp=$_enteredOtp&password=$_enteredPassword';

          NetworkUtils.putUrlNetWorkCall(
            loginURL,
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
  onSuccess(response, responseType) async {
    Utils.printLog("text === $response");

    try {
      if (responseType == 'registerResident') {
        setState(() {
          _isLoading = false;
        });

        ResponceModel responceModel =
            ResponceModel.fromJson(json.decode(response));

        if (responceModel.status == "success") {
          successDialog(context, responceModel.message!, const LoginScreen());
        } else {
          Utils.showToast(responceModel.message!);
        }
      }
    } catch (error) {
      print("Error parsing JSON: $error");
    }
  }
}
