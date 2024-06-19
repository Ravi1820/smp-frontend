import 'dart:convert';
import 'dart:io';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/profile.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/resident/family_members/view_family_member.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:SMP/components/dropdown/gender_dropdown.dart';
import 'package:SMP/components/dropdown/text_form_field.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/widget/loader.dart';
import 'package:SMP/widget/text_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/dropdown/relation_dropdown.dart';
import '../../../model/responce_model.dart';

class EditFamilyMemberScreen extends StatefulWidget {
  EditFamilyMemberScreen({
    super.key,
    required this.memberId,
    required this.userName,
    required this.image,
    required this.relation,
    required this.age,
    required this.gender,
    required this.memberType,
    required this.familyTableId,
    required this.navigatorListener,
    required this.emailId,
    required this.phone,
    required this.baseImageIssueApi,
    required this.imageUrl,
  });

  int memberId;
  String userName;
  String image;
  String memberType;
  int familyTableId;
  String emailId;
  String phone;
  String relation;
  String age;
  String gender;
  String imageUrl;
  String baseImageIssueApi;
  NavigatorListener navigatorListener;

  @override
  State<EditFamilyMemberScreen> createState() {
    return _EditFamilyMemberScreenState();
  }
}

class _EditFamilyMemberScreenState extends State<EditFamilyMemberScreen>
    with ApiListener, NavigatorListener {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _userNameController = TextEditingController();
  var _mobileController = TextEditingController();
  var _relationController = TextEditingController();
  var _emailController = TextEditingController();

  var _ageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var _enteredMobile = '';
  var _enteredEmail = '';
  var _enteredGuestName = '';
  var _enteredRelation = '';
  String _selectedGender = '';
  String memberType = '';

  String phone = '';
  String emailId = '';
  int familyTableId = -1;
  String? baseImageIssueApi;

  bool _isNetworkConnected = false, _isLoading = false;
  int? memberId;
  String imageUrl = '';

  // var _enteredRelation = '';
  String? _selectedRelation;

  // List<String> relation =["father","mother","son","daughter","sister","brother","spouse","grand father","grand mother"];
  List<String> relationList = [
    "Father",
    "Mother",
    "Son",
    "Daughter",
    "Sister",
    "Brother",
    "Spouse",
    "Grand father",
    "Grand mother",
    "Cousin",
    "Niece",
    "Nephew",
    "Uncle",
    "Aunt"
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    validateAge(widget.age);
    _userNameController.text = widget.userName;
    _selectedRelation = widget.relation;
    _ageController.text = widget.age;
    memberId = widget.memberId;
    _selectedGender = widget.gender ?? "";
    memberType = widget.memberType;
    _emailController.text = widget.emailId;
    _mobileController.text = widget.phone;
    emailId = widget.emailId;
    phone = widget.phone;

    baseImageIssueApi = widget.baseImageIssueApi;
    imageUrl = widget.imageUrl;
    familyTableId = widget.familyTableId;
    _smpStorage();
    _getDataFromOriginal();
    checkOriginalData();
  }

  @override
  void dispose() {
    _disposalData();
    super.dispose();
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

  bool showField() {
    Utils.printLog("Phone Number comming $phone");
    return phone != null && phone.isNotEmpty;
  }

  bool showEmailField() {
    Utils.printLog("Phone Number comming $emailId");
    return emailId != null && emailId.isNotEmpty;
  }

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
      }
    }

    return validationMessage;
  }

  final genders = ['Select Gender', 'Male', 'Female', 'Other'];

  File? _selectedImage;

  void handleGenderChange(String? selectedGender) {
    if (selectedGender != null) {
      setState(() {
        _selectedGender = selectedGender;
      });
    }
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
      final pickedFile =
          await imagePicker.pickImage(source: source, maxWidth: 600);
      if (pickedFile != null) {
        setState(() {
          filePath = File(pickedFile.path);
        });
      }
    }
  }

  bool isValidEmail(String email) {
    const pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  String? _guestNameErrorMessage;

  String? _guestRelationErrorMessage;

  String? _guestAddressErrorMessage;
  String? _mobileErrorMessage;

  File? filePath = null;

  @override
  Widget build(BuildContext context) {
    TextStyle headerPlaceHolder = TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.04,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      color: const Color.fromARGB(181, 27, 85, 148),
    );

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
    //

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: Strings.EDIT_FAMILY_HEADER,
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
                              margin:  EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_15),
                              shadowColor: Colors.blueGrey,
                              child: Container(
                                decoration: AppStyles.decoration(context),
                                child: Padding(
                                  padding:  EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                                  child: Form(
                                    key: _formKey,
                                    child: Table(
                                      columnWidths: const {
                                        0: FlexColumnWidth(2),
                                        1: FlexColumnWidth(4),
                                        // 2: FlexColumnWidth(4),
                                      },
                                      children: <TableRow>[
                                        TableRow(
                                          children: <Widget>[
                                            const TableCell(
                                              child: CustomTextLabel(
                                                  labelText:
                                                      Strings.FAMILY_NAME_TEXT,
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
                                                    hintText: Strings
                                                        .FAMILY_NAME_TEXT,
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
                                                              Strings
                                                                  .FAMILY_NAME_ERROR_TEXT;
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
                                                              Strings
                                                                  .FAMILY_NAME_ERROR_TEXT_1;
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
                                                      _enteredGuestName =
                                                          value!;
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
                                                  labelText:
                                                      Strings.FAMILY_AGE_TEXT,
                                                  manditory: "*"),
                                            ),
                                            TableCell(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.all(FontSizeUtil.SIZE_02),
                                                child: Column(
                                                  children: [
                                                    TextFormField(
                                                      controller:
                                                          _ageController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      scrollPadding: EdgeInsets.only(
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
                                                                Strings
                                                                    .FAMILY_AGE_ERROR_TEXT;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            _ageErrorMessage =
                                                                null;
                                                          });
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: Strings
                                                            .FAMILY_AGE_TEXT,
                                                        // border: InputBorder.none,
                                                        hintStyle:
                                                            headerPlaceHolder,
                                                      ),
                                                      onSaved: (value) {
                                                        _enteredAge = value!;
                                                      },
                                                    ),
                                                    if (_ageErrorMessage !=
                                                        null)
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          _ageErrorMessage!,
                                                          style:
                                                              const TextStyle(
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
                                                labelText: Strings
                                                    .FAMILY_RELATION_TEXT,
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
                                                  placeholder: Strings
                                                      .SELECT_RELATION_TEXT,
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
                                                labelText:
                                                    Strings.FAMILY_GENDER_TEXT,
                                                manditory: "*",
                                              ),
                                            ),
                                            TableCell(
                                                child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0),
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 14),
                                                  child: ButtonTheme(
                                                    child: DropdownButton<
                                                            String>(
                                                        isExpanded: true,
                                                        value: (_selectedGender !=
                                                                    null &&
                                                                _selectedGender
                                                                    .isNotEmpty)
                                                            ? _selectedGender
                                                            : genders[0],
                                                        // Use the provided value directly
                                                        items:
                                                            genders.map((item) {
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
                                                              .map<Widget>(
                                                                  (item) {
                                                            return Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                child: Text(
                                                                  item,
                                                                  style: AppStyles
                                                                      .heading1(
                                                                          context),
                                                                ),
                                                              ),
                                                            );
                                                          }).toList();
                                                        }),
                                                  ),
                                                ),
                                              ),
                                            )),
                                          ],
                                        ),
                                        if (isValiedAge)
                                          TableRow(
                                            children: <Widget>[
                                              const TableCell(
                                                child: CustomTextLabel(
                                                  labelText: Strings
                                                      .FAMILY_MOBILE_TEXT,
                                                ),
                                              ),
                                              TableCell(
                                                child: Column(
                                                  children: [
                                                    AbsorbPointer(
                                                      absorbing: showField(),
                                                      child: CustomTextField(
                                                        inputFormatter: [
                                                          FilteringTextInputFormatter
                                                              .digitsOnly,
                                                          LengthLimitingTextInputFormatter(
                                                              10),
                                                        ],
                                                        controller:
                                                            _mobileController,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        hintText: Strings
                                                            .FAMILY_MOBILE_TEXT,
                                                        textInputAction:
                                                            TextInputAction
                                                                .next,
                                                        scrollPadding:
                                                            EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                      context)
                                                                  .viewInsets
                                                                  .bottom *
                                                              1,
                                                        ),
                                                        onChanged: (value) {
                                                          String?
                                                              validationMessage;

                                                          if (value!
                                                              .isNotEmpty) {
                                                            const mobilePattern =
                                                                r'^[0-9]{10}$';
                                                            final isValidMobile =
                                                                RegExp(mobilePattern)
                                                                    .hasMatch(
                                                                        value);

                                                            if (!isValidMobile) {
                                                              validationMessage =
                                                                  Strings
                                                                      .FAMILE_MOBILE_ERROR_TEXT;
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
                                                          _enteredMobile =
                                                              value!;
                                                        },
                                                      ),
                                                    ),
                                                    if (_mobileErrorMessage !=
                                                        null)
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          _mobileErrorMessage!,
                                                          style:
                                                              const TextStyle(
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
                                                  labelText:
                                                      Strings.FAMILY_EMAIL_TEXT,
                                                ),
                                              ),
                                              TableCell(
                                                child: Column(
                                                  children: [
                                                    AbsorbPointer(
                                                      absorbing:
                                                          showEmailField(),
                                                      child: CustomTextField(
                                                        inputFormatter: [
                                                          FilteringTextInputFormatter
                                                              .allow(
                                                            RegExp(
                                                                r"[a-zA-Z0-9._%+-@]+|\s"),
                                                          ),
                                                        ],
                                                        controller:
                                                            _emailController,
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                        hintText: Strings
                                                            .FAMILY_EMAIL_TEXT,
                                                        scrollPadding:
                                                            EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                      context)
                                                                  .viewInsets
                                                                  .bottom *
                                                              4,
                                                        ),
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        onChanged: (value) {
                                                          if (value!
                                                              .isNotEmpty) {
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
                                                          _enteredEmail =
                                                              value!;
                                                        },
                                                      ),
                                                    ),
                                                    if (showEmailErrorMessage)
                                                      const Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          Strings
                                                              .FAMILE_EMAIL_ERROR_TEXT,
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

                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: FontSizeUtil.CONTAINER_SIZE_25, horizontal: FontSizeUtil.CONTAINER_SIZE_12),
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (await checkOriginalData() ||
                                            filePath != null) {
                                          submitFmailyData();
                                        } else {
                                          Utils.showToast(Strings
                                              .NO_FAMILY_CHANGE_DETECTED);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff1B5694),
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_15),
                                        ),
                                        padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_15),
                                      ),
                                      child:  Text(
                                        Strings.UPDATE_FAMIILY_BUTTON_TEXT,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: FontSizeUtil.CONTAINER_SIZE_18,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding:  EdgeInsets.symmetric(
                                        vertical: FontSizeUtil.CONTAINER_SIZE_20, horizontal: FontSizeUtil.CONTAINER_SIZE_12),
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff1B5694),
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_15),
                                        ),
                                        padding:  EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_15),
                                      ),
                                      child:  Text(
                                        Strings.CANCEL_FAMIILY_BUTTON_TEXT,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: FontSizeUtil.CONTAINER_SIZE_18,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: FontSizeUtil.CONTAINER_SIZE_150,
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

  deleteFmailyData() async {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          _isLoading = true;
          String keyName = "inputData";
          var responseType = 'updateProfile';

          final Map<String, dynamic> data = <String, dynamic>{};

          data[memberType] = familyTableId;
          // data['familyTableId'] = familyTableId ;

          NetworkUtils.postNetWorkCall(
              Constant.deleteFamilyURL, data, this, responseType);
        }
      });
    });
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

          if (_formKey.currentState!.validate() &&
              _guestNameErrorMessage == null &&
              _ageErrorMessage == null &&
              _mobileErrorMessage == null &&
              showEmailErrorMessage == false &&
              _guestRelationErrorMessage == null &&
              _selectedGender != "Select Gender") {
            _formKey.currentState!.save();
            int memId = widget.memberId;

            String partURL =
                '${Constant.updateFamilyURL}?memberId=$memId&memberType=$memberType&apartmentId=$apartmentId';

            NetworkUtils.filePostUploadNetWorkCall(partURL, keyName,
                _getJsonData().toString(), filePath, this, responseType);
          } else {
            _isLoading = false;
            errorAlert(context, "Please fill all mandatory fields");
          }
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
      '"relation"': '"$_selectedRelation"',
      '"mobile"': '"$_enteredMobile"',
      '"emailId"': '"$_enteredEmail"',
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
            successDialogWithListner(context, responceModel.message!,
                const ViewFamilyMemberScreen(), this);
          } else {
            errorAlert(context, responceModel.message!);
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

  _getDataFromOriginal() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('editFamName', _userNameController.text);
    prefs.setString('editFamAge', _ageController.text);
    prefs.setString('editFamRelation', _selectedRelation!);
    prefs.setString('editFamGender', _selectedGender);
    prefs.setString('editFamImage', baseImageIssueApi!);
  }

  _disposalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('editFamName');
    prefs.remove('editFamAge');

    prefs.remove('editFamRelation');
    prefs.remove('editFamGender');
    prefs.remove('editFamImage');
  }

  Future<bool> checkOriginalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var originalName = prefs.getString('editFamName') ?? '';
    Utils.printLog('originalName : $originalName');
    var originalAge = prefs.getString('editFamAge') ?? '';
    Utils.printLog('originalAge : $originalAge');
    var originalRelation = prefs.getString('editFamRelation') ?? '';
    Utils.printLog('originalRelation : $originalRelation');
    var originalGender = prefs.getString('editFamGender') ?? '';
    Utils.printLog('originalGender: $originalGender');
    var originalImage = prefs.getString('editFamImage') ?? '';
    Utils.printLog(_userNameController.text);
    Utils.printLog(_ageController.text);
    Utils.printLog(_selectedRelation!);
    Utils.printLog(_selectedGender!);
    return _userNameController.text != originalName ||
        _ageController.text != originalAge ||
        _selectedRelation != originalRelation ||
        _selectedGender != originalGender ||
        baseImageIssueApi != originalImage;
  }
}
