import 'dart:convert';
import 'dart:io';
import 'package:SMP/components/dropdown/relation_dropdown.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/profile.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:SMP/components/dropdown/gender_dropdown.dart';
import 'package:SMP/components/dropdown/text_form_field.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/widget/loader.dart';
import 'package:SMP/widget/text_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/responce_model.dart';

class AddFamilyMemberScreen extends StatefulWidget {
  const AddFamilyMemberScreen({super.key});

  @override
  State<AddFamilyMemberScreen> createState() {
    return _AddFamilyMemberScreenState();
  }
}

class _AddFamilyMemberScreenState extends State<AddFamilyMemberScreen>
    with ApiListener {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _userNameController = TextEditingController();
  var _mobileController = TextEditingController();
  var _emailController = TextEditingController();
   var userNameErrorText;
   var mobileErrorText;
   var emailErrortext;

  final _formKey = GlobalKey<FormState>();
  var _enteredMobile = '';
  var _enteredEmail = '';
  var _enteredGuestName = '';
  var _enteredRelation = '';
  String? _selectedRelation;

  String? _selectedGender;
  List<String> relation =["father","mother","son","daughter","sister","brother","spouse","grand father","grand mother"];

  bool _isNetworkConnected = false, _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    _smpStorage();
  }

  String? token;
  String userName = "";

  int? userId;
  int? apartmentId;
  bool showEmailErrorMessage = false;

  void _smpStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var id = prefs.getInt('id');
    var apartId = prefs.getInt('apartmentId');

    var userNam = prefs.getString('userName');

    setState(() {
      token = token!;
      userId = id!;
      apartmentId = apartId!;
      userName = userNam!;
    });
  }

  bool obscure = false;
  String? _ageErrorMessage;
  bool isValiedAge = false;

  String? validateAge(String? value) {
    String? validationMessage;

    if (value!.isEmpty) {
      validationMessage = 'Age cannot be null';
    } else {
      final int age = int.tryParse(value) ?? 0;

      if (age <= 18) {
        // Age is less than or equal to 18
        // You may want to provide a validation message here
        Utils.printLog("Below  Age");

        setState(() {
          isValiedAge = false;

          _enteredMobile = '';
          _enteredEmail = '';
          _mobileErrorMessage = null;
          showEmailErrorMessage = false;
        });
        // validationMessage = 'Age must be above 18 years';
        return validationMessage;
      } else {
        Utils.printLog("Above  Age");
        setState(() {
          isValiedAge = true;
        });

        // Age is greater than 18
        // Set _isAgeValid to true if necessary
      }
    }

    return validationMessage;
  }

  final genders = ['Male', 'Female', 'Other'];

  File? _selectedImage;

  void handleGenderChange(String? selectedGender) {
    setState(() {
      _selectedGender = selectedGender;
    });
  }
  void handleRelationChange(String? selectedGender) {
    setState(() {
      _selectedRelation = selectedGender;
    });
  }



  var _enteredAge = '';



  void _takePicture() async {
    ImageSource? source = await Utils.takePicture(context);
    if (source != null) {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(source: source, maxWidth: 600);
      if (pickedFile != null) {
        setState(() {
          _selectedImage= File(pickedFile.path);
        });
      }
    }
  }


  String? _selectedFamily;
  List<String> relationList =[
    "Father"
    ,
    "Mother"
    ,
    "Son"
    ,
    "Daughter"
    ,
    "Sister"
    ,
    "Brother"
    ,
    "Spouse"
    ,
    "Grand father"
    ,
    "Grand mother"
    ,
    "Cousin"
    ,
    "Niece"
    ,
    "Nephew"
    ,
    "Uncle"
    ,
    "Aunt"
  ];


  bool isValidEmail(String email) {
    const pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  String? _guestNameErrorMessage;

  String? _guestRelationErrorMessage;

  String? _guestAddressErrorMessage;
  String? _mobileErrorMessage;

  @override
  Widget build(BuildContext context) {
    TextStyle headerPlaceHolder = TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.04,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      color: const Color.fromARGB(181, 27, 85, 148),
    );

    Widget content = GestureDetector(
      onTap: _takePicture,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(alignment: Alignment.center, child: const AvatarScreen()),
          Positioned(
            bottom: FontSizeUtil.SIZE_07,
            right:  FontSizeUtil.SIZE_08,
            child: GestureDetector(
              onTap: _takePicture,
              child: Container(
                padding: EdgeInsets.all( FontSizeUtil.SIZE_08),
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
        ],
      ),
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_50),
          child: Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: Strings.ADD_FAMILY_HEADER,
            profile: () {},
          ),
        ),
        // drawer: const DrawerScreen(),
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
                        child: Column(
                          children: [
                            SizedBox(height: FontSizeUtil.CONTAINER_SIZE_20),
                            Container(
                              height: FontSizeUtil.CONTAINER_SIZE_100,
                              width: FontSizeUtil.CONTAINER_SIZE_100,
                              alignment: Alignment.center,
                              child: content,
                            ),

                            SizedBox(height: FontSizeUtil.CONTAINER_SIZE_15),
                            Card(
                              margin:  EdgeInsets.all( FontSizeUtil.CONTAINER_SIZE_15),
                              shadowColor: Colors.blueGrey,
                              child: Container(
                                decoration: AppStyles.decoration(context),
                                child: Padding(
                                  padding: EdgeInsets.all( FontSizeUtil.CONTAINER_SIZE_10),
                                  child: Form(
                                    key: _formKey,
                                    child: Table(
                                      columnWidths:const {
                                        0: FlexColumnWidth(2),
                                        1: FlexColumnWidth(4),
                                        // 2: FlexColumnWidth(4),
                                      },
                                      children: <TableRow>[
                                        TableRow(
                                          children: <Widget>[
                                            const TableCell(
                                              child: CustomTextLabel(
                                                  labelText: Strings.FAMILY_NAME_TEXT,
                                                  manditory: "*"),
                                            ),
                                            TableCell(
                                              child: Column(
                                                children: [
                                                  CustomTextField(
                                                    controller:
                                                        _userNameController,
                                                    scrollPadding:
                                                        EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                                  .viewInsets
                                                                  .bottom *
                                                              1,
                                                    ),
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    keyboardType:
                                                        TextInputType.name,
                                                    hintText: Strings.FAMILY_NAME_TEXT,
                                                    inputFormatter: [
                                                      FilteringTextInputFormatter
                                                          .allow(
                                                        RegExp(
                                                            r"[a-zA-Z,#0-9]+|\s"),
                                                      ),
                                                    ],
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        setState(() {
                                                          _guestNameErrorMessage =
                                                              Strings.FAMILY_NAME_ERROR_TEXT;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          _guestNameErrorMessage =
                                                              null;
                                                        });
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        setState(() {
                                                          _guestNameErrorMessage =
                                                              Strings.FAMILY_NAME_ERROR_TEXT_1;
                                                          _enteredGuestName =
                                                              value!;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          _guestNameErrorMessage =
                                                              null;
                                                        });
                                                      }
                                                    },
                                                    onSaved: (value) {
                                                      _enteredGuestName = value!;
                                                    },
                                                  ),
                                                  if (_guestNameErrorMessage !=
                                                      null)
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        _guestNameErrorMessage!,
                                                        style: const TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        TableRow(
                                          children: <Widget>[
                                            const TableCell(
                                              child: CustomTextLabel(
                                                  labelText: Strings.FAMILY_AGE_TEXT,
                                                  manditory: "*"),
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
                                                      scrollPadding:
                                                          EdgeInsets.only(
                                                              bottom: MediaQuery.of(
                                                                          context)
                                                                      .viewInsets
                                                                      .bottom *
                                                                  1.15),
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                        LengthLimitingTextInputFormatter(
                                                            3),
                                                      ],
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      style: AppStyles.heading1(
                                                          context),

                                                      onChanged: (value) {
                                                        validateAge(value);
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            _ageErrorMessage =
                                                                Strings.FAMILY_AGE_ERROR_TEXT;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            _ageErrorMessage =
                                                                null;
                                                          });
                                                        }
                                                        return null;
                                                      },

                                                      decoration: InputDecoration(
                                                        hintText: Strings.FAMILY_AGE_TEXT,
                                                        // border: InputBorder.none,
                                                        hintStyle:
                                                            headerPlaceHolder,
                                                      ),
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
                                                          style: const TextStyle(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        TableRow(
                                          children: <Widget>[
                                            const TableCell(
                                              child: CustomTextLabel(
                                                labelText: Strings.FAMILY_RELATION_TEXT,
                                                manditory: "*",
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0),
                                                child: RelationDropdownWidget(
                                                  value: _selectedRelation,
                                                  genders: relationList,
                                                  placeholder: Strings.SELECT_RELATION_TEXT,
                                                  onGenderChanged:
                                                  handleRelationChange,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        TableRow(
                                          children: <Widget>[
                                            const TableCell(
                                              child: CustomTextLabel(
                                                labelText: Strings.FAMILY_GENDER_TEXT,
                                                manditory: "*",
                                              ),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0),
                                                child: DropdownWidget(
                                                  value: _selectedGender,
                                                  genders: genders,
                                                  placeholder: Strings.SELECT_GENDER_TEXT,
                                                  onGenderChanged:
                                                      handleGenderChange,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (isValiedAge)
                                          TableRow(
                                            children: <Widget>[
                                              const TableCell(
                                                child: CustomTextLabel(
                                                  labelText: Strings.FAMILY_MOBILE_TEXT,
                                                ),
                                              ),
                                              TableCell(
                                                child: Column(
                                                  children: [
                                                    CustomTextField(
                                                      controller:
                                                          _mobileController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      hintText: Strings.FAMILY_MOBILE_TEXT,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      scrollPadding:
                                                          EdgeInsets.only(
                                                        bottom:
                                                            MediaQuery.of(context)
                                                                    .viewInsets
                                                                    .bottom *
                                                                1,
                                                      ),
                                                      inputFormatter: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                        LengthLimitingTextInputFormatter(
                                                            10),
                                                      ],
                                                      onChanged: (value) {
                                                        String? validationMessage;

                                                        if (value!.isNotEmpty) {
                                                          const mobilePattern =
                                                              r'^[0-9]{10}$';
                                                          final isValidMobile =
                                                              RegExp(mobilePattern)
                                                                  .hasMatch(
                                                                      value);

                                                          if (!isValidMobile) {
                                                            validationMessage =
                                                                Strings.FAMILE_MOBILE_ERROR_TEXT;
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
                                                          style: const TextStyle(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        if (isValiedAge)
                                          TableRow(
                                            children: <Widget>[
                                              const TableCell(
                                                child: CustomTextLabel(
                                                  labelText: Strings.FAMILY_EMAIL_TEXT,

                                                ),
                                              ),
                                              TableCell(
                                                child: Column(
                                                  children: [
                                                    CustomTextField(
                                                      inputFormatter: [
                                                        FilteringTextInputFormatter.allow(
                                                          RegExp(r"[a-zA-Z0-9._%+-@]+|\s"),
                                                        ),
                                                      ],
                                                      controller:
                                                          _emailController,
                                                      keyboardType: TextInputType
                                                          .emailAddress,
                                                      hintText: Strings.FAMILY_EMAIL_TEXT,
                                                      scrollPadding:
                                                          EdgeInsets.only(
                                                        bottom:
                                                            MediaQuery.of(context)
                                                                    .viewInsets
                                                                    .bottom *
                                                                4,
                                                      ),
                                                      textInputAction:
                                                          TextInputAction.done,

                                                      onChanged: (value) {
                                                        if (value!.isNotEmpty) {
                                                          if (isValidEmail(
                                                              value!)) {
                                                            setState(() {
                                                              showEmailErrorMessage =
                                                                  false;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              showEmailErrorMessage =
                                                                  true;
                                                            });
                                                          }
                                                        } else {
                                                          setState(() {
                                                            showEmailErrorMessage =
                                                                false;
                                                          });
                                                        }
                                                      },
                                                      validator: (value) {
                                                        return null;
                                                      },
                                                      onSaved: (value) {
                                                        _enteredEmail = value!;
                                                      },
                                                    ),
                                                    if (showEmailErrorMessage)
                                                      const Align(
                                                        alignment:
                                                            Alignment.centerLeft,
                                                        child: Text(
                                                          Strings.FAMILE_EMAIL_ERROR_TEXT,
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
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
                            // const SizedBox(height: 30),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: FontSizeUtil.CONTAINER_SIZE_25, horizontal: FontSizeUtil.CONTAINER_SIZE_50),
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: submitFmailyData,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff1B5694),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_15),
                                  ),
                                  padding:  EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_15),
                                ),
                                child: const Text(Strings.SUBMIT_FAMILY_BUTTON_TEXT,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: FontSizeUtil.CONTAINER_SIZE_120,
                            )
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

  submitFmailyData() async {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          _isLoading = true;
          String keyName = "inputData";
          var responseType = 'updateProfile';
          if (!isValiedAge) {
            if (_formKey.currentState!.validate() &&
                _guestNameErrorMessage == null &&
                _ageErrorMessage == null &&
                _guestRelationErrorMessage == null &&
                _selectedGender != null) {
              _formKey.currentState!.save();

              Utils.printLog("Below  Age");
              String partURL =
                  '${Constant.addFamilyURL}?userId=$userId&apartmentId=$apartmentId';
              NetworkUtils.filePostUploadNetWorkCall(
                  partURL,
                  keyName,
                  _getJsonData().toString(),
                  _selectedImage,
                  this,
                  responseType);
            } else {
              _isLoading = false;
              errorAlert(context, "Please Fill all manditory Filelds");
            }
          } else {
            if (_formKey.currentState!.validate() &&
                _guestNameErrorMessage == null &&
                _ageErrorMessage == null &&
                _guestRelationErrorMessage == null &&
                _mobileErrorMessage == null &&
                _selectedGender != null &&
                showEmailErrorMessage == false) {
              _formKey.currentState!.save();

              Utils.printLog("Above Age");

              String partURL =
                  '${Constant.addFamilyURL}?userId=$userId&apartmentId=$apartmentId';
              NetworkUtils.filePostUploadNetWorkCall(
                  partURL,
                  keyName,
                  _getJsonData().toString(),
                  _selectedImage,
                  this,
                  responseType);
            } else {
              _isLoading = false;

              errorAlert(context, "Please fill all mandatory fields");
            }
          }
        }
        else{
           print("else called");
           _isLoading = false;
           Utils.showCustomToast(context);
        }
      });
    });
  }

  _getJsonData() {
    final data = {
      '"fullName"': '"$_enteredGuestName"',
      '"gender"': '"$_selectedGender"',
      '"age"': '"$_enteredAge"',
      '"apartmentId"': apartmentId,
      '"mobile"': '"$_enteredMobile"',
      '"relation"': '"$_selectedRelation"',
      '"emailId"': '"$_enteredEmail"',
      '"address"': '""',
      '"pincode"': '""',
      '"state"': '""',
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
      setState(() {
        _isLoading = false;
        if (responseType == 'updateProfile') {
          ResponceModel responceModel =
              ResponceModel.fromJson(json.decode(response));

          if (responceModel.status == "success") {
            successDialog(context, responceModel.message!, const UserProfile());
          } else {
            errorAlert(context, responceModel.message!);
          }
        }
      });
    } catch (error) {
      Utils.printLog("Error text === $response");
    }
  }
}
