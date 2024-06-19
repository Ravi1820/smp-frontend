import 'dart:convert';
import 'dart:io';
import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/profile.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/resident/family_members/edit_family_member.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/widget/loader.dart';
import 'package:SMP/widget/text_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewDetailedFamilyMemberScreen extends StatefulWidget {
  ViewDetailedFamilyMemberScreen({
    super.key,
    required this.memberId,
    required this.userName,
    required this.image,
    required this.relation,
    required this.age,
    required this.gender,
    required this.memberType,
    required this.familyTableId,
    required this.baseImageIssueApi,
    required this.apartmentId,
    required this.navigatorListener,
    required this.emailId,
    required this.profilePicture,
    required this.phone,
  });

  int memberId;
  int apartmentId;
  String userName;
  String image;
  String profilePicture;
  String memberType;
  int familyTableId;
  String emailId;
  String phone;
  String relation;
  String age;
  String gender;
  String baseImageIssueApi;
  NavigatorListener navigatorListener;

  @override
  State<ViewDetailedFamilyMemberScreen> createState() {
    return _ViewDetailedFamilyMemberState();
  }
}

class _ViewDetailedFamilyMemberState
    extends State<ViewDetailedFamilyMemberScreen> with ApiListener {
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

  String? imageUrl;

  bool _isNetworkConnected = false, _isLoading = false;
  int? memberId;

  String baseImageIssueApi = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    validateAge(widget.age);
    _userNameController.text = widget.userName;
    _relationController.text = widget.relation;
    _ageController.text = widget.age;
    memberId = widget.memberId;
    _selectedGender = widget.gender;
    emailId = widget.emailId;
    phone = widget.phone;

    imageUrl = widget.profilePicture;

    memberType = widget.memberType;
    familyTableId = widget.familyTableId;
    _smpStorage();
    _getUser();
  }

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('apartmentId');

    setState(() {
      baseImageIssueApi = BaseApiImage.baseImageUrl(id!, "profile");
    });
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

  var _enteredAge = '';

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

    Widget imageContent = GestureDetector(
      child: const AvatarScreen(),
    );

    if (imageUrl!.isNotEmpty) {
      imageContent = GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color.fromARGB(192, 177, 177, 177),
              width: FontSizeUtil.SIZE_01,
            ),
            borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_50),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_50),
            child: Stack(
              children: <Widget>[
                if (imageUrl != null && imageUrl!.isNotEmpty)
                  Image.network(
                    '$baseImageIssueApi${imageUrl.toString()}',
                    fit: BoxFit.cover,
                    width: FontSizeUtil.CONTAINER_SIZE_100,
                    height: FontSizeUtil.CONTAINER_SIZE_100,
                    errorBuilder: (context, error, stackTrace) {
                      // Handle image loading errors here
                      return Image.asset(
                        "assets/images/no-img.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      );
                    },
                  )
                else
                  Image.asset(
                    "assets/images/no-img.png",
                    fit: BoxFit.cover,
                    width: FontSizeUtil.CONTAINER_SIZE_100,
                    height: FontSizeUtil.CONTAINER_SIZE_100,
                  ),
              ],
            ),
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
            title: Strings.VIEW_FAMILY_MEMBER_HEADER,
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
                              child: imageContent,
                            ),
                            SizedBox(height: FontSizeUtil.SIZE_15),
                            Card(
                              margin: EdgeInsets.all(
                                  FontSizeUtil.CONTAINER_SIZE_15),
                              shadowColor: Colors.blueGrey,
                              child: Container(
                                decoration: AppStyles.decoration(context),
                                child: Padding(
                                  padding: EdgeInsets.all(
                                      FontSizeUtil.CONTAINER_SIZE_10),
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
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: CustomTextLabel(
                                                      labelText:
                                                          _userNameController
                                                              .text,
                                                    ),
                                                  ),
                                                  Divider(),
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
                                                padding: EdgeInsets.all(
                                                    FontSizeUtil.SIZE_02),
                                                child: Column(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: CustomTextLabel(
                                                        labelText:
                                                            _ageController.text,
                                                      ),
                                                    ),
                                                    Divider()
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
                                                  manditory: "*"),
                                            ),
                                            TableCell(
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: CustomTextLabel(
                                                      labelText:
                                                          _relationController
                                                              .text,
                                                    ),
                                                  ),
                                                  Divider()
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (_selectedGender != null &&
                                            _selectedGender.isNotEmpty)
                                          TableRow(
                                            children: <Widget>[
                                              const TableCell(
                                                child: CustomTextLabel(
                                                  labelText: Strings
                                                      .FAMILY_GENDER_TEXT,
                                                  manditory: "*",
                                                ),
                                              ),
                                              TableCell(
                                                  child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0),
                                                child: Column(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: CustomTextLabel(
                                                        labelText:
                                                            _selectedGender,
                                                      ),
                                                    ),
                                                    Divider()
                                                  ],
                                                ),
                                              )),
                                            ],
                                          ),
                                        if (phone != null && phone.isNotEmpty)
                                          TableRow(
                                            children: <Widget>[
                                              const TableCell(
                                                child: CustomTextLabel(
                                                  labelText: Strings
                                                      .FAMILY_MOBILE_TEXT,
                                                ),
                                              ),
                                              TableCell(
                                                  child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0),
                                                child: Column(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: CustomTextLabel(
                                                          labelText: phone),
                                                    ),
                                                    Divider()
                                                  ],
                                                ),
                                              )),
                                            ],
                                          ),
                                        if (emailId != null &&
                                            emailId.isNotEmpty)
                                          TableRow(
                                            children: <Widget>[
                                              const TableCell(
                                                child: CustomTextLabel(
                                                  labelText:
                                                      Strings.FAMILY_EMAIL_TEXT,
                                                ),
                                              ),
                                              TableCell(
                                                  child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0),
                                                child: Column(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: CustomTextLabel(
                                                        labelText: emailId,
                                                      ),
                                                    ),
                                                    Divider()
                                                  ],
                                                ),
                                              )),
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
                                        vertical:
                                            FontSizeUtil.CONTAINER_SIZE_25,
                                        horizontal:
                                            FontSizeUtil.CONTAINER_SIZE_80),
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: submitFmailyData,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff1B5694),
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              FontSizeUtil.CONTAINER_SIZE_15),
                                        ),
                                        padding: EdgeInsets.all(
                                            FontSizeUtil.CONTAINER_SIZE_15),
                                      ),
                                      child: Text(
                                        Strings.FAMILY_EDIT_BUTTON_TEXT,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              FontSizeUtil.CONTAINER_SIZE_18,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: FontSizeUtil.CONTAINER_SIZE_80,
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
          NetworkUtils.postNetWorkCall(
              Constant.deleteFamilyURL, data, this, responseType);
        } else {
          print("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  submitFmailyData() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EditFamilyMemberScreen(
          memberId: widget.memberId ?? 0,
          userName: widget.userName ?? "",
          image: widget.profilePicture ?? "",
          relation: widget.relation ?? "",
          imageUrl: widget.profilePicture ?? "",
          baseImageIssueApi: baseImageIssueApi ?? "",
          memberType: widget.memberType ?? "",
          phone: widget.phone ?? "",
          emailId: widget.emailId ?? "",
          familyTableId: widget.familyTableId ?? 0,
          age: widget.age ?? "",
          gender: widget.gender ?? "",
          navigatorListener: widget.navigatorListener,
        ),
      ),
    );
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
