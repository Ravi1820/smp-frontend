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
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

class BookAmenity extends StatefulWidget {
  BookAmenity({
    super.key,
    // required this.navigatorListener
  });

  // NavigatorListener? navigatorListener;

  @override
  State<BookAmenity> createState() {
    return _BookAmenityState();
  }
}

class _BookAmenityState extends State<BookAmenity>
    with ApiListener, NavigatorListener {
  final _formKey = GlobalKey<FormState>();
  bool _isNetworkConnected = false, _isLoading = false;

  var _enteredDescription = '';
  DateTime? _fromDateTime;
  DateTime? _toDateTime;
  int apartmentId = 0;
  int pinCode = 0;
  String? token = '';
  int? userId = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    _startDateController.addListener(() {
      setState(() {
        _startErrorMessage = validateStartDate(_startDateController.text);
      });
    });

    _endDateController.addListener(() {
      setState(() {
        _endErrorMessage = validateEndDate(_endDateController.text);
      });
    });
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

  String? validateStartDate(String input) {
    DateTime selectedDate = DateTime.parse(input);
    if (_toDateTime != null && selectedDate.isAfter(_toDateTime!)) {
      return 'Facility start date must be before Facility end date';
    } else if (_toDateTime != null &&
        selectedDate.isAtSameMomentAs(_toDateTime!)) {
      // Check if the time is after the "From Time"
      if (selectedDate.isAfter(_toDateTime!)) {
        return 'Facility start date must be before Facility end date';
      }
    }
    return null;
  }

  String? validateEndDate(String input) {
    DateTime selectedDate = DateTime.parse(input);
    if (_fromDateTime != null && selectedDate.isBefore(_fromDateTime!)) {
      return 'Facility end date must be after Facility start date';
    } else if (_fromDateTime != null && selectedDate == _fromDateTime) {
      // Check if the time is after the "From Time"
      String formattedFromTime = DateFormat('HH:mm:ss').format(_fromDateTime!);
      String formattedEndTime = DateFormat('HH:mm:ss').format(selectedDate);

      if (formattedEndTime.compareTo(formattedFromTime) <= 0) {
        return 'Facility end date must be after Facility start date';
      }
    }
    setState(() {
      _startErrorMessage = null;
    });
    return null;
  }

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

  bool showErrorMessage = false;
  bool showFacilityTypeErrorMessage = false;
  bool showDescriptionErrorMessage = false;
  String? _endErrorMessage;
  String? _startErrorMessage;
  String? _selectedPriority;
  String? _selectedFacilityType;

  final facilityType = [
    'Fitness center',
    'Swimming Pools',
    'Parking',
    'Community garden',
    'Gym',
    'Playing Area',
    'Library'
  ];

  //
  Color _containerBorderColor1 = Colors.white; // Added this line
  Color _boxShadowColor1 = const Color.fromARGB(255, 100, 100, 100);
  bool _showCheckboxes = false;

  DateTime currentDate = DateTime.now();

  String? _enteredAdmittedDate;
  String? _enteredDichargedDate;

  final TextEditingController _endDateController = TextEditingController();

  final TextEditingController _startDateController = TextEditingController();

  Future<void> datePicker(BuildContext context, String type) async {
    DateTime currentDate = DateTime.now();
    DateTime lastDate = DateTime(2100);
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
            if (type == Strings.START_DATE) {
              setState(() {
                _enteredAdmittedDate = formattedDateTime;
                _startDateController.text = _enteredAdmittedDate ?? '';
                _fromDateTime = selectedDateTime; // Store the selected DateTime
              });
            } else if (type == "Discharged Date") {
              setState(() {
                _enteredDichargedDate = formattedDateTime;
                _endDateController.text = _enteredDichargedDate ?? '';
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
    BoxDecoration decoration = BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(255, 255, 255, 1),
          Color.fromRGBO(255, 255, 255, 1),
        ],
      ),
      borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_10),
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
        margin: EdgeInsets.only(
            right: FontSizeUtil.CONTAINER_SIZE_10,
            top: FontSizeUtil.CONTAINER_SIZE_10),
        height: FontSizeUtil.CONTAINER_SIZE_100,
        width: FontSizeUtil.CONTAINER_SIZE_100,
        decoration: decoration,
        child: Center(
          child: Image.asset(
            'assets/images/Vector-1.png',
            height: FontSizeUtil.CONTAINER_SIZE_50,
            width: FontSizeUtil.CONTAINER_SIZE_50,
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
          height: FontSizeUtil.CONTAINER_SIZE_100,
          width: FontSizeUtil.CONTAINER_SIZE_100,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 233, 162, 0.5),
            borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_20),
          ),
          child: Center(
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_20),
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
            title: Strings.BOOK_AMENITY_HEADER,
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
                          margin:
                              EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_15),
                          shadowColor: Colors.blueGrey,
                          child: Container(
                            decoration: decoration,
                            child: Padding(
                              padding: EdgeInsets.all(
                                  FontSizeUtil.CONTAINER_SIZE_10),
                              child: Form(
                                key: _formKey,
                                child: Table(
                                  children: <TableRow>[
                                    TableRow(
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                                height: FontSizeUtil
                                                    .CONTAINER_SIZE_10),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: Strings
                                                        .FACILITY_TYPE_LABEL,
                                                    style: TextStyle(
                                                      color:
                                                          const Color.fromRGBO(
                                                              27, 86, 148, 1.0),
                                                      fontSize: FontSizeUtil
                                                          .CONTAINER_SIZE_16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '*',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: FontSizeUtil
                                                          .CONTAINER_SIZE_15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                                height: FontSizeUtil
                                                    .CONTAINER_SIZE_10),
                                            Stack(
                                              alignment: Alignment.centerLeft,
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius
                                                        .circular(FontSizeUtil
                                                            .CONTAINER_SIZE_10),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Color.fromARGB(
                                                            255, 100, 100, 100),
                                                        blurRadius: 6,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  height: FontSizeUtil
                                                      .CONTAINER_SIZE_45,
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child: ButtonTheme(
                                                      alignedDropdown: true,
                                                      child:
                                                          DropdownButtonFormField<
                                                              String>(
                                                        isExpanded: true,
                                                        value:
                                                            _selectedFacilityType,
                                                        items: facilityType
                                                            .map((item) {
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
                                                          setState(() {
                                                            _selectedFacilityType =
                                                                value!;
                                                            _showCheckboxes =
                                                                true; // Show checkboxes when an item is selected
                                                            showFacilityTypeErrorMessage =
                                                                value.isEmpty;
                                                          });
                                                        },
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            setState(() {
                                                              showFacilityTypeErrorMessage =
                                                                  true;
                                                            });
                                                            return Strings
                                                                .FACILITY_TYPE_ERROR_TEXT;
                                                          } else {
                                                            setState(() {
                                                              showFacilityTypeErrorMessage =
                                                                  false;
                                                            });
                                                            return null;
                                                          }
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          hintText: Strings
                                                              .FACILITY_TYPE_HINT_TEXT,
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                            horizontal: FontSizeUtil
                                                                .CONTAINER_SIZE_16,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (showFacilityTypeErrorMessage)
                                              Text(
                                                Strings
                                                    .FACILITY_TYPE_ERROR_TEXT,
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: FontSizeUtil
                                                      .CONTAINER_SIZE_15,
                                                ),
                                              ),
                                            SizedBox(
                                                height: FontSizeUtil
                                                    .CONTAINER_SIZE_10),
                                          ],
                                        ),
                                      ],
                                    ),
                                    if (_showCheckboxes)
                                      TableRow(
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  height: FontSizeUtil
                                                      .CONTAINER_SIZE_10),
                                              ...List.generate(
                                                  checkboxItems.length,
                                                  (index) {
                                                return CheckboxListTile(
                                                  value: checkboxItems[index]
                                                      .isSelected,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      checkboxItems[index]
                                                              .isSelected =
                                                          value ?? false;
                                                    });
                                                  },
                                                  title: Row(
                                                    children: [
                                                      Text(checkboxItems[index]
                                                          .title),
                                                      checkboxItems[index]
                                                                  .availablity ==
                                                              "Available"
                                                          ? Icon(Icons.cancel)
                                                          : Icon(Icons.cancel)
                                                      // Text(checkboxItems[index].availablity),
                                                    ],
                                                  ),
                                                );
                                              }),
                                              SizedBox(
                                                  height: FontSizeUtil
                                                      .CONTAINER_SIZE_10),
                                            ],
                                          ),
                                        ],
                                      ),
                                    TableRow(
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                                height: FontSizeUtil
                                                    .CONTAINER_SIZE_10),
                                            Text(
                                              Strings
                                                  .FACILITY_START_TIME_HINT_TEXT,
                                              style: TextStyle(
                                                color: const Color.fromRGBO(
                                                    27, 86, 148, 1.0),
                                                fontSize: FontSizeUtil
                                                    .CONTAINER_SIZE_16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                                height: FontSizeUtil
                                                    .CONTAINER_SIZE_10),
                                            Stack(
                                              alignment: Alignment.centerLeft,
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius
                                                        .circular(FontSizeUtil
                                                            .CONTAINER_SIZE_10),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Color.fromARGB(
                                                            255, 100, 100, 100),
                                                        blurRadius: 6,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  height: FontSizeUtil
                                                      .CONTAINER_SIZE_50,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        FontSizeUtil.SIZE_06),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              datePicker(
                                                                  context,
                                                                  Strings.START_DATE);
                                                              FocusScope.of(
                                                                      context)
                                                                  .unfocus();
                                                            },
                                                            child:
                                                                AbsorbPointer(
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                _startDateController,
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .done,
                                                                style: AppStyles
                                                                    .heading1(
                                                                        context),
                                                                decoration:
                                                                    const InputDecoration(
                                                                  prefixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .date_range_outlined,
                                                                    color: Color(
                                                                        0xff4d004d),
                                                                  ),
                                                                  hintText: Strings
                                                                      .FACILITY_START_TIME_HINT_TEXT,
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .black38),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                                onChanged:
                                                                    (value) {
                                                                  String?
                                                                      validationMessage;

                                                                  if (value
                                                                      .isEmpty) {
                                                                    validationMessage =
                                                                        Strings
                                                                            .SELECT_DATE_WARNING_TEXT;
                                                                  } else if (_endDateController
                                                                          .text !=
                                                                      null) {
                                                                    if (_enteredDichargedDate !=
                                                                        null) {
                                                                      final startDateTime =
                                                                          DateTime.parse(
                                                                              _enteredAdmittedDate!);
                                                                      final endDateTime =
                                                                          DateTime.parse(
                                                                              _enteredDichargedDate!);
                                                                      if (startDateTime
                                                                          .isAfter(
                                                                              endDateTime)) {
                                                                        validationMessage =
                                                                            Strings.FACILITY_START_TIME_ERROR_TEXT;
                                                                      }
                                                                      if (validationMessage !=
                                                                          null) {
                                                                        setState(
                                                                            () {
                                                                          _startErrorMessage =
                                                                              validationMessage;
                                                                        });
                                                                      } else {
                                                                        setState(
                                                                            () {
                                                                          _startErrorMessage =
                                                                              null;
                                                                        });
                                                                      }
                                                                    }
                                                                  }

                                                                  if (validationMessage !=
                                                                      null) {
                                                                    setState(
                                                                        () {
                                                                      _startErrorMessage =
                                                                          validationMessage;
                                                                    });
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      _startErrorMessage =
                                                                          null;
                                                                    });
                                                                  }
                                                                },
                                                                validator:
                                                                    (value) {
                                                                  String?
                                                                      validationMessage;
                                                                  if (value ==
                                                                          null ||
                                                                      value
                                                                          .isEmpty) {
                                                                    validationMessage =
                                                                        Strings
                                                                            .POLL_START_TIME_ERROR_TEXT1;
                                                                    setState(
                                                                        () {
                                                                      _startErrorMessage =
                                                                          validationMessage;
                                                                    });
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      _startErrorMessage =
                                                                          null;
                                                                    });
                                                                  }
                                                                  if (_enteredDichargedDate !=
                                                                      null) {
                                                                    final startDateTime =
                                                                        DateTime.parse(
                                                                            _enteredAdmittedDate!);
                                                                    final endDateTime =
                                                                        DateTime.parse(
                                                                            _enteredDichargedDate!);
                                                                    if (startDateTime
                                                                        .isAfter(
                                                                            endDateTime)) {
                                                                      validationMessage =
                                                                          Strings
                                                                              .POLL_START_TIME_ERROR_TEXT;
                                                                    }
                                                                    if (validationMessage !=
                                                                        null) {
                                                                      setState(
                                                                          () {
                                                                        _startErrorMessage =
                                                                            validationMessage;
                                                                      });
                                                                    } else {
                                                                      setState(
                                                                          () {
                                                                        _startErrorMessage =
                                                                            null;
                                                                      });
                                                                    }
                                                                  }
                                                                  return null;
                                                                },
                                                                onSaved:
                                                                    (value) {
                                                                  _enteredAdmittedDate =
                                                                      value;
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            datePicker(context,
                                                                Strings.START_DATE);
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
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                height: FontSizeUtil.SIZE_05),
                                            if (_startErrorMessage != null)
                                              Text(
                                                _startErrorMessage!,
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: FontSizeUtil
                                                      .CONTAINER_SIZE_15,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                                height: FontSizeUtil
                                                    .CONTAINER_SIZE_10),
                                            Text(
                                              Strings
                                                  .FACILITY_END_TIME_HINT_TEXT,
                                              style: TextStyle(
                                                color: const Color.fromRGBO(
                                                    27, 86, 148, 1.0),
                                                fontSize: FontSizeUtil
                                                    .CONTAINER_SIZE_16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                                height: FontSizeUtil
                                                    .CONTAINER_SIZE_10),
                                            Stack(
                                              alignment: Alignment.centerLeft,
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius
                                                        .circular(FontSizeUtil
                                                            .CONTAINER_SIZE_10),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Color.fromARGB(
                                                            255, 100, 100, 100),
                                                        blurRadius: 6,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  height: FontSizeUtil
                                                      .CONTAINER_SIZE_50,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        FontSizeUtil.SIZE_06),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              datePicker(
                                                                  context,
                                                                  "Discharged Date");
                                                              FocusScope.of(
                                                                      context)
                                                                  .unfocus();
                                                            },
                                                            child:
                                                                AbsorbPointer(
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    _endDateController,
                                                                textInputAction:
                                                                    TextInputAction
                                                                        .done,
                                                                style: AppStyles
                                                                    .heading1(
                                                                        context),
                                                                decoration:
                                                                    const InputDecoration(
                                                                  prefixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .date_range_outlined,
                                                                    color: Color(
                                                                        0xff4d004d),
                                                                  ),
                                                                  hintText: Strings
                                                                      .FACILITY_END_TIME_HINT_TEXT,
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .black38),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                                onChanged:
                                                                    (value) {
                                                                  String?
                                                                      validationMessage;

                                                                  if (value
                                                                      .isEmpty) {
                                                                    validationMessage =
                                                                        Strings
                                                                            .SELECT_DATE_WARNING_TEXT;
                                                                  } else if (_startDateController
                                                                          .text !=
                                                                      null) {
                                                                    final startDateTime =
                                                                        DateTime.parse(
                                                                            _startDateController.text);
                                                                    final endDateTime =
                                                                        DateTime.parse(
                                                                            _endDateController.text);
                                                                    if (endDateTime
                                                                        .isBefore(
                                                                            startDateTime)) {
                                                                      validationMessage =
                                                                          Strings
                                                                              .POLL_END_TIME_ERROR_TEXT;
                                                                    }
                                                                  }

                                                                  if (validationMessage !=
                                                                      null) {
                                                                    setState(
                                                                        () {
                                                                      _endErrorMessage =
                                                                          validationMessage;
                                                                    });
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      _endErrorMessage =
                                                                          null;
                                                                    });
                                                                  }
                                                                },
                                                                validator:
                                                                    (value) {
                                                                  String?
                                                                      validationMessage;
                                                                  if (value ==
                                                                          null ||
                                                                      value
                                                                          .isEmpty) {
                                                                    validationMessage =
                                                                        Strings
                                                                            .POLL_END_TIME_ERROR_TEXT1;

                                                                    setState(
                                                                        () {
                                                                      _endErrorMessage =
                                                                          validationMessage;
                                                                    });
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      _endErrorMessage =
                                                                          null;
                                                                    });
                                                                  }
                                                                  if (_enteredAdmittedDate !=
                                                                      null) {
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
                                                                          Strings
                                                                              .POLL_END_TIME_ERROR_TEXT;
                                                                    }
                                                                    if (validationMessage !=
                                                                        null) {
                                                                      setState(
                                                                          () {
                                                                        _endErrorMessage =
                                                                            validationMessage;
                                                                      });
                                                                    } else {
                                                                      setState(
                                                                          () {
                                                                        _endErrorMessage =
                                                                            null;
                                                                      });
                                                                    }
                                                                  }
                                                                  return null;
                                                                },
                                                                onSaved:
                                                                    (value) {
                                                                  _enteredDichargedDate =
                                                                      value;
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            datePicker(context,
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
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                height: FontSizeUtil.SIZE_05),
                                            if (_endErrorMessage != null)
                                              Text(
                                                _endErrorMessage!,
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: FontSizeUtil
                                                      .CONTAINER_SIZE_15,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    TableRow(children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: Strings.CALCULATED_TEXT,
                                                  style: TextStyle(
                                                    color: const Color.fromRGBO(
                                                        27, 86, 148, 1.0),
                                                    fontSize: FontSizeUtil
                                                        .CONTAINER_SIZE_16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: FontSizeUtil
                                                        .CONTAINER_SIZE_15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              height: FontSizeUtil
                                                  .CONTAINER_SIZE_10),
                                          Stack(
                                            alignment: Alignment.centerLeft,
                                            children: <Widget>[
                                              AbsorbPointer(
                                                absorbing: true,
                                                child: FocusScope(
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
                                                            ? const Color
                                                                    .fromARGB(
                                                                162,
                                                                63,
                                                                158,
                                                                235)
                                                            : const Color
                                                                    .fromARGB(
                                                                255,
                                                                100,
                                                                100,
                                                                100);
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius
                                                            .circular(FontSizeUtil
                                                                .CONTAINER_SIZE_10),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                _boxShadowColor1,
                                                            blurRadius: 6,
                                                            offset:
                                                                const Offset(
                                                                    0, 2),
                                                          ),
                                                        ],
                                                        border: Border.all(
                                                          color:
                                                              _containerBorderColor1,
                                                        ),
                                                      ),
                                                      height: FontSizeUtil
                                                          .CONTAINER_SIZE_50,
                                                      child: TextFormField(
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .deny(Strings
                                                                  .EMOJI_DENY_REGEX)
                                                        ],
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        maxLines: 30,
                                                        scrollPadding: EdgeInsets.only(
                                                            bottom: MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom *
                                                                1.40),
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        style:
                                                            AppStyles.heading1(
                                                                context),
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          contentPadding: EdgeInsets.only(
                                                              top: FontSizeUtil
                                                                  .CONTAINER_SIZE_14,
                                                              left: FontSizeUtil
                                                                  .CONTAINER_SIZE_20),
                                                          hintText: Strings
                                                              .CALCULATED_TEXT_HINT_TEXT,
                                                          hintStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black38),
                                                        ),
                                                        onChanged: (value) {
                                                          String?
                                                              validationMessage;

                                                          if (value.isEmpty) {
                                                            validationMessage =
                                                                Strings
                                                                    .ISSUE_DESCRIPTION_ERROR_TEXT;
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
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                              height: FontSizeUtil.SIZE_05),
                                          if (showDescriptionErrorMessage)
                                            Text(
                                              Strings
                                                  .ISSUE_DESCRIPTION_ERROR_TEXT1,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: FontSizeUtil
                                                      .CONTAINER_SIZE_15),
                                            ),
                                          SizedBox(
                                              height: FontSizeUtil
                                                  .CONTAINER_SIZE_10),
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
                              vertical: FontSizeUtil.CONTAINER_SIZE_15,
                              horizontal: FontSizeUtil.CONTAINER_SIZE_50),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              _formKey.currentState!.save();

                              print(_selectedFacilityType);
                              print(_selectedPriority);

                              if (_formKey.currentState!.validate() &&
                                  showDescriptionErrorMessage == false &&
                                  showErrorMessage == false &&
                                  showFacilityTypeErrorMessage == false) {
                                _formKey.currentState!.save();
                                _bookacilityApi();
                              } else {
                                Utils.showToast(Strings.MANDATORY_WARNING_TEXT);
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
                            child: Text(Strings.FACILITY_SUBIMT_BUTTON_TEXT,
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

  _bookacilityApi() async {
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
          NetworkUtils.filePostUploadNetWorkCall(
              partURL,
              keyName,
              _getJsonData(selectedFlatId).toString(),
              _selectedImage,
              this,
              responseType);
        } else {
          Utils.printLog("else called");
          Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
        }
      });
    });
  }

  _getJsonData(selectedFlatId) {
    final data = {
      '"catagory"': '"$_selectedFacilityType"',
      '"issueType"': '"$_selectedFacilityType"',
      '"description"': '"$_enteredDescription"',
      '"priority"': '"$_selectedPriority"',
      '"residentId"': userId,
      '"flatId"': selectedFlatId,
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
      setState(() {
        _isLoading = false;
        if (responseType == 'raiseIssue') {
          UpdateUserModel responceModel =
              UpdateUserModel.fromJson(json.decode(response));
          if (responceModel.status == "success") {
            FocusScope.of(context).unfocus();
            var message = "You have successfully raised an issue";
            successDialogWithListner(
                context, message, const ViewListScreen(), this);
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
  }
}

class CheckboxItem {
  String title;
  bool isSelected;
  String availablity;

  CheckboxItem(this.title, this.availablity, this.isSelected);
}

final checkboxItems = [
  CheckboxItem('PH 1', 'Available', false),
  CheckboxItem('PH 2', 'Available', false),
  CheckboxItem('PH 3', 'Occupied', false),
];
