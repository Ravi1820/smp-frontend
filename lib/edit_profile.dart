import 'dart:convert';
import 'dart:io';

import 'package:SMP/contants/constant_url.dart';

import 'package:SMP/contants/success_dialog.dart';

import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/model/update_user_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/widget/loader.dart';
import 'package:SMP/widget/text_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({
    super.key,
    required this.userType,
    required this.userId,
    required this.userName,
    required this.email,
    required this.profilePicture,
    required this.address,
    required this.phone,
    required this.age,
    required this.pinCode,
    required this.state,
    required this.gender,
    required this.baseImageIssueApi,
    required this.navigatorListener,
  });

  final String userType;
  final int userId;
  final String userName;
  final String email;
  final String address;
  final String phone;
  final String age;
  final String pinCode;

  final String state;
  final String gender;

  final String? baseImageIssueApi;

  final String? profilePicture;
  final NavigatorListener navigatorListener;

  @override
  State<EditProfile> createState() {
    return _EditProfile();
  }
}

class _EditProfile extends State<EditProfile>
    with ApiListener, NavigatorListener {
  final _formKey = GlobalKey<FormState>();
  bool _isNetworkConnected = false, _isLoading = false;
  TextEditingController _controller = TextEditingController();
  bool _isTextFieldChanged = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  String? imageUrl = '';
  String? baseImageUrl = '';

  int userId = 0;

  final TextEditingController _controllerFullName = TextEditingController();
  final TextEditingController _controllerUserName = TextEditingController();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerAddress1 = TextEditingController();

  final TextEditingController _controllerMobile = TextEditingController();
  final TextEditingController _controllerLandline = TextEditingController();
  final TextEditingController _controllerState = TextEditingController();

  final TextEditingController _controllerAge = TextEditingController();
  final TextEditingController _controllerPinCode = TextEditingController();
  String baseImageIssueApi = '';
  String _selectedGender = '';

  @override
  initState() {
    super.initState();

    _controllerFullName.text = widget.userName;
    _selectedGender = widget.gender ?? "";
    _controllerEmail.text = widget.email;
    _controllerAddress1.text = widget.address;
    _controllerMobile.text = widget.phone;
    _controllerAge.text = widget.age;
    _controllerState.text = widget.state;

    _controllerPinCode.text = widget.pinCode;
    imageUrl = widget.baseImageIssueApi! + widget.profilePicture!;

    print(imageUrl);

    print(baseImageUrl);

    _controller.addListener(() {
      setState(() {
        _isTextFieldChanged = _controllerMobile.text.isNotEmpty;
      });
    });
  }

  String _previousStateValue = '';

  var _enteredEmailId = '';
  var _enteredMobile = '';
  var _enteredFullName = '';
  var _enteredAddress1 = '';
  var _enteredState = '';
  var _enteredPincode = '';
  var _enteredAge = '';
  var _enteredUserName = '';

  // Error Messages

  String? _userNameErrorMessage;

  String? _fullNameErrorMessage;

  String? _mobileErrorMessage;
  String? _emailErrorMessage;
  String? _apartmentNameErrorMessage;
  String? _address1NameErrorMessage;
  String? _stateErrorMessage;
  String? _countaryErrorMessage;
  String? _address2NameErrorMessage;
  String? _pincodeErrorMessage;
  String? _ageErrorMessage;

  List<String> genders = ['Select Gender', 'Male', 'Female', 'Other'];

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
    );
    return emailRegex.hasMatch(email);
  }

  void handleGenderChange(String? selectedGender) {
    if (selectedGender != null) {
      setState(() {
        _selectedGender = selectedGender;
      });
    }
  }

  String? validateAge(String? value) {
    String? validationMessage;

    if (value!.isEmpty) {
      validationMessage = 'Age cannot be empty';
    } else {
      final int age = int.tryParse(value) ?? 0;

      if (age <= 0 || age < 18) {
        validationMessage = 'Invalid Age. Must be above 18 years';
      }
    }

    setState(() {
      _ageErrorMessage = validationMessage;
    });

    return validationMessage;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _takePicture() async {
    ImageSource? source = await Utils.takePicture(context);
    if (source != null) {
      final imagePicker = ImagePicker();
      final pickedFile =
          await imagePicker.pickImage(source: source, maxWidth: 600);
      if (pickedFile != null) {
        setState(() {
          filePath = File(pickedFile.path);
        });
      }
    }
  }

  File? filePath = null;

  String? dropdownValue;
  bool light = true;

  var isEnabled = false;
  final animationDuration = const Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    Widget content = Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(alignment: Alignment.center, child: const AvatarScreen()),
        Positioned(
          bottom: FontSizeUtil.SIZE_07,
          right: FontSizeUtil.SIZE_08,
          child: GestureDetector(
            onTap: _takePicture,
            child: Container(
              padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
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
          top: FontSizeUtil.SIZE_01,
          right: FontSizeUtil.SIZE_01,
          child: GestureDetector(
            child: Container(
              padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
              child: Text(
                '*',
                style: TextStyle(
                  color: const Color.fromRGBO(255, 0, 0, 1),
                  fontSize: FontSizeUtil.CONTAINER_SIZE_25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );

    (imageUrl != null && filePath == null && imageUrl != 'Unknown')
        ? content = GestureDetector(
            onTap: _takePicture,
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_50),
              child: Stack(
                children: <Widget>[
                  if (imageUrl != null && imageUrl!.isNotEmpty)
                    Image.network(
                      '$baseImageIssueApi${imageUrl.toString()}',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      gaplessPlayback: true,
                      errorBuilder: (context, error, stackTrace) {
                        return Utils.createStackWidget(_takePicture);
                      },
                    )
                  else
                    Utils.createStackWidget(_takePicture),
                ],
              ),
            ),
          )
        : content = GestureDetector(
            onTap: _takePicture,
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_50),
              child: Image.file(
                filePath!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                gaplessPlayback: true,
              ),
            ),
          );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: 'Edit Profile',
        ),
      ),
      body: AbsorbPointer(
        absorbing: _isLoading,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
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
                  padding: EdgeInsets.symmetric(
                    horizontal: FontSizeUtil.CONTAINER_SIZE_10,
                    vertical: FontSizeUtil.CONTAINER_SIZE_10,
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: FontSizeUtil.CONTAINER_SIZE_100,
                        width: FontSizeUtil.CONTAINER_SIZE_100,
                        alignment: Alignment.center,
                        child: content,
                      ),
                      SizedBox(height: FontSizeUtil.CONTAINER_SIZE_20),
                      Card(
                        margin: EdgeInsets.all(FontSizeUtil.SIZE_05),
                        color: const Color.fromARGB(255, 240, 245, 240),
                        shadowColor: Colors.blueGrey,
                        elevation: 10,
                        child: Column(
                          children: [
                            Form(
                              key: _formKey,
                              child: Table(
                                columnWidths: const {
                                  0: FlexColumnWidth(1.9),
                                  1: FlexColumnWidth(4),
                                },
                                children: <TableRow>[
                                  TableRow(
                                    children: <Widget>[
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: FontSizeUtil
                                                  .CONTAINER_SIZE_18,
                                              left: FontSizeUtil.SIZE_05),
                                          child: Text(Strings.MOBILE_LABEL_TEXT,
                                              style:
                                                  AppStyles.heading1(context)),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              FontSizeUtil.SIZE_02),
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                scrollPadding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                                .viewInsets
                                                                .bottom *
                                                            3.10),
                                                controller: _controllerMobile,
                                                style:
                                                    AppStyles.heading1(context),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                      10)
                                                ],
                                                onChanged: (value) {
                                                  String? validationMessage;

                                                  if (value.isEmpty) {
                                                    validationMessage = Strings
                                                        .MOB_CANT_BE_EMPTY;
                                                  } else if (value.isNotEmpty) {
                                                    const mobilePattern =
                                                        r'^[0-9]{10}$';
                                                    final isValidMobile =
                                                        RegExp(mobilePattern)
                                                            .hasMatch(value);

                                                    if (!isValidMobile) {
                                                      validationMessage = Strings
                                                          .MOB_INVALID_MESSAGE;
                                                    }
                                                  }

                                                  if (validationMessage !=
                                                      null) {
                                                    setState(() {
                                                      _mobileErrorMessage =
                                                          validationMessage;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      _mobileErrorMessage =
                                                          null;
                                                    });
                                                  }
                                                },
                                                validator: (value) {
                                                  String? validationMessage;
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    validationMessage = Strings
                                                        .MOB_CANT_BE_EMPTY;
                                                  } else if (value.isNotEmpty) {
                                                    const mobilePattern =
                                                        r'^[0-9]{10}$';
                                                    final isValidMobile =
                                                        RegExp(mobilePattern)
                                                            .hasMatch(value);

                                                    if (!isValidMobile) {
                                                      validationMessage = Strings
                                                          .MOB_INVALID_MESSAGE;
                                                    }
                                                  }

                                                  if (validationMessage !=
                                                      null) {
                                                    setState(() {
                                                      _mobileErrorMessage =
                                                          validationMessage;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      _mobileErrorMessage =
                                                          null;
                                                    });
                                                  }
                                                  return null;
                                                },
                                                onSaved: (value) {
                                                  _enteredMobile = value!;
                                                },
                                              ),
                                              if (_mobileErrorMessage != null)
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      _mobileErrorMessage!,
                                                      style:
                                                          AppStyles.errorStyle(
                                                              context)),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: FontSizeUtil
                                                  .CONTAINER_SIZE_18,
                                              left: FontSizeUtil.SIZE_05),
                                          child: Text(Strings.FULL_LABEL_TEXT,
                                              style:
                                                  AppStyles.heading1(context)),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              FontSizeUtil.SIZE_02),
                                          child: Column(
                                            children: [
                                              AbsorbPointer(
                                                child: TextFormField(
                                                  controller:
                                                      _controllerFullName,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                      RegExp(
                                                          r"[a-zA-Z,#0-9]+|\s"),
                                                    ),
                                                  ],
                                                  style: AppStyles.heading1(
                                                      context),
                                                  onChanged: (value) {
                                                    String?
                                                        validationFullNameMessage;

                                                    if (value.isEmpty) {
                                                      validationFullNameMessage =
                                                          Strings
                                                              .FULLNAME_REQUIRED_TEXT;
                                                    }
                                                    if (validationFullNameMessage !=
                                                        null) {
                                                      setState(() {
                                                        _userNameErrorMessage =
                                                            validationFullNameMessage;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        _userNameErrorMessage =
                                                            null;
                                                      });
                                                    }
                                                  },
                                                  validator: (value) {
                                                    String? validationMessage;

                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      validationMessage = Strings
                                                          .FULLNAME_REQUIRED_TEXT;
                                                    }
                                                    if (validationMessage !=
                                                        null) {
                                                      setState(() {
                                                        _userNameErrorMessage =
                                                            validationMessage;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        _userNameErrorMessage =
                                                            null;
                                                      });
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    _enteredFullName = value!;
                                                  },
                                                ),
                                              ),
                                              if (_userNameErrorMessage != null)
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      _userNameErrorMessage!,
                                                      style:
                                                          AppStyles.errorStyle(
                                                              context)),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: FontSizeUtil
                                                  .CONTAINER_SIZE_18,
                                              left: FontSizeUtil.SIZE_05),
                                          child: Text(Strings.EMAIL_LABEL_TEXT,
                                              style:
                                                  AppStyles.heading1(context)),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              FontSizeUtil.SIZE_02),
                                          child: Column(
                                            children: [
                                              AbsorbPointer(
                                                child: TextFormField(
                                                  controller: _controllerEmail,
                                                  style: AppStyles.heading1(
                                                      context),
                                                  onChanged: (value) {
                                                    String? validationMessage;
                                                    if (value.isEmpty) {
                                                      validationMessage = Strings
                                                          .EMAIL_CANT_BE_EMPTY;
                                                    } else if (value
                                                            .trim()
                                                            .isNotEmpty &&
                                                        !_isValidEmail(value)) {
                                                      validationMessage = Strings
                                                          .EMAIL_INVALID_MESSAGE;
                                                    }
                                                    if (validationMessage !=
                                                        null) {
                                                      setState(() {
                                                        _emailErrorMessage =
                                                            validationMessage;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        _emailErrorMessage =
                                                            null;
                                                      });
                                                    }
                                                  },
                                                  validator: (value) {
                                                    String? validationMessage;
                                                    if (value!.isEmpty) {
                                                      validationMessage = Strings
                                                          .EMAIL_CANT_BE_EMPTY;
                                                    } else if (value
                                                            .trim()
                                                            .isNotEmpty &&
                                                        !_isValidEmail(value)) {
                                                      validationMessage = Strings
                                                          .EMAIL_INVALID_MESSAGE;
                                                    }
                                                    if (validationMessage !=
                                                        null) {
                                                      setState(() {
                                                        _emailErrorMessage =
                                                            validationMessage;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        _emailErrorMessage =
                                                            null;
                                                      });
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    _enteredEmailId = value!;
                                                  },
                                                ),
                                              ),
                                              if (_emailErrorMessage != null)
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      _emailErrorMessage!,
                                                      style:
                                                          AppStyles.errorStyle(
                                                              context)),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: FontSizeUtil
                                                  .CONTAINER_SIZE_18,
                                              left: FontSizeUtil.SIZE_05),
                                          child: Text(
                                            Strings.AGE_LABEL_TEXT,
                                            style: AppStyles.heading1(context),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              FontSizeUtil.SIZE_02),
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                scrollPadding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                                .viewInsets
                                                                .bottom *
                                                            1.15),
                                                controller: _controllerAge,
                                                style:
                                                    AppStyles.heading1(context),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                      2)
                                                ],
                                                onChanged: (value) {
                                                  validateAge(value);
                                                },
                                                validator: (value) {
                                                  return validateAge(value);
                                                },
                                                onSaved: (value) {
                                                  _enteredAge = value!;
                                                },
                                              ),
                                              if (_ageErrorMessage != null)
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(_ageErrorMessage!,
                                                      style:
                                                          AppStyles.errorStyle(
                                                              context)),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: FontSizeUtil.SIZE_05),
                                          child: CustomTextLabel(
                                            labelText:
                                                Strings.GENDER_LABEL_TEXT,
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 0),
                                          child: DropdownButtonHideUnderline(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  right: FontSizeUtil
                                                      .CONTAINER_SIZE_14),
                                              child: ButtonTheme(
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                    border: Border(
                                                      bottom: BorderSide(
                                                        color: Colors.grey,
                                                        // Choose your desired color
                                                        width:
                                                            1.0, // Choose your desired border width
                                                      ),
                                                    ),
                                                  ),
                                                  child: DropdownButton<String>(
                                                    isExpanded: true,
                                                    value: (_selectedGender !=
                                                                null &&
                                                            _selectedGender
                                                                .isNotEmpty)
                                                        ? _selectedGender ==
                                                                    "M" ||
                                                                _selectedGender ==
                                                                    "male"
                                                            ? "Male"
                                                            : _selectedGender ==
                                                                        "F" ||
                                                                    _selectedGender ==
                                                                        "female"
                                                                ? "Female"
                                                                : _selectedGender ==
                                                                        "Other"
                                                                    ? "Other"
                                                                    : _selectedGender
                                                        : null,
                                                    // Initially set it to null
                                                    items: genders.map((item) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: item,
                                                        child: Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(item),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged:
                                                        handleGenderChange,
                                                    selectedItemBuilder:
                                                        (context) {
                                                      return genders
                                                          .map<Widget>((item) {
                                                        return Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            child: Text(
                                                              item,
                                                              style: AppStyles
                                                                  .heading1(
                                                                      context),
                                                            ),
                                                          ),
                                                        );
                                                      }).toList();
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: FontSizeUtil
                                                  .CONTAINER_SIZE_18,
                                              left: FontSizeUtil.SIZE_05),
                                          child: Text(
                                            Strings.ADDRESS_LABEL_TEXT,
                                            style: AppStyles.heading1(context),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              FontSizeUtil.SIZE_02),
                                          child: Column(
                                            children: [
                                              AbsorbPointer(
                                                child: TextFormField(
                                                  controller:
                                                      _controllerAddress1,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                      RegExp(
                                                          r"[a-zA-Z,#0-9]+|\s"),
                                                    )
                                                  ],
                                                  style: AppStyles.heading1(
                                                      context),
                                                  scrollPadding:
                                                      EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                      context)
                                                                  .viewInsets
                                                                  .bottom *
                                                              1.15),
                                                  onChanged: (value) {
                                                    String? validationMessage;

                                                    if (value.isEmpty) {
                                                      validationMessage = Strings
                                                          .ADDRESS_CANT_BE_EMPTY;
                                                    } else if (!value.contains(
                                                        RegExp(
                                                            r"[a-zA-Z,#0-9]+|\s"))) {
                                                      validationMessage = Strings
                                                          .ADDRESS_CANT_SPL_CHAR;
                                                    }

                                                    if (validationMessage !=
                                                        null) {
                                                      setState(() {
                                                        _address1NameErrorMessage =
                                                            validationMessage;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        _address1NameErrorMessage =
                                                            null;
                                                      });
                                                    }
                                                  },
                                                  validator: (value) {
                                                    String? validationMessage;

                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      validationMessage = Strings
                                                          .ADDRESS_CANT_BE_EMPTY;
                                                    } else if (!value.contains(
                                                        RegExp(
                                                            r"[a-zA-Z,#0-9]+|\s"))) {
                                                      validationMessage = Strings
                                                          .ADDRESS_CANT_SPL_CHAR;
                                                    }
                                                    if (validationMessage !=
                                                        null) {
                                                      setState(() {
                                                        _address1NameErrorMessage =
                                                            validationMessage;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        _address1NameErrorMessage =
                                                            null;
                                                      });
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    _enteredAddress1 = value!;
                                                  },
                                                ),
                                              ),
                                              if (_address1NameErrorMessage !=
                                                  null)
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      _address1NameErrorMessage!,
                                                      style:
                                                          AppStyles.errorStyle(
                                                              context)),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: FontSizeUtil
                                                  .CONTAINER_SIZE_18,
                                              left: FontSizeUtil.SIZE_05),
                                          child: Text(
                                            Strings.STATE_LABEL_TEXT,
                                            style: AppStyles.heading1(context),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              FontSizeUtil.SIZE_02),
                                          child: Column(
                                            children: [
                                              AbsorbPointer(
                                                child: TextFormField(
                                                  controller: _controllerState,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                      RegExp(r"[a-zA-Z]+|\s"),
                                                    )
                                                  ],
                                                  style: AppStyles.heading1(
                                                      context),
                                                  scrollPadding:
                                                      EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                      context)
                                                                  .viewInsets
                                                                  .bottom *
                                                              1.15),
                                                  onChanged: (value) {
                                                    String? validationMessage;

                                                    if (value.isEmpty) {
                                                      validationMessage = Strings
                                                          .STATE_CANT_BE_EMPTY;
                                                    } else if (!value.contains(
                                                        RegExp(
                                                            r'^[a-zA-Z0-9,#\s]*$'))) {
                                                      validationMessage = Strings
                                                          .STATE_CANT_SPL_CHAR;
                                                    }

                                                    if (validationMessage !=
                                                        null) {
                                                      setState(() {
                                                        _stateErrorMessage =
                                                            validationMessage;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        _stateErrorMessage =
                                                            null;
                                                      });
                                                    }
                                                  },
                                                  validator: (value) {
                                                    String? validationMessage;

                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      validationMessage = Strings
                                                          .STATE_CANT_BE_EMPTY;
                                                    } else if (!value.contains(
                                                        RegExp(
                                                            r'^[a-zA-Z0-9\s]*$'))) {
                                                      validationMessage = Strings
                                                          .STATE_CANT_SPL_CHAR;
                                                    }
                                                    if (validationMessage !=
                                                        null) {
                                                      setState(() {
                                                        _stateErrorMessage =
                                                            validationMessage;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        _stateErrorMessage =
                                                            null;
                                                      });
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    _enteredState = value!;
                                                  },
                                                ),
                                              ),
                                              if (_stateErrorMessage != null)
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      _stateErrorMessage!,
                                                      style:
                                                          AppStyles.errorStyle(
                                                              context)),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: FontSizeUtil
                                                  .CONTAINER_SIZE_18,
                                              left: FontSizeUtil.SIZE_05),
                                          child: Text(
                                            Strings.PINCODE_LABEL_TEXT,
                                            style: AppStyles.heading1(context),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              FontSizeUtil.SIZE_02),
                                          child: Column(
                                            children: [
                                              AbsorbPointer(
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  scrollPadding:
                                                      EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                      context)
                                                                  .viewInsets
                                                                  .bottom *
                                                              3.10),
                                                  controller:
                                                      _controllerPinCode,
                                                  style: AppStyles.heading1(
                                                      context),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                    LengthLimitingTextInputFormatter(
                                                        6)
                                                  ],
                                                  onChanged: (value) {
                                                    String? validationMessage;

                                                    if (value.isEmpty) {
                                                      validationMessage = Strings
                                                          .PINCODE_CANT_BE_EMPTY;
                                                    } else if (value
                                                        .isNotEmpty) {
                                                      const mobilePattern =
                                                          r'^[0-9]{6}$';
                                                      final isValidMobile =
                                                          RegExp(mobilePattern)
                                                              .hasMatch(value);

                                                      if (!isValidMobile) {
                                                        validationMessage = Strings
                                                            .PINCODE_INVALID_MES;
                                                      }
                                                    }

                                                    if (validationMessage !=
                                                        null) {
                                                      setState(() {
                                                        _pincodeErrorMessage =
                                                            validationMessage;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        _pincodeErrorMessage =
                                                            null;
                                                      });
                                                    }
                                                  },
                                                  validator: (value) {
                                                    String? validationMessage;
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      validationMessage = Strings
                                                          .PINCODE_CANT_BE_EMPTY;
                                                    } else if (value
                                                        .isNotEmpty) {
                                                      const mobilePattern =
                                                          r'^[0-9]{6}$';
                                                      final isValidMobile =
                                                          RegExp(mobilePattern)
                                                              .hasMatch(value);

                                                      if (!isValidMobile) {
                                                        validationMessage = Strings
                                                            .PINCODE_INVALID_MES;
                                                      }
                                                    }

                                                    if (validationMessage !=
                                                        null) {
                                                      setState(() {
                                                        _pincodeErrorMessage =
                                                            validationMessage;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        _pincodeErrorMessage =
                                                            null;
                                                      });
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    _enteredPincode = value!;
                                                  },
                                                ),
                                              ),
                                              if (_pincodeErrorMessage != null)
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      _pincodeErrorMessage!,
                                                      style:
                                                          AppStyles.errorStyle(
                                                              context)),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                          ],
                        ),
                      ),
                      SizedBox(height: FontSizeUtil.CONTAINER_SIZE_20),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(211, 38, 209, 38),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      FontSizeUtil.CONTAINER_SIZE_15),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: FontSizeUtil.CONTAINER_SIZE_50,
                                  vertical: FontSizeUtil.CONTAINER_SIZE_15,
                                ),
                              ),
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (_pincodeErrorMessage == null &&
                                    _userNameErrorMessage == null &&
                                    _ageErrorMessage == null &&
                                    _mobileErrorMessage == null &&
                                    _selectedGender != "Select Gender" &&
                                    _pincodeErrorMessage == null) {
                                  _formKey.currentState!.save();

                                  if (await _isDataChanged() ||
                                      filePath != null) {
                                    _editProfileApi();
                                  } else {
                                    Utils.showToast(
                                        Strings.EDIT_PROFILE_UPDATE_ERROR_TEXT);
                                  }
                                } else {
                                  Utils.showToast(
                                      Strings.VALID_USER_DETAILS_ERROR_TEXT);
                                }
                              },
                              child: const Text(
                                Strings.UPDATE_TEXT,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(width: FontSizeUtil.CONTAINER_SIZE_10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(226, 182, 36, 36),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      FontSizeUtil.CONTAINER_SIZE_15),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: FontSizeUtil.CONTAINER_SIZE_50,
                                  vertical: FontSizeUtil.CONTAINER_SIZE_15,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(Strings.CANCEL_TEXT,
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: FontSizeUtil.CONTAINER_SIZE_200),
                    ],
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

  Future<bool> _isDataChanged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var oldEmail = prefs.getString('email') ?? '';
    var oldMobile = prefs.getString('mobile') ?? '';
    var oldState = prefs.getString('state') ?? '';
    var oldAddress = prefs.getString('address') ?? '';
    var oldPincode = prefs.getString('pinCode') ?? '';
    var oldAge = prefs.getString('age') ?? 0;
    var oldFullName = prefs.getString('fullName') ?? '';

    return _enteredEmailId != oldEmail ||
        _enteredMobile != oldMobile ||
        _enteredState != oldState ||
        _enteredAddress1 != oldAddress ||
        _enteredPincode != oldPincode ||
        _enteredAge != oldAge ||
        _enteredFullName != oldFullName;
  }

  _editProfileApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          _isLoading = true;
          var responseType = 'updateProfile';
          String keyName = "userData";
          String partURL = '${Constant.updateUserURL}?userId=$id';
          NetworkUtils.fileUploadNetWorkCall(partURL, keyName,
              _getJsonData().toString(), filePath, this, responseType);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          // Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
          Utils.showCustomToast(context);
        }
      });
    });
  }

  _getJsonData() {
    final data = {
      '"emailId"': '"$_enteredEmailId"',
      '"mobile"': '"$_enteredMobile"',
      '"state"': '"$_enteredState"',
      '"address"': '"$_enteredAddress1"',
      '"pinCode"': '"$_enteredPincode"',
      '"age"': '"$_enteredAge"',
      '"gender"': '"$_selectedGender"',
      '"fullName"': '"$_enteredFullName"',
    };
    return data;
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
        if (responseType == 'updateProfile') {
          UpdateUserModel responceModel =
              UpdateUserModel.fromJson(json.decode(response));

          if (responceModel.status == "success") {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("userName", responceModel.value!.fullName ?? "");
            prefs.setInt("apartmentId", responceModel.value!.apartmentId!);
            prefs.setString("emailId", responceModel.value!.emailId ?? "");
            prefs.setString("mobile", responceModel.value!.mobile ?? "");
            prefs.setString("age", responceModel.value!.age ?? "");

            prefs.setString(
                "profilePicture", responceModel.value!.profilePicture ?? "");
            prefs.setString("address", responceModel.value!.address ?? "");
            prefs.setString("fullName", responceModel.value!.fullName ?? "");
            prefs.setString("gender", responceModel.value!.gender ?? "");
            prefs.setString("pinCode", responceModel.value!.pinCode ?? "");
            prefs.setString("state", responceModel.value!.state ?? "");
            successDialogWithListner(context, responceModel.message!,
                DashboardScreen(isFirstLogin: false), this);
          } else {
            Utils.showToast(responceModel.message!);
          }
        }
      });
    } catch (error) {
      Utils.printLog("Error text === $response");
    }
  }

  @override
  onNavigatorBackPressed() {
    Navigator.pop(context);
    widget.navigatorListener.onNavigatorBackPressed();
  }
}
