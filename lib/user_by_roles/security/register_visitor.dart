import 'dart:convert';
import 'dart:io';

import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/push_notificaation_key.dart';
import 'package:SMP/contants/register_vis.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/appartment_data_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/select_details/block_list.dart';
import 'package:SMP/user_by_roles/admin/select_details/flat_list.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:SMP/components/dropdown/gender_dropdown.dart';
import 'package:SMP/components/dropdown/text_form_field.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/widget/loader.dart';
import 'package:SMP/widget/text_label.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/view_model/flat_view_model.dart';
import 'package:SMP/view_model/floor_view_model.dart';
import 'package:SMP/view_model/smp_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:SMP/widget/footers.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../presenter/flat_data_listener.dart';
import '../../utils/size_utility.dart';

class RegisterVisitorBySecurity extends StatefulWidget {
  const RegisterVisitorBySecurity({super.key});

  @override
  State<RegisterVisitorBySecurity> createState() {
    return _RegisterVisitorBySecurityState();
  }
}

class _RegisterVisitorBySecurityState extends State<RegisterVisitorBySecurity>
    with
        ApiListener,
        AppartmentDataListener,
        FlatDataListener,
        NavigatorListener {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  var _enteredMobile = '';
  var _enteredGuestName = '';

  var _mobileController = TextEditingController();
  var _userNameController = TextEditingController();

  var _purposeController = TextEditingController();

  bool _isNetworkConnected = false, _isLoading = false;
  var _enteredVisitorCount = '';
  int _counter = 1;

  File? _selectedImage;

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

  String _selectedOwner = '';

  int? apartmentId;
  String? _countErrorMessage;

  String userDeviceId = '';
  String userownerOrTenantDeviceId = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    _getApartmentId();

    setupPushNotification();
  }

  void setupPushNotification() async {
    final fcm = FirebaseMessaging.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apartId = prefs.getInt('apartmentId');

    await fcm.requestPermission();
    final token = await fcm.getToken();

    setState(() {
      userDeviceId = token!;
      apartmentId = apartId!;
    });
    print(token);
  }

  int? selectedApartmentId;
  int? selectedBlockId;
  int? selectedFloorId;
  int? selectedFlatId;

  String? selectedApartmentName;
  String? selectedBlockName;
  String? selectedFloorName;
  String? selectedFlatName;
  String? selectedUserName;
  int? selectedUserId = 0;
  int? apartId;

  int? blockCount;

  Future<void> _getApartmentId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      apartId = prefs.getInt('apartmentId');
      blockCount = prefs.getInt('blockCount');
      print("Block Count $blockCount");
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final genders = ['Male', 'Female', 'Other'];

  final purpose = ['Daily-Help', 'Visitor ', 'Delivery', 'Others'];

  String? _enteredPurposeToMeet;

  String? _selectedPurpose;

  void handlePurposeChange(String? selectedPurpose) {
    setState(() {
      _selectedPurpose = selectedPurpose;
      _enteredPurposeToMeet = null;
    });
  }

  String? _guestNameErrorMessage;

  String? _guestOtherPurposeErrorMessage;

  String? _mobileErrorMessage;

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
            right:  FontSizeUtil.SIZE_08,
            child: GestureDetector(
              onTap: _takePicture,
              child: Container(
                padding:  EdgeInsets.all( FontSizeUtil.SIZE_08),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(
                        38, 105, 177, 1) // Change the color as needed
                    ),
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
          borderRadius: BorderRadius.circular( FontSizeUtil.CONTAINER_SIZE_50),
          child: Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      );
    }

    TextStyle headerPlaceHolder = TextStyle(
        fontFamily: 'Roboto',
        fontSize: MediaQuery.of(context).size.width * 0.04,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        color: const Color.fromARGB(181, 27, 85, 148));

    TextStyle headerLeftTitle = TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.04,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      color: const Color(0xff1B5694),
    );



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
            title: Strings.REGISTER_VISITOR_HEADER,
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
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 255, 255, 255),
                      Color.fromARGB(255, 255, 255, 255),
                      Color.fromARGB(255, 255, 255, 255),
                      Color.fromARGB(255, 255, 255, 255),
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  // padding: const EdgeInsets.symmetric(b),
                  child: Column(
                    children: <Widget>[
                       SizedBox(height: FontSizeUtil.CONTAINER_SIZE_20),
                      Container(
                        height:  FontSizeUtil.CONTAINER_SIZE_100,
                        width:  FontSizeUtil.CONTAINER_SIZE_100,
                        alignment: Alignment.center,
                        child: content,
                      ),
                       SizedBox(height:  FontSizeUtil.SIZE_15),

                      Card(
                        margin: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_15),
                        shadowColor: Colors.blueGrey,
                        child: Container(
                          decoration: AppStyles.decoration(context),
                          child: Padding(
                            padding: EdgeInsets.all( FontSizeUtil.SIZE_08),
                            child: Form(
                              key: _formKey,
                              child: Table(
                                children: <TableRow>[
                                  TableRow(
                                    children: <Widget>[
                                      const TableCell(
                                        child: CustomTextLabel(
                                          labelText: Strings.VISITOR_MOBILE,
                                          manditory: "*",
                                        ),
                                      ),
                                      TableCell(
                                        child: Column(
                                          children: [
                                            CustomTextField(
                                              controller: _mobileController,
                                              scrollPadding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                        .viewInsets
                                                        .bottom *
                                                    1,
                                              ),
                                              textInputAction:
                                                  TextInputAction.next,
                                              inputFormatter: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                LengthLimitingTextInputFormatter(
                                                    10)
                                              ],
                                              keyboardType: TextInputType.number,
                                              hintText: Strings.VISITOR_MOBILE_HINT,
                                              onChanged: (value) {
                                                String? validationMessage;

                                                if (value!.isNotEmpty) {
                                                  const mobilePattern =
                                                      r'^[0-9]{10}$';
                                                  final isValidMobile =
                                                      RegExp(mobilePattern)
                                                          .hasMatch(value);

                                                  if (!isValidMobile) {
                                                    validationMessage =
                                                        Strings.VISITOR_MOBILE_ERROR_TEXT;
                                                  }
                                                }

                                                if (validationMessage != null) {
                                                  setState(() {
                                                    _mobileErrorMessage =
                                                        validationMessage;
                                                  });
                                                } else {
                                                  setState(() {
                                                    _mobileErrorMessage = null;
                                                  });
                                                }
                                              },
                                              validator: (value) {
                                                String? validationMessage;

                                                if (value == null ||
                                                    value.isEmpty) {
                                                  setState(() {
                                                    _mobileErrorMessage =
                                                        Strings.VISITOR_MOBILE_ERROR_TEXT1;
                                                  });
                                                } else if (value!.isNotEmpty) {
                                                  const mobilePattern =
                                                      r'^[0-9]{10}$';
                                                  final isValidMobile =
                                                      RegExp(mobilePattern)
                                                          .hasMatch(value);

                                                  if (!isValidMobile) {
                                                    _mobileErrorMessage =
                                                        Strings.VISITOR_MOBILE_ERROR_TEXT;
                                                  }
                                                } else {
                                                  setState(() {
                                                    _mobileErrorMessage = null;
                                                  });
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                _enteredMobile = value!;
                                              },
                                            ),
                                            if (_mobileErrorMessage != null)
                                              Align(
                                                alignment: Alignment.centerLeft,
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
                                      const TableCell(
                                        child: CustomTextLabel(
                                          labelText: Strings.VISITOR_NAME_TEXT,
                                          manditory: "*",
                                        ),
                                      ),
                                      TableCell(
                                        child: Column(
                                          children: [
                                            CustomTextField(
                                              controller: _userNameController,
                                              scrollPadding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                        .viewInsets
                                                        .bottom *
                                                    1,
                                              ),
                                              textInputAction:
                                                  TextInputAction.next,

                                              inputFormatter: [
                                                FilteringTextInputFormatter.allow(
                                                  RegExp(r"[a-zA-Z,#0-9]+|\s"),
                                                ),
                                                LengthLimitingTextInputFormatter(
                                                    45)
                                              ],
                                              keyboardType: TextInputType.name,
                                              hintText: Strings.VISITOR_NAME_HINT,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  setState(() {
                                                    _guestNameErrorMessage =
                                                        Strings.VISITOR_NAME_ERROR_TEXT;
                                                  });
                                                } else {
                                                  setState(() {
                                                    _guestNameErrorMessage = null;
                                                  });
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  setState(() {
                                                    _guestNameErrorMessage =
                                                       Strings.VISITOR_NAME_ERROR_TEXT;
                                                  });
                                                } else {
                                                  setState(() {
                                                    _guestNameErrorMessage = null;
                                                  });
                                                }
                                              },
                                              onSaved: (value) {
                                                _enteredGuestName = value!;
                                              },
                                            ),
                                            if (_guestNameErrorMessage != null)
                                              Align(
                                                alignment: Alignment.centerLeft,
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
                                          padding: EdgeInsets.only(top: FontSizeUtil.CONTAINER_SIZE_18),
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                    text: Strings.VISITOR_PURPOSE_TEXT,
                                                    style: headerLeftTitle),
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
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 0),
                                          child: DropdownWidget(
                                            value:_selectedPurpose,
                                            genders: purpose,
                                            placeholder: Strings.VISITOR_PURPOSE_HINT,
                                            onGenderChanged: handlePurposeChange,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: <Widget>[
                                      TableCell(
                                        child: Visibility(
                                          visible: _selectedPurpose == Strings.OTHER_PURPOSE,
                                          child: Padding(
                                            padding:
                                                 EdgeInsets.only(top: FontSizeUtil.CONTAINER_SIZE_18),
                                            child: Text(Strings.OTHER_PURPOSE_TEXT,
                                                style: headerLeftTitle),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Visibility(
                                          visible: _selectedPurpose == Strings.OTHER_PURPOSE,
                                          maintainState: true,
                                          maintainAnimation: true,
                                          child: Padding(
                                            padding: EdgeInsets.all(FontSizeUtil.SIZE_02),
                                            child: Column(
                                              children: [
                                                TextFormField(
                                                  scrollPadding: EdgeInsets.only(
                                                      bottom:
                                                          MediaQuery.of(context)
                                                                  .viewInsets
                                                                  .bottom *
                                                              1.15),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                      RegExp(
                                                          r"[a-zA-Z,#0-9]+|\s"),
                                                    ),
                                                    LengthLimitingTextInputFormatter(
                                                        45)
                                                  ],
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        Strings.OTHER_PURPOSE_HINT,
                                                    hintStyle: headerPlaceHolder,
                                                  ),
                                                  style:
                                                      AppStyles.heading1(context),
                                                  onSaved: (value) {
                                                    _enteredPurposeToMeet =
                                                        value!;
                                                  },
                                                ),
                                                if (_guestOtherPurposeErrorMessage !=
                                                    null)
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      _guestOtherPurposeErrorMessage!,
                                                      style: const TextStyle(
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
                                  if (blockCount != null && blockCount! > 2)
                                    TableRow(
                                      children: <Widget>[
                                        TableCell(
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(top: FontSizeUtil.CONTAINER_SIZE_18),
                                            child: Text(Strings.BLOCK_TEXT,
                                                style: headerLeftTitle),
                                          ),
                                        ),
                                        TableCell(
                                          child: GestureDetector(
                                            onTap: () async {
                                              FocusScope.of(context).unfocus();

                                              setState(() {
                                                selectedFlatId = 0;
                                                selectedFlatName = null;
                                                selectedUserId = 0;
                                                selectedUserName = null;
                                              });

                                              Navigator.of(context).push(
                                                  createRoute(BlockList(
                                                      apartmentId: apartId!,
                                                      dataListener: this)));
                                            },
                                            child: Container(
                                              decoration:  BoxDecoration(
                                                color: Colors.white,
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.grey,
                                                    // Adjust color as needed
                                                    width:
                                                    FontSizeUtil.SIZE_01, // Adjust thickness as needed
                                                  ),
                                                ),
                                              ),
                                              height: FontSizeUtil.CONTAINER_SIZE_50,
                                              width: double.infinity,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets
                                                            .symmetric(
                                                        vertical:FontSizeUtil.CONTAINER_SIZE_10),
                                                    child: selectedBlockName !=
                                                            null
                                                        ? Text(
                                                            selectedBlockName!,
                                                            style: AppStyles
                                                                .heading1(
                                                                    context),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )
                                                        : Text(
                                                            Strings.BLOCK_TEXT_PLACEHOLDER,
                                                            style:
                                                                headerPlaceHolder,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: FontSizeUtil.SIZE_08),
                                                    child:const Icon(
                                                      Icons.arrow_forward,
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
                                          padding: EdgeInsets.only(top: FontSizeUtil.CONTAINER_SIZE_18),
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                    text: Strings.FLAT_TEXT,
                                                    style: headerLeftTitle),
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
                                          // Text("Flat Number",
                                          //     style: headerLeftTitle),
                                        ),
                                      ),
                                      TableCell(
                                        child: GestureDetector(
                                          onTap: () async {
                                            FocusScope.of(context).unfocus();

                                            if (selectedBlockId != null &&
                                                selectedBlockId != 0) {
                                              Navigator.of(context).push(
                                                  createRoute(FlatList(
                                                      apartmentId: apartId!,
                                                      blockId: selectedBlockId!,
                                                      dataListener: this)));
                                            } else {
                                              Navigator.of(context).push(
                                                  createRoute(FlatList(
                                                      apartmentId: apartId!,
                                                      blockId: 0,
                                                      dataListener: this)));
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 0.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.grey,
                                                    // Adjust color as needed
                                                    width:
                                                    FontSizeUtil.SIZE_01, // Adjust thickness as needed
                                                  ),
                                                ),
                                              ),
                                              height: FontSizeUtil.CONTAINER_SIZE_50,
                                              width: double.infinity,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets
                                                            .symmetric(
                                                        vertical: FontSizeUtil.CONTAINER_SIZE_10),
                                                    child: selectedFlatName !=
                                                            null
                                                        ? Text(
                                                            selectedFlatName!,
                                                            style: AppStyles
                                                                .heading1(
                                                                    context),
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                          )
                                                        : Text(
                                                            Strings.FLAT_TEXT_PLACEHOLDER,
                                                            style:
                                                                headerPlaceHolder,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                          ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right:FontSizeUtil.SIZE_08),
                                                    child:const Icon(
                                                      Icons.arrow_forward,
                                                    ),
                                                  ),
                                                ],
                                              ),
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
                                          padding:  EdgeInsets.only(top: FontSizeUtil.CONTAINER_SIZE_18),
                                          child: Text(Strings.RESIDENT_NAME,
                                              style: headerLeftTitle),
                                        ),
                                      ),
                                      TableCell(
                                        child: Column(
                                          children: [
                                            Container(
                                              margin:
                                                   EdgeInsets.only(top: FontSizeUtil.CONTAINER_SIZE_15),
                                              child: selectedUserName != null
                                                  ? Align(
                                                alignment:
                                                Alignment.topLeft,
                                                    child: Padding(
                                                        padding:
                                                             EdgeInsets.all(
                                                                FontSizeUtil.SIZE_02),
                                                        child: Text(
                                                            selectedUserName!,
                                                            style: headerLeftTitle),
                                                      ),
                                                  )
                                                  : Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(Strings.RESIDENT_NAME,
                                                          style:
                                                              headerPlaceHolder),
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
                                          padding: EdgeInsets.only(
                                            top:FontSizeUtil.CONTAINER_SIZE_20,
                                          ),
                                          child:const CustomTextLabel(
                                            labelText: Strings.NUMBER_OF_GUEST_TEXT,
                                            manditory: "*",
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: FontSizeUtil.CONTAINER_SIZE_10, bottom: FontSizeUtil.SIZE_05),
                                          child: Column(
                                            children: [
                                              const Divider(
                                                color: Colors.black,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: FontSizeUtil.SIZE_08),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      height:FontSizeUtil.CONTAINER_HEGIHT_SIZE,
                                                      width:FontSizeUtil.CONTAINER_WIDTH_SIZE,
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
                                                        style: TextStyle(
                                                            fontSize: FontSizeUtil.CONTAINER_SIZE_16),
                                                      ),
                                                    ),
                                                    Container(
                                                      height:FontSizeUtil.CONTAINER_HEGIHT_SIZE,
                                                      width:FontSizeUtil.CONTAINER_WIDTH_SIZE,
                                                      decoration:
                                                          AppStyles.decoration(
                                                              context),
                                                      child: IconButton(
                                                        icon:
                                                            const Icon(Icons.add),
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
                        padding: EdgeInsets.symmetric(
                            vertical: FontSizeUtil.CONTAINER_SIZE_10, horizontal: FontSizeUtil.CONTAINER_SIZE_50),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate() &&
                                _guestNameErrorMessage == null &&
                                _mobileErrorMessage == null &&
                                _countErrorMessage == null) {
                              _formKey.currentState!.save();
                              print("Guest Name");
                              _formKey.currentState!.save();

                              var purpose = '';
                              if (_selectedPurpose != null) {
                                if (_selectedPurpose == Strings.OTHER_PURPOSE) {
                                  purpose = _enteredPurposeToMeet!;
                                } else {
                                  purpose = _selectedPurpose!;
                                }
                              }
                              Utils.printLog("selectedUserId==$selectedUserId");

                              if (selectedUserId != 0) {
                                _addGuestApi(
                                  purpose,
                                );
                              } else {
                                errorAlert(
                                  context,
                                  Strings.RESIDENT_NOT_AVAILBLE,
                                );
                              }
                            } else {
                              errorAlert(
                                context,
                                Strings.MANDATORY_FIELD_TEXT,
                              );
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
                          child: Text(
                            Strings.REGISTER_VISITOR_BUTTON_TEXT,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.of(context).size.width * 0.04,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: FontSizeUtil.CONTAINER_SIZE_50),
                    ],
                  ),
                ),
              ),
              if (_isLoading) const Positioned(child: LoadingDialog()),
              const FooterScreen()
            ],
          ),
        ),
      ),
    );
  }

  String selectedPurpose = '';

  _addGuestApi(
    purpose1,
  ) async {
    setState(() {
      selectedPurpose = purpose1;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final id = prefs.getInt('id');
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          _isLoading = true;
          var responseType = 'login';
          String keyName = "visitorData";

          String partURL =
              '${Constant.addVisitorURL}?securityId=$id&apartmentId=$apartId';

          NetworkUtils.filePostUploadNetWorkCall(
              partURL,
              keyName,
              _getJsonData(
                purpose1,
              ).toString(),
              _selectedImage,
              this,
              responseType);
        }
      });
    });
  }

  _getJsonData(
    purpose1,
  ) {
    final data = {
      '"name"': '"$_enteredGuestName"',
      '"purpose"': '"$purpose1"',
      '"numberOfVisitor"': '"$_counter"',
      '"mobile"': '"$_enteredMobile"',
      '"flatId"': selectedFlatId,
      '"apartmentId"': apartId,
      '"residentId"': selectedUserId,

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
  onSuccess(responses, String responseType) async {
    try {
      Utils.printLog("responseType :: $responseType responses::$responses");

      setState(() async {
        _isLoading = false;
        if (responseType == 'login') {
          final res = json.decode(responses);
          final message = res['message'];

          final visitorId = res['value'];


          successDialogWithListner(
              context, message, const RegisterVisitorBySecurity(), this);
          Utils.printLog("Resident Device ID $userownerOrTenantDeviceId");
          Utils.printLog("Security Device ID $userDeviceId");

          // _pushNotificationNetworkCall(visitorId);

          setState(() {
            _isLoading = false;
            Utils.printLog("inside state  state isloading::$_isLoading");
          });
        } else if (responseType == 'push') {
          _isLoading = false;
          Utils.printLog("push notification responces $responses");
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Utils.printLog("Error text === $responses");
    }
  }

  @override
  onDataClicked(id, name, available, dataType) {
    setState(() {
      if (dataType == Strings.APPARTMENT_NAME) {
        selectedApartmentName = name;
        selectedApartmentId = id;
      }
      if (dataType == Strings.BLOCK_NAME) {
        selectedBlockName = name;
        selectedBlockId = id;
      }
      if (dataType == Strings.FLOOR_NAME) {
        selectedFloorName = name;
        selectedFloorId = id;
      }
    });
  }

  @override
  onFlatDataClicked(flatId, flatNumber, userId, username, deviceId) {
    Utils.printLog("SELECTED USERNAME $username");
    setState(() {
      selectedFlatId = flatId;
      selectedFlatName = flatNumber;
      selectedUserId = userId;
      selectedUserName =
          username.isNotEmpty ? username : Strings.SELECTED_USER_LABEL;

      userownerOrTenantDeviceId = deviceId;
    });
  }

  @override
  onNavigatorBackPressed() {
    setState(() {
      _selectedImage =null;
      _mobileController.text = '';
      _userNameController.text = '';
      selectedFlatId = -1;
      selectedFlatName = 'Select Flat';
      selectedUserId = -1;
      selectedUserName = '';
      userownerOrTenantDeviceId = '';
      _counter = 1;
      handlePurposeChange(purpose[0]);
    });
  }
}
