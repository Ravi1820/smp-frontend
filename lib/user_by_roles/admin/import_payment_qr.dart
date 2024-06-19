import 'dart:convert';
import 'dart:io';

import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/model/movies.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/profile.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:SMP/widget/footers.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImportPaymentQrScreen extends StatefulWidget {
  const ImportPaymentQrScreen({super.key});
  @override
  State<ImportPaymentQrScreen> createState() {
    return _ImportPaymentQrScreenState();
  }
}

class _ImportPaymentQrScreenState extends State<ImportPaymentQrScreen>
    with ApiListener {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _upiNumberController = TextEditingController();

  //  TextEditingController _upiIdController = TextEditingController();
  bool _isValid = false;

  void _validateUpiId(String value) {
    // Regular expression to match UPI ID format
    RegExp regex = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$');
    setState(() {
      _isValid = regex.hasMatch(value);
    });
  }

  bool _isNetworkConnected = false, isLoading = true;
  File? _selectedImage;
  String? _selectedHospitalId;

  bool _isLoading = false;

  List apartmentList = [];

  int apartmentId = 0;
  String apartmentName = "";

  String _enteredUpiName = '';

  final _adminNameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();
  }

  bool showNameErrorMessage = false;
  List roles = [];

  int selectedRoleId = 0;

  ApartmentModel? selectedUser;
  int? _selectedApartmentID;

  bool isValidEmail(String email) {
    // const pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+)+[a-zA-Z]{7,7}$';
    const pattern = r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9-]{2,}$';

    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  void pickFile() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = GestureDetector(
      onTap: pickFile,
      child: Container(
        width: MediaQuery.of(context).size.width - 1.03,
        height: 200,
        decoration: BoxDecoration(
          color: const Color(0x3018A7FF),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: const Color(0x8218A7FF),
            width: 3,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.cloud_upload,
                size: 50,
                color: Color(0xFF18A7FF),
              ),
              Text(
                'Click here to import qr',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF18A7FF),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'roboto',
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: pickFile,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .push(createRoute(DashboardScreen(isFirstLogin: false)));
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: "Upload Payment QR",
            // menuOpen: () {
            //   _scaffoldKey.currentState!.openDrawer();
            // },
            profile: () {
              Navigator.of(context).push(createRoute(const UserProfile()));
            },
          ),
        ),
        // drawer: const DrawerScreen(),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width - 1.03,
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD6DAE6),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: content,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.topLeft,
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'UPI Id ',
                                style: TextStyle(
                                  color: Color.fromRGBO(27, 86, 148, 1.0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // TextSpan(
                              //   text: '*',
                              //   style: TextStyle(
                              //     color: Color.fromRGBO(255, 0, 0, 1),
                              //     fontSize: 16,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Form(
                        key: _formKey,
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _adminNameFocusNode.requestFocus();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 100, 100, 100),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                height: 55,
                                child: Focus(
                                  focusNode: _adminNameFocusNode,
                                  child: TextFormField(
                                    controller: _upiNumberController,
                                    onEditingComplete: () {
                                      FocusScope.of(context)
                                          .requestFocus(_phoneFocusNode);
                                    },
                                    scrollPadding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom *
                                            1.15),
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      // FilteringTextInputFormatter
                                      //     .digitsOnly,
                                      LengthLimitingTextInputFormatter(15),
                                    ],
                                    // inputFormatters: [
                                    //   FilteringTextInputFormatter.allow(
                                    //     RegExp(
                                    //         r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$'),
                                    //   ),
                                    // ],
                                    style:
                                        const TextStyle(color: Colors.black87),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(top: 14),
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Color(0xff4d004d),
                                      ),
                                      hintText: 'UPI Id',
                                      hintStyle:
                                          TextStyle(color: Colors.black38),
                                    ),

                                    onChanged: (value) {
                                      if (isValidEmail(value)) {
                                        setState(() {
                                          showNameErrorMessage = false;
                                        });
                                      } else {
                                        setState(() {
                                          showNameErrorMessage = true;
                                        });
                                      }
                                      // RegExp regex = RegExp(
                                      //     r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$');
                                      // if (value.isEmpty) {
                                      //   setState(() {
                                      //     showNameErrorMessage = true;
                                      //   });
                                      // } else if (regex.hasMatch(value)) {
                                      //   setState(() {
                                      //     showNameErrorMessage =
                                      //         false;
                                      //   });
                                      // } else {
                                      //   setState(() {
                                      //     showNameErrorMessage = true;
                                      //   });
                                      // }
                                    },
                                    onSaved: (value) {
                                      _enteredUpiName = value!;
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (showNameErrorMessage)
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Invalid UPI",
                            style: TextStyle(color: Colors.red, fontSize: 15),
                          ),
                        ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 50),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_selectedImage != null) {
                              // if (_upiNumberController.text.isNotEmpty) {
                              setState(() {
                                _isLoading = true;
                              });

                              print(_selectedImage);
                              print(_upiNumberController.text);
                              // }
                              // else {
                              //   setState(() {
                              //     _isLoading = false;
                              //   });
                              //   errorAlert(context, "Please enter qr number");
                              // }

                              _uploadResidentApi();
                            } else {
                              setState(() {
                                _isLoading = false;
                              });
                              errorAlert(context, "Please select qr image");
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
                          child: const Text("Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      const SizedBox(height: 120),
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

  _uploadResidentApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apartId = prefs.getInt('apartmentId');
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          _isLoading = true;

          String upiNumber = _upiNumberController.text;
          var responseType = 'createExcel';
          String keyName = "upiId";

          String partURL = '${Constant.qrUploadUrl}?apartmentId=$apartId';

          NetworkUtils.filePutUrlUploadNetWorkCall(
              partURL, keyName, upiNumber, _selectedImage, this, responseType);
        }
        else {
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
      if (res == "createExcel") {
        ResponceModel responceModel =
            ResponceModel.fromJson(json.decode(response));

        if (responceModel.status == "success") {
          successDialog(context, responceModel.message!,
              DashboardScreen(isFirstLogin: false));
        } else {
          Utils.showToast(responceModel.message!);
        }
      }
    } catch (error) {
      print("Error 1");
      errorAlert(
        context,
        response.body.toString(),
      );
    }
  }
}
