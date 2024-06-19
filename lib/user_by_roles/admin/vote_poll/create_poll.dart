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
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

class CreatePollScreen extends StatefulWidget {
  CreatePollScreen({super.key, required this.navigatorListener});

  NavigatorListener? navigatorListener;

  @override
  State<CreatePollScreen> createState() {
    return _CreatePollState();
  }
}

class _CreatePollState extends State<CreatePollScreen>
    with ApiListener, NavigatorListener {
  final _formKey = GlobalKey<FormState>();
  List<String> options = [];
  bool _isNetworkConnected = false, _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _enteredHospitalName = '';
  var _enteredCountName = '';
  String? token;
  int? userId;
  int? apartmentId;
  bool showErrorMessage = false;
  bool showPurposeErrorMessage = false;
  bool showCountErrorMessage = false;
  Color _containerBorderColor1 = Colors.white; // Added this line
  Color _boxShadowColor1 = const Color.fromARGB(255, 100, 100, 100);
  String? _enteredAdmittedDate;
  String? _enteredDichargedDate;
  String? _guestPollEndErrorMessage;
  String? _guestPollStartErrorMessage;
  final TextEditingController _dichargeDateController = TextEditingController();
  final TextEditingController _admittedDateController = TextEditingController();
  DateTime? _fromDateTime;
  DateTime? _toDateTime;
  BuildContext? dialogContext;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    super.initState();
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

  void _smpStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var id = prefs.getInt('id');
    var apartId = prefs.getInt('apartmentId');
    setState(() {
      token = token!;
      userId = id!;
      apartmentId = apartId!;
    });
  }

  String? validateStartDate(String input) {
    DateTime selectedDate = DateTime.parse(input);
    if (_toDateTime != null && selectedDate.isAfter(_toDateTime!)) {
      return 'Poll start date must be before Poll end date';
    } else if (_toDateTime != null &&
        selectedDate.isAtSameMomentAs(_toDateTime!)) {
      // Check if the time is after the "From Time"
      if (selectedDate.isAfter(_toDateTime!)) {
        return 'Poll start date must be before Poll end date';
      }
    }
    return null;
  }

  String? validateEndDate(String input) {
    DateTime selectedDate = DateTime.parse(input);
    if (_fromDateTime != null && selectedDate.isBefore(_fromDateTime!)) {
      return 'Poll end date must be after Poll start date';
    } else if (_fromDateTime != null && selectedDate == _fromDateTime) {
      // Check if the time is after the "From Time"
      String formattedFromTime = DateFormat('HH:mm:ss').format(_fromDateTime!);
      String formattedEndTime = DateFormat('HH:mm:ss').format(selectedDate);

      if (formattedEndTime.compareTo(formattedFromTime) <= 0) {
        return 'Poll end date must be after Poll start date';
      }
    }
    setState(() {
      _guestPollStartErrorMessage = null;
    });
    return null;
  }

  void _deleteOption(int index) {
    setState(() {
      options.removeAt(index);
    });
  }

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
              title: Strings.CREATE_POLL_HEADER,
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
                                                    color:const Color.fromRGBO(
                                                        27, 86, 148, 1.0),
                                                    fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
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
                                                                BorderRadius
                                                                    .circular(
                                                                    FontSizeUtil.CONTAINER_SIZE_10),
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
                                                          height: FontSizeUtil.CONTAINER_SIZE_100,
                                                          child: TextFormField(
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter.deny(Strings.EMOJI_DENY_REGEX)
                                                            ],
                                                            keyboardType:
                                                                TextInputType
                                                                    .multiline,
                                                            maxLines: null,
                                                            textInputAction:
                                                                TextInputAction
                                                                    .done,
                                                            style: AppStyles
                                                                .heading1(
                                                                    context),
                                                            decoration:
                                                                 InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: FontSizeUtil.CONTAINER_SIZE_14),
                                                              prefixIcon: Icon(
                                                                Icons
                                                                    .description,
                                                                color: Color(
                                                                    0xff4d004d),
                                                              ),
                                                              hintText:
                                                                  Strings.PURPOSE_HINT_TEXT,
                                                              hintStyle: TextStyle(
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
                                                      fontSize: FontSizeUtil.CONTAINER_SIZE_15,
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
                                                  SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                                                   Text(
                                                    Strings
                                                        .POLL_START_TIME_HINT_TEXT,
                                                    style: TextStyle(
                                                      color:const Color.fromRGBO(
                                                          27, 86, 148, 1.0),
                                                      fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                   SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                                                  Stack(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    children: <Widget>[
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(FontSizeUtil.CONTAINER_SIZE_10),
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
                                                        height: FontSizeUtil.CONTAINER_SIZE_50,
                                                        child: Padding(
                                                          padding:
                                                               EdgeInsets
                                                                  .all(FontSizeUtil.SIZE_06),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    datePicker(
                                                                        context,
                                                                        "Admitted Date");
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
                                                                  },
                                                                  child:
                                                                      AbsorbPointer(
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          _admittedDateController,
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
                                                                          if (_enteredDichargedDate !=
                                                                              null) {
                                                                            final startDateTime =
                                                                                DateTime.parse(_enteredAdmittedDate!);
                                                                            final endDateTime =
                                                                                DateTime.parse(_enteredDichargedDate!);
                                                                            if (startDateTime.isAfter(endDateTime)) {
                                                                              validationMessage = Strings.POLL_START_TIME_ERROR_TEXT;
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
                                                                        }

                                                                        if (validationMessage !=
                                                                            null) {
                                                                          setState(
                                                                              () {
                                                                            _guestPollStartErrorMessage =
                                                                                validationMessage;
                                                                          });
                                                                        } else {
                                                                          setState(
                                                                              () {
                                                                            _guestPollStartErrorMessage =
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
                                                                            value.isEmpty) {
                                                                          validationMessage =
                                                                              Strings.POLL_START_TIME_ERROR_TEXT1;
                                                                          setState(
                                                                              () {
                                                                            _guestPollStartErrorMessage =
                                                                                validationMessage;
                                                                          });
                                                                        } else {
                                                                          setState(
                                                                              () {
                                                                            _guestPollStartErrorMessage =
                                                                                null;
                                                                          });
                                                                        }
                                                                        if (_enteredDichargedDate !=
                                                                            null) {
                                                                          final startDateTime =
                                                                              DateTime.parse(_enteredAdmittedDate!);
                                                                          final endDateTime =
                                                                              DateTime.parse(_enteredDichargedDate!);
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
                                                   SizedBox(height: FontSizeUtil.SIZE_05),
                                                  if (_guestPollStartErrorMessage !=
                                                      null)
                                                    Text(
                                                      _guestPollStartErrorMessage!,
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: FontSizeUtil.CONTAINER_SIZE_15,
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
                                                   SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                                                   Text(
                                                    Strings
                                                        .POLL_END_TIME_HINT_TEXT,
                                                    style: TextStyle(
                                                      color:const Color.fromRGBO(
                                                          27, 86, 148, 1.0),
                                                      fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                                                  Stack(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    children: <Widget>[
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(FontSizeUtil.CONTAINER_SIZE_10),
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
                                                        height: FontSizeUtil.CONTAINER_SIZE_50,
                                                        child: Padding(
                                                          padding:
                                                               EdgeInsets
                                                                  .all(FontSizeUtil.SIZE_06),
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
                                                                          _dichargeDateController,
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
                                                                      validator:
                                                                          (value) {
                                                                        String?
                                                                            validationMessage;
                                                                        if (value ==
                                                                                null ||
                                                                            value.isEmpty) {
                                                                          validationMessage =
                                                                              Strings.POLL_END_TIME_ERROR_TEXT1;

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
                                                                        if (_enteredAdmittedDate !=
                                                                            null) {
                                                                          final startDateTime =
                                                                              DateTime.parse(_enteredAdmittedDate!);
                                                                          final endDateTime =
                                                                              DateTime.parse(_enteredDichargedDate!);
                                                                          if (endDateTime
                                                                              .isBefore(startDateTime)) {
                                                                            validationMessage =
                                                                                Strings.POLL_END_TIME_ERROR_TEXT;
                                                                          }
                                                                          if (validationMessage !=
                                                                              null) {
                                                                            setState(() {
                                                                              _guestPollEndErrorMessage = validationMessage;
                                                                            });
                                                                          } else {
                                                                            setState(() {
                                                                              _guestPollEndErrorMessage = null;
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
                                                   SizedBox(height:FontSizeUtil.SIZE_05),
                                                  if (_guestPollEndErrorMessage !=
                                                      null)
                                                    Text(
                                                      _guestPollEndErrorMessage!,
                                                      style:  TextStyle(
                                                        color: Colors.red,
                                                        fontSize: FontSizeUtil.CONTAINER_SIZE_15,
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
                                                    onTap: () => {
                                                      FocusScope.of(context)
                                                          .unfocus(),
                                                      _openAddOptionDialog(
                                                          context,
                                                          _containerBorderColor1,
                                                          _boxShadowColor1),
                                                    },
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                            icon: const Icon(
                                                                Icons.add),
                                                            onPressed: () => {
                                                                  // _showCustomDialog(context)
                                                                  FocusScope.of(
                                                                          context)
                                                                      .unfocus(),
                                                                  _openAddOptionDialog(
                                                                      context,
                                                                      _containerBorderColor1,
                                                                      _boxShadowColor1),
                                                                }),
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
                                                            padding:
                                                                EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                    FontSizeUtil.SIZE_07),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        FontSizeUtil.CONTAINER_SIZE_10),
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
                                                              height: FontSizeUtil.CONTAINER_SIZE_50,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                            .all(
                                                                        FontSizeUtil.CONTAINER_SIZE_10),
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
                                                                      onTap: () =>
                                                                          _deleteOption(
                                                                              index),
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
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: FontSizeUtil.CONTAINER_SIZE_25, horizontal: FontSizeUtil.CONTAINER_SIZE_50),
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate() &&
                                        _guestPollEndErrorMessage == null &&
                                        _guestPollEndErrorMessage == null &&
                                        showPurposeErrorMessage == false) {
                                      if (options.length >= 2) {
                                        _formKey.currentState!.save();
                                        FocusScope.of(context).unfocus();

                                        _addPollApi();
                                      } else {
                                        var msg = Strings
                                            .MINIMUM_TWO_POLL_WARNING_TEXT;
                                        errorAlert(context, msg);
                                      }
                                    } else {
                                      var msg = Strings.MANDATORY_WARNING_TEXT;
                                      errorAlert(context, msg);
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
                                  child: Text(Strings.CREATE_POLL_BUTTON_TEXT,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            FontSizeUtil.CONTAINER_SIZE_18,
                                      )),
                                ),
                              ),
                              SizedBox(height: FontSizeUtil.CONTAINER_SIZE_130),
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

  _addPollApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apartId = prefs.getInt('apartmentId');
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;

        if (_isNetworkConnected) {
          _isLoading = true;
          String responseType = "createPoll";
          String keyName = "pollDetail";

          final Map<String, dynamic> data = <String, dynamic>{};

          data['pollesFor'] = _enteredHospitalName;
          data['startTime'] = _enteredAdmittedDate;
          data['endTime'] = _enteredDichargedDate;
          data['alloption'] = options;
          // data['voteAllowed'] = _enteredCountName;
          data['apartmentId'] = apartId;

          String addVotePollURL =
              '${Constant.addVotePollURL}?apartmentId=$apartId';

          NetworkUtils.postMultipartNetWorkUrlCall(
              addVotePollURL, data, this, responseType, keyName);
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
      ResponceModel responceModel =
          ResponceModel.fromJson(json.decode(response));

      if (responceModel.status == "success") {
        // successDialog(
        //     context, responceModel.message!, const AdminVotePollScreen());

        successDialogWithListner(
            context, responceModel.message!, const AdminVotePollScreen(), this);
      } else {
        Utils.showToast(responceModel.message!);
      }
      setState(() {
        _isLoading = false;
      });
      // ApiResponceModel
      // var jsonResponse = json.decode(response);

      // ApiResponceModel notice = ApiResponceModel.fromJson(jsonResponse);

      // successDialog(context, notice.message!, const AdminVotePollScreen());
    } catch (error) {
      print("Error 1");
      errorAlert(
        context,
        response.toString(),
      );
    }
  }

  void _openAddOptionDialog(
      BuildContext context, containerBorderColor1, boxShadowColor) {
    String newOption = '';
    bool isSaveButtonDisabled = true; // Track the state of the "Save" button

    showDialog(
      context: context,
      barrierDismissible: false,
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
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(Strings.EMOJI_DENY_REGEX)
                                  ],
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
          // Container(
          //   width: 350,
          //   // height: MediaQuery.of(context).size.height * 0.35,
          //   decoration: AppStyles.decoration(context),
          //   child: SingleChildScrollView(
          //     child: Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Column(
          //         children: [
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.end,
          //             children: [
          //               const Expanded(
          //                 child: Center(
          //                   child: Padding(
          //                     padding: EdgeInsets.only(left: 30),
          //                     child: Text(
          //                       'Update Status',
          //                       style: TextStyle(
          //                         color: Color.fromRGBO(27, 86, 148, 1.0),
          //                         fontSize: 16,
          //                         fontWeight: FontWeight.bold,
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               GestureDetector(
          //                 onTap: () {
          //                   Navigator.of(context).pop();
          //                 },
          //                 child: Padding(
          //                   padding: const EdgeInsets.all(8.0),
          //                   child: Container(
          //                     height: 30,
          //                     width: 30,
          //                     decoration: AppStyles.circle1(context),
          //                     child: const Icon(
          //                       Icons.close_sharp,
          //                       color: Colors.white,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           Padding(
          //             padding: const EdgeInsets.symmetric(horizontal: 18.0),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: <Widget>[
          //                 const SizedBox(height: 10),
          //                 const Text(
          //                   'Select status',
          //                   style: TextStyle(
          //                     color: Color.fromRGBO(27, 86, 148, 1.0),
          //                     fontSize: 16,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //                 const SizedBox(height: 10),
          //                 Stack(
          //                   alignment: Alignment.centerLeft,
          //                   children: <Widget>[
          //                     Container(
          //                       decoration: BoxDecoration(
          //                         color: Colors.white,
          //                         borderRadius: BorderRadius.circular(10),
          //                         boxShadow: const [
          //                           BoxShadow(
          //                             color: Color.fromARGB(255, 100, 100, 100),
          //                             blurRadius: 6,
          //                             offset: Offset(0, 2),
          //                           ),
          //                         ],
          //                       ),
          //                       height: 50,
          //                       child: DropdownButtonFormField<String>(
          //                         value: _selectedGender,
          //                         decoration: const InputDecoration(
          //                           border: InputBorder.none,
          //                           prefixIcon: Icon(Icons.accessibility),
          //                         ),
          //                         items: genders.asMap().entries.map((entry) {
          //                           // final index = entry.key;
          //                           final gender = entry.value;
          //                           return DropdownMenuItem<String>(
          //                             value: gender,
          //                             child: Row(
          //                               children: [
          //                                 const SizedBox(width: 6),
          //                                 Text(gender),
          //                               ],
          //                             ),
          //                           );
          //                         }).toList(),
          //                         onChanged: (value) {
          //                           setState(() {
          //                             _selectedGender = value;
          //                           });
          //                         },
          //                         hint: const Text(
          //                           "Select Status",
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //                 const SizedBox(height: 10),
          //                 const Text(
          //                   'Enter Action',
          //                   style: TextStyle(
          //                     color: Color.fromRGBO(27, 86, 148, 1.0),
          //                     fontSize: 16,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //                 const SizedBox(height: 10),
          //                 Stack(
          //                   alignment: Alignment.centerLeft,
          //                   children: <Widget>[
          //                     const SizedBox(width: 8),
          //                     FocusScope(
          //                       child: Focus(
          //                         onFocusChange: (hasFocus) {
          //                           setState(() {
          //                             containerBorderColor1 = hasFocus
          //                                 ? const Color.fromARGB(
          //                                     255, 0, 137, 250)
          //                                 : Colors.white;
          //                             boxShadowColor = hasFocus
          //                                 ? const Color.fromARGB(
          //                                     162, 63, 158, 235)
          //                                 : const Color.fromARGB(
          //                                     255, 100, 100, 100);
          //                           });
          //                         },
          //                         child: Container(
          //                           decoration: BoxDecoration(
          //                             color: Colors.white,
          //                             borderRadius: BorderRadius.circular(10),
          //                             boxShadow: [
          //                               BoxShadow(
          //                                 color: boxShadowColor,
          //                                 blurRadius: 6,
          //                                 offset: const Offset(0, 2),
          //                               ),
          //                             ],
          //                             border: Border.all(
          //                               color: containerBorderColor1,
          //                             ),
          //                           ),
          //                           height: 100,
          //                           child: TextFormField(
          //                             keyboardType: TextInputType.multiline,
          //                             scrollPadding: EdgeInsets.only(
          //                                 bottom: MediaQuery.of(context)
          //                                         .viewInsets
          //                                         .bottom *
          //                                     6.10),
          //                             maxLines: null,
          //                             style: const TextStyle(
          //                                 color: Colors.black87),
          //                             decoration: const InputDecoration(
          //                               border: InputBorder.none,
          //                               contentPadding:
          //                                   EdgeInsets.only(top: 14),
          //                               prefixIcon: Icon(
          //                                 Icons.description,
          //                                 color: Color(0xff4d004d),
          //                               ),
          //                               hintText: 'Enter Message',
          //                               hintStyle:
          //                                   TextStyle(color: Colors.black38),
          //                             ),
          //                             validator: (value) {
          //                               if (value == null ||
          //                                   value.isEmpty ||
          //                                   value.trim().length <= 1 ||
          //                                   value.trim().length > 20) {
          //                                 setState(() {
          //                                   // showErrorMessage = true;
          //                                 });
          //                               } else {
          //                                 setState(() {
          //                                   // showErrorMessage = false;
          //                                 });
          //                                 return null;
          //                               }
          //                               return null;
          //                             },
          //                             onChanged: (value) {
          //                               newOption = value;
          //                             },
          //                             onSaved: (value) {
          //                               setState(() {});
          //                             },
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //                    const SizedBox(height: 10),
          //                 Row(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   children: <Widget>[
          //                     SizedBox(
          //                       height: 30,
          //                       child: ElevatedButton(
          //                         style: OutlinedButton.styleFrom(
          //                           shape: RoundedRectangleBorder(
          //                             borderRadius: BorderRadius.circular(20.0),
          //                             side: const BorderSide(
          //                                 color:
          //                                     Color.fromARGB(255, 0, 123, 255),
          //                                 width: 2),
          //                           ),
          //                           padding: const EdgeInsets.symmetric(
          //                               horizontal: 15, vertical: 0),
          //                         ),
          //                         onPressed: () {
          //                           // if (selectedIssueId != 0) {
          //                           String trimmedOption = newOption.trim();
          //                           print(trimmedOption);
          //                           print(_selectedGender);
          //                           if (trimmedOption.isNotEmpty) {
          //                             Utils.getNetworkConnectedStatus()
          //                                 .then((status) {
          //                               setState(() {
          //                                 _isNetworkConnected = status;
          //                                 _isLoading = status;
          //                                 print(_isNetworkConnected);
          //                                 if (_isNetworkConnected) {
          //                                   _isLoading = true;
          //                                   String responseType = "assignTask";

          //                                   String loginURL =
          //                                       '${Constant.updateIssueStatueURL}?issueId=$selectedIssueId&status=$_selectedGender&action=$trimmedOption';

          //                                   NetworkUtils.putUrlNetWorkCall(
          //                                       loginURL, this, responseType);
          //                                 }
          //                               });
          //                             });

          //                             Navigator.of(context).pop();
          //                           } else {
          //                             Fluttertoast.showToast(
          //                               msg: "Please enter the message",
          //                               toastLength: Toast.LENGTH_SHORT,
          //                               gravity: ToastGravity.CENTER,
          //                               timeInSecForIosWeb: 1,
          //                               backgroundColor: Colors.red,
          //                               textColor: Colors.white,
          //                               fontSize: 16.0,
          //                             );
          //                           }

          //                         },
          //                         child: const Text("Submit"),
          //                       ),
          //                     ),
          //                     const SizedBox(width: 10),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        );
      },
    );
  }

  @override
  onNavigatorBackPressed() {
    Navigator.pop(context);
    widget.navigatorListener!.onNavigatorBackPressed();
    // TODO: implement onBackPressed
    // throw UnimplementedError();
  }
}

//   Future<void> _showCustomDialog(
//       BuildContext context, containerBorderColor1, boxShadowColor) async {
//     String newOption = '';

//     dialogContext = context;

//     return showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (context) {
//         return Center(
//           child: Material(
//             type: MaterialType.transparency,
//             child: Container(
//               width: 330,
//               decoration: AppStyles.decoration(context),
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       const Text(
//                         'Option',
//                         style: TextStyle(
//                           color: Color.fromRGBO(27, 86, 148, 1.0),
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Stack(
//                         alignment: Alignment.centerLeft,
//                         children: <Widget>[
//                           FocusScope(
//                             child: Focus(
//                               onFocusChange: (hasFocus) {
//                                 setState(() {
//                                   containerBorderColor1 = hasFocus
//                                       ? const Color.fromARGB(255, 0, 137, 250)
//                                       : Colors.white;
//                                   boxShadowColor = hasFocus
//                                       ? const Color.fromARGB(162, 63, 158, 235)
//                                       : const Color.fromARGB(
//                                           255, 100, 100, 100);
//                                 });
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(10),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: boxShadowColor,
//                                       blurRadius: 6,
//                                       offset: const Offset(0, 2),
//                                     ),
//                                   ],
//                                   border: Border.all(
//                                     color: containerBorderColor1,
//                                   ),
//                                 ),
//                                 height: 100,
//                                 child: TextFormField(
//                                   keyboardType: TextInputType.multiline,
//                                   maxLines: null,
//                                   style: const TextStyle(color: Colors.black87),
//                                   decoration: const InputDecoration(
//                                     border: InputBorder.none,
//                                     contentPadding: EdgeInsets.only(top: 14),
//                                     prefixIcon: Icon(
//                                       Icons.description,
//                                       color: Color(0xff4d004d),
//                                     ),
//                                     hintText: 'Enter Option',
//                                     hintStyle: TextStyle(color: Colors.black38),
//                                   ),
//                                   validator: (value) {
//                                     if (value == null ||
//                                         value.isEmpty ||
//                                         value.trim().length <= 1 ||
//                                         value.trim().length > 20) {
//                                       setState(() {
//                                         showErrorMessage = true;
//                                       });
//                                     } else {
//                                       setState(() {
//                                         showErrorMessage = false;
//                                       });
//                                       return null;
//                                     }
//                                     return null;
//                                   },
//                                   onChanged: (value) {
//                                     newOption = value;
//                                   },
//                                   onSaved: (value) {
//                                     setState(() {});
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           SizedBox(
//                             height: 30,
//                             child: ElevatedButton(
//                               style: OutlinedButton.styleFrom(
//                                 backgroundColor:
//                                     const Color.fromARGB(211, 38, 209, 38),
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20.0),
//                                   side: const BorderSide(
//                                     width: 1,
//                                     color: Color.fromARGB(211, 38, 209, 38),
//                                   ),
//                                 ),
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 15, vertical: 0),
//                               ),
//                               // style: OutlinedButton.styleFrom(
//                               //   shape: RoundedRectangleBorder(
//                               //     borderRadius: BorderRadius.circular(20.0),
//                               //     side: const BorderSide(
//                               //         color: Color.fromARGB(255, 0, 123, 255),
//                               //         width: 2),
//                               //   ),
//                               //   padding: const EdgeInsets.symmetric(
//                               //       horizontal: 15, vertical: 0),
//                               // ),
//                               onPressed: () {
//                                 // Use trim() to remove leading and trailing whitespaces
//                                 String trimmedOption = newOption.trim();

//                                 if (!options
//                                     .map((option) => option.toLowerCase())
//                                     .contains(trimmedOption.toLowerCase())) {
//                                   if (trimmedOption.isNotEmpty) {
//                                     setState(() {
//                                       options.add(trimmedOption);
//                                     });
//                                     Navigator.of(context).pop();
//                                   } else {
//                                     Fluttertoast.showToast(
//                                       msg: "Please select an option",
//                                       toastLength: Toast.LENGTH_SHORT,
//                                       gravity: ToastGravity.CENTER,
//                                       timeInSecForIosWeb: 1,
//                                       backgroundColor: Colors.red,
//                                       textColor: Colors.white,
//                                       fontSize: 16.0,
//                                     );
//                                   }
//                                 } else {
//                                   Fluttertoast.showToast(
//                                     msg: "Option already entered",
//                                     toastLength: Toast.LENGTH_SHORT,
//                                     gravity: ToastGravity.CENTER,
//                                     timeInSecForIosWeb: 1,
//                                     backgroundColor: Colors.red,
//                                     textColor: Colors.white,
//                                     fontSize: 16.0,
//                                   );
//                                 }
//                               },
//                               child: const Text("Save"),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           SizedBox(
//                             height: 30,
//                             child: ElevatedButton(
//                               style: OutlinedButton.styleFrom(
//                                 backgroundColor:
//                                     const Color.fromARGB(226, 182, 36, 36),
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20.0),
//                                   side: const BorderSide(
//                                     width: 1,
//                                     color: Color.fromARGB(226, 182, 36, 36),
//                                   ),
//                                 ),
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 15, vertical: 0),
//                               ),
//                               // style: OutlinedButton.styleFrom(
//                               //   shape: RoundedRectangleBorder(
//                               //     borderRadius: BorderRadius.circular(20.0),
//                               //     side: const BorderSide(
//                               //         color: Color.fromARGB(255, 0, 123, 255),
//                               //         width: 2),
//                               //   ),
//                               //   padding: const EdgeInsets.symmetric(
//                               //       horizontal: 15, vertical: 0),
//                               // ),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                               child: const Text("Close"),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
