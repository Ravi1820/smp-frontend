import 'dart:convert';

import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/profile.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/vote_poll/admin_vote_poll.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

class EditPollScreen extends StatefulWidget {
  EditPollScreen(
      {super.key,
      required this.purpose,
      required this.startDate,
      required this.navigatorListener,
      required this.endDate,
      required this.options,
      required this.pollId});

  int pollId;
  String purpose;
  DateTime startDate;
  DateTime endDate;
  List<String> options;
  NavigatorListener? navigatorListener;

  @override
  State<EditPollScreen> createState() {
    return _EditPollState();
  }
}

class _EditPollState extends State<EditPollScreen>
    with ApiListener, NavigatorListener {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> options = [];
  List<String> deleteOptions = [];

  var _enteredHospitalName = '';

  final TextEditingController _purposeController = TextEditingController();

  final TextEditingController _dichargeDateController = TextEditingController();

  final TextEditingController _admittedDateController = TextEditingController();
  int pollId = 0;
  int selectedOptionIndex = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();

    setState(() {
      final formattedStartDate =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.startDate);
      _admittedDateController.text = formattedStartDate;

      final formattedEndDate =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.endDate);
      _dichargeDateController.text = formattedEndDate;

      _guestPollStartErrorMessage =
          validateStartDate(_admittedDateController.text);
      _guestPollEndErrorMessage = validateEndDate(_dichargeDateController.text);

      options = widget.options;
      _purposeController.text = widget.purpose;
      pollId = widget.pollId;
    });

    _admittedDateController.addListener(() {
      setState(() {
        _guestPollStartErrorMessage =
            validateStartDate(_admittedDateController.text);
      });
    });

    _dichargeDateController.addListener(() {
      setState(() {
        _guestPollEndErrorMessage =
            validateEndDate(_dichargeDateController.text);
      });
    });
    _smpStorage();
  }

  String? token;
  int? userId;

  void _smpStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var id = prefs.getInt('id');

    setState(() {
      token = token!;
      userId = id!;
    });
  }

  bool error = false;

  String? validateStartDate(String input) {
    if (input.isEmpty) {
      return 'Please select Poll Start Time.';
    }

    DateTime selectedDate = DateTime.parse(input);

    if (_toDateTime != null && selectedDate.isAfter(_toDateTime!)) {
      return 'Poll Start Time must be before Poll End Time.';
    }

    if (_dichargeDateController.text.isNotEmpty) {
      DateTime dischargeDate = DateTime.parse(_dichargeDateController.text);
      if (selectedDate.isAfter(dischargeDate)) {
        return 'Poll Start Time must be before Poll End Time.';
      }
    }

    return null;
  }

  String? validateEndDate(String input) {
    DateTime selectedDate = DateTime.parse(input);

    if (_fromDateTime != null && selectedDate.isBefore(_fromDateTime!)) {
      setState(() {
        _guestPollEndErrorMessage =
            'Poll end date must be after Poll start date';
      });
      return 'Poll end date must be after Poll start date';
    } else if (_fromDateTime != null && selectedDate == _fromDateTime) {
      // Check if the time is after the "From Time"
      if (_fromDateTime != null &&
          _fromDateTime!.hour != null &&
          _fromDateTime!.minute != null) {
        String formattedFromTime =
            DateFormat('HH:mm:ss').format(_fromDateTime!);
        String formattedEndTime = DateFormat('HH:mm:ss').format(selectedDate);

        if (formattedEndTime.compareTo(formattedFromTime) <= 0) {
          setState(() {
            _guestPollEndErrorMessage =
                'Poll end date must be after Poll start date';
          });
          return 'Poll end date must be after Poll start date';
        }
      }
    }

    setState(() {
      _guestPollEndErrorMessage = null;
      _guestPollStartErrorMessage = null;
    });

    return null;
  }

  bool showErrorMessage = false;

  bool showPurposeErrorMessage = false;

  Color _containerBorderColor1 = Colors.white; // Added this line
  Color _boxShadowColor1 = const Color.fromARGB(255, 100, 100, 100);

  String? _enteredAdmittedDate;
  String? _enteredDichargedDate;

  String? _guestPollEndErrorMessage;
  String? _guestPollStartErrorMessage;

  DateTime? _fromDateTime;
  DateTime? _toDateTime;
  bool _isNetworkConnected = false;
  List<String> deletedIndices = [];
  List<String> deletedOptionsBackup = [];

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
                _admittedDateController.text = _enteredAdmittedDate ?? '';
                _fromDateTime = selectedDateTime; // Store the selected DateTime
              });
            } else if (type == "Discharged Date") {
              setState(() {
                _enteredDichargedDate = formattedDateTime;
                _dichargeDateController.text = _enteredDichargedDate ?? '';
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

  BuildContext? dialogContext;

  @override
  Widget build(BuildContext context) {
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
              title: Strings.EDIT_POLL_HEADER,
              profile: () {
                Navigator.of(context).push(createRoute(const UserProfile()));
              },
            ),
          ),
          backgroundColor: Colors.white,
          body: AbsorbPointer(
            absorbing: _isLoading,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
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
                                        children: <TableRow>[
                                          TableRow(children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  Strings.PURPOSE_LABEL_TEXT,
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
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  children: <Widget>[
                                                    FocusScope(
                                                      child: Focus(
                                                        onFocusChange:
                                                            (hasFocus) {
                                                          setState(() {
                                                            _containerBorderColor1 =
                                                                hasFocus
                                                                    ? const Color
                                                                            .fromARGB(
                                                                        255,
                                                                        0,
                                                                        137,
                                                                        250)
                                                                    : Colors
                                                                        .white;
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
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    FontSizeUtil
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
                                                              .CONTAINER_SIZE_100,
                                                          child: TextFormField(
                                                            controller:
                                                                _purposeController,
                                                            style: AppStyles
                                                                .heading1(
                                                                    context),
                                                            keyboardType:
                                                                TextInputType
                                                                    .multiline,
                                                            maxLines: null,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: FontSizeUtil
                                                                          .CONTAINER_SIZE_14),
                                                              prefixIcon:
                                                                  const Icon(
                                                                Icons
                                                                    .description,
                                                                color: Color(
                                                                    0xff4d004d),
                                                              ),
                                                              hintText: Strings
                                                                  .PURPOSE_HINT_TEXT,
                                                              hintStyle: const TextStyle(
                                                                  color: Colors
                                                                      .black38),
                                                            ),
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty ||
                                                                  value
                                                                          .trim()
                                                                          .length <=
                                                                      1) {
                                                                setState(() {
                                                                  showPurposeErrorMessage =
                                                                      true;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  showPurposeErrorMessage =
                                                                      false;
                                                                });
                                                                return null;
                                                              }
                                                              return null;
                                                            },
                                                            onChanged: (value) {
                                                              if (value
                                                                      .isEmpty ||
                                                                  value
                                                                          .trim()
                                                                          .length <=
                                                                      1) {
                                                                setState(() {
                                                                  showPurposeErrorMessage =
                                                                      true;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  showPurposeErrorMessage =
                                                                      false;
                                                                });
                                                              }
                                                            },
                                                            onSaved: (value) {
                                                              _enteredHospitalName =
                                                                  value!;
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (showPurposeErrorMessage ==
                                                    true)
                                                  Text(
                                                    Strings
                                                        .POLL_PURPOSE_ERROR_TEXT,
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: FontSizeUtil
                                                          .CONTAINER_SIZE_15,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ]),
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
                                                        .POLL_START_TIME_HINT_TEXT,
                                                    style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          27, 86, 148, 1.0),
                                                      fontSize: FontSizeUtil
                                                          .CONTAINER_SIZE_16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: FontSizeUtil
                                                          .CONTAINER_SIZE_10),
                                                  Stack(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    children: <Widget>[
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  FontSizeUtil
                                                                      .CONTAINER_SIZE_10),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      100,
                                                                      100,
                                                                      100),
                                                              blurRadius: 6,
                                                              offset:
                                                                  Offset(0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        height: FontSizeUtil
                                                            .CONTAINER_SIZE_50,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  FontSizeUtil
                                                                      .SIZE_06),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    GestureDetector(
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
                                                                          _admittedDateController,
                                                                      style: AppStyles
                                                                          .heading1(
                                                                              context),
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        prefixIcon:
                                                                            Icon(
                                                                          Icons
                                                                              .date_range_outlined,
                                                                          color:
                                                                              Color(0xff4d004d),
                                                                        ),
                                                                        hintText:
                                                                            Strings.POLL_START_TIME_HINT_TEXT,
                                                                        hintStyle:
                                                                            TextStyle(color: Colors.black38),
                                                                        border:
                                                                            InputBorder.none,
                                                                      ),
                                                                      onChanged:
                                                                          (value) {
                                                                        String?
                                                                            validationMessage;

                                                                        if (value
                                                                            .isEmpty) {
                                                                          validationMessage =
                                                                              Strings.SELECT_DATE_WARNING_TEXT;
                                                                        } else if (_dichargeDateController.text !=
                                                                            null) {
                                                                          final startDateTime =
                                                                              DateTime.parse(_admittedDateController.text);
                                                                          final endDateTime =
                                                                              DateTime.parse(_dichargeDateController.text);
                                                                          if (startDateTime
                                                                              .isAfter(endDateTime)) {
                                                                            validationMessage =
                                                                                Strings.POLL_START_TIME_ERROR_TEXT;
                                                                          }
                                                                          if (validationMessage !=
                                                                              null) {
                                                                            setState(() {
                                                                              _guestPollStartErrorMessage = validationMessage;
                                                                            });
                                                                          } else {
                                                                            setState(() {
                                                                              _guestPollStartErrorMessage = null;
                                                                            });
                                                                          }
                                                                        }
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
                                                                  datePicker(
                                                                      context,
                                                                      "Admitted Date");
                                                                },
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .date_range,
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
                                                      height:
                                                          FontSizeUtil.SIZE_05),
                                                  if (_guestPollStartErrorMessage !=
                                                      null)
                                                    Text(
                                                      _guestPollStartErrorMessage!,
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
                                                        .POLL_END_TIME_HINT_TEXT,
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
                                                  SizedBox(
                                                      height: FontSizeUtil
                                                          .CONTAINER_SIZE_10),
                                                  Stack(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    children: <Widget>[
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  FontSizeUtil
                                                                      .CONTAINER_SIZE_10),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      100,
                                                                      100,
                                                                      100),
                                                              blurRadius: 6,
                                                              offset:
                                                                  Offset(0, 2),
                                                            ),
                                                          ],
                                                        ),
                                                        height: FontSizeUtil
                                                            .CONTAINER_SIZE_50,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  FontSizeUtil
                                                                      .SIZE_06),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    GestureDetector(
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
                                                                          _dichargeDateController,
                                                                      style: AppStyles
                                                                          .heading1(
                                                                              context),
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        prefixIcon:
                                                                            Icon(
                                                                          Icons
                                                                              .date_range_outlined,
                                                                          color:
                                                                              Color(0xff4d004d),
                                                                        ),
                                                                        hintText:
                                                                            Strings.POLL_END_TIME_HINT_TEXT,
                                                                        hintStyle:
                                                                            TextStyle(color: Colors.black38),
                                                                        border:
                                                                            InputBorder.none,
                                                                      ),
                                                                      onChanged:
                                                                          (value) {
                                                                        String?
                                                                            validationMessage;

                                                                        if (value
                                                                            .isEmpty) {
                                                                          validationMessage =
                                                                              Strings.SELECT_DATE_WARNING_TEXT;
                                                                        } else if (_admittedDateController.text !=
                                                                            null) {
                                                                          final startDateTime =
                                                                              DateTime.parse(_admittedDateController.text);
                                                                          final endDateTime =
                                                                              DateTime.parse(_dichargeDateController.text);
                                                                          if (endDateTime
                                                                              .isBefore(startDateTime)) {
                                                                            validationMessage =
                                                                                Strings.POLL_END_TIME_ERROR_TEXT;
                                                                          }
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
                                                                  datePicker(
                                                                      context,
                                                                      "Discharged Date");
                                                                },
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .date_range,
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
                                                      height:
                                                          FontSizeUtil.SIZE_05),
                                                  if (_guestPollEndErrorMessage !=
                                                      null)
                                                    Text(
                                                      _guestPollEndErrorMessage!,
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
                                                  GestureDetector(
                                                    onTap: () => _showCustomDialog(
                                                        context,
                                                        _containerBorderColor1,
                                                        _boxShadowColor1),
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.add),
                                                          onPressed: () =>
                                                              // _showCustomDialog(context)
                                                              _showCustomDialog(
                                                                  context,
                                                                  _containerBorderColor1,
                                                                  _boxShadowColor1),
                                                        ),
                                                        Text(
                                                          Strings
                                                              .POLLONS_OPTIONS_LABEL_TEXT,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Roboto',
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.04,
                                                            fontStyle: FontStyle
                                                                .normal,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: const Color(
                                                                0xff1B5694),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount: options.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Stack(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        FontSizeUtil
                                                                            .SIZE_08),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        FontSizeUtil
                                                                            .CONTAINER_SIZE_10),
                                                                boxShadow: const [
                                                                  BoxShadow(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            100,
                                                                            100,
                                                                            100),
                                                                    blurRadius:
                                                                        6,
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            2),
                                                                  ),
                                                                ],
                                                              ),
                                                              height: FontSizeUtil
                                                                  .CONTAINER_SIZE_50,
                                                              child: Padding(
                                                                padding: EdgeInsets.all(
                                                                    FontSizeUtil
                                                                        .CONTAINER_SIZE_10),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        options[
                                                                            index],
                                                                        style: AppStyles.heading1(
                                                                            context),
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () =>
                                                                              {
                                                                        if (options.length >
                                                                            2)
                                                                          {
                                                                            _deleteOption(options[index]),
                                                                          }
                                                                        else
                                                                          {
                                                                            errorAlert(
                                                                              context,
                                                                              Strings.DELETE_MINIMUM_TWO_POLL_TEXT,
                                                                            )
                                                                          }
                                                                      },
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .delete,
                                                                        color: Color(
                                                                            0xff4d004d),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff1B5694),
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              FontSizeUtil.CONTAINER_SIZE_15),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              FontSizeUtil.CONTAINER_SIZE_50,
                                          vertical:
                                              FontSizeUtil.CONTAINER_SIZE_15,
                                        ),
                                      ),
                                      onPressed: () {
                                        print(_guestPollStartErrorMessage);
                                        print(_guestPollEndErrorMessage);

                                        if (_formKey.currentState!.validate() &&
                                            showPurposeErrorMessage == false) {
                                          String? startErrorMessage =
                                              validateStartDate(
                                                  _admittedDateController.text);
                                          String? endErrorMessage =
                                              validateEndDate(
                                                  _dichargeDateController.text);

                                          setState(() {
                                            _guestPollStartErrorMessage =
                                                startErrorMessage;
                                            _guestPollEndErrorMessage =
                                                endErrorMessage;
                                          });

                                          if (_guestPollStartErrorMessage ==
                                                  null &&
                                              _guestPollEndErrorMessage ==
                                                  null) {
                                            if (options.length >= 2) {
                                              _formKey.currentState!.save();
                                              setState(() {
                                                _isLoading = true;
                                              });

                                              _editPoll();
                                            } else {
                                              var msg = Strings
                                                  .EDIT_MINIMUM_TWO_POLL_TEXT;
                                              errorAlert(context, msg);
                                            }
                                          } else {
                                            var msg = Strings.VALIED_POLL_DATE;
                                            errorAlert(context, msg);
                                          }
                                        } else {
                                          var msg =
                                              Strings.MANDATORY_WARNING_TEXT;
                                          errorAlert(context, msg);
                                        }
                                      },
                                      child: const Text(
                                          Strings.POLL_UPDATE_BUTTON_TEXT),
                                    ),
                                    SizedBox(
                                        width: FontSizeUtil.CONTAINER_SIZE_30),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xff1B5694),
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              FontSizeUtil.CONTAINER_SIZE_15),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              FontSizeUtil.CONTAINER_SIZE_50,
                                          vertical:
                                              FontSizeUtil.CONTAINER_SIZE_15,
                                        ),
                                      ),
                                      onPressed: () {
                                        if (deletedOptionsBackup.isNotEmpty) {
                                          setState(() {
                                            options
                                                .addAll(deletedOptionsBackup);
                                            deletedOptionsBackup.clear();
                                          });
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                          Strings.DELETE_POLL_CANCEL_TEXT),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: FontSizeUtil.CONTAINER_SIZE_70),
                            ],
                          ),
                        ),
                      ),
                      const FooterScreen(),
                    ],
                  ),
                  if (_isLoading) const Positioned(child: LoadingDialog()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteOption(index) async {
    setState(() {
      deleteOptions.add(index);
      deletedOptionsBackup.add(index);
      Utils.printLog(" added index: $index");
      options.remove(index);
      Utils.printLog(" removed index: $index");
    });
  }

  Future<void> _editPoll() async {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");

      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;

        if (_isNetworkConnected) {
          _isLoading = true;
          String responseType = "editPolls";

          final Map<String, dynamic> data = <String, dynamic>{};

          data['pollesFor'] = _enteredHospitalName;
          data['startTime'] = _enteredAdmittedDate;
          data['endTime'] = _enteredDichargedDate;
          data['addOptions'] = options;
          data['deleteOptions'] = deleteOptions;

          String editVotePollURL =
              '${Constant.editVotePollURL}?votePollId=$pollId';
          NetworkUtils.updatePollPutNetworkCall(
              editVotePollURL, data, this, responseType, "votePollData");
          deletedIndices.clear();
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
    if (status == 401) {
      Utils.sessonExpired(context);
    } else {
      Utils.showToast(Strings.API_ERROR_MSG_TEXT);
    }
  }

  @override
  onSuccess(response, res) async {
    Utils.printLog("text === $response");

    try {
      if (res == "deletePollOptions") {
        ResponceModel responceModel =
            ResponceModel.fromJson(json.decode(response));

        if (responceModel.status == "success") {
          Utils.showToast(responceModel.message!);
          setState(() {
            options.removeAt(selectedOptionIndex);
          });
        } else {
          Utils.showToast(responceModel.message!);
        }
        setState(() {
          _isLoading = false;
        });
      } else if (res == "editPolls") {
        ResponceModel responceModel =
            ResponceModel.fromJson(json.decode(response));

        if (responceModel.status == "success") {
          successDialogWithListner(context, responceModel.message!,
              const AdminVotePollScreen(), this);
        } else {
          Utils.showToast(responceModel.message!);
        }
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print("Error 1");
      errorAlert(
        context,
        response.toString(),
      );
    }
  }

  void _showCustomDialog(
      BuildContext context, containerBorderColor1, boxShadowColor) {
    String newOption = '';
    bool isSaveButtonDisabled = true; // Track the state of the "Save" button

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              width: 330,
              decoration: AppStyles.decoration(context),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Option',
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
                          FocusScope(
                            child: Focus(
                              onFocusChange: (hasFocus) {
                                setState(() {
                                  containerBorderColor1 = hasFocus
                                      ? const Color.fromARGB(255, 0, 137, 250)
                                      : Colors.white;
                                  boxShadowColor = hasFocus
                                      ? const Color.fromARGB(162, 63, 158, 235)
                                      : const Color.fromARGB(
                                          255, 100, 100, 100);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: boxShadowColor,
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: containerBorderColor1,
                                  ),
                                ),
                                height: 100,
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  style: const TextStyle(color: Colors.black87),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(top: 14),
                                    prefixIcon: Icon(
                                      Icons.description,
                                      color: Color(0xff4d004d),
                                    ),
                                    hintText: 'Enter Option',
                                    hintStyle: TextStyle(color: Colors.black38),
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.trim().length <= 1 ||
                                        value.trim().length > 20) {
                                      setState(() {
                                        showErrorMessage = true;
                                      });
                                    } else {
                                      setState(() {
                                        showErrorMessage = false;
                                      });
                                      return null;
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    newOption = value;
                                  },
                                  onSaved: (value) {
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 30,
                            child: ElevatedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(211, 38, 209, 38),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: const BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(211, 38, 209, 38),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 0),
                              ),
                              // style: OutlinedButton.styleFrom(
                              //   shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(20.0),
                              //     side: const BorderSide(
                              //         color: Color.fromARGB(255, 0, 123, 255),
                              //         width: 2),
                              //   ),
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 15, vertical: 0),
                              // ),
                              onPressed: () {
                                // Use trim() to remove leading and trailing whitespaces
                                String trimmedOption = newOption.trim();

                                if (!options
                                    .map((option) => option.toLowerCase())
                                    .contains(trimmedOption.toLowerCase())) {
                                  if (trimmedOption.isNotEmpty) {
                                    setState(() {
                                      options.add(trimmedOption);
                                    });
                                    Navigator.of(context).pop();
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "Please select an option",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Option already entered",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }
                              },
                              child: const Text(
                                "Save",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 30,
                            child: ElevatedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(226, 182, 36, 36),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: const BorderSide(
                                    width: 1,
                                    color: Color.fromARGB(226, 182, 36, 36),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 0),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Close",
                                style: TextStyle(color: Colors.white),
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
        );
      },
    );
  }

  @override
  onNavigatorBackPressed() {
    Navigator.pop(context);
    widget.navigatorListener!.onNavigatorBackPressed();
  }
}
