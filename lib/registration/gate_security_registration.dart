import 'dart:convert';
import 'dart:io';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/user_by_roles/admin/security-lists/security-lists.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:SMP/widget/footers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/src/material/date_picker_theme.dart'
    show DatePickerTheme;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

class GateSecurityRegistrationScreen extends StatefulWidget {
  GateSecurityRegistrationScreen({super.key, required this.navigatorListener});

  NavigatorListener? navigatorListener;

  @override
  State<GateSecurityRegistrationScreen> createState() {
    return _GateSecurityRegistrationScreenState();
  }
}

class _GateSecurityRegistrationScreenState
    extends State<GateSecurityRegistrationScreen>
    with ApiListener, NavigatorListener {
  bool showErrorMessage = false;
  final _formKey = GlobalKey<FormState>();
  bool _isNetworkConnected = false, _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var _enteredSecurityName = '';
  var _enteredSecurityPhone = '';
  var _enteredSecurityEmail = '';
  var _enteredPinCode = '';

  var _enteredState = '';
  var _enteredAge = '';

  var _enteredSecurityConfirmPassword = '';
  var _enteredSecurityAddress = '';

  String? showPhoneErrorMessage;
  String? showFlatErrorMessage;
  String? showApartmentErrorMessage;
  String? _pincodeErrorMessage;
  final TextEditingController _guestAddressController = TextEditingController();

  String? _guestPollEndErrorMessage;
  String? _guestPollStartErrorMessage;

  String? _guestAddressErrorMessage;

  bool showNameErrorMessage = false;
  bool showFullNameErrorMessage = false;
  bool showPinCodeErrorMessage = false;

  String? _guestStateErrorMessage;
  String? _guestAgeErrorMessage;
  String? _guestPasswordErrorMessage;

  bool showEmailErrorMessage = false;
  bool showPasswordErrorMessage = false;
  bool showConfirmErrorMessage = false;

  final _adminNameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _fullNameFocusNode = FocusNode();

  bool showPasswordError = false;
  bool showConfirmPasswordError = false;
  String? _enteredSecurityPassword;
  String? confirmPassword;

  String? validatePassword(String? value) {
    if (value == null ||
        value.isEmpty ||
        value.trim().length < 6 ||
        value.trim().length > 15) {
      setState(() {
        showPasswordError = true;
      });
    } else {
      setState(() {
        showPasswordError = false;
      });
      return null;
    }
    return null;

    // return null;
  }

  // bool showPassword = false;
  bool showConfiremPassword = false;

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty || value != _enteredSecurityPassword) {
      return 'Must match with the password.';
    }
    return null;
  }

  int apartmentiId = 0;

  @override
  void initState() {
    super.initState();

    _smpStorage();
  }

  _smpStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apartmentId = prefs.getInt('apartmentId');

    setState(() {
      apartmentiId = apartmentId!;
    });

    print(apartmentiId);
  }

  String? radioButtonItem = 'Nurse';

  int id = 1;

  File? _selectedImage;

  void _takePicture() async {
    ImageSource? source = await Utils.takePicture(context);
    if (source != null) {
      final imagePicker = ImagePicker();
      final pickedFile =
          await imagePicker.pickImage(source: source, maxWidth: 600);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    }
  }

  int? _selectedHospitalId;

  DateTime currentDate = DateTime.now();

  String? _enteredAdmittedDate;
  String? _enteredDichargedDate;

  final TextEditingController _admittedDateController = TextEditingController();
  final TextEditingController _dichargeDateController = TextEditingController();

  // Future<void> datePicker(BuildContext context, String type) async {
  //   final TimeOfDay? pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.fromDateTime(currentDate),
  //   );
  //
  //   if (pickedTime != null) {
  //     if (type == "Discharged Date") {
  //       setState(() {
  //         currentDate = DateTime(
  //           currentDate.year,
  //           currentDate.month,
  //           currentDate.day,
  //           pickedTime.hour,
  //           pickedTime.minute,
  //         );
  //
  //         _enteredAdmittedDate = pickedTime.format(context);
  //         _admittedDateController.text = _enteredAdmittedDate ?? '';
  //       });
  //     }
  //     if (type == "Admitted Date") {
  //       setState(() {
  //         currentDate = DateTime(
  //           currentDate.year,
  //           currentDate.month,
  //           currentDate.day,
  //           pickedTime.hour,
  //           pickedTime.minute,
  //         );
  //
  //         _enteredDichargedDate = pickedTime.format(context);
  //         _dichargeDateController.text = _enteredDichargedDate ?? '';
  //       });
  //     }
  //   }
  // }
  void _showTimePicker(BuildContext context, String type) async {
    DateTime now = DateTime.now();

    DatePicker.showTime12hPicker(
      context,
      theme: picker.DatePickerTheme(
        containerHeight: 210.0,
      ),
      showTitleActions: true,
      onConfirm: (time) {
        print('confirm $time');
        int hour = time.hour;
        String period = 'AM';
        if (hour >= 12) {
          period = 'PM';
          if (hour != 12) {
            hour -= 12;
          }
        } else if (hour == 0) {
          hour = 12;
        }

        String minutes = time.minute.toString().padLeft(2, '0');

        if (type == "Discharged Date") {
          setState(() {
            _enteredAdmittedDate = '$hour:$minutes $period';
            Utils.printLog('admittedDate : $_enteredAdmittedDate}');
            _admittedDateController.text = _enteredAdmittedDate ?? '';
          });
        } else if (type == "Admitted Date") {
          setState(() {
            _enteredDichargedDate = '$hour:$minutes $period';
            Utils.printLog('dischargedDate : $_enteredDichargedDate}');
            _dichargeDateController.text = _enteredDichargedDate ?? '';
          });
        }
      },
      currentTime: DateTime(now.year, now.month, now.day, now.hour),
      locale: picker.LocaleType.en,
    );

    (context as Element).markNeedsBuild();
  }

  var _enteredPassword = '';
  var _enteredConfirmPassword = '';

  bool showPassword = false;
  final TextEditingController _passwordController = TextEditingController();

  bool isValidEmail(String email) {
    // Define a regular expression pattern for a valid email address
    const pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  @override
  Widget build(context) {
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
                    color: Color.fromRGBO(38, 105, 177, 1)),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: 1.0,
            right: 1.0,
            child: GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  '*',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 0, 0, 1),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    const double verticalHeightBetweenTextBoxAndNextLabel = 15;

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

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: 'Security Registration',
          profile: () {},
        ),
      ),
      // drawer: const DrawerScreen(),
      body: AbsorbPointer(
        absorbing: _isLoading,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(255, 255, 255, 255),
                            Color.fromARGB(255, 255, 255, 255),
                            Color.fromARGB(255, 255, 255, 255),
                            Color.fromARGB(255, 255, 255, 255),
                          ],
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        // padding: const EdgeInsets.symmetric(
                        // horizontal: 24,
                        // vertical: 30,
                        // ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 30),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 100,
                                  width: 100,
                                  alignment: Alignment.center,
                                  child: content,
                                ),
                                const SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(height: 10),

                                    //securityName
                                    RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Security Name ',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  27, 86, 148, 1.0),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '*',
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(255, 0, 0, 1),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Stack(
                                      alignment: Alignment.centerLeft,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            _adminNameFocusNode.requestFocus();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                      255, 100, 100, 100),
                                                  blurRadius: 6,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            height: 55,
                                            child: Focus(
                                              focusNode: _adminNameFocusNode,
                                              child: TextFormField(
                                                onEditingComplete: () {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          _phoneFocusNode);
                                                },
                                                textInputAction:
                                                    TextInputAction.next,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(
                                                    RegExp(
                                                        r"[a-zA-Z,#0-9]+|\s"),
                                                  ),
                                                ],
                                                style: const TextStyle(
                                                    color: Colors.black87),
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.only(top: 14),
                                                  prefixIcon: Icon(
                                                    Icons.person_2_outlined,
                                                    color: Color(0xff4d004d),
                                                  ),
                                                  hintText:
                                                      Strings.ENTER_NAME_TEXT,
                                                  hintStyle: TextStyle(
                                                      color: Colors.black38),
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    setState(() {
                                                      showNameErrorMessage =
                                                          true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      showNameErrorMessage =
                                                          false;
                                                    });
                                                    return null;
                                                  }
                                                  return null;
                                                },
                                                onChanged: (value) {
                                                  if (value.isEmpty) {
                                                    setState(() {
                                                      showNameErrorMessage =
                                                          true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      showNameErrorMessage =
                                                          false;
                                                    });
                                                  }
                                                },
                                                onSaved: (value) {
                                                  _enteredSecurityName = value!;
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (showNameErrorMessage)
                                      const Text(
                                        "Name is required",
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 15),
                                      ),
                                    const SizedBox(height: 10),
                                    // age
                                    const Text(
                                      'Age',
                                      style: TextStyle(
                                        color: Color.fromRGBO(27, 86, 148, 1.0),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                        height:
                                            verticalHeightBetweenTextBoxAndNextLabel),
                                    Stack(
                                      alignment: Alignment.centerLeft,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color.fromARGB(
                                                    255, 100, 100, 100),
                                                blurRadius: 6,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          height: 55,
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                  2),
                                            ],
                                            // inputFormatters: [
                                            // FilteringTextInputFormatter.allow(
                                            // RegExp(r'[0-9]')),
                                            // ],
                                            style: const TextStyle(
                                                color: Colors.black87),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.only(top: 14),
                                              prefixIcon: Icon(
                                                Icons.person,
                                                color: Color(0xff4d004d),
                                              ),
                                              hintText: Strings.ENTER_AGE_TEXT,
                                              hintStyle: TextStyle(
                                                  color: Colors.black38),
                                            ),
                                            onChanged: (value) {
                                              String? validationMessage;
                                              if (value.isEmpty) {
                                                validationMessage =
                                                    'Age cannot be empty';
                                              }
                                              if (validationMessage != null) {
                                                setState(() {
                                                  _guestAgeErrorMessage =
                                                      validationMessage;
                                                });
                                              } else {
                                                setState(() {
                                                  _guestAgeErrorMessage = null;
                                                });
                                              }
                                            },
                                            validator: (value) {
                                              String? validationMessage;
                                              if (value!.isEmpty) {
                                                validationMessage =
                                                    'Age cannot be empty';
                                              }
                                              if (validationMessage != null) {
                                                setState(() {
                                                  _guestAgeErrorMessage =
                                                      validationMessage;
                                                });
                                              } else {
                                                setState(() {
                                                  _guestAgeErrorMessage = null;
                                                });
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _enteredAge = value!;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (_guestAgeErrorMessage != null)
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          _guestAgeErrorMessage!,
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 10),

                                    //phone Number
                                    RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Phone ',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  27, 86, 148, 1.0),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '*',
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(255, 0, 0, 1),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                        height:
                                            verticalHeightBetweenTextBoxAndNextLabel),
                                    Stack(
                                      alignment: Alignment.centerLeft,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            _phoneFocusNode.requestFocus();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                      255, 100, 100, 100),
                                                  blurRadius: 6,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            height: 55,
                                            child: Focus(
                                              focusNode: _phoneFocusNode,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                      10),
                                                ],
                                                textInputAction:
                                                    TextInputAction.next,
                                                // inputFormatters: [
                                                // FilteringTextInputFormatter.allow(
                                                // RegExp(r'[0-9]')),
                                                // ],
                                                style: const TextStyle(
                                                    color: Colors.black87),
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.only(top: 14),
                                                  prefixIcon: Icon(
                                                    Icons.phone_android_rounded,
                                                    color: Color(0xff4d004d),
                                                  ),
                                                  hintText: Strings
                                                      .ENTER_PHONE_NUMBER_TEXT,
                                                  hintStyle: TextStyle(
                                                      color: Colors.black38),
                                                ),
                                                onChanged: (value) {
                                                  String? validationMessage;
                                                  if (value.isNotEmpty) {
                                                    const mobilePattern =
                                                        r'^[0-9]{10}$';
                                                    final isValidMobile =
                                                        RegExp(mobilePattern)
                                                            .hasMatch(value);
                                                    if (!isValidMobile) {
                                                      validationMessage =
                                                          'Please enter valid mobile number';
                                                    }
                                                  }
                                                  if (validationMessage !=
                                                      null) {
                                                    setState(() {
                                                      showPhoneErrorMessage =
                                                          validationMessage;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      showPhoneErrorMessage =
                                                          null;
                                                    });
                                                  }
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    setState(() {
                                                      showPhoneErrorMessage =
                                                          "Phone number cannot be empty";
                                                    });
                                                  } else if (value
                                                              .trim()
                                                              .length <=
                                                          9 ||
                                                      value.trim().length >
                                                          11) {
                                                    setState(() {
                                                      showPhoneErrorMessage =
                                                          "Phone number must be 10 digits";
                                                    });
                                                  } else {
                                                    setState(() {
                                                      showPhoneErrorMessage =
                                                          null;
                                                    });
                                                    return null;
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  _enteredSecurityPhone =
                                                      value!;
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (showPhoneErrorMessage != null)
                                      Text(
                                        showPhoneErrorMessage!,
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 15),
                                      ),
                                    // const SizedBox(height: 10),
                                    const SizedBox(height: 10),

                                    // email
                                    RichText(
                                      text: const TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Email ',
                                            style: TextStyle(
                                              color: Color.fromRGBO(
                                                  27, 86, 148, 1.0),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Stack(
                                      alignment: Alignment.centerLeft,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color.fromARGB(
                                                    255, 100, 100, 100),
                                                blurRadius: 6,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          height: 55,
                                          child: TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(
                                                    r"[a-zA-Z0-9._%+-@]+|\s"),
                                              ),
                                            ],
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            style: const TextStyle(
                                                color: Colors.black87),
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.only(top: 14),
                                              prefixIcon: Icon(
                                                Icons.mail,
                                                color: Color(0xff4d004d),
                                              ),
                                              hintText:
                                                  Strings.ENTER_EMAIL_TEXT,
                                              hintStyle: TextStyle(
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
                                            onSaved: (value) {
                                              _enteredSecurityEmail = value!;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (showEmailErrorMessage)
                                      const Text(
                                        'Please enter a valid email address.',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    const SizedBox(height: 10),
                                    // password
                                    const Text(
                                      'Password',
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
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color.fromARGB(
                                                    255, 100, 100, 100),
                                                blurRadius: 6,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          height: 55,
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
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
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.only(top: 14),
                                              prefixIcon: Icon(
                                                Icons.password_sharp,
                                                color: Color(0xff4d004d),
                                              ),
                                              hintText:
                                                  Strings.ENTER_PASSWORD_TEXT,
                                              hintStyle: TextStyle(
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
                                              if (value.isEmpty) {
                                                setState(() {
                                                  _guestPasswordErrorMessage =
                                                      'Password cannot be empty';
                                                });
                                              } else {
                                                setState(() {
                                                  _guestPasswordErrorMessage =
                                                      null;
                                                });
                                              }
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty ||
                                                  value.trim().length <= 1 ||
                                                  value.trim().length > 50) {
                                                setState(() {
                                                  _guestPasswordErrorMessage =
                                                      'Should be valid password';
                                                });
                                              } else {
                                                setState(() {
                                                  _guestPasswordErrorMessage =
                                                      null;
                                                });
                                                return null;
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
                                    if (_guestPasswordErrorMessage != null)
                                      const Text(
                                        "Password can't be empty.",
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 15),
                                      ),

                                    const SizedBox(
                                        height:
                                            verticalHeightBetweenTextBoxAndNextLabel),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Address',
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
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color.fromARGB(
                                                    255, 100, 100, 100),
                                                blurRadius: 6,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          height: 55,
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            style: const TextStyle(
                                                color: Colors.black87),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r"[a-zA-Z,#0-9]+|\s"),
                                              ),
                                            ],
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.only(top: 14),
                                              prefixIcon: Icon(
                                                Icons.add_home_work_sharp,
                                                color: Color(0xff4d004d),
                                              ),
                                              hintText:
                                                  Strings.ENTER_ADDRESS_TEXT,
                                              hintStyle: TextStyle(
                                                  color: Colors.black38),
                                            ),
                                            onChanged: (value) {
                                              if (value.isEmpty) {
                                                setState(() {
                                                  _guestAddressErrorMessage =
                                                      'Should be Valid Address';
                                                });
                                              } else {
                                                setState(() {
                                                  _guestAddressErrorMessage =
                                                      null;
                                                });
                                              }
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty ||
                                                  value.trim().length <= 1 ||
                                                  value.trim().length > 50) {
                                                setState(() {
                                                  _guestAddressErrorMessage =
                                                      'Should be Valid Address';
                                                });
                                              } else {
                                                setState(() {
                                                  _guestAddressErrorMessage =
                                                      null;
                                                });
                                                return null;
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _enteredSecurityAddress = value!;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (_guestAddressErrorMessage != null)
                                      const Text(
                                        'Address cant be empty.',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 15),
                                      ),
                                    const SizedBox(height: 10),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'State',
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
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color.fromARGB(
                                                    255, 100, 100, 100),
                                                blurRadius: 6,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          height: 55,
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                RegExp(r"[a-zA-Z,#0-9]+|\s"),
                                              ),
                                            ],
                                            style: const TextStyle(
                                                color: Colors.black87),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.only(top: 14),
                                              prefixIcon: Icon(
                                                Icons.location_city,
                                                color: Color(0xff4d004d),
                                              ),
                                              hintText:
                                                  Strings.ENTER_STATE_TEXT,
                                              hintStyle: TextStyle(
                                                  color: Colors.black38),
                                            ),
                                            onChanged: (value) {
                                              if (value.isEmpty) {
                                                setState(() {
                                                  _guestStateErrorMessage =
                                                      'State cannot be empty';
                                                });
                                              } else {
                                                setState(() {
                                                  _guestStateErrorMessage =
                                                      null;
                                                });
                                              }
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty ||
                                                  value.trim().length <= 1 ||
                                                  value.trim().length > 50) {
                                                setState(() {
                                                  _guestStateErrorMessage =
                                                      'Should be valid state';
                                                });
                                              } else {
                                                setState(() {
                                                  _guestStateErrorMessage =
                                                      null;
                                                });
                                                return null;
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _enteredState = value!;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (_guestStateErrorMessage != null)
                                      const Text(
                                        "State can't be empty.",
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 15),
                                      ),
                                    const SizedBox(height: 10),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Pincode',
                                      style: TextStyle(
                                        color: Color.fromRGBO(27, 86, 148, 1.0),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                        height:
                                            verticalHeightBetweenTextBoxAndNextLabel),
                                    Stack(
                                      alignment: Alignment.centerLeft,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color.fromARGB(
                                                    255, 100, 100, 100),
                                                blurRadius: 6,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          height: 55,
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                  6),
                                            ],
                                            style: const TextStyle(
                                                color: Colors.black87),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.only(top: 14),
                                              prefixIcon: Icon(
                                                Icons.add_location_alt,
                                                color: Color(0xff4d004d),
                                              ),
                                              hintText:
                                                  Strings.ENTER_PINCODE_TEXT,
                                              hintStyle: TextStyle(
                                                  color: Colors.black38),
                                            ),
                                            onChanged: (value) {
                                              String? validationMessage;
                                              if (value.isEmpty) {
                                                validationMessage =
                                                    'Pincode cannot be empty';
                                              } else if (value.isNotEmpty &&
                                                  value.trim().length != 6) {
                                                validationMessage =
                                                    'Invalid Pincode ';
                                              }
                                              if (validationMessage != null) {
                                                setState(() {
                                                  _pincodeErrorMessage =
                                                      validationMessage;
                                                });
                                              } else {
                                                setState(() {
                                                  _pincodeErrorMessage = null;
                                                });
                                              }
                                            },
                                            validator: (value) {
                                              String? validationMessage;
                                              if (value!.isEmpty) {
                                                validationMessage =
                                                    'Pincode cannot be empty';
                                              } else if (value.isNotEmpty &&
                                                  value.trim().length != 6) {
                                                validationMessage =
                                                    'Invalid pincode ';
                                              }
                                              if (validationMessage != null) {
                                                setState(() {
                                                  _pincodeErrorMessage =
                                                      validationMessage;
                                                });
                                              } else {
                                                setState(() {
                                                  _pincodeErrorMessage = null;
                                                });
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _enteredPinCode = value!;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (_pincodeErrorMessage != null)
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          _pincodeErrorMessage!,
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(
                                        height:
                                            verticalHeightBetweenTextBoxAndNextLabel),
                                    const Text(
                                      'Shift Start Time',
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
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color.fromARGB(
                                                    255, 100, 100, 100),
                                                blurRadius: 6,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          height: 50,
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      _showTimePicker(context,
                                                          "Discharged Date");
                                                    },
                                                    child: AbsorbPointer(
                                                      child: TextFormField(
                                                        // textInputAction:
                                                        // TextInputAction.next,
                                                        controller:
                                                            _admittedDateController,
                                                        decoration:
                                                            const InputDecoration(
                                                          prefixIcon: Icon(
                                                            Icons
                                                                .date_range_outlined,
                                                            color: Color(
                                                                0xff4d004d),
                                                          ),
                                                          hintText:
                                                              'Shift Start Time',
                                                          hintStyle: TextStyle(
                                                              color: Colors
                                                                  .black38),
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                        onChanged: (value) {},
                                                        onSaved: (value) {
                                                          _enteredDichargedDate =
                                                              value;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _showTimePicker(context,
                                                        "Discharged Date");
                                                  },
                                                  child: const Icon(
                                                    Icons.date_range,
                                                    color: Color(0xff4d004d),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    if (_guestPollStartErrorMessage != null)
                                      const SizedBox(height: 20),
                                    const Text(
                                      'Shift End Time',
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
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color.fromARGB(
                                                    255, 100, 100, 100),
                                                blurRadius: 6,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          height: 50,
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      _showTimePicker(context,
                                                          "Admitted Date");
                                                    },
                                                    child: AbsorbPointer(
                                                      child: TextFormField(
                                                        // textInputAction:
                                                        // TextInputAction.done,
                                                        controller:
                                                            _dichargeDateController,
                                                        decoration:
                                                            const InputDecoration(
                                                          prefixIcon: Icon(
                                                            Icons
                                                                .date_range_outlined,
                                                            color: Color(
                                                                0xff4d004d),
                                                          ),
                                                          hintText:
                                                              'Shift End Time',
                                                          hintStyle: TextStyle(
                                                              color: Colors
                                                                  .black38),
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                        onChanged: (value) {
                                                          // Handle onChanged if needed
                                                        },
                                                        onSaved: (value) {
                                                          _enteredDichargedDate =
                                                              value;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _showTimePicker(context,
                                                        "Admitted Date");
                                                  },
                                                  child: const Icon(
                                                    Icons.date_range,
                                                    color: Color(0xff4d004d),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    if (_guestPollEndErrorMessage != null)
                                      Text(
                                        _guestPollEndErrorMessage!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 15,
                                        ),
                                      ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 25, horizontal: 50),
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate() &&
                                          showNameErrorMessage == false &&
                                          _guestAddressErrorMessage == null &&
                                          showPhoneErrorMessage == null &&
                                          showEmailErrorMessage == false) {
                                        if (_selectedImage != null) {
                                          _formKey.currentState!.save();
                                          if (_enteredAdmittedDate != null &&
                                              _enteredDichargedDate != null &&
                                              _enteredAdmittedDate!
                                                  .isNotEmpty &&
                                              _enteredDichargedDate!
                                                  .isNotEmpty) {
                                            _addGuestApi();
                                          } else {
                                            errorAlert(
                                              context,
                                              "Please select time",
                                            );
                                          }
                                        } else {
                                          errorAlert(
                                            context,
                                            "Please select image",
                                          );
                                        }
                                      } else {
                                        errorAlert(
                                          context,
                                          "Please fill mandatory fields",
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff1B5694),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: const EdgeInsets.all(15),
                                    ),
                                    child: const Text(
                                      "Security Register",
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
              if (_isLoading) const Positioned(child: LoadingDialog()),
            ],
          ),
        ),
      ),
    );
  }

  _addGuestApi() async {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;

        if (_isNetworkConnected) {
          _isLoading = true;
          String responseType = "login";
          final Map<String, dynamic> data = <String, dynamic>{};

          data['userName'] = _enteredSecurityName;
          data['emailId'] = _enteredSecurityEmail;
          data['password'] = _enteredPassword;
          data['age'] = _enteredAge;
          data['mobile'] = _enteredSecurityPhone;
          data['address'] = _enteredSecurityAddress;
          data['shiftTimeStart'] = _enteredAdmittedDate;
          data['shiftTimeEnd'] = _enteredDichargedDate;
          data['apartmentId'] = apartmentiId.toString();
          data['state'] = _enteredState;
          data['pinCode'] = _enteredPinCode;
          data['roles'] = ["security"];

          String keyName = "userData";

          NetworkUtils.postMultipartNetWorkCall(
            Constant.addSecurityURL,
            _selectedImage!,
            data,
            this,
            keyName,
            responseType,
          );
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
    // Utils.sessonExpired(context,  "Session is expired. Please login again");
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
      setState(() {
        if (responseType == 'login') {
          ResponceModel responceModel =
              ResponceModel.fromJson(json.decode(response));

          if (responceModel.status == "success") {
            successDialogWithListner(
                context, responceModel.message!, const SecurityLists(), this);
          } else {
            Utils.showToast(responceModel.message!);
          }
          // var message = "Security signed up successfully";
          // successDialogWithListner(
          //     context, message, const SecurityLists(), this);
        }
      });
    } catch (error) {
      Utils.printLog("Error text === $response");
    }
  }

  @override
  onNavigatorBackPressed() {
    Navigator.pop(context);
    widget.navigatorListener!.onNavigatorBackPressed();
  }
}
