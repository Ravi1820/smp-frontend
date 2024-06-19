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
import 'package:SMP/utils/colors_utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterAminity extends StatefulWidget {
  RegisterAminity({
    super.key,
  });

  @override
  State<RegisterAminity> createState() {
    return _RegisterAminityState();
  }
}

class _RegisterAminityState extends State<RegisterAminity>
    with ApiListener, NavigatorListener {
  final _formKey = GlobalKey<FormState>();
  bool _isNetworkConnected = false, _isLoading = false;
  var _enteredVehicleNumber = '';
  int apartmentId = 0;
  String? token = '';
  int? userId = 0;
  bool showVehicleSlotErrorMessage = false;
  bool showVehicleTypeErrorMessage = false;
  bool showVehicleNumberErrorMessage = false;
  bool showChargesErrorMessage = false;
  bool showLocationErrorMessage = false;
  bool showDescriptionErrorMessage = false;
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
  Color _containerBorderColor1 = Colors.white;
  Color _boxShadowColor1 = const Color.fromARGB(255, 100, 100, 100);
  Color _facilityNameBorderColor = Colors.white;
  Color _facilityNameBoxShadowColor = const Color.fromARGB(255, 100, 100, 100);
  Color _facilityLocationBorderColor = Colors.white;
  Color _facilityLocationBoxShadowColor =
      const Color.fromARGB(255, 100, 100, 100);
  Color _facilityChargesBorderColor = Colors.white;
  Color _facilityChargesBoxShadowColor =
      const Color.fromARGB(255, 100, 100, 100);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<File> _selectedImages = [];

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

  void _takePicture() async {
    ImageSource? source = await Utils.takePicture(context);
    if (source != null) {
      final imagePicker = ImagePicker();
      final pickedFile =
          await imagePicker.pickImage(source: source, maxWidth: 600);
      if (pickedFile != null) {
        setState(() {
          _selectedImages.add(File(pickedFile.path));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            title: Strings.AMENITY_HEADER,
            profile: () async {
              Utils.navigateToPushScreen(
                  context, DashboardScreen(isFirstLogin: false));
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
                        SmpAppColors.white,
                        SmpAppColors.white,
                      ],
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: FontSizeUtil.PADDING_HEIGHT_10),
                        Card(
                          margin:
                              EdgeInsets.all(FontSizeUtil.PADDING_HEIGHT_10),
                          shadowColor: SmpAppColors.blueGrey,
                          child: Container(
                            decoration: AppStyles.decoration(context),
                            child: Padding(
                              padding: EdgeInsets.all(
                                  FontSizeUtil.PADDING_HEIGHT_10),
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
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: Strings
                                                          .FACILITY_LABEL,
                                                      style: AppStyles.label(
                                                          context)),
                                                  TextSpan(
                                                    text: '*',
                                                    style: TextStyle(
                                                      color: SmpAppColors.red,
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
                                                    .PADDING_HEIGHT_10),
                                            Stack(
                                              alignment: Alignment.centerLeft,
                                              children: <Widget>[
                                                FocusScope(
                                                  child: Focus(
                                                    onFocusChange: (hasFocus) {
                                                      setState(() {
                                                        _facilityNameBorderColor =
                                                            hasFocus
                                                                ? SmpAppColors
                                                                    .containerFocusColor
                                                                : SmpAppColors
                                                                    .white;
                                                        _facilityNameBoxShadowColor =
                                                            hasFocus
                                                                ? SmpAppColors
                                                                    .boxShadowFocusColor
                                                                : SmpAppColors
                                                                    .boxShadowUnFocusColor;
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
                                                                _facilityNameBoxShadowColor,
                                                            blurRadius: 6,
                                                            offset:
                                                                const Offset(
                                                                    0, 2),
                                                          ),
                                                        ],
                                                        border: Border.all(
                                                          color:
                                                              _facilityNameBorderColor,
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
                                                                  .CONTAINER_SIZE_14),
                                                          hintText: Strings
                                                              .FACILITY_LABEL_PLACEHOLDER,
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
                                                                    .VEHICLE_NUMBER_ERRORMESSAGE;
                                                          }
                                                          if (validationMessage !=
                                                              null) {
                                                            setState(() {
                                                              showVehicleNumberErrorMessage =
                                                                  true;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              showVehicleNumberErrorMessage =
                                                                  false;
                                                            });
                                                          }
                                                        },
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            setState(() {
                                                              showVehicleNumberErrorMessage =
                                                                  true;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              showVehicleNumberErrorMessage =
                                                                  false;
                                                            });
                                                            return null;
                                                          }
                                                        },
                                                        onSaved: (value) {
                                                          _enteredVehicleNumber =
                                                              value!;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (showVehicleNumberErrorMessage)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: FontSizeUtil.SIZE_05,
                                                    left: FontSizeUtil.SIZE_05),
                                                child: Text(
                                                  Strings.FACILITY_ERRORMESSAGE,
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: FontSizeUtil
                                                          .CONTAINER_SIZE_15),
                                                ),
                                              ),
                                            SizedBox(
                                                height: FontSizeUtil.SIZE_05),
                                          ],
                                        ),
                                      ],
                                    ),
                                    TableRow(children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              height: FontSizeUtil.SIZE_05),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                    text: Strings
                                                        .FACILITY_TYPE_LABEL,
                                                    style: AppStyles.label(
                                                        context)),
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
                                                  .PADDING_HEIGHT_10),
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
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            showVehicleTypeErrorMessage =
                                                                true;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            _selectedFacilityType =
                                                                value;
                                                          });
                                                          setState(() {
                                                            showVehicleTypeErrorMessage =
                                                                false;
                                                          });
                                                        }
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            showVehicleTypeErrorMessage =
                                                                true;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            showVehicleTypeErrorMessage =
                                                                false;
                                                          });
                                                          return null;
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        // Remove the bottom border line
                                                        hintText: Strings
                                                            .VEHICLE_TYPE_PLACEHOLDER,
                                                        contentPadding:
                                                            EdgeInsets.symmetric(
                                                                horizontal:
                                                                    FontSizeUtil
                                                                        .CONTAINER_SIZE_16),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (showVehicleTypeErrorMessage)
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: FontSizeUtil.SIZE_05,
                                                  top: FontSizeUtil.SIZE_05),
                                              child: Text(
                                                Strings
                                                    .VEHICLE_TYPE_ERROR_MESSAGE,
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: FontSizeUtil
                                                        .CONTAINER_SIZE_15),
                                              ),
                                            ),
                                          SizedBox(
                                              height: FontSizeUtil
                                                  .PADDING_HEIGHT_10),
                                        ],
                                      ),
                                    ]),
                                    TableRow(
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: Strings
                                                          .FACILITY_LOCATION,
                                                      style: AppStyles.label(
                                                          context)),
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
                                                    .PADDING_HEIGHT_10),
                                            Stack(
                                              alignment: Alignment.centerLeft,
                                              children: <Widget>[
                                                FocusScope(
                                                  child: Focus(
                                                    onFocusChange: (hasFocus) {
                                                      setState(() {
                                                        _facilityLocationBorderColor =
                                                            hasFocus
                                                                ? SmpAppColors
                                                                    .containerFocusColor
                                                                : SmpAppColors
                                                                    .white;
                                                        _facilityLocationBoxShadowColor =
                                                            hasFocus
                                                                ? SmpAppColors
                                                                    .boxShadowFocusColor
                                                                : SmpAppColors
                                                                    .boxShadowUnFocusColor;
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
                                                                _facilityLocationBoxShadowColor,
                                                            blurRadius: 6,
                                                            offset:
                                                                const Offset(
                                                                    0, 2),
                                                          ),
                                                        ],
                                                        border: Border.all(
                                                          color:
                                                              _facilityLocationBorderColor,
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
                                                                  .CONTAINER_SIZE_14),
                                                          hintText: Strings
                                                              .FACILITY_LOCATION_PLACEHOLDER,
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
                                                                    .VEHICLE_NUMBER_ERRORMESSAGE;
                                                          }
                                                          if (validationMessage !=
                                                              null) {
                                                            setState(() {
                                                              showLocationErrorMessage =
                                                                  true;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              showLocationErrorMessage =
                                                                  false;
                                                            });
                                                          }
                                                        },
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            setState(() {
                                                              showLocationErrorMessage =
                                                                  true;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              showLocationErrorMessage =
                                                                  false;
                                                            });
                                                            return null;
                                                          }
                                                        },
                                                        onSaved: (value) {
                                                          _enteredVehicleNumber =
                                                              value!;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (showLocationErrorMessage)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: FontSizeUtil.SIZE_05,
                                                    left: FontSizeUtil.SIZE_05),
                                                child: Text(
                                                  Strings
                                                      .FACILITY_LOCATION_ERRORMESSAGE,
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: FontSizeUtil
                                                          .CONTAINER_SIZE_15),
                                                ),
                                              ),
                                            SizedBox(
                                                height: FontSizeUtil.SIZE_05),
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
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: Strings
                                                        .FACILITY_CHARGES,
                                                    style: AppStyles.label(
                                                        context),
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
                                                    .PADDING_HEIGHT_10),
                                            Stack(
                                              alignment: Alignment.centerLeft,
                                              children: <Widget>[
                                                FocusScope(
                                                  child: Focus(
                                                    onFocusChange: (hasFocus) {
                                                      setState(() {
                                                        _facilityChargesBorderColor =
                                                            hasFocus
                                                                ? SmpAppColors
                                                                    .containerFocusColor
                                                                : SmpAppColors
                                                                    .white;
                                                        _facilityChargesBoxShadowColor =
                                                            hasFocus
                                                                ? SmpAppColors
                                                                    .boxShadowFocusColor
                                                                : SmpAppColors
                                                                    .boxShadowUnFocusColor;
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
                                                                _facilityChargesBoxShadowColor,
                                                            blurRadius: 6,
                                                            offset:
                                                                const Offset(
                                                                    0, 2),
                                                          ),
                                                        ],
                                                        border: Border.all(
                                                          color:
                                                              _facilityChargesBorderColor,
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
                                                                  .CONTAINER_SIZE_14),
                                                          hintText: Strings
                                                              .FACILITY_CHARGES_PLACEHOLDER,
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
                                                                    .VEHICLE_NUMBER_ERRORMESSAGE;
                                                          }
                                                          if (validationMessage !=
                                                              null) {
                                                            setState(() {
                                                              showChargesErrorMessage =
                                                                  true;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              showChargesErrorMessage =
                                                                  false;
                                                            });
                                                          }
                                                        },
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            setState(() {
                                                              showChargesErrorMessage =
                                                                  true;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              showChargesErrorMessage =
                                                                  false;
                                                            });
                                                            return null;
                                                          }
                                                        },
                                                        onSaved: (value) {
                                                          _enteredVehicleNumber =
                                                              value!;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (showChargesErrorMessage)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: FontSizeUtil.SIZE_05,
                                                    left: FontSizeUtil.SIZE_05),
                                                child: Text(
                                                  Strings
                                                      .FACILITY_CHARGES_ERRORMESSAGE,
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: FontSizeUtil
                                                          .CONTAINER_SIZE_15),
                                                ),
                                              ),
                                            SizedBox(
                                                height: FontSizeUtil.SIZE_05),
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
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                      text: Strings
                                                          .FACILITY_DESCRIPTION,
                                                      style: AppStyles.label(
                                                          context)),
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
                                                    .PADDING_HEIGHT_10),
                                            Stack(
                                              alignment: Alignment.centerLeft,
                                              children: <Widget>[
                                                FocusScope(
                                                  child: Focus(
                                                    onFocusChange: (hasFocus) {
                                                      setState(() {
                                                        _containerBorderColor1 =
                                                            hasFocus
                                                                ? SmpAppColors
                                                                    .containerFocusColor
                                                                : SmpAppColors
                                                                    .white;
                                                        _boxShadowColor1 = hasFocus
                                                            ? SmpAppColors
                                                                .boxShadowFocusColor
                                                            : SmpAppColors
                                                                .boxShadowUnFocusColor;
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
                                                          .CONTAINER_SIZE_100,
                                                      child: TextFormField(
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .deny(Strings
                                                                  .EMOJI_DENY_REGEX)
                                                        ],
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        maxLines: FontSizeUtil
                                                            .MAX_LINE_30,
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
                                                                  .CONTAINER_SIZE_14),
                                                          hintText: Strings
                                                              .FACILITY_DESCRIPTION_PLACEHOLDER,
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
                                                                    .VEHICLE_NUMBER_ERRORMESSAGE;
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
                                                          _enteredVehicleNumber =
                                                              value!;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (showDescriptionErrorMessage)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: FontSizeUtil.SIZE_05,
                                                    left: FontSizeUtil.SIZE_05),
                                                child: Text(
                                                  Strings
                                                      .FACILITY_DESCRIPTION_ERRORMESSAGE,
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: FontSizeUtil
                                                          .CONTAINER_SIZE_15),
                                                ),
                                              ),
                                            SizedBox(
                                                height: FontSizeUtil.SIZE_10),
                                          ],
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: <Widget>[
                                        Row(
                                          children: [
                                            Expanded(
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Wrap(
                                                  spacing: FontSizeUtil
                                                      .CONTAINER_SIZE_10,
                                                  runSpacing: FontSizeUtil
                                                      .CONTAINER_SIZE_10,
                                                  children: _selectedImages
                                                      .map((image) {
                                                    return InkWell(
                                                      onTap: () {},
                                                      child: Container(
                                                        height: FontSizeUtil
                                                            .CONTAINER_SIZE_100,
                                                        width: FontSizeUtil
                                                            .CONTAINER_SIZE_100,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                                  .fromRGBO(255,
                                                              233, 162, 0.5),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  FontSizeUtil
                                                                      .CONTAINER_SIZE_20),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  FontSizeUtil
                                                                      .CONTAINER_SIZE_20),
                                                          child: Image.file(
                                                            image,
                                                            height:
                                                                double.infinity,
                                                            width:
                                                                double.infinity,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList()
                                                    ..add(
                                                      InkWell(
                                                        onTap: _takePicture,
                                                        child: Container(
                                                          height: FontSizeUtil
                                                              .CONTAINER_SIZE_100,
                                                          width: FontSizeUtil
                                                              .CONTAINER_SIZE_100,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey[300],
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    FontSizeUtil
                                                                        .CONTAINER_SIZE_20),
                                                          ),
                                                          child: Center(
                                                            child: Icon(
                                                              Icons.add_a_photo,
                                                              color: const Color
                                                                      .fromRGBO(
                                                                  27,
                                                                  86,
                                                                  148,
                                                                  1.0),
                                                              size: FontSizeUtil
                                                                  .CONTAINER_SIZE_50,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ),
                                              ),
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
                              vertical: FontSizeUtil.CONTAINER_SIZE_15,
                              horizontal: FontSizeUtil.CONTAINER_SIZE_50),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate() &&
                                  showVehicleNumberErrorMessage == false &&
                                  showVehicleTypeErrorMessage == false) {
                                _formKey.currentState!.save();
                                _addVehicleApi();
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
                            child: Text(Strings.ADD_VEHICLE_SUBMIT_BUTTON,
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

  _addVehicleApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    var apartmentId = prefs.getInt('apartmentId');
    var selectedFlatId = prefs.getString(Strings.FLATID);

    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          _isLoading = true;
          var responseType = 'addVehicle';
          String keyName = "vehiclesInp";
          String partURL = "${Constant.addVehicleURL}?apartmentId=$apartmentId";
          // NetworkUtils.filePostUploadNetWorkCall(partURL, keyName,
          //     _getJsonData().toString(), _selectedImages, this, responseType);
        } else {
          Utils.printLog("else called");
          Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
        }
      });
    });
  }

  _getJsonData() {
    final data = {
      '"vehicleType"': '"$_selectedFacilityType"',
      '"vehicleNumber"': '"$_enteredVehicleNumber"',
      '"userId"': userId,
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
        if (responseType == 'addVehicle') {
          UpdateUserModel responceModel =
              UpdateUserModel.fromJson(json.decode(response));
          if (responceModel.status == "success") {
            FocusScope.of(context).unfocus();
            var message = responceModel.message!;
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
    // widget.navigatorListener!.onNavigatorBackPressed();
  }
}
