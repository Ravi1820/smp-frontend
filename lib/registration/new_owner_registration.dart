import 'dart:convert';
import 'dart:io';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/model/new_owner_registration_model.dart';

import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/appartment_data_listener.dart';
import 'package:SMP/registration/waiting_for_approval.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/select_details/apartment_list.dart';
import 'package:SMP/user_by_roles/admin/select_details/block_list.dart';
import 'package:SMP/user_by_roles/admin/select_details/flat_list.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/view_model/flat_view_model.dart';
import 'package:SMP/view_model/floor_view_model.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:SMP/contants/error_alert.dart';

import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:SMP/widget/footers.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../presenter/flat_data_listener.dart';
import '../utils/size_utility.dart';

class NewOwnerRegistrationScreen extends StatefulWidget {
  const NewOwnerRegistrationScreen({
    super.key,
    required this.emailId,
  });

  final String emailId;

  @override
  State<NewOwnerRegistrationScreen> createState() {
    return _NewOwnerRegistrationScreenState();
  }
}

class _NewOwnerRegistrationScreenState extends State<NewOwnerRegistrationScreen>
    with ApiListener, AppartmentDataListener, FlatDataListener {
  bool showErrorMessage = false;
  final _formKey = GlobalKey<FormState>();
  bool _isNetworkConnected = false, _isLoading = false;
  int _blockCount = 3;

  var _enteredEmail = '';
  var _enteredMobile = '';
  var _enteredfullName = '';

  List blocklist = [];
  List floorList = [];
  List flatModel = [];

  String? showPhoneErrorMessage;
  String? showFlatErrorMessage;
  String? showApartmentErrorMessage;

  String? showBlocErrorMessage;
  bool showNameErrorMessage = false;
  bool showFullNameErrorMessage = false;
  bool showPinCodeErrorMessage = false;

  bool showAddressErrorMessage = false;

  bool showEmailErrorMessage = false;

  var userRole = '';

  final _adminNameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _fullNameFocusNode = FocusNode();

  final genders = ['Male', 'Female', 'Other'];

  String? radioButtonItem = 'Owner';

  int id = 1;

  File? _selectedImage;

  File? _selectedIDProofImage;

  int? selectedApartmentId;
  int? selectedBlockId;
  int? selectedFloorId;
  int? selectedFlatId;

  String? selectedApartmentName;
  String? selectedBlockName;
  String? selectedFloorName;
  String? selectedFlatName;

  final TextEditingController _emailController = TextEditingController();

  Future<void> _getApartmentId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _emailController.text = widget.emailId;
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
          _selectedIDProofImage = File(pickedFile.path);
        });
      }
    }
  }

  void _takeProfilePicture() async {
    showDialog<ImageSource>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.only(top: 10.0, right: 10.0),
        content: Container(
          margin: const EdgeInsets.only(left: 0.0, right: 0.0),
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                  top: 18.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Choose image source',
                        style: AppStyles.heading(context),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                      width: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: const BorderSide(
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 0,
                              ),
                            ),
                            onPressed: () =>
                                Navigator.pop(context, ImageSource.gallery),
                            child: const Text("Gallery"),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: const BorderSide(
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 0,
                              ),
                            ),
                            onPressed: () =>
                                Navigator.pop(context, ImageSource.camera),
                            child: const Text("Camera"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                      width: 5.0,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.close, size: 25, color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((ImageSource? source) async {
      if (source == null) return;
      final imagePicker = ImagePicker();
      final pickedFile =
          await imagePicker.pickImage(source: source, maxWidth: 600);
      if (pickedFile == null) {
        return;
      }
      setState(() => _selectedImage = File(pickedFile.path));
    });
  }

  @override
  void dispose() {
    _adminNameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _fullNameFocusNode.dispose();
    super.dispose();
  }

  bool isValidEmail(String email) {
    // Define a regular expression pattern for a valid email address
    const pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  List<FloorViewModel> availableFloors = [];
  List<FlatViewModel> availableFlats = [];
  String userDeviceId = '';

  @override
  void initState() {
    super.initState();
    _getApartmentId();
  }

  List apartmentList = [];

  List<String> radioOptions = [
    "Owner",
    'Tenant',
  ];

  String getRadioText(int value) {
    if (value >= 1 && value <= radioOptions.length) {
      return radioOptions[value - 1];
    }
    return '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(context) {
    Widget content = InkWell(
      onTap: _takePicture,
      child: Container(
        margin: const EdgeInsets.only(right: 10, top: 10),
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

    if (_selectedIDProofImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 233, 162, 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                _selectedIDProofImage!,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }

    Widget profileImage = GestureDetector(
      onTap: _takeProfilePicture,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(alignment: Alignment.center, child: const AvatarScreen()),
          Positioned(
            bottom: 7.0,
            right: 8.0,
            child: GestureDetector(
              onTap: _takeProfilePicture,
              child: Container(
                padding: const EdgeInsets.all(8.0),
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
    const double verticalHeightBetweenTextBoxAndNextLabel = 15;

    if (_selectedImage != null) {
      profileImage = GestureDetector(
        onTap: _takeProfilePicture,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AbsorbPointer(
        absorbing: _isLoading,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
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
                        child: Padding(
                          padding: const EdgeInsets.only(top: 48.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          alignment: Alignment.center,
                                          child: profileImage,
                                        ),
                                      ),
                                      // ,
                                      const SizedBox(
                                          height:
                                              verticalHeightBetweenTextBoxAndNextLabel),
                                      const Text(
                                        'Choose Apartment',
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(27, 86, 148, 1.0),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Stack(
                                        alignment: Alignment.centerLeft,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              if (_blockCount > 2) {
                                                _changeApartmentData(
                                                    Strings.APPARTMENT_NAME,
                                                    "");
                                              } else {
                                                _changeApartmentData("",
                                                    Strings.APPARTMENT_NAME);
                                              }

                                              Navigator.of(context).push(
                                                  createRoute(AprtmentList(
                                                      dataListener: this)));
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Color.fromARGB(
                                                          255, 100, 100, 100),
                                                      blurRadius: 6,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                height: 50,
                                                width: double.infinity,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(10.0),
                                                      child:
                                                          selectedApartmentName !=
                                                                  null
                                                              ? Text(
                                                                  selectedApartmentName!,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          16),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                )
                                                              : const Text(
                                                                  'Select Apartment',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 8.0),
                                                      child: Icon(
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
                                      const SizedBox(
                                          height:
                                              verticalHeightBetweenTextBoxAndNextLabel),

                                      if (_blockCount > 2)
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Block Number ',
                                                style: TextStyle(
                                                  color: const Color.fromRGBO(
                                                      27, 86, 148, 1.0),
                                                  fontSize: FontSizeUtil
                                                      .LABEL_TEXT_SIZE,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '*',
                                                style: TextStyle(
                                                  color: const Color.fromRGBO(
                                                      255, 0, 0, 1),
                                                  fontSize: FontSizeUtil
                                                      .LABEL_TEXT_SIZE,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (_blockCount > 2)
                                        const SizedBox(
                                            height:
                                                verticalHeightBetweenTextBoxAndNextLabel),
                                      if (_blockCount > 2)
                                        Stack(
                                          alignment: Alignment.centerLeft,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                _changeApartmentData(
                                                    "", Strings.BLOCK_NAME);

                                                Utils.printLog(
                                                    "BlockAPP $selectedApartmentId");
                                                if (selectedApartmentId !=
                                                    null) {
                                                  Navigator.of(context).push(
                                                    createRoute(
                                                      BlockList(
                                                          apartmentId:
                                                              selectedApartmentId!,
                                                          dataListener: this),
                                                    ),
                                                  );
                                                } else {
                                                  Utils.showToast(
                                                      "Please select any apartment");
                                                }
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Color.fromARGB(
                                                            255, 100, 100, 100),
                                                        blurRadius: 6,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  height: 50,
                                                  width: double.infinity,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child:
                                                            selectedBlockName !=
                                                                    null
                                                                ? Text(
                                                                    selectedBlockName!,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            16),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  )
                                                                : const Text(
                                                                    Strings
                                                                        .BLOCK_LABEL,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                  ),
                                                      ),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 8.0),
                                                        child: Icon(
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
                                      if (_blockCount > 2)
                                        if (showBlocErrorMessage != null)
                                          Text(
                                            showBlocErrorMessage!,
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 15),
                                          ),
                                      if (_blockCount > 2)
                                        const SizedBox(
                                            height:
                                                verticalHeightBetweenTextBoxAndNextLabel),
                                      // if (blockAvailable != 0)
                                      //   RichText(
                                      //     text: TextSpan(
                                      //       children: [
                                      //         TextSpan(
                                      //           text: 'Floor Number ',
                                      //           style: TextStyle(
                                      //             color: const Color.fromRGBO(
                                      //                 27, 86, 148, 1.0),
                                      //             fontSize: FontSizeUtil
                                      //                 .LABEL_TEXT_SIZE,
                                      //             fontWeight: FontWeight.bold,
                                      //           ),
                                      //         ),
                                      //         TextSpan(
                                      //           text: '*',
                                      //           style: TextStyle(
                                      //             color: const Color.fromRGBO(
                                      //                 255, 0, 0, 1),
                                      //             fontSize: FontSizeUtil
                                      //                 .LABEL_TEXT_SIZE,
                                      //             fontWeight: FontWeight.bold,
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // if (blockAvailable != 0)
                                      //   const SizedBox(
                                      //       height:
                                      //           verticalHeightBetweenTextBoxAndNextLabel),
                                      // if (blockAvailable != 0)
                                      //   Stack(
                                      //     alignment: Alignment.centerLeft,
                                      //     children: <Widget>[
                                      //       GestureDetector(
                                      //         onTap: () async {
                                      //           if (selectedApartmentId != null &&
                                      //               selectedBlockId != null) {
                                      //             Navigator.of(context).push(
                                      //                 createRoute(FloorList(
                                      //                     apartmentId:
                                      //                         selectedApartmentId!,
                                      //                     blockId:
                                      //                         selectedBlockId!,
                                      //                     dataListener: this)));
                                      //           } else {
                                      //             Navigator.of(context).push(
                                      //               createRoute(
                                      //                 FloorList(
                                      //                     apartmentId:
                                      //                         selectedApartmentId!,
                                      //                     blockId: 0,
                                      //                     dataListener: this),
                                      //               ),
                                      //             );

                                      //             // Utils.showToast(
                                      //             //     "Please select apartment and block");
                                      //           }
                                      //         },
                                      //         child: Padding(
                                      //           padding:
                                      //               const EdgeInsets.symmetric(
                                      //                   horizontal: 0.0),
                                      //           child: Container(
                                      //             decoration: BoxDecoration(
                                      //               color: Colors.white,
                                      //               borderRadius:
                                      //                   BorderRadius.circular(10),
                                      //               boxShadow: const [
                                      //                 BoxShadow(
                                      //                   color: Color.fromARGB(
                                      //                       255, 100, 100, 100),
                                      //                   blurRadius: 6,
                                      //                   offset: Offset(0, 2),
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //             height: 50,
                                      //             width: double.infinity,
                                      //             child: Row(
                                      //               mainAxisAlignment:
                                      //                   MainAxisAlignment
                                      //                       .spaceBetween,
                                      //               children: [
                                      //                 Padding(
                                      //                   padding:
                                      //                       const EdgeInsets.all(
                                      //                           10.0),
                                      //                   child:
                                      //                       selectedFloorName !=
                                      //                               null
                                      //                           ? Text(
                                      //                               selectedFloorName!,
                                      //                               style: const TextStyle(
                                      //                                   fontSize:
                                      //                                       16),
                                      //                               overflow:
                                      //                                   TextOverflow
                                      //                                       .ellipsis,
                                      //                             )
                                      //                           : const Text(
                                      //                               'Select Floor',
                                      //                               style: TextStyle(
                                      //                                   fontSize:
                                      //                                       16),
                                      //                               overflow:
                                      //                                   TextOverflow
                                      //                                       .ellipsis,
                                      //                             ),
                                      //                 ),
                                      //                 const Padding(
                                      //                   padding: EdgeInsets.only(
                                      //                       right: 8.0),
                                      //                   child: Icon(
                                      //                     Icons.arrow_forward,
                                      //                   ),
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // if (blockAvailable != 0)
                                      //   if (showBlocErrorMessage != null)
                                      //     Text(
                                      //       showBlocErrorMessage!,
                                      //       style: const TextStyle(
                                      //           color: Colors.red, fontSize: 15),
                                      //     ),
                                      // if (blockAvailable != 0)
                                      //   const SizedBox(
                                      //       height:
                                      //           verticalHeightBetweenTextBoxAndNextLabel),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Flat Number ',
                                              style: TextStyle(
                                                color: const Color.fromRGBO(
                                                    27, 86, 148, 1.0),
                                                fontSize: FontSizeUtil
                                                    .LABEL_TEXT_SIZE,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '*',
                                              style: TextStyle(
                                                color: const Color.fromRGBO(
                                                    255, 0, 0, 1),
                                                fontSize: FontSizeUtil
                                                    .LABEL_TEXT_SIZE,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                          height:
                                              verticalHeightBetweenTextBoxAndNextLabel),
                                      Stack(
                                        alignment: Alignment.centerLeft,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () async {
                                              if (selectedApartmentId != null &&
                                                  selectedBlockId != null &&
                                                  _blockCount > 2) {
                                                Navigator.of(context).push(
                                                    createRoute(FlatList(
                                                        apartmentId:
                                                            selectedApartmentId!,
                                                        blockId:
                                                            selectedBlockId!,
                                                        dataListener: this)));
                                              } else if (selectedApartmentId !=
                                                  null) {
                                                Navigator.of(context).push(
                                                    createRoute(FlatList(
                                                        apartmentId:
                                                            selectedApartmentId!,
                                                        blockId: 0,
                                                        dataListener: this)));
                                              } else {
                                                Utils.showToast(
                                                    "Please select any apartment");
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Color.fromARGB(
                                                          255, 100, 100, 100),
                                                      blurRadius: 6,
                                                      offset: Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                height: 50,
                                                width: double.infinity,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: selectedFlatName !=
                                                              null
                                                          ? Text(
                                                              selectedFlatName!,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          16),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            )
                                                          : Text(
                                                              Strings
                                                                  .FLAT_LABEL,
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 8.0),
                                                      child: Icon(
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
                                      if (showBlocErrorMessage != null)
                                        Text(
                                          showBlocErrorMessage!,
                                          style: const TextStyle(
                                              color: Colors.red, fontSize: 15),
                                        ),
                                      const SizedBox(
                                          height:
                                              verticalHeightBetweenTextBoxAndNextLabel),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Phone ',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    27, 86, 148, 1.0),
                                                fontSize: FontSizeUtil
                                                    .LABEL_TEXT_SIZE,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '*',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    255, 0, 0, 1),
                                                fontSize: FontSizeUtil
                                                    .LABEL_TEXT_SIZE,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                          height:
                                              verticalHeightBetweenTextBoxAndNextLabel),
                                      Stack(
                                        alignment: Alignment.centerLeft,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              _phoneFocusNode.requestFocus();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                                  .TEXT_FIELD_HEIGHT,
                                              child: Focus(
                                                focusNode: _phoneFocusNode,
                                                child: TextFormField(
                                                  scrollPadding:
                                                      EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                      context)
                                                                  .viewInsets
                                                                  .bottom *
                                                              1.15),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    //   FilteringTextInputFormatter.allow(
                                                    //       RegExp(r'[0-9]')),
                                                    // ],
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                    LengthLimitingTextInputFormatter(
                                                        10)
                                                    //   inputFormatters: [
                                                    //   FilteringTextInputFormatter
                                                    //       .digitsOnly,
                                                    //   LengthLimitingTextInputFormatter(
                                                    //       10)
                                                  ],
                                                  style: const TextStyle(
                                                      color: Colors.black87),
                                                  decoration:
                                                      const InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            top: 14),
                                                    prefixIcon: Icon(
                                                      Icons
                                                          .phone_android_rounded,
                                                      color: Color(0xff4d004d),
                                                    ),
                                                    hintText: 'Phone',
                                                    hintStyle: TextStyle(
                                                        color: Colors.black38),
                                                  ),
                                                  onChanged: (value) {
                                                    String? validationMessage;

                                                    if (value.isNotEmpty) {
                                                      const mobilePattern =
                                                          r'^[0-9]{10}$';
                                                      final isValidMobile =
                                                          RegExp(mobilePattern)
                                                              .hasMatch(value);

                                                      if (!isValidMobile) {
                                                        validationMessage =
                                                            'Please enter valid mobile number';
                                                      }
                                                    }

                                                    if (validationMessage !=
                                                        null) {
                                                      setState(() {
                                                        showPhoneErrorMessage =
                                                            validationMessage;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        showPhoneErrorMessage =
                                                            null;
                                                      });
                                                    }
                                                  },
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      setState(() {
                                                        showPhoneErrorMessage =
                                                            "Phone number cannot be empty";
                                                      });
                                                    } else if (value
                                                                .trim()
                                                                .length <=
                                                            9 ||
                                                        value.trim().length >
                                                            11) {
                                                      setState(() {
                                                        showPhoneErrorMessage =
                                                            "Phone number must be 10 digits";
                                                      });
                                                    } else {
                                                      setState(() {
                                                        showPhoneErrorMessage =
                                                            null;
                                                      });
                                                      return null;
                                                    }
                                                    return null;
                                                  },
                                                  onSaved: (value) {
                                                    _enteredMobile = value!;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (showPhoneErrorMessage != null)
                                        Text(
                                          showPhoneErrorMessage!,
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      const SizedBox(
                                          height:
                                              verticalHeightBetweenTextBoxAndNextLabel),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Full Name ',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    27, 86, 148, 1.0),
                                                fontSize: FontSizeUtil
                                                    .LABEL_TEXT_SIZE,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '*',
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    255, 0, 0, 1),
                                                fontSize: FontSizeUtil
                                                    .LABEL_TEXT_SIZE,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                          height:
                                              verticalHeightBetweenTextBoxAndNextLabel),
                                      Stack(
                                        alignment: Alignment.centerLeft,
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                      255, 100, 100, 100),
                                                  blurRadius: 6,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            height:
                                                FontSizeUtil.TEXT_FIELD_HEIGHT,
                                            child: TextFormField(
                                              scrollPadding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                          .viewInsets
                                                          .bottom *
                                                      1.15),
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(
                                                  RegExp(r"[a-zA-Z,#0-9]+|\s"),
                                                ),
                                              ],
                                              style: const TextStyle(
                                                  color: Colors.black87),
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.only(top: 14),
                                                prefixIcon: Icon(
                                                  Icons.roller_shades,
                                                  color: Color(0xff4d004d),
                                                ),
                                                hintText: 'Full Name ',
                                                hintStyle: TextStyle(
                                                    color: Colors.black38),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty ||
                                                    value.trim().length <= 1 ||
                                                    value.trim().length > 50) {
                                                  setState(() {
                                                    showFullNameErrorMessage =
                                                        true;
                                                  });
                                                } else {
                                                  setState(() {
                                                    showFullNameErrorMessage =
                                                        false;
                                                  });
                                                  return null;
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                if (value.trim().length <= 0 ||
                                                    value.trim().length > 50) {
                                                  setState(() {
                                                    showFullNameErrorMessage =
                                                        true;
                                                  });
                                                } else {
                                                  setState(() {
                                                    showFullNameErrorMessage =
                                                        false;
                                                  });
                                                  return null;
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                _enteredfullName = value!;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (showFullNameErrorMessage)
                                        const Text(
                                          'Name is required',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      const SizedBox(height: 10),
                                      const SizedBox(
                                          height:
                                              verticalHeightBetweenTextBoxAndNextLabel),

                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Email ',
                                              style: TextStyle(
                                                color: const Color.fromRGBO(
                                                    27, 86, 148, 1.0),
                                                fontSize: FontSizeUtil
                                                    .LABEL_TEXT_SIZE,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '*',
                                              style: TextStyle(
                                                color: const Color.fromRGBO(
                                                    255, 0, 0, 1),
                                                fontSize: FontSizeUtil
                                                    .LABEL_TEXT_SIZE,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                          height:
                                              verticalHeightBetweenTextBoxAndNextLabel),
                                      Stack(
                                        alignment: Alignment.centerLeft,
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color.fromARGB(
                                                      255, 100, 100, 100),
                                                  blurRadius: 6,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            height:
                                                FontSizeUtil.TEXT_FIELD_HEIGHT,
                                            child: TextFormField(
                                              scrollPadding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                          .viewInsets
                                                          .bottom *
                                                      1.15),
                                              controller: _emailController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              style: const TextStyle(
                                                  color: Colors.black87),
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.only(top: 14),
                                                prefixIcon: Icon(
                                                  Icons.mail,
                                                  color: Color(0xff4d004d),
                                                ),
                                                hintText: 'Email Id',
                                                hintStyle: TextStyle(
                                                    color: Colors.black38),
                                              ),
                                              onChanged: (value) {
                                                if (isValidEmail(value)) {
                                                  setState(() {
                                                    showEmailErrorMessage =
                                                        false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    showEmailErrorMessage =
                                                        true;
                                                  });
                                                }
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    !value.contains('@') ||
                                                    value.isEmpty ||
                                                    value.trim().length > 50) {
                                                  setState(() {
                                                    showEmailErrorMessage =
                                                        true;
                                                  });
                                                } else {
                                                  setState(() {
                                                    showEmailErrorMessage =
                                                        false;
                                                  });
                                                  return null;
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                _enteredEmail = value!;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (showEmailErrorMessage)
                                        const Text(
                                          'Please enter a valid emailId.',
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      const SizedBox(height: 10),

                                      const SizedBox(
                                          height:
                                              verticalHeightBetweenTextBoxAndNextLabel),

                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Select Role ',
                                              style: TextStyle(
                                                color: const Color.fromRGBO(
                                                    27, 86, 148, 1.0),
                                                fontSize: FontSizeUtil
                                                    .LABEL_TEXT_SIZE,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '*',
                                              style: TextStyle(
                                                color: const Color.fromRGBO(
                                                    255, 0, 0, 1),
                                                fontSize: FontSizeUtil
                                                    .LABEL_TEXT_SIZE,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, top: 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            for (int i = 1;
                                                i <= radioOptions.length;
                                                i++)
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    id = i;
                                                    radioButtonItem =
                                                        getRadioText(i);
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                      child: Radio(
                                                        value: i,
                                                        groupValue: id,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            id = i;
                                                            radioButtonItem =
                                                                getRadioText(i);
                                                          });
                                                          // getList();
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      getRadioText(i),
                                                      style: const TextStyle(
                                                          fontSize: 13),
                                                    ),
                                                    const SizedBox(width: 20)
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      if (radioButtonItem != "Owner")
                                        Container(
                                          child: content,
                                        ),
                                      // : Container(),
                                      if (radioButtonItem != "Owner")
                                        const SizedBox(height: 5),
                                      if (radioButtonItem != "Owner")
                                        RichText(
                                          text: const TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Photo Id Proof ',
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      27, 86, 148, 1.0),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 25, horizontal: 50),
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        if (showFullNameErrorMessage == false &&
                                            showEmailErrorMessage == false &&
                                            showPhoneErrorMessage == null &&
                                            selectedFlatId != null) {
                                          _formKey.currentState!.save();
                                          print("Success");

                                          _addTenantResidentApi();
                                        } else {
                                          errorAlert(
                                            context,
                                            Strings.MANDATORY_FIELD_TEXT,
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
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: const EdgeInsets.all(15),
                                    ),
                                    child: const Text(
                                      Strings.ADD_VEHICLE_SUBMIT_BUTTON,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 80)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    child: FooterScreen(),
                  ),
                ],
              ),
              if (_isLoading) const Positioned(child: LoadingDialog()),
            ],
          ),
        ),
      ),
    );
  }

  _changeApartmentData(var appartmentName, var blockName) {
    setState(() {
      Utils.printLog("apparment==$appartmentName  blockName==$blockName");
      if (appartmentName.isNotEmpty) {
        Utils.printLog("apparment==$appartmentName");
        selectedBlockName = Strings.BLOCK_LABEL;
        selectedFlatName = Strings.FLOOR_LABEL;
      } else if (blockName.isNotEmpty) {
        Utils.printLog("blockName==$blockName");
        selectedFlatName = Strings.FLOOR_LABEL;
      }
    });
  }

  _addTenantResidentApi() async {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;

        if (_isNetworkConnected) {
          _isLoading = true;
          String responseType = "login";
          String keyName = "userData";
          String registerTenantUrl =
              '${Constant.registerTenantURL}?apartmentId=$selectedApartmentId';
          NetworkUtils.fileMultipleImagePostUploadNetWorkCall(
              registerTenantUrl,
              keyName,
              _getJsonData().toString(),
              _selectedImage,
              _selectedIDProofImage,
              this,
              responseType);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  _getJsonData() {
    final data = {
      '"flatId"': selectedFlatId,
      '"mobile"': '"$_enteredMobile"',
      '"fullName"': '"$_enteredfullName"',
      '"email"': '"$_enteredEmail"',
      '"role"': '"$radioButtonItem"',
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      Utils.printLog("Success text === $response");
      setState(() {
        if (responseType == 'login') {
          NewOwnerRegistrationModel responceModel =
              NewOwnerRegistrationModel.fromJson(json.decode(response));

          if (responceModel.status == "error") {
            Utils.showErrorToast(responceModel.message!);
            _isLoading = false;
          } else {
            prefs.setString(Strings.CURRENT_DATE_TIME, responceModel.date!);
            prefs.setInt(Strings.NEW_OWMER_TENNANT_ID, responceModel.userId!);
            _isLoading = false;

            successDialog(
                context,
                responceModel.message!,
                WaitingForApprovalScreen(
                  isFirstLogin: false,
                ));
          }
        }
      });
    } catch (error) {
      Utils.printLog("Error text === $response");
    }
  }

  @override
  onBackPressed() {
    _getApartmentId();
  }

  @override
  onDataClicked(id, name, blockCount, dataType) {
    setState(() {
      if (dataType == Strings.APPARTMENT_NAME) {
        selectedApartmentName = name;
        selectedApartmentId = id;
        _blockCount = blockCount;
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
    setState(() {
      selectedFlatId = flatId;
      selectedFlatName = flatNumber;
    });
  }
}
