import 'dart:convert';
import 'dart:io';

import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/model/update_user_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/resident/resident_raised_issues/view_issue_list.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AddIssue extends StatefulWidget {
  AddIssue({super.key, required this.navigatorListener});

  NavigatorListener? navigatorListener;

  @override
  State<AddIssue> createState() {
    return _AddIssueState();
  }
}

class _AddIssueState extends State<AddIssue>
    with ApiListener, NavigatorListener {
  final _formKey = GlobalKey<FormState>();
  bool _isNetworkConnected = false, _isLoading = false;

  var _enteredDescription = '';

  int apartmentId = 0;
  int pinCode = 0;
  String? token = '';
  int? userId = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    _smpStorage();
  }

  void _smpStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var apartId = prefs.getInt('apartmentId');

    var id = prefs.getInt('id');

    setState(() {
      token = token!;
      apartmentId = apartId!;
      userId = id!;
    });
  }

  File? _selectedImage;

  void _takePicture() async {
    ImageSource? source = await Utils.takePicture(context);
    if (source != null) {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(source: source, maxWidth: 600);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    }
  }

  bool showErrorMessage = false;
  bool showCategoryErrorMessage = false;
  bool showDescriptionErrorMessage = false;

  String? _selectedGender;
  String? _selectedPriority;
  String? _selectedCategory;

  final priority = ['High', 'Medium', 'Low'];
  final genders = ['General', 'Security', 'Maintenance'];
  Color _containerBorderColor1 = Colors.white; // Added this line
  Color _boxShadowColor1 = const Color.fromARGB(255, 100, 100, 100);

  var _enteredPassword = '';

  DateTime currentDate = DateTime.now();

  String? _enteredAdmittedDate;
  String? _enteredDichargedDate;

  final TextEditingController _dichargeDateController = TextEditingController();

  final TextEditingController _admittedDateController = TextEditingController();

  Future<void> datePicker(BuildContext context, String type) async {
    DateTime? userSelectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (userSelectedDate == null) {
      return;
    } else {
      TimeOfDay? userSelectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentDate),
      );

      if (userSelectedTime == null) {
        return;
      }

      DateTime selectedDateTime = DateTime(
        userSelectedDate.year,
        userSelectedDate.month,
        userSelectedDate.day,
        userSelectedTime.hour,
        userSelectedTime.minute,
      );

      String formattedDateTime =
          DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);

      if (type == "Admitted Date") {
        setState(() {
          _enteredAdmittedDate = formattedDateTime;
          _dichargeDateController.text = _enteredAdmittedDate ?? '';
        });
      } else if (type == "Discharged Date") {
        setState(() {
          _enteredDichargedDate = formattedDateTime;
          _admittedDateController.text = _enteredDichargedDate ?? '';
        });
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration = BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(255, 255, 255, 1),
          Color.fromRGBO(255, 255, 255, 1),
        ],
      ),
      borderRadius: BorderRadius.circular( FontSizeUtil.CONTAINER_SIZE_10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(1, 4),
        ),
      ],
    );
    Widget content = InkWell(
      onTap: _takePicture,
      child: Container(
        margin: EdgeInsets.only(right:  FontSizeUtil.CONTAINER_SIZE_10, top:  FontSizeUtil.CONTAINER_SIZE_10),
        height:  FontSizeUtil.CONTAINER_SIZE_100,
        width:  FontSizeUtil.CONTAINER_SIZE_100,
        decoration: decoration,
        child: Center(
          child: Image.asset(
            'assets/images/Vector-1.png',
            height:  FontSizeUtil.CONTAINER_SIZE_50,
            width:  FontSizeUtil.CONTAINER_SIZE_50,
            color: const Color.fromRGBO(27, 86, 148, 1.0),
          ),
        ),
      ),
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Container(
          margin: EdgeInsets.only(top: FontSizeUtil.CONTAINER_SIZE_10),
          height:  FontSizeUtil.CONTAINER_SIZE_100,
          width:  FontSizeUtil.CONTAINER_SIZE_100,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 233, 162, 0.5),
            borderRadius: BorderRadius.circular( FontSizeUtil.CONTAINER_SIZE_20),
          ),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular( FontSizeUtil.CONTAINER_SIZE_20),
              child: Image.file(
                _selectedImage!,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
       return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: Strings.RAISE_ISSUE_HEADER,
            profile: () async {
              Navigator.of(context)
                  .push(createRoute(DashboardScreen(isFirstLogin: false)));
            },

          ),
        ),
        body: AbsorbPointer(
          absorbing: _isLoading,
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Container(
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
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                        Card(
                          margin:  EdgeInsets.all( FontSizeUtil.CONTAINER_SIZE_15),
                          shadowColor: Colors.blueGrey,
                          child: Container(
                            decoration: decoration,
                            child: Padding(
                              padding:  EdgeInsets.all( FontSizeUtil.CONTAINER_SIZE_10),
                              child: Form(
                                key: _formKey,
                                child: Table(
                                  children: <TableRow>[
                                    TableRow(children: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                           SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                                          RichText(
                                            text:  TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: Strings.ISSUE_CATAGORY_LABEL,
                                                  style: TextStyle(
                                                    color:const Color.fromRGBO(
                                                        27, 86, 148, 1.0),
                                                    fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: FontSizeUtil.CONTAINER_SIZE_15,
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
                                                  borderRadius:
                                                      BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_10),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Color.fromARGB(
                                                          255, 100, 100, 100),
                                                      blurRadius: 6,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                height: FontSizeUtil.CONTAINER_SIZE_45,
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: ButtonTheme(
                                                    alignedDropdown: true,
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      isExpanded: true,
                                                      value: _selectedGender,
                                                      items: genders.map((item) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: item,
                                                          child: Text(item,
                                                              style: AppStyles
                                                                  .heading1(
                                                                      context)),
                                                        );
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            showCategoryErrorMessage =
                                                                true;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            _selectedCategory =
                                                                value;
                                                          });
                                                          setState(() {
                                                            showCategoryErrorMessage =
                                                                false;
                                                          });
                                                        }
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            showCategoryErrorMessage =
                                                                true;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            showCategoryErrorMessage =
                                                                false;
                                                          });
                                                          return null;
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                           InputDecoration(
                                                        border: InputBorder
                                                            .none, // Remove the bottom border line
                                                        hintText:
                                                            Strings.ISSUE_SELECT_CATAGORY_TEXT,
                                                        contentPadding:
                                                            EdgeInsets.symmetric(
                                                                horizontal: FontSizeUtil.CONTAINER_SIZE_16),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (showCategoryErrorMessage)
                                             Text(
                                              Strings.SELECT_CATAGORY_ERROR_TEXT,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: FontSizeUtil.CONTAINER_SIZE_15),
                                            ),
                                           SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                                        ],
                                      ),
                                    ]),
                                    TableRow(children: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start, // Align content to the start (left)

                                        children: [
                                           SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: Strings.ISSUE_PRIORITY_TEXT,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        27, 86, 148, 1.0),
                                                    fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: FontSizeUtil.CONTAINER_SIZE_15,
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
                                                  borderRadius:
                                                      BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_10),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Color.fromARGB(
                                                          255, 100, 100, 100),
                                                      blurRadius: 6,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                height: FontSizeUtil.CONTAINER_SIZE_45,
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: ButtonTheme(
                                                    alignedDropdown: true,
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      isExpanded: true,
                                                      value: _selectedPriority,
                                                      items: priority.map((item) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: item,
                                                          child: Text(item,
                                                              style: AppStyles
                                                                  .heading1(
                                                                      context)),
                                                        );
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            showErrorMessage =
                                                                true;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            _selectedPriority =
                                                                value;
                                                          });
                                                          setState(() {
                                                            showErrorMessage =
                                                                false;
                                                          });
                                                        }
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            showErrorMessage =
                                                                true;
                                                          });
                                                          // return 'Please select a category';
                                                        } else {
                                                          setState(() {
                                                            showErrorMessage =
                                                                false;
                                                          });
                                                          return null;
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border: InputBorder.none,
                                                        hintText:
                                                        Strings.ISSUE_SELECT_PRIORITY_TEXT,
                                                        contentPadding:
                                                            EdgeInsets.symmetric(
                                                                horizontal: FontSizeUtil.CONTAINER_SIZE_16),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                           SizedBox(height:FontSizeUtil.SIZE_05),
                                          if (showErrorMessage)
                                             Text(
                                             Strings.SELECT_PRIORITY_ERROR_TEXT,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: FontSizeUtil.CONTAINER_SIZE_15),
                                            ),
                                           SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                                        ],
                                      ),
                                    ]),
                                    TableRow(children: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,

                                        children: [
                                          RichText(
                                            text:  TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: Strings.ISSSUE_DESCRIPTION_TEXT,
                                                  style: TextStyle(
                                                    color : const Color.fromRGBO(
                                                        27, 86, 148, 1.0),
                                                    fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: FontSizeUtil.CONTAINER_SIZE_15,
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
                                              FocusScope(
                                                child: Focus(
                                                  onFocusChange: (hasFocus) {
                                                    setState(() {
                                                      _containerBorderColor1 =
                                                          hasFocus
                                                              ? const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  0,
                                                                  137,
                                                                  250)
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
                                                          BorderRadius.circular(
                                                              FontSizeUtil.CONTAINER_SIZE_10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: _boxShadowColor1,
                                                          blurRadius: 6,
                                                          offset:
                                                              const Offset(0, 2),
                                                        ),
                                                      ],
                                                      border: Border.all(
                                                        color:
                                                            _containerBorderColor1,
                                                      ),
                                                    ),
                                                    height: FontSizeUtil.CONTAINER_SIZE_100,
                                                    child: TextFormField(
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter.deny(Strings.EMOJI_DENY_REGEX)
                                                      ],
                                                      keyboardType:
                                                          TextInputType.multiline,
                                                      maxLines: 30,
                                                      scrollPadding:
                                                          EdgeInsets.only(
                                                              bottom: MediaQuery.of(
                                                                          context)
                                                                      .viewInsets
                                                                      .bottom *
                                                                  1.40),
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      style: AppStyles.heading1(
                                                          context),
                                                      decoration:
                                                           InputDecoration(
                                                        border: InputBorder.none,
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: FontSizeUtil.CONTAINER_SIZE_14,
                                                                left: FontSizeUtil.CONTAINER_SIZE_20),
                                                        hintText:
                                                            Strings.ISSUE_DESCRIPTION_PLASCEHOLDER,
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.black38),
                                                      ),
                                                      onChanged: (value) {
                                                        String? validationMessage;

                                                        if (value.isEmpty) {
                                                          validationMessage =
                                                              Strings.ISSUE_DESCRIPTION_ERROR_TEXT;
                                                        }
                                                        if (validationMessage !=
                                                            null) {
                                                          setState(() {
                                                            showDescriptionErrorMessage =
                                                                true;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            showDescriptionErrorMessage =
                                                                false;
                                                          });
                                                        }
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            showDescriptionErrorMessage =
                                                                true;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            showDescriptionErrorMessage =
                                                                false;
                                                          });
                                                          return null;
                                                        }
                                                      },
                                                      onSaved: (value) {
                                                        _enteredDescription =
                                                            value!;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: FontSizeUtil.SIZE_05),
                                          if (showDescriptionErrorMessage)
                                             Text(
                                              Strings.ISSUE_DESCRIPTION_ERROR_TEXT1,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: FontSizeUtil.CONTAINER_SIZE_15),
                                            ),
                                           SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                                        ],
                                      ),
                                    ]),
                                    TableRow(children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                           SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                                          RichText(
                                            text:  TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: Strings.UPLOAD_ISSUE_IMAGE_TEXT,
                                                  style: TextStyle(
                                                    color:const Color.fromRGBO(
                                                        27, 86, 148, 1.0),
                                                    fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          content,
                                        ],
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: FontSizeUtil.CONTAINER_SIZE_15, horizontal: FontSizeUtil.CONTAINER_SIZE_50),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              _formKey.currentState!.save();

                              print(_selectedCategory);
                              print(_selectedPriority);

                              if (_formKey.currentState!.validate() &&
                                  showDescriptionErrorMessage == false &&
                                  showErrorMessage == false &&
                                  showCategoryErrorMessage == false) {
                                _formKey.currentState!.save();
                                _raiseIssueApi();

                              } else {
                                Utils.showToast(
                                    Strings.MANDATORY_WARNING_TEXT);
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
                            child:  Text(Strings.ISSUE_SUBMIT_BUTTON_TEXT,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: FontSizeUtil.CONTAINER_SIZE_18,
                                )),
                          ),
                        ),
                        SizedBox(height: FontSizeUtil.CONTAINER_SIZE_150),
                        // const FooterScreen()
                      ],
                    ),
                  ),
                ),
              ),
              if (_isLoading) Positioned(child: LoadingDialog()),
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

  _raiseIssueApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    var apartmentId = prefs.getInt('apartmentId');
    var selectedFlatId = prefs.getString(Strings.FLATID);
    Utils.printLog("$selectedFlatId");

    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          _isLoading = true;
          var responseType = 'raiseIssue';
          String keyName = "issueData";
          String partURL = Constant.raiseIssueURL;
          NetworkUtils.filePostUploadNetWorkCall(partURL, keyName,
              _getJsonData(selectedFlatId).toString(), _selectedImage, this, responseType);
        }
        else {
          Utils.printLog("else called");
          Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
        }
      });
    });
  }

  _getJsonData(selectedFlatId) {
    final data = {
      '"catagory"': '"$_selectedCategory"',
      '"issueType"': '"$_selectedCategory"',
      '"description"': '"$_enteredDescription"',
      '"priority"': '"$_selectedPriority"',
      '"residentId"': userId,
      '"flatId"' :selectedFlatId,
      '"apartmentId"': apartmentId
    };

    return data;
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
      setState(() {
        _isLoading = false;
        if (responseType == 'raiseIssue') {
          UpdateUserModel responceModel =
              UpdateUserModel.fromJson(json.decode(response));

          if (responceModel.status == "success") {
            FocusScope.of(context).unfocus();
            var message = "You have successfully raised an issue";
            successDialogWithListner(
                context, message,const ViewListScreen(), this);
          } else {
            errorAlert(context, responceModel.message!);
          }
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Utils.printLog("Error text === $response");
    }
  }

  @override
  onNavigatorBackPressed() {
    Navigator.pop(context);
    // Navigator.pop(context);
    widget.navigatorListener!.onNavigatorBackPressed();


  }
}



