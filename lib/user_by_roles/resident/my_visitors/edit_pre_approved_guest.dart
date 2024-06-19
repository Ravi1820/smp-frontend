import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/dropdown/gender_dropdown.dart';
import '../../../components/dropdown/text_form_field.dart';
import '../../../contants/constant_url.dart';
import '../../../contants/error_alert.dart';
import '../../../contants/error_dialog.dart';
import '../../../contants/success_dialog.dart';
import '../../../model/edit_pre_approved_model.dart';
import '../../../model/success_model.dart';
import '../../../network/NetworkUtils.dart';
import '../../../presenter/api_listener.dart';
import '../../../presenter/navigator_lisitner.dart';
import '../../../theme/common_style.dart';
import '../../../utils/Strings.dart';
import '../../../utils/Utils.dart';
import '../../../utils/size_utility.dart';
import '../../../widget/avatar.dart';
import '../../../widget/footers.dart';
import '../../../widget/header.dart';
import '../../../widget/loader.dart';
import '../../../widget/text_label.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

import 'approved_visitors.dart';

class EditPreApproveGuest extends StatefulWidget {
  const EditPreApproveGuest({
    super.key,
    required this.visitorId,
    required this.guestName,
    required this.mobile,
    required this.fromDate,
    required this.toDate,
    required this.purposeToMeet,
    required this.numberOfGuest,
    required this.profilePicture,
    required this.baseImageIssueApi,
    required this.navigatorListener,
  });

  final int visitorId;
  final String guestName;
  final String mobile;
  final String fromDate;
  final String toDate;
  final String purposeToMeet;
  final int numberOfGuest;
  final String profilePicture;
  final String baseImageIssueApi;
  final NavigatorListener navigatorListener;

  @override
  State<EditPreApproveGuest> createState() => _EditPreApproveGuestState();
}

class _EditPreApproveGuestState extends State<EditPreApproveGuest>
    with ApiListener, NavigatorListener {
  bool _isNetworkConnected = false, _isLoading = false;
  int visitorId = 0;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _otherController = TextEditingController();

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();
  final purpose = ['Personal', 'Parcels ', 'Maintenance', 'Others'];
  String selectedFlatId = "";

  // var otherPurpose;
  String editOtherPurpose = "";
  String baseImageIssueApi = '';
  File? filePath = null;
  String? _selectedPurpose;
  String? _guestPollEndErrorMessage;
  String? _guestPollStartErrorMessage;
  String? _guestOtherPurposeErrorMessage;
  String? _guestPurposeErrorMessage;
  String? _countErrorMessage;
  String? _guestNameErrorMessage;
  String? _mobileErrorMessage;
  DateTime currentDate = DateTime.now();
  String? _enteredAdmittedDate;
  String? _enteredDichargedDate;
  int _counter = 1;
  File? _selectedImage;
  DateTime? _fromDateTime;
  String? _enteredPurposeToMeet;
  var _enteredMobile = '';
  var _enteredGuestName = '';
  var _enteredGuestAddress = '';
  DateTime? _toDateTime;
  String? _imageUrl;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _getDataFromApprovedVisitor();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    _fromDateController.addListener(() {
      setState(() {
        _guestPollStartErrorMessage =
            validateStartDate(_fromDateController.text);
      });
    });
    _toDateController.addListener(() {
      setState(() {
        _guestPollEndErrorMessage = validateEndDate(_toDateController.text);
      });
    });
    _smpStorage();
  }

  String? validateStartDate(String input) {
    DateTime selectedDate = DateTime.parse(input);
    DateTime currentDate = DateTime.now();
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

    (_imageUrl != null && filePath == null && _imageUrl != 'Unknown')
        ? content = GestureDetector(
            onTap: _takePicture,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Stack(
                children: <Widget>[
                  if (_imageUrl != null && _imageUrl!.isNotEmpty)
                    Image.network(
                      '$baseImageIssueApi${_imageUrl.toString()}',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      gaplessPlayback: true,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                            alignment: Alignment.center,
                            child: const AvatarScreen());
                      },
                    )
                  else
                    const AvatarScreen(),
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

    TextStyle headerPlaceHolder = TextStyle(
        fontFamily: 'Roboto',
        fontSize: MediaQuery.of(context).size.width * 0.04,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        color: const Color.fromARGB(181, 27, 85, 148));

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
              title: Strings.EDIT_PRE_APPROVE_GUEST_HEADER,
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
                                height: FontSizeUtil.CONTAINER_SIZE_100,
                                width: FontSizeUtil.CONTAINER_SIZE_100,
                                alignment: Alignment.center,
                                child: content,
                              ),

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
                                          0: FlexColumnWidth(4),
                                          1: FlexColumnWidth(4),
                                          // 2: FlexColumnWidth(4),
                                        },
                                        children: <TableRow>[
                                          TableRow(
                                            children: <Widget>[
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      FontSizeUtil.SIZE_01),
                                                  child: const CustomTextLabel(
                                                      labelText: Strings
                                                          .GUEST_NAME_LABEL_TEXT,
                                                      manditory: "*"),
                                                ),
                                              ),
                                              TableCell(
                                                child: Column(
                                                  children: [
                                                    CustomTextField(
                                                      controller:
                                                          _nameController,
                                                      scrollPadding:
                                                          EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                                    context)
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
                                                      hintText: Strings
                                                          .GUEST_NAME_HINT_TEXT,
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            _guestNameErrorMessage =
                                                                Strings
                                                                    .NAME_REQU_TEXT;
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
                                                                    .NAME_REQU_TEXT;
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
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          _guestNameErrorMessage!,
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
                                          TableRow(
                                            children: <Widget>[
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      FontSizeUtil.SIZE_01),
                                                  child: const CustomTextLabel(
                                                    labelText: Strings
                                                        .MOBILE_LABEL_TEXT,
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
                                                        bottom: MediaQuery.of(
                                                                    context)
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
                                                      hintText: Strings
                                                          .MOBILE_HINT_TXT,
                                                      onChanged: (value) {
                                                        String?
                                                            validationMessage;

                                                        if (value!.isNotEmpty) {
                                                          const mobilePattern =
                                                              r'^[0-9]{10}$';
                                                          final isValidMobile =
                                                              RegExp(mobilePattern)
                                                                  .hasMatch(
                                                                      value);

                                                          if (!isValidMobile) {
                                                            validationMessage =
                                                                Strings
                                                                    .INVALID_MOB_NUM;
                                                          }
                                                        }

                                                        setState(() {
                                                          _mobileErrorMessage =
                                                              validationMessage;
                                                        });
                                                      },
                                                      validator: (value) {
                                                        String?
                                                            validationMessage;

                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            _mobileErrorMessage =
                                                                Strings
                                                                    .MOB_NUM_REQ;
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
                                                                Strings
                                                                    .INVALID_MOB_NUM;
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
                                          TableRow(
                                            children: <Widget>[
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      FontSizeUtil.SIZE_10),
                                                  child: const CustomTextLabel(
                                                    labelText: Strings
                                                        .FROM_DATE_LABEL_TEXT,
                                                    manditory: "*",
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      FontSizeUtil.SIZE_02),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(
                                                              color:
                                                                  Colors.black,
                                                              width:
                                                                  FontSizeUtil
                                                                      .SIZE_01,
                                                            ),
                                                          ),
                                                        ),
                                                        height: FontSizeUtil
                                                            .CONTAINER_SIZE_50,
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
                                                                        _fromDateController,
                                                                    style: AppStyles
                                                                        .heading1(
                                                                            context),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      hintText:
                                                                          Strings
                                                                              .FROM_DATE_HIN_TEXT,
                                                                      hintStyle:
                                                                          headerPlaceHolder,
                                                                      border: InputBorder
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
                                                                            validateStartDate(value);
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
                                                                Icons
                                                                    .date_range,
                                                                color: Color(
                                                                    0xff4d004d),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height: FontSizeUtil
                                                              .SIZE_05),
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
                                                  padding: EdgeInsets.all(
                                                      FontSizeUtil.SIZE_01),
                                                  child: const CustomTextLabel(
                                                    labelText: Strings
                                                        .TO_DATE_LABEL_TEXT,
                                                    manditory: "*",
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      FontSizeUtil.SIZE_02),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(
                                                              color:
                                                                  Colors.black,
                                                              width:
                                                                  FontSizeUtil
                                                                      .SIZE_01,
                                                            ),
                                                          ),
                                                        ),
                                                        height: FontSizeUtil
                                                            .CONTAINER_SIZE_50,
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
                                                                        _toDateController,
                                                                    style: AppStyles
                                                                        .heading1(
                                                                            context),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      hintText:
                                                                          Strings
                                                                              .TO_DATE_HIN_TEXT,
                                                                      hintStyle:
                                                                          headerPlaceHolder,
                                                                      border: InputBorder
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
                                                                Icons
                                                                    .date_range,
                                                                color: Color(
                                                                    0xff4d004d),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height: FontSizeUtil
                                                              .SIZE_05),
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
                                                  padding: EdgeInsets.all(
                                                      FontSizeUtil.SIZE_01),
                                                  child: const CustomTextLabel(
                                                    labelText:
                                                        Strings.PUR_TO_MEET,
                                                    manditory: "*",
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
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
                                                        validate: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            setState(() {
                                                              _guestPurposeErrorMessage =
                                                                  Strings
                                                                      .PUR_REQ_TXT;
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
                                                    padding: EdgeInsets.all(
                                                        FontSizeUtil.SIZE_01),
                                                    child:
                                                        const CustomTextLabel(
                                                      labelText:
                                                          Strings.OTH_PUR,
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
                                                    padding: EdgeInsets.all(
                                                        FontSizeUtil.SIZE_02),
                                                    child: Column(
                                                      children: [
                                                        TextFormField(
                                                          controller:
                                                              _otherController,
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
                                                          style: AppStyles
                                                              .heading1(
                                                                  context),
                                                          decoration:
                                                              InputDecoration(
                                                            hintText: Strings
                                                                .PUR_HIN_TXT,
                                                            hintStyle:
                                                                headerPlaceHolder,
                                                          ),
                                                          onChanged: (value) {
                                                            String?
                                                                validationMessage;

                                                            if (value.isEmpty) {
                                                              validationMessage =
                                                                  Strings
                                                                      .PUR_REQ_TXT;
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
                                                                color:
                                                                    Colors.red,
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
                                                    labelText: Strings
                                                        .NUM_GUEST_LABEL_TXT,
                                                    manditory: "*",
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    top: FontSizeUtil
                                                        .CONTAINER_SIZE_18,
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        height: FontSizeUtil
                                                            .CONTAINER_HEGIHT_SIZE,
                                                        width: FontSizeUtil
                                                            .CONTAINER_WIDTH_SIZE,
                                                        decoration: AppStyles
                                                            .decoration(
                                                                context),
                                                        child: IconButton(
                                                          icon: const Icon(
                                                              Icons.remove),
                                                          onPressed: () {
                                                            setState(() {
                                                              if (_counter >
                                                                  1) {
                                                                _counter--;
                                                              }
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.all(
                                                            FontSizeUtil
                                                                .CONTAINER_SIZE_15),
                                                        child: Text(
                                                          '$_counter',
                                                          style: TextStyle(
                                                              fontSize: FontSizeUtil
                                                                  .CONTAINER_SIZE_16),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: FontSizeUtil
                                                            .CONTAINER_HEGIHT_SIZE,
                                                        width: FontSizeUtil
                                                            .CONTAINER_WIDTH_SIZE,
                                                        decoration: AppStyles
                                                            .decoration(
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
                              // const SizedBox(height: 50),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: FontSizeUtil.CONTAINER_SIZE_25,
                                    horizontal: FontSizeUtil.CONTAINER_SIZE_50),
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: updatedAppartmentData,
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
                                  child:  Text(Strings.UPDATE_TEXT,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            FontSizeUtil.CONTAINER_SIZE_18,
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
                _fromDateController.text = _enteredAdmittedDate ?? '';
                _fromDateTime = selectedDateTime;
              });
            } else if (type == "Discharged Date") {
              setState(() {
                _enteredDichargedDate = formattedDateTime;
                _toDateController.text = _enteredDichargedDate ?? '';
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
      locale: picker.LocaleType.en,
      minTime: currentDate,
      maxTime: lastDate, // Set the maximum time to the last date
    );
  }

  void handlePurposeValidate(String? value) {
    if (value == null || value.isEmpty) {
      _guestPurposeErrorMessage = "Please select any purpose.";
    }
    return;
  }

  void handlePurposeChange(String? selectedPurpose) {
    setState(() {
      _selectedPurpose = selectedPurpose;
      _enteredPurposeToMeet = null;
    });
  }

  void _smpStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var id = prefs.getInt('id');
    var apartId = prefs.getInt('apartmentId');

    var userNam = prefs.getString('userName');

    setState(() {
      token = token!;
      Utils.printLog('token: $token');
      var apartmentId = apartId;
      selectedFlatId = prefs.getString('flatId')!;
      Utils.printLog('FlatId: $selectedFlatId');
      var userId = id!;
      var userName = userNam!;
    });
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

  _getDataFromApprovedVisitor() {
    _nameController.text = widget.guestName;
    _mobileController.text = widget.mobile;
    _fromDateController.text = widget.fromDate;
    _toDateController.text = widget.toDate;
    // _selectedPurpose=widget.purposeToMeet;
    if (widget.purposeToMeet.isNotEmpty) {
      List selectedCategoryIds = purpose.map((category) => category).toList();
      if (!selectedCategoryIds.contains(widget.purposeToMeet)) {
        _otherController.text = widget.purposeToMeet;
        _selectedPurpose = "Others";
        // print("Other purpose == $otherPurpose");
      } else {
        _selectedPurpose = widget.purposeToMeet;
      }
    }
    _counter = widget.numberOfGuest;
    _imageUrl = widget.profilePicture;
    baseImageIssueApi = widget.baseImageIssueApi;
    Utils.printLog("name ${_nameController.text}");
    Utils.printLog("mobile ${_mobileController.text}");
    Utils.printLog("fromDate ${_fromDateController.text}");
    Utils.printLog("toDate ${_toDateController.text}");
    Utils.printLog("purpose  $_selectedPurpose");
    Utils.printLog("counter $_counter");
  }

  updatedAppartmentData() {
    if (_formKey.currentState!.validate() &&
        _countErrorMessage == null &&
        _guestNameErrorMessage == null &&
        _fromDateController.text.isNotEmpty &&
        _toDateController.text.isNotEmpty &&
        _mobileErrorMessage == null) {
      _formKey.currentState!.save();

      print(_enteredGuestName);

      print(_enteredPurposeToMeet);
      print(_enteredMobile);
      print(_fromDateController.text);
      print(_toDateController.text);

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
        _updateGuestAPI(purpose);
      } else {
        errorAlert(context, "Please enter purpose");
      }
    } else {
      errorAlert(context, Strings.MANDATORY_FIELD_TEXT);
    }
  }

  _updateGuestAPI(purpose) {
    Utils.getNetworkConnectedStatus().then((status) {
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          var responseType = 'updateGuest';
          print("visitorID : ${visitorId}");
          var keyName = "visitorInput";

          String updateGuestUrl =
              "${Constant.updatePreApproveGuestURL}visitorId=${widget.visitorId}";
          print(updateGuestUrl);
          NetworkUtils.filePostUploadNetWorkCall(updateGuestUrl, keyName,
              _getJsonData(purpose).toString(), filePath, this, responseType);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          // Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
          Utils.showCustomToast(context);
        }
      });
    });
  }

  _getJsonData(purpose) {
    final data = {
      '"name"': '"$_enteredGuestName"',
      '"purpose"': '"$purpose"',
      '"mobile"': '"$_enteredMobile"',
      '"validFrom"': '"${_fromDateController.text}"',
      '"validTo"': '"${_toDateController.text}"',
      '"numberOfVisitor"': _counter,
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
        if (responseType == 'updateGuest') {
          EditPreApproved editPreApproved =
              EditPreApproved.fromJson(json.decode(response));
          if (editPreApproved.status == "success") {
            successDialogWithListner(context, editPreApproved.message!,
                const ResidentApprovedVisitorsList(), this);
            print("successDialogWithListner called====");
            _isLoading = false;
          } else {
            errorDialog(context, editPreApproved.message!,
                const ResidentApprovedVisitorsList());
            _isLoading = false;
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
