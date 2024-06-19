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

class AddNewVehicle extends StatefulWidget {
  AddNewVehicle({super.key, required this.navigatorListener});

  NavigatorListener? navigatorListener;

  @override
  State<AddNewVehicle> createState() {
    return _AddNewVehicleState();
  }
}

class _AddNewVehicleState extends State<AddNewVehicle>
    with ApiListener, NavigatorListener {
  final _formKey = GlobalKey<FormState>();
  bool _isNetworkConnected = false, _isLoading = false;
  var _enteredVehicleNumber = '';
  int apartmentId = 0;
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
      final pickedFile =
          await imagePicker.pickImage(source: source, maxWidth: 600);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    }
  }

  bool showVehicleSlotErrorMessage = false;
  bool showVehicleTypeErrorMessage = false;
  bool showVehicleNumberErrorMessage = false;

  String? _selectedSlot;
  String? _selectedVehicleType;
  String? _selectedCategory;

  final vehicleType = ['2 Wheeler', '3 Wheeler', '4 Wheeler'];
  final slots = ['B-101', 'B-102', 'B-103'];
  Color _containerBorderColor1 = Colors.white; // Added this line
  Color _boxShadowColor1 = const Color.fromARGB(255, 100, 100, 100);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Widget content = InkWell(
      onTap: _takePicture,
      child: Container(
        margin: EdgeInsets.only(
            right: FontSizeUtil.SIZE_10, top: FontSizeUtil.SIZE_10),
        height: 100,
        width: 100,
        decoration: AppStyles.decoration(context),
        child: Center(
          child: Image.asset(
            'assets/images/Vector-1.png',
            height: 50,
            width: 50,
            color: const Color.fromRGBO(27, 86, 148, 1.0),
          ),
        ),
      ),
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Container(
          margin: EdgeInsets.only(top: FontSizeUtil.SIZE_10),
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
            title: Strings.ADD_VEHICLE_HEADER,
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
                        SizedBox(height: FontSizeUtil.PADDING_HEIGHT_10),
                        Card(
                          margin:
                              EdgeInsets.all(FontSizeUtil.PADDING_HEIGHT_10),
                          shadowColor: Colors.blueGrey,
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
                                              CrossAxisAlignment.center,
                                          children: [
                                            content,
                                            SizedBox(
                                                height: FontSizeUtil
                                                    .PADDING_HEIGHT_10),
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
                                                        .VEHICLE_NUMBER_LABEL,
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
                                                          FilteringTextInputFormatter.deny(Strings.EMOJI_DENY_REGEX)
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
                                                              .VEHICLE_NUMBER_PLACEHOLDER,
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
                                                  Strings
                                                      .VEHICLE_NUMBER_ERRORMESSAGE,
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
                                                      .VEHICLE_TYPE_LABEL,
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
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
                                                          _selectedVehicleType,
                                                      items: vehicleType
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
                                                            _selectedVehicleType =
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
          NetworkUtils.filePostUploadNetWorkCall(partURL, keyName,
              _getJsonData().toString(), _selectedImage, this, responseType);
        } else {
          Utils.printLog("else called");
          Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
        }
      });
    });
  }

  _getJsonData() {
    final data = {
      '"vehicleType"': '"$_selectedVehicleType"',
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
    widget.navigatorListener!.onNavigatorBackPressed();
  }
}
