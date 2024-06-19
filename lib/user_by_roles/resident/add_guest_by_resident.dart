import 'dart:convert';
import 'dart:io';

import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/model/success_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:SMP/components/dropdown/gender_dropdown.dart';
import 'package:SMP/components/dropdown/text_form_field.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/widget/loader.dart';
import 'package:SMP/widget/text_label.dart';
import 'package:SMP/user_by_roles/resident/whatsapp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/src/material/date_picker_theme.dart'
    show DatePickerTheme;

import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

import '../../utils/size_utility.dart';

class AddGuestByResident extends StatefulWidget {
  const AddGuestByResident({super.key});

  @override
  State<AddGuestByResident> createState() {
    return _AddGuestByResidentState();
  }
}

class _AddGuestByResidentState extends State<AddGuestByResident>
    with ApiListener, NavigatorListener {

  bool _isNetworkConnected = false, _isLoading = false;

  var _guestNameController = TextEditingController();

  var _mobileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _enteredAadharIdenty = '';
  var enteredIdenty = '';

  var _enteredPanIdenty = '';

  var _enteredVisitorCount = '1';

  var _enteredMobile = '';
  var _enteredGuestName = '';
  var _enteredGuestAddress = '';

  String? _selectedGender;
  String? _selectedIdentyType;

  String? _guestPollEndErrorMessage;
  String? _guestPollStartErrorMessage;
  String? _guestOtherPurposeErrorMessage;
  String? _guestPurposeErrorMessage;
  String? _countErrorMessage;
  int _counter = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    _guestFromDateController.addListener(() {
      setState(() {
        _guestPollStartErrorMessage =
            validateStartDate(_guestFromDateController.text);
      });
    });

    _guestToDateController.addListener(() {
      setState(() {
        _guestPollEndErrorMessage =
            validateEndDate(_guestToDateController.text);
      });
    });
    _smpStorage();
  }

  String? validateStartDate(String input) {
    // Implement your validation logic for the "From Date" field here.
    // Return an error message if the validation fails, otherwise return null.
    // For example, you can check if the selected date is in the past.
    DateTime selectedDate = DateTime.parse(input);
    DateTime currentDate = DateTime.now();

    // if (selectedDate.isBefore(currentDate)) {
    //   return 'From Date must be in the future';
    // }

    return null;
  }

  String? validateEndDate(String input) {
    DateTime selectedDate = DateTime.parse(input);

    if (_fromDateTime != null && selectedDate.isBefore(_fromDateTime!)) {
      return 'To Date must be after From Date';
    } else if (_fromDateTime != null && selectedDate == _fromDateTime) {
      // Check if the time is after the "From Time"
      String formattedFromTime = DateFormat('HH:mm:ss').format(_fromDateTime!);
      String formattedEndTime = DateFormat('HH:mm:ss').format(selectedDate);

      if (formattedEndTime.compareTo(formattedFromTime) <= 0) {
        return 'End time should be after Start time';
      }
    }

    return null;
  }

  String? token;
  String userName = "";

  int? userId;
  int? apartmentId;
  String? selectedFlatId = '';

  void _smpStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var id = prefs.getInt('id');
    var apartId = prefs.getInt('apartmentId');

    var userNam = prefs.getString('userName');

    setState(() {
      token = token!;
      Utils.printLog('token: $token');
      apartmentId = apartId;
      selectedFlatId = prefs.getString('flatId');
      Utils.printLog('FlatId: $selectedFlatId');
      userId = id!;
      userName = userNam!;
    });
  }

  bool obscure = false;

  final genders = ['Male', 'Female', 'Other'];
  final purpose = ['Personal', 'Parcels ', 'Maintenance', 'Others'];

  final identyType = ['Aadhaar', 'PAN'];
  File? _selectedImage;
  String? _enteredPurposeToMeet;

  void handleGenderChange(String? selectedGender) {
    setState(() {
      _selectedGender = selectedGender;
    });
  }

  void handleIdProofChange(String? selectedIdProof) {
    setState(() {
      _selectedIdentyType = selectedIdProof;
    });
  }

  void handlePurposeValidate(String? value) {
    if (value == null || value.isEmpty) {
      _guestPurposeErrorMessage = "Please select any purpose.";
    }
    return;
  }

  String? _selectedPurpose;

  void handlePurposeChange(String? selectedPurpose) {
    setState(() {
      _selectedPurpose = selectedPurpose;
      _enteredPurposeToMeet = null;
    });
  }
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

  String? _guestNameErrorMessage;
  String? _guestAddressErrorMessage;
  String? _guestIdentyErrorMessage;
  String? _guestIdentyPanErrorMessage;

  String? _mobileErrorMessage;
  DateTime currentDate = DateTime.now();

  DateTime? _fromDateTime;
  DateTime? _toDateTime;
  String? _enteredAdmittedDate; // Add these variables
  String? _enteredDichargedDate; // Add these variables
  int counterValue = 0;



  final TextEditingController _guestToDateController = TextEditingController();

  final TextEditingController _guestFromDateController =
      TextEditingController();


  Future<void> datePicker(BuildContext context, String type) async {
    DateTime currentDate = DateTime.now();
    DateTime lastDate = DateTime(2100);

    // Show the date picker
    DatePicker.showDatePicker(
      context,
      theme: picker.DatePickerTheme(
        containerHeight: 210.0,
      ),
      showTitleActions: true,
      onConfirm: (date) async {
        print('confirm $date');
        // Set the selected date to a formatted string
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);

        // Show the time picker
        DatePicker.showTimePicker(
          context,
          theme: picker.DatePickerTheme(
            containerHeight: 210.0,
          ),
          showTitleActions: true,
          showSecondsColumn: false,
          onConfirm: (time) {
            print('confirm $time');
            // Set the selected time to a formatted string
            String formattedTime = '${time.hour}:${time.minute}:${time.second}';

            // Combine the selected date and time
            DateTime selectedDateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
              time.second,
            );

            // Format the combined date and time
            String formattedDateTime =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDateTime);

            // Update state based on the type (Admitted Date or Discharged Date)
            if (type == "Admitted Date") {
              setState(() {
                _enteredAdmittedDate = formattedDateTime;
                _guestFromDateController.text = _enteredAdmittedDate ?? '';
                _fromDateTime = selectedDateTime;
              });
            } else if (type == "Discharged Date") {
              setState(() {
                _enteredDichargedDate = formattedDateTime;
                _guestToDateController.text = _enteredDichargedDate ?? '';
                _toDateTime = selectedDateTime; // Store the selected DateTime
              });
            }

            (context as Element).markNeedsBuild(); // Rebuild the UI
          },
          currentTime: DateTime.now(),
          // Set the current time as initial time
          locale: picker.LocaleType.en,
        );
      },
      currentTime: currentDate,
      // Set the current date as initial date
      locale: picker.LocaleType.en,
      minTime: currentDate,
      // Set the minimum time to the current date
      maxTime: lastDate, // Set the maximum time to the last date
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Widget content = GestureDetector(
      onTap: _takePicture,
      child: Stack(
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



    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: CustomAppBar(
              title: Strings.PRE_APPROVE_GUEST_HEADER,
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
                              SizedBox(height: FontSizeUtil.CONTAINER_SIZE_20),
                              Container(
                                height:  FontSizeUtil.CONTAINER_SIZE_100,
                                width:  FontSizeUtil.CONTAINER_SIZE_100,
                                alignment: Alignment.center,
                                child: content,
                              ),

                              Card(
                                margin:  EdgeInsets.all( FontSizeUtil.CONTAINER_SIZE_15),
                                shadowColor: Colors.blueGrey,
                                child: Container(
                                  decoration: AppStyles.decoration(context),
                                  child: Padding(
                                    padding:  EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                                    child: Form(
                                      key: _formKey,
                                      child: Table(
                                        columnWidths:const {
                                          0: FlexColumnWidth(4),
                                          1: FlexColumnWidth(4),

                                        },
                                        children: <TableRow>[
                                          TableRow(
                                            children: <Widget>[
                                               TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.all( FontSizeUtil.SIZE_01),
                                                  child:const CustomTextLabel(
                                                      labelText:Strings.GUEST_NAME_LABEL_TEXT,
                                                      manditory: "*"),
                                                ),
                                              ),
                                              TableCell(
                                                child: Column(
                                                  children: [
                                                    CustomTextField(
                                                      controller:
                                                          _guestNameController,
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
                                                      inputFormatter: [
                                                        FilteringTextInputFormatter
                                                            .allow(
                                                          RegExp(
                                                              r"[a-zA-Z,#0-9]+|\s"),
                                                        ),
                                                      ],
                                                      hintText: Strings.GUEST_NAME_HINT_TEXT,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            _guestNameErrorMessage =
                                                               Strings.NAME_REQU_TEXT;
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
                                                               Strings.NAME_SHU_VALID;
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
                                               TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.all( FontSizeUtil.SIZE_01),
                                                  child: CustomTextLabel(
                                                    labelText: Strings.MOBILE_LABEL_TEXT,
                                                    manditory: "*",
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Column(
                                                  children: [
                                                    CustomTextField(
                                                      controller:
                                                          _mobileController,
                                                      scrollPadding:
                                                          EdgeInsets.only(
                                                        bottom:
                                                            MediaQuery.of(context)
                                                                    .viewInsets
                                                                    .bottom *
                                                                1,
                                                      ),
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatter: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                        LengthLimitingTextInputFormatter(
                                                            10),
                                                      ],
                                                      hintText: Strings.MOBILE_HINT_TXT,
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
                                                               Strings.MOB_INVALID_MESSAGE;
                                                          }
                                                        }

                                                        setState(() {
                                                          _mobileErrorMessage =
                                                              validationMessage;
                                                        });
                                                      },
                                                      validator: (value) {
                                                        String? validationMessage;

                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            _mobileErrorMessage =
                                                               Strings.MOB_NUM_REQ;
                                                          });
                                                        } else if (value!
                                                            .isNotEmpty) {
                                                          const mobilePattern =
                                                              r'^[0-9]{10}$';
                                                          final isValidMobile =
                                                              RegExp(mobilePattern)
                                                                  .hasMatch(
                                                                      value);

                                                          if (!isValidMobile) {
                                                            _mobileErrorMessage =
                                                               Strings.MOB_INVALID_MESSAGE;
                                                          }
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
                                               TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.all(FontSizeUtil.SIZE_01),
                                                  child: CustomTextLabel(
                                                    labelText: Strings.FROM_DATE_LABEL_TEXT,
                                                    manditory: "*",
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding:
                                                       EdgeInsets.all(FontSizeUtil.SIZE_02),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                             BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(
                                                              color: Colors.black,
                                                              width: FontSizeUtil.SIZE_01,
                                                            ),
                                                          ),
                                                        ),
                                                        height:FontSizeUtil.CONTAINER_SIZE_50,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child: InkWell(
                                                                onTap: () {
                                                                  datePicker(
                                                                      context,
                                                                      "Admitted Date");
                                                                },
                                                                child:
                                                                    AbsorbPointer(
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _guestFromDateController,
                                                                    style: AppStyles
                                                                        .heading1(
                                                                            context),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      hintText:
                                                                         Strings.FROM_DATE_HIN_TEXT,
                                                                      hintStyle:
                                                                         AppStyles.headerPlaceHolder(context),
                                                                      border:
                                                                          InputBorder
                                                                              .none,
                                                                    ),
                                                                    validator:
                                                                        (value) {
                                                                      if (value ==
                                                                              null ||
                                                                          value
                                                                              .isEmpty) {
                                                                        setState(
                                                                            () {
                                                                          _guestPollStartErrorMessage =
                                                                              Strings.DATE_REQ_TEXT;
                                                                        });
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          _guestPollStartErrorMessage =
                                                                              null;
                                                                        });
                                                                      }
                                                                      return null;
                                                                    },
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        _guestPollStartErrorMessage =
                                                                            validateStartDate(
                                                                                value);
                                                                      });
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                datePicker(
                                                                    context,
                                                                    "Admitted Date");
                                                              },
                                                              child: const Icon(
                                                                Icons.date_range,
                                                                color: Color(
                                                                    0xff4d004d),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: FontSizeUtil.SIZE_05),
                                                      if (_guestPollStartErrorMessage !=
                                                          null)
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            _guestPollStartErrorMessage!,
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
                                               TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.all(FontSizeUtil.SIZE_01),
                                                  child: CustomTextLabel(
                                                    labelText:Strings.TO_DATE_LABEL_TEXT,
                                                    manditory: "*",
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding:
                                                       EdgeInsets.all(FontSizeUtil.SIZE_02),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                             BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(
                                                              color: Colors.black,
                                                              width:FontSizeUtil.SIZE_01,
                                                            ),
                                                          ),
                                                        ),
                                                        height: FontSizeUtil.CONTAINER_SIZE_50,
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: InkWell(
                                                                onTap: () {
                                                                  datePicker(
                                                                      context,
                                                                      "Discharged Date");
                                                                },
                                                                child:
                                                                    AbsorbPointer(
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _guestToDateController,
                                                                    style: AppStyles
                                                                        .heading1(
                                                                            context),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      hintText:
                                                                        Strings.TO_DATE_HIN_TEXT,
                                                                      hintStyle:
                                                                      AppStyles.headerPlaceHolder(context),
                                                                      border:
                                                                          InputBorder
                                                                              .none,
                                                                    ),
                                                                    validator:
                                                                        (value) {
                                                                      if (value ==
                                                                              null ||
                                                                          value
                                                                              .isEmpty) {
                                                                        setState(
                                                                            () {
                                                                          _guestPollEndErrorMessage =
                                                                             Strings.DATE_REQ_TEXT;
                                                                        });
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          _guestPollEndErrorMessage =
                                                                              null;
                                                                        });
                                                                      }
                                                                      return null;
                                                                    },
                                                                    onChanged:
                                                                        (value) {
                                                                      _formKey
                                                                          .currentState!
                                                                          .save();

                                                                      String?
                                                                          validationMessage;

                                                                      final startDateTime =
                                                                          DateTime.parse(
                                                                              _enteredAdmittedDate!);
                                                                      final endDateTime =
                                                                          DateTime.parse(
                                                                              _enteredDichargedDate!);
                                                                      if (endDateTime
                                                                          .isBefore(
                                                                              startDateTime)) {
                                                                        validationMessage =
                                                                          Strings.END_TIME_MESS;
                                                                      }
                                                                      if (validationMessage !=
                                                                          null) {
                                                                        setState(
                                                                            () {
                                                                          _guestPollEndErrorMessage =
                                                                              validationMessage;
                                                                        });
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          _guestPollEndErrorMessage =
                                                                              null;
                                                                        });
                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                datePicker(
                                                                    context,
                                                                    "Discharged Date");
                                                              },
                                                              child: const Icon(
                                                                Icons.date_range,
                                                                color: Color(
                                                                    0xff4d004d),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                       SizedBox(height: FontSizeUtil.SIZE_05),
                                                      if (_guestPollEndErrorMessage !=
                                                          null)
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            _guestPollEndErrorMessage!,
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
                                               TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.all(FontSizeUtil.SIZE_01),
                                                  child: CustomTextLabel(
                                                    labelText: Strings.PUR_TO_MEET,
                                                    manditory: "*",
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 0),
                                                  child: Column(
                                                    children: [
                                                      DropdownWidget(
                                                        value: _selectedPurpose,
                                                        genders: purpose,
                                                        placeholder:
                                                           Strings.SEL_PUR,
                                                        onGenderChanged:
                                                            handlePurposeChange,

                                                        // validate: handlePurposeValidate,

                                                        validate: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            setState(() {
                                                              _guestPurposeErrorMessage =
                                                                 Strings.PUR_REQ_TXT;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              _guestPurposeErrorMessage =
                                                                  null;
                                                            });
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                      if (_guestPurposeErrorMessage !=
                                                          null)
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            _guestPurposeErrorMessage!,
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
                                              TableCell(
                                                child: Visibility(
                                                  visible: _selectedPurpose ==
                                                    Strings.OTHERS,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(FontSizeUtil.SIZE_01),
                                                    child: CustomTextLabel(
                                                      labelText:Strings.OTH_PUR,
                                                      manditory: "*",
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Visibility(
                                                  visible: _selectedPurpose ==
                                                     Strings.OTHERS,
                                                  maintainState: true,
                                                  maintainAnimation: true,
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(FontSizeUtil.SIZE_02),
                                                    child: Column(
                                                      children: [
                                                        TextFormField(
                                                          scrollPadding: EdgeInsets.only(
                                                              bottom: MediaQuery.of(
                                                                          context)
                                                                      .viewInsets
                                                                      .bottom *
                                                                  3.15),
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .allow(
                                                              RegExp(
                                                                  r"[a-zA-Z,#0-9]+|\s"),
                                                            ),
                                                          ],
                                                          style:
                                                              AppStyles.heading1(
                                                                  context),
                                                          decoration:
                                                              InputDecoration(
                                                            hintText:
                                                               Strings.PUR_HIN_TXT,
                                                            hintStyle:
                                                            AppStyles.headerPlaceHolder(context),
                                                          ),
                                                          onChanged: (value) {
                                                            String?
                                                                validationMessage;

                                                            if (value.isEmpty) {
                                                              validationMessage =
                                                                 Strings.PUR_REQ_TXT;
                                                            }
                                                            if (validationMessage !=
                                                                null) {
                                                              setState(() {
                                                                _guestOtherPurposeErrorMessage =
                                                                    validationMessage;
                                                              });
                                                            } else {
                                                              setState(() {
                                                                _guestOtherPurposeErrorMessage =
                                                                    null;
                                                              });
                                                            }
                                                          },
                                                          onSaved: (value) {
                                                            _enteredPurposeToMeet =
                                                                value!;
                                                          },
                                                        ),
                                                        if (_guestOtherPurposeErrorMessage !=
                                                            null)
                                                          Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              _guestOtherPurposeErrorMessage!,
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
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: FontSizeUtil.SIZE_07,
                                                  ),
                                                  child: CustomTextLabel(
                                                    labelText:Strings.NUM_GUEST_LABEL_TXT,
                                                    manditory: "*",
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding:  EdgeInsets.only(
                                                    top: FontSizeUtil.CONTAINER_SIZE_18,
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        height: FontSizeUtil
                                                            .CONTAINER_HEGIHT_SIZE,
                                                        width: FontSizeUtil
                                                            .CONTAINER_WIDTH_SIZE,
                                                        decoration:
                                                            AppStyles.decoration(
                                                                context),
                                                        child: IconButton(
                                                          icon: const Icon(
                                                              Icons.remove),
                                                          onPressed: () {
                                                            setState(() {
                                                              if (_counter > 1) {
                                                                _counter--;
                                                              }
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                             EdgeInsets.all(
                                                                FontSizeUtil.CONTAINER_SIZE_15),
                                                        child: Text(
                                                          '$_counter',
                                                          style: const TextStyle(
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: FontSizeUtil
                                                            .CONTAINER_HEGIHT_SIZE,
                                                        width: FontSizeUtil
                                                            .CONTAINER_WIDTH_SIZE,
                                                        decoration:
                                                            AppStyles.decoration(
                                                                context),
                                                        child: IconButton(
                                                          icon: const Icon(
                                                              Icons.add),
                                                          onPressed: () {
                                                            setState(() {
                                                              _counter++;
                                                            });
                                                          },
                                                        ),
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
                              Container(
                                padding:  EdgeInsets.symmetric(
                                    vertical: FontSizeUtil.CONTAINER_SIZE_25, horizontal: FontSizeUtil.CONTAINER_SIZE_50),
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: submitApartmentDate,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff1B5694),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_15),
                                    ),
                                    padding:  EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_15),
                                  ),
                                  child:  Text(Strings.INVITE_BUT_TXT,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: FontSizeUtil.CONTAINER_SIZE_18,
                                      )),
                                ),
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
      ),
    );
  }

  submitApartmentDate() async {
    if (_formKey.currentState!.validate() &&
        _countErrorMessage == null &&
        _guestNameErrorMessage == null &&
        _enteredAdmittedDate != null &&
        _enteredDichargedDate != null &&
        _mobileErrorMessage == null) {
      _formKey.currentState!.save();

      print(_enteredGuestName);
      print(_enteredGuestAddress);
      print(_selectedGender);
      print(_selectedIdentyType);
      print(_enteredAadharIdenty);
      print(_enteredPanIdenty);
      print(_enteredPurposeToMeet);
      print(_enteredMobile);
      print(_enteredAdmittedDate);
      print(_enteredDichargedDate);

      var purpose = '';
      if (_selectedPurpose != null) {
        if (_selectedPurpose == 'Others') {
          purpose = _enteredPurposeToMeet!;
        } else {
          purpose = _selectedPurpose!;
        }
      }

      print(_selectedImage);
      print(purpose);

      if (purpose.isNotEmpty) {
        _addGuestApi(purpose);
      } else {
        errorAlert(context, "Please enter purpose");
      }
    } else {
      errorAlert(context, Strings.MANDATORY_FIELD_TEXT);
    }
  }

  _addGuestApi(purpose) async {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          _isLoading = true;
          var responseType = 'addGuest';

          String addGuestURL = '${Constant.addGuestURL}?residentId=$userId';
          String keyName = "guestData";
          NetworkUtils.filePostUploadNetWorkCall(
              addGuestURL,
              keyName,
              _getJsonData(purpose).toString(),
              _selectedImage,
              this,
              responseType);
        }
        else {
          Utils.printLog("else called");
          _isLoading=false;
          Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
        }
      });
    });
  }

  _getJsonData(purpose) {
    final data = {
      '"name"': '"$_enteredGuestName"',
      '"purpose"': '"$purpose"',
      // '"proofDetails"': '"$proof"',
      '"validFrom"': '"$_enteredAdmittedDate"',
      '"validTo"': '"$_enteredDichargedDate"',
      '"mobile"': '"$_enteredMobile"',

      '"numberOfVisitor"': _counter,

      '"flatId"': selectedFlatId,
      '"residentId"': userId,

      '"apartmentId"': apartmentId
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
        if (responseType == 'addGuest') {
          SuccessModel responceModel =
              SuccessModel.fromJson(json.decode(response));
          if (responceModel.status == "success") {
            var time = "You have invited the visitor, \n Thank you";
            _isLoading = false;

            successDialog(
              context,
              time,
              Whatsapp(
                  userName: userName,
                  guestId: responceModel.passcode!,
                  fromDate: _enteredAdmittedDate!,
                  toDate: _enteredDichargedDate!,
                  flatNumber: responceModel.flatDetails!.flatNumber,
                  blockNumber: responceModel.flatDetails!.blockNumbber,
                  floorNumber: responceModel.flatDetails!.floorNumber,
                  address1: responceModel.flatDetails!.address1,
                  state: responceModel.flatDetails!.apartmentState,
                  countary: responceModel.flatDetails!.apartmentCountry,
                  pincode: responceModel.flatDetails!.aprtmentPincode,
                  navigatorListener: this,
                  type: ''),
            );
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
    // Navigator.pop(context);
  }
}
