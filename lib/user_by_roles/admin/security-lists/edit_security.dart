import 'dart:convert';
import 'dart:io';

import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/security-lists/edit_shift_time.dart';
import 'package:SMP/user_by_roles/admin/security-lists/security-lists.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditSecurity extends StatefulWidget {
  EditSecurity({
    super.key,
    required this.securityId,
    required this.userName,
    required this.emailId,
    required this.mobile,
    required this.age,
    required this.state,
    required this.address,
    required this.pinCode,
    required this.gender,
    required this.shiftStartTime,
    required this.shiftEndTime,
    required this.apartmentId,
    required this.baseImageIssueApi,
    required this.securityImage,
    required this.navigatorListener
  });

  int securityId;

  String userName;
  String age;
  String state;
  String baseImageIssueApi;
  String gender;
  String emailId;
  String mobile;
  String address;
  String pinCode;
  String shiftStartTime;
  String shiftEndTime;
  int apartmentId;
  String securityImage;
  NavigatorListener navigatorListener;

  @override
  State<EditSecurity> createState() {
    return _EditSecurity();
  }
}

class _EditSecurity extends State<EditSecurity>
    with WidgetsBindingObserver, ApiListener, NavigatorListener {
  bool _isNetworkConnected = false, _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  var _enteredEmailId = '';
  var _enteredMobile = '';
  var _enteredLandline = '';
  var _enteredHospitalName = '';
  var _enteredAddress2 = '';
  var _enteredAddress1 = '';
  var _enteredState = '';
  var _enteredPincode = '';
  var _enteredCountry = '';
  var _enteredAge = '';

  bool isKeyboardVisible = false;


  // Error Messages
  String? _mobileErrorMessage;
  String? _emailErrorMessage;
  String? _apartmentNameErrorMessage;
  String? _address1NameErrorMessage;
  String? _stateErrorMessage;
  String? _countaryErrorMessage;
  String? _address2NameErrorMessage;
  String? _pincodeErrorMessage;
  String? _ageErrorMessage;

  final TextEditingController _controllerFullName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerAddress1 = TextEditingController();
  final TextEditingController _controllerMobile = TextEditingController();
  final TextEditingController _controllerState = TextEditingController();
  final TextEditingController _controllerAge = TextEditingController();
  final TextEditingController _controllerPinCode = TextEditingController();
  final TextEditingController _controllerGender = TextEditingController();

  int apartmentId = 0;
  int securityId = 0;
  String shiftStartTime1 = '';
  String shiftStartTime2 = '';
  String imageUrl = '';
  String userName = '';
  String baseImageIssueApi = '';

  File? _selectedImage;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();

    setState(() {
      apartmentId = widget.apartmentId;
      securityId = widget.securityId;
      _controllerFullName.text = widget.userName;
      userName = widget.userName;
      _controllerAge.text = widget.age;
      _controllerState.text = widget.state;
      imageUrl = widget.securityImage;
      baseImageIssueApi = widget.baseImageIssueApi;
      _controllerPinCode.text = widget.pinCode;
      shiftStartTime2 = widget.shiftEndTime;
      _controllerEmail.text = widget.emailId;
      _controllerAddress1.text = widget.address;
      shiftStartTime1 = widget.shiftStartTime;
      _controllerMobile.text = widget.mobile;
      _controllerGender.text = widget.gender;
    });
    _storeOriginalData();
  }
  @override
  void dispose(){
    _dataDisposal();
    super.dispose();


  }



  void _takePicture() async {
    ImageSource? source = await Utils.takePicture(context);
    if (source != null) {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(source: source, maxWidth: 600);
      if (pickedFile != null) {
        setState(() {
          filePath = File(pickedFile.path);
        });
      }
    }
  }

  File? filePath = null;



  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
    );
    return emailRegex.hasMatch(email);
  }

  String? validateAge(String? value) {
    String? validationMessage;

    if (value!.isEmpty) {
      validationMessage = Strings.AGE_INVALID_TXT;
    } else {
      final int age = int.tryParse(value) ?? 0;

      if (age < 18) {
        validationMessage = Strings.AGE_MUST_18;
      }
    }

    setState(() {
      _ageErrorMessage = validationMessage;
    });

    return validationMessage;
  }


  void editUserChoice() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSecurityShiftTime(
          securityId: widget.securityId,
          shiftStartTime: widget.shiftStartTime,
          shiftEndTime: widget.shiftEndTime,
        ),
      ),
    );
  }

  void deleteSecurity() {
    print("Delete Clicked");
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Stack(
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
                  fontSize: 25,
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
              borderRadius: BorderRadius.circular(50),
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
                        return const AvatarScreen();
                      },
                    )
                  else
                    const AvatarScreen()
                ],
              ),
            ),
          )
        : content = GestureDetector(
            onTap: _takePicture,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.file(
                filePath!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                gaplessPlayback: true,
              ),
            ),
          );

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: Strings.EDIT_SECURITY_HEADER,
            profile: () {},
          ),
        ),

        backgroundColor: Colors.white,
        body: AbsorbPointer(
          absorbing: _isLoading,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Column(
                          children: [
                             SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                            Container(
                              height: FontSizeUtil.CONTAINER_SIZE_100,
                              width: FontSizeUtil.CONTAINER_SIZE_100,
                              alignment: Alignment.center,
                              child: content,
                            ),
                            Card(
                              margin: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_15),
                              shadowColor: Colors.blueGrey,
                              child: Container(
                                decoration: AppStyles.decoration(context),
                                child: Padding(
                                  padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                                  child: Form(
                                    key: _formKey,
                                    child: Table(
                                      columnWidths:const {
                                        0: FlexColumnWidth(2),
                                        1: FlexColumnWidth(3),

                                      },
                                      children: <TableRow>[
                                        TableRow(
                                          children: <Widget>[
                                            TableCell(
                                              child: Padding(
                                                padding:  EdgeInsets.only(
                                                    top: FontSizeUtil.CONTAINER_SIZE_18, left: FontSizeUtil.SIZE_05),
                                                child: Text(Strings.SECURITY_NAME,
                                                    style:AppStyles.heading1(context)),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Column(
                                                  children: [
                                                    TextFormField(
                                                      controller:
                                                          _controllerFullName,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .allow(
                                                          RegExp(
                                                              r"[a-zA-Z,#0-9]+|\s"),
                                                        ),
                                                      ],
                                                      style: AppStyles.blockText(
                                                          context),
                                                      onChanged: (value) {
                                                        String? validationMessage;

                                                        if (value.isEmpty) {
                                                          validationMessage =
                                                             Strings.NAME_CANT_EMPTY;
                                                        }
                                                        if (validationMessage !=
                                                            null) {
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
                                                              Strings.NAME_CANT_EMPTY;
                                                        }
                                                        if (validationMessage !=
                                                            null) {
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
                                                        _enteredHospitalName =
                                                            value!;
                                                      },
                                                    ),
                                                    if (_apartmentNameErrorMessage !=
                                                        null)
                                                      Align(
                                                        alignment:
                                                            Alignment.centerLeft,
                                                        child: Text(
                                                            _apartmentNameErrorMessage!,
                                                            style:AppStyles.errorStyle(context)),
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
                                                    top: FontSizeUtil.CONTAINER_SIZE_18, left: FontSizeUtil.SIZE_05),
                                                child: Text(Strings.MOBILE_LABEL_TEXT,
                                                    style:AppStyles.heading1(context),),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.all(FontSizeUtil.SIZE_02),
                                                child: Column(
                                                  children: [
                                                    TextFormField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      controller:
                                                          _controllerMobile,
                                                      style: AppStyles.blockText(
                                                          context),
                                                      onChanged: (value) {
                                                        String? validationMessage;

                                                        if (value.isEmpty) {
                                                          validationMessage =
                                                             Strings.PHN_CANT_BE_EMPTY;
                                                        } else if (value
                                                            .isNotEmpty) {
                                                          const mobilePattern =
                                                              r'^[0-9]{10}$';
                                                          final isValidMobile =
                                                              RegExp(mobilePattern)
                                                                  .hasMatch(
                                                                      value);

                                                          if (!isValidMobile) {
                                                            validationMessage =
                                                              Strings.INVALID_MOB_NUM;
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
                                                          validationMessage =
                                                             Strings.PHN_CANT_BE_EMPTY;
                                                        } else if (value
                                                            .isNotEmpty) {
                                                          const mobilePattern =
                                                              r'^[0-9]{10}$';
                                                          final isValidMobile =
                                                              RegExp(mobilePattern)
                                                                  .hasMatch(
                                                                      value);

                                                          if (!isValidMobile) {
                                                            validationMessage =
                                                               Strings.INVALID_MOB_NUM;
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
                                                    if (_mobileErrorMessage !=
                                                        null)
                                                      Align(
                                                        alignment:
                                                            Alignment.centerLeft,
                                                        child: Text(
                                                            _mobileErrorMessage!,
                                                            style:AppStyles.errorStyle(context)),
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
                                                padding:  EdgeInsets.only(
                                                    top: FontSizeUtil.CONTAINER_SIZE_18, left: FontSizeUtil.SIZE_05),
                                                child: Text(Strings.EMAIL_LABEL_TEXT,
                                                    style:AppStyles.heading1(context)),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.all(FontSizeUtil.SIZE_02),
                                                child: Column(
                                                  children: [
                                                    TextFormField(
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter.allow(
                                                          RegExp(r"[a-zA-Z0-9._%+-@]+|\s"),
                                                        ),
                                                      ],
                                                      controller:
                                                          _controllerEmail,
                                                      style: AppStyles.blockText(
                                                          context),
                                                      onChanged: (value) {
                                                        String? validationMessage;
                                                        if (value.isEmpty) {
                                                          validationMessage =
                                                             Strings.EMAIL_CANT_BE_EMPTY;
                                                        } else if (value
                                                                .trim()
                                                                .isNotEmpty &&
                                                            !_isValidEmail(
                                                                value)) {
                                                          validationMessage =
                                                              Strings.EMAIL_INVALID_MESSAGE;
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
                                                          validationMessage =
                                                             Strings.EMAIL_CANT_BE_EMPTY;
                                                        } else if (value
                                                                .trim()
                                                                .isNotEmpty &&
                                                            !_isValidEmail(
                                                                value)) {
                                                          validationMessage =
                                                              Strings.EMAIL_INVALID_MESSAGE;
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
                                                    if (_emailErrorMessage !=
                                                        null)
                                                      Align(
                                                        alignment:
                                                            Alignment.centerLeft,
                                                        child: Text(
                                                            _emailErrorMessage!,
                                                            style: AppStyles.errorStyle(context)),
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
                                                    top: FontSizeUtil.CONTAINER_SIZE_18, left: FontSizeUtil.SIZE_05),
                                                child: Text(Strings.ADDRESS_LABEL_TEXT,
                                                    style: AppStyles.heading1(context)),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                     EdgeInsets.all(FontSizeUtil.SIZE_02),
                                                child: Column(
                                                  children: [
                                                    TextFormField(
                                                      controller:
                                                          _controllerAddress1,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .allow(
                                                          RegExp(r"[a-zA-Z]+|\s"),
                                                        )
                                                      ],
                                                      style: AppStyles.blockText(
                                                          context),
                                                      onChanged: (value) {
                                                        String? validationMessage;

                                                        if (value.isEmpty) {
                                                          validationMessage =
                                                             Strings.ADDRESS_CANT_BE_EMPTY;
                                                        }
                                                        if (validationMessage !=
                                                            null) {
                                                          setState(() {
                                                            _address2NameErrorMessage =
                                                                validationMessage;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            _address2NameErrorMessage =
                                                                null;
                                                          });
                                                        }
                                                      },
                                                      validator: (value) {
                                                        String? validationMessage;

                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          validationMessage =
                                                              Strings.ADDRESS_CANT_BE_EMPTY;
                                                        }
                                                        if (validationMessage !=
                                                            null) {
                                                          setState(() {
                                                            _address2NameErrorMessage =
                                                                validationMessage;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            _address2NameErrorMessage =
                                                                null;
                                                          });
                                                        }
                                                        return null;
                                                      },
                                                      onSaved: (value) {
                                                        _enteredAddress1 = value!;
                                                      },
                                                    ),
                                                    if (_address2NameErrorMessage !=
                                                        null)
                                                      Align(
                                                        alignment:
                                                            Alignment.centerLeft,
                                                        child: Text(
                                                            _address2NameErrorMessage!,
                                                            style:AppStyles.errorStyle(context)),
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
                                                    top: FontSizeUtil.CONTAINER_SIZE_18, left: FontSizeUtil.SIZE_05),
                                                child: Text(Strings.AGE,
                                                    style:AppStyles.heading1(context)),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                     EdgeInsets.all(FontSizeUtil.SIZE_02),
                                                child: Column(
                                                  children: [
                                                    TextFormField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                        LengthLimitingTextInputFormatter(
                                                            2),
                                                      ],
                                                      scrollPadding:
                                                          EdgeInsets.only(
                                                              bottom: MediaQuery.of(
                                                                          context)
                                                                      .viewInsets
                                                                      .bottom *
                                                                  1.15),
                                                      controller: _controllerAge,
                                                      style: AppStyles.blockText(
                                                          context),
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
                                                        child: Text(
                                                            _ageErrorMessage!,
                                                            style:AppStyles.errorStyle(context)),
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
                                                    top: FontSizeUtil.CONTAINER_SIZE_18, left: FontSizeUtil.SIZE_05),
                                                child: Text(Strings.STATE_LABEL_TEXT,
                                                    style:AppStyles.heading1(context)),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.all(FontSizeUtil.SIZE_02),
                                                child: Column(
                                                  children: [
                                                    TextFormField(
                                                      controller:
                                                          _controllerState,
                                                      style: AppStyles.blockText(
                                                          context),
                                                      keyboardType:
                                                          TextInputType.text,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .allow(
                                                          RegExp(r"[a-zA-Z]+|\s"),
                                                        )
                                                      ],
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
                                                          validationMessage =
                                                              Strings.STATE_CANT_BE_EMPTY;
                                                        } else if (!value
                                                            .contains(RegExp(
                                                                r'^[a-zA-Z0-9\s]*$'))) {
                                                          validationMessage =
                                                              Strings.STATE_CANT_SPL_CHAR;
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
                                                          validationMessage =
                                                             Strings.STATE_CANT_BE_EMPTY;
                                                        } else if (!value
                                                            .contains(RegExp(
                                                                r'^[a-zA-Z0-9\s]*$'))) {
                                                          validationMessage =
                                                              Strings.STATE_CANT_SPL_CHAR;
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
                                                    if (_stateErrorMessage !=
                                                        null)
                                                      Align(
                                                        alignment:
                                                            Alignment.centerLeft,
                                                        child: Text(
                                                            _stateErrorMessage!,
                                                            style:AppStyles.errorStyle(context)),
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
                                                    top: FontSizeUtil.CONTAINER_SIZE_18, left: FontSizeUtil.SIZE_05),
                                                child: Text(Strings.PINCODE_LABEL_TEXT,
                                                    style:AppStyles.heading1(context)),
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.all(FontSizeUtil.SIZE_02),
                                                child: Column(
                                                  children: [
                                                    TextFormField(
                                                      controller:
                                                          _controllerPinCode,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                        LengthLimitingTextInputFormatter(
                                                            6),
                                                      ],
                                                      style: AppStyles.blockText(
                                                          context),
                                                      scrollPadding:
                                                          EdgeInsets.only(
                                                              bottom: MediaQuery.of(
                                                                          context)
                                                                      .viewInsets
                                                                      .bottom *
                                                                  3.10),
                                                      onChanged: (value) {
                                                        String? validationMessage;
                                                        if (value.isEmpty) {
                                                          validationMessage =
                                                            Strings.PINCODE_CANT_BE_EMPTY;
                                                        } else if (value
                                                                .isNotEmpty &&
                                                            value.trim().length !=
                                                                6) {
                                                          validationMessage =
                                                              Strings.PINCODE_INVALID_MES;
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

                                                        if (value!.isEmpty) {
                                                          validationMessage =
                                                             Strings.PINCODE_CANT_BE_EMPTY;
                                                        } else if (value
                                                                .isNotEmpty &&
                                                            (value.trim().length <
                                                                    1 ||
                                                                value
                                                                        .trim()
                                                                        .length >
                                                                    7)) {
                                                          const mobilePattern =
                                                              r'^[0-9]{10}$';
                                                          final isValidMobile =
                                                              RegExp(mobilePattern)
                                                                  .hasMatch(
                                                                      value);

                                                          if (!isValidMobile) {
                                                            validationMessage =
                                                                'Invalid Age';
                                                          }
                                                          validationMessage =
                                                             Strings.PINCODE_INVALID_MES;
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
                                                    if (_pincodeErrorMessage !=
                                                        null)
                                                      Align(
                                                        alignment:
                                                            Alignment.centerLeft,
                                                        child: Text(
                                                            _pincodeErrorMessage!,
                                                            style:AppStyles.errorStyle(context)),
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
                                ),
                              ),
                            ),
                             SizedBox(height: FontSizeUtil.CONTAINER_SIZE_20),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff1B5694),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_15),
                                      ),
                                      padding:  EdgeInsets.symmetric(
                                        horizontal: FontSizeUtil.CONTAINER_SIZE_50,
                                        vertical: FontSizeUtil.CONTAINER_SIZE_15,
                                      ),
                                    ),
                                    onPressed:
                                    () async {

                                      if(await _compareOriginalToUpdate()){
                                        if (_formKey.currentState!.validate() &&
                                            _apartmentNameErrorMessage == null &&
                                            _address1NameErrorMessage == null &&
                                            _emailErrorMessage == null &&
                                            _mobileErrorMessage == null &&
                                            _stateErrorMessage == null &&
                                            _ageErrorMessage == null &&
                                            _countaryErrorMessage == null &&
                                            _pincodeErrorMessage == null) {
                                          print(
                                              " _editSecurityProfileApi called ");
                                          _editSecurityProfileApi();
                                        }else{
                                          Utils.showToast(Strings.MANDATORY_FIELD_TEXT);
    }

                                      }else{
                                        Utils.showToast(Strings.NO_CHANGES_TEXT);
                                      }
                                    }
                                    ,
                                    child: const Text(Strings.UPDATE_TEXT,style: TextStyle(color: Colors.white),),
                                  ),
                                ],
                              ),
                            ),
                            if (isKeyboardVisible)
                               SizedBox(
                                height: FontSizeUtil.CONTAINER_SIZE_40,
                              ),

                          ],
                        ),
                      ),
                    ),
                    const FooterScreen(),
                  ],
                ),
              ),
              if (_isLoading) const Positioned(child: LoadingDialog()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeMetrics() {
    final bool isKeyboardNowVisible =
        MediaQuery.of(context).viewInsets.bottom > 0;
    if (isKeyboardVisible != isKeyboardNowVisible) {
      setState(() {
        isKeyboardVisible = isKeyboardNowVisible;
      });
    }
    super.didChangeMetrics();
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
      setState(() {
        if (responseType == 'deleteSecurity') {
          _isLoading = false;

          var message = response;
          successDialogWithListner(context, message, const SecurityLists(),this);
        } else if (responseType == 'updateProfile') {
          successDialogWithListner(context, response, const SecurityLists(),this);


        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      Utils.printLog("Error text === $response");
    }
  }

  _editSecurityProfileApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    print("id : $id");
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          _isLoading = true;
          var responseType = 'updateProfile';

          String fullname = _controllerFullName.text;
          String email = _controllerEmail.text;
          String mobile = _controllerMobile.text;
          String address = _controllerAddress1.text;
          String pincode = _controllerPinCode.text;
          String age = _controllerAge.text;
          String gender = _controllerGender.text;
          String state = _controllerState.text;

          String keyName = "securityData";
          String partURL = '${Constant.updateSecurityURL}?userId=$securityId';
          NetworkUtils.fileUploadNetWorkCall(
              partURL,
              keyName,
              _getJsonData(fullname, email, mobile, address, pincode, age,
                      gender, state)
                  .toString(),
              filePath,
              this,
              responseType);
        }
        else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  _getJsonData(fullname, email, mobile, address, pincode, age, gender, state) {
    final data = {
      '"fullName"': '"$fullname"',
      '"emailId"': '"$email"',
      '"mobile"': '"$mobile"',
      '"address"': '"$address"',
      '"pinCode"': '"$pincode"',
      '"age"': '"$age"',
      '"gender"': '"$gender"',
      '"state"': '"$state"',
      '"apartmentId"': apartmentId,
    };
    return data;
  }


  @override
  onNavigatorBackPressed() {
    Navigator.pop(context);
    widget.navigatorListener.onNavigatorBackPressed();

  }

  _storeOriginalData() async{
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('securityName',  _controllerFullName.text);
    prefs.setString('securityMobile', _controllerMobile.text );
        print('Email : $_controllerEmail');
    prefs.setString('securityEmail',_controllerEmail.text);
    prefs.setString('securityAddress',   _controllerAddress1.text);
    prefs.setString('securityAge',_controllerAge.text);
    prefs.setString('securityState',  _controllerState.text);
    prefs.setString('securityPinCode',_controllerPinCode.text);
    prefs.setString('baseImageIssueApi', baseImageIssueApi);
  }
  _dataDisposal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("securityName");
    prefs.remove("securityMobile");
    prefs.remove("securityEmail");
    prefs.remove('securityAddress');
    prefs.remove('securityAge');
    prefs.remove('securityState');
    prefs.remove('securityPinCode');
  }

  Future <bool>_compareOriginalToUpdate()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var originalName = prefs.getString('securityName');
    print(originalName);
    var originalMobile = prefs.getString('securityMobile');
    print(originalMobile);
    var originalEmailId = prefs.getString('securityEmail');
    print(originalEmailId);
    var originalAddress = prefs.getString('securityAddress');
    print(originalAddress);
    var originalAge = prefs.getString('securityAge');
    print(originalAge);
    var originalState = prefs.getString('securityState');
    print(originalState);
    var originalpinCode=prefs.getString('securityPinCode');
    print(originalpinCode);
    var originalBaseImageIssueApi = prefs.getString("baseImageIssueApi");
    return _controllerFullName.text !=originalName ||
        _controllerMobile.text != originalMobile ||
        _controllerEmail.text != originalEmailId ||
        _controllerAddress1.text != originalAddress ||
        _controllerAge.text != originalAge ||
        _controllerState.text !=originalState ||
        _controllerPinCode.text != originalpinCode||
         imageUrl!=originalBaseImageIssueApi;
  }
}
