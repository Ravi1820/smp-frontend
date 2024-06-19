import 'dart:convert';
import 'dart:io';

import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/model/fees_type_model.dart';
import 'package:SMP/model/movies.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/profile.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/contants/error_dialog.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/view_model/smp_view_model.dart';
import 'package:SMP/widget/loader.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:SMP/widget/footers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadMonthlyMaintananceScreen extends StatefulWidget {
  const UploadMonthlyMaintananceScreen({super.key});

  @override
  State<UploadMonthlyMaintananceScreen> createState() {
    return _UploadMonthlyMaintananceScreenState();
  }
}

class _UploadMonthlyMaintananceScreenState
    extends State<UploadMonthlyMaintananceScreen> with ApiListener {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isNetworkConnected = false, isLoading = true;
  File? _selectedImage;
  String? _selectedHospitalId;
  String? _selectedOwnerName;
  String _enteredDescriptionName = '';
  final TextEditingController descriptionController = TextEditingController();
  bool _isLoading = false;
  List apartmentList = [];
  List userTypeList = ["Owner", "Tenant", "Owner and Tenant"];
  int apartmentId = 0;
  String apartmentName = "";
  bool showPurposeErrorMessage = false;
  Color _containerBorderColor1 = Colors.white; // Added this line
  Color _boxShadowColor1 = const Color.fromARGB(255, 100, 100, 100);
  List roles = [];
  int selectedRoleId = 0;
  ApartmentModel? selectedUser;
  int? _selectedApartmentID;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();
    _getApartmentData();
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      print('Selected file: ${file.name}');

      setState(() {
        _selectedImage = File(file.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Card(
      elevation: 5,
      margin: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_16),
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(FontSizeUtil.CONTAINER_SIZE_10)),
          side: BorderSide(
              width: FontSizeUtil.SIZE_01, color: const Color(0xFF18A7FF))),
      child: SizedBox(
        height: FontSizeUtil.CONTAINER_SIZE_50,
        child: Center(
            child: Text(Strings.NO_FILES_SELECTED_TEXT,
                style: TextStyle(fontSize: FontSizeUtil.CONTAINER_SIZE_20))),
      ),
    );

    if (_selectedImage != null) {
      content = Card(
        elevation: 4,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(FontSizeUtil.CONTAINER_SIZE_10),
              topRight: Radius.circular(FontSizeUtil.CONTAINER_SIZE_10)),
          side: BorderSide(
            width: FontSizeUtil.SIZE_01,
            color: const Color(0xFF18A7FF),
          ),
        ),
        child: SizedBox(
          height: FontSizeUtil.CONTAINER_SIZE_50,
          child: Center(
            child: Text(
              _selectedImage!.path.split('/').last,
              style: TextStyle(fontSize: FontSizeUtil.CONTAINER_SIZE_20),
            ),
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
            title: Strings.UPLOAD_SOCIETY_DUES_HEADER,
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
                      Colors.white,
                      Colors.white,
                    ],
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: FontSizeUtil.CONTAINER_SIZE_10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: FontSizeUtil.CONTAINER_SIZE_15),
                          child: Text(
                            Strings.SELECT_DUE_TYPE_TEXT,
                            style: TextStyle(
                              color: const Color.fromRGBO(27, 86, 148, 1.0),
                              fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                      Stack(
                        alignment: Alignment.centerLeft,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: FontSizeUtil.CONTAINER_SIZE_10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    FontSizeUtil.CONTAINER_SIZE_10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 100, 100, 100),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              height: FontSizeUtil.CONTAINER_SIZE_50,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  hint: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          Strings.SELECT_DUE_TYPE_TEXT,
                                          style: TextStyle(
                                              fontSize: FontSizeUtil
                                                  .CONTAINER_SIZE_16),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  items: apartmentList
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item.feesType,
                                            child: Text(
                                              item.feesType,
                                              style: TextStyle(
                                                  fontSize: FontSizeUtil
                                                      .CONTAINER_SIZE_16),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList(),
                                  value: _selectedHospitalId,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedHospitalId = value;

                                      var selectedMovie =
                                          apartmentList.firstWhere(
                                              (item) => item.feesType == value);

                                      _selectedApartmentID = selectedMovie.id;
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: FontSizeUtil.CONTAINER_SIZE_50,
                                    padding: EdgeInsets.only(
                                        left: FontSizeUtil.CONTAINER_SIZE_14,
                                        right: FontSizeUtil.CONTAINER_SIZE_14),
                                    elevation: 2,
                                  ),
                                  iconStyleData: IconStyleData(
                                    icon: const Icon(
                                      Icons.arrow_drop_down_outlined,
                                    ),
                                    iconSize: FontSizeUtil.CONTAINER_SIZE_18,
                                    iconEnabledColor: Colors.black,
                                    iconDisabledColor: Colors.grey,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: FontSizeUtil.CONTAINER_SIZE_200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          FontSizeUtil.CONTAINER_SIZE_14),
                                    ),
                                    offset: const Offset(0, 0),
                                    scrollbarTheme: ScrollbarThemeData(
                                      radius: Radius.circular(
                                          FontSizeUtil.CONTAINER_SIZE_40),
                                      thickness:
                                          MaterialStateProperty.all<double>(6),
                                      thumbVisibility:
                                          MaterialStateProperty.all<bool>(true),
                                    ),
                                  ),
                                  menuItemStyleData: MenuItemStyleData(
                                    height: FontSizeUtil.CONTAINER_SIZE_40,
                                    padding: EdgeInsets.only(
                                        left: FontSizeUtil.CONTAINER_SIZE_14,
                                        right: FontSizeUtil.CONTAINER_SIZE_14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: FontSizeUtil.CONTAINER_SIZE_10,
                      ),
                      SizedBox(
                        height: FontSizeUtil.CONTAINER_SIZE_10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: FontSizeUtil.CONTAINER_SIZE_15),
                          child:  Text(
                            Strings.SELECT_USER_GROUP_TEXT,
                            style: TextStyle(
                              color:const Color.fromRGBO(27, 86, 148, 1.0),
                              fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                      Stack(
                        alignment: Alignment.centerLeft,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: FontSizeUtil.CONTAINER_SIZE_10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    FontSizeUtil.CONTAINER_SIZE_10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 100, 100, 100),
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              height:FontSizeUtil.CONTAINER_SIZE_50,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  hint: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          Strings.SELECT_USER_GROUP_TEXT,
                                          style: TextStyle(
                                              fontSize: FontSizeUtil
                                                  .CONTAINER_SIZE_16),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  items: userTypeList
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: TextStyle(
                                                  fontSize: FontSizeUtil
                                                      .CONTAINER_SIZE_16),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList(),
                                  value: _selectedOwnerName,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedOwnerName = value!;
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: FontSizeUtil.CONTAINER_SIZE_50,
                                    padding: EdgeInsets.only(
                                        left: FontSizeUtil.CONTAINER_SIZE_14,
                                        right: FontSizeUtil.CONTAINER_SIZE_14),
                                    elevation: 2,
                                  ),
                                  iconStyleData: IconStyleData(
                                    icon: const Icon(
                                      Icons.arrow_drop_down_outlined,
                                    ),
                                    iconSize: FontSizeUtil.CONTAINER_SIZE_18,
                                    iconEnabledColor: Colors.black,
                                    iconDisabledColor: Colors.grey,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: FontSizeUtil.CONTAINER_SIZE_200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          FontSizeUtil.CONTAINER_SIZE_14),
                                    ),
                                    offset: const Offset(0, 0),
                                    scrollbarTheme: ScrollbarThemeData(
                                      radius:  Radius.circular(FontSizeUtil.CONTAINER_SIZE_40),
                                      thickness:
                                          MaterialStateProperty.all<double>(6),
                                      thumbVisibility:
                                          MaterialStateProperty.all<bool>(true),
                                    ),
                                  ),
                                  menuItemStyleData: MenuItemStyleData(
                                    height: FontSizeUtil.CONTAINER_SIZE_40,
                                    padding: EdgeInsets.only(
                                        left: FontSizeUtil.CONTAINER_SIZE_14,
                                        right: FontSizeUtil.CONTAINER_SIZE_14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: FontSizeUtil.CONTAINER_SIZE_10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: FontSizeUtil.CONTAINER_SIZE_15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.SOCIETY_DESCRIPTION,
                              style: TextStyle(
                                color:const Color.fromRGBO(27, 86, 148, 1.0),
                                fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                            Stack(
                              alignment: Alignment.centerLeft,
                              children: <Widget>[
                                FocusScope(
                                  child: Focus(
                                    onFocusChange: (hasFocus) {
                                      setState(() {
                                        _containerBorderColor1 = hasFocus
                                            ? const Color.fromARGB(
                                                255, 0, 137, 250)
                                            : Colors.white;
                                        _boxShadowColor1 = hasFocus
                                            ? const Color.fromARGB(
                                                162, 63, 158, 235)
                                            : const Color.fromARGB(
                                                255, 100, 100, 100);
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            FontSizeUtil.CONTAINER_SIZE_10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: _boxShadowColor1,
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                        border: Border.all(
                                          color: _containerBorderColor1,
                                        ),
                                      ),
                                      height: FontSizeUtil.CONTAINER_SIZE_100,
                                      child: TextFormField(
                                        controller: descriptionController,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        style: AppStyles.heading1(context),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              top: FontSizeUtil
                                                  .CONTAINER_SIZE_14),
                                          prefixIcon: const Icon(
                                            Icons.description,
                                            color: Color(0xff4d004d),
                                          ),
                                          hintText: Strings.SOCIETY_DESCRIPTION_HINT,
                                          hintStyle: const TextStyle(
                                              color: Colors.black38),
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty ||
                                              value.trim().length <= 1) {
                                            setState(() {
                                              showPurposeErrorMessage = true;
                                            });
                                          } else {
                                            setState(() {
                                              showPurposeErrorMessage = false;
                                            });
                                            return null;
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          if (value.isEmpty ||
                                              value.trim().length <= 1) {
                                            setState(() {
                                              showPurposeErrorMessage = true;
                                            });
                                          } else {
                                            setState(() {
                                              showPurposeErrorMessage = false;
                                            });
                                          }
                                        },
                                        onSaved: (value) {
                                          _enteredDescriptionName = value!;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (showPurposeErrorMessage == true)
                              Text(
                                Strings.SOCIETY_DESCRIPTION_ERROR_TEXT,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: FontSizeUtil.CONTAINER_SIZE_15,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width - 1.03,
                          margin:
                              EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_20),
                          padding:
                              EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD6DAE6),
                            borderRadius:
                                BorderRadius.circular(FontSizeUtil.SIZE_05),
                          ),
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                onTap: pickFile,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width - 1.03,
                                  height: FontSizeUtil.CONTAINER_SIZE_200,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                        0x3018A7FF), // Adjust opacity as needed
                                    borderRadius: BorderRadius.circular(
                                        FontSizeUtil.SIZE_05),
                                    border: Border.all(
                                      color: const Color(0x8218A7FF),
                                      // Adjust opacity as needed
                                      width: FontSizeUtil.SIZE_03,
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.cloud_upload,
                                          size: FontSizeUtil.CONTAINER_SIZE_50,
                                          color:const Color(0xFF18A7FF),
                                        ),
                                        Text(
                                          Strings.UPLOAD_EXCEL_TEXT,
                                          style: TextStyle(
                                            fontSize:
                                                FontSizeUtil.CONTAINER_SIZE_20,
                                            color: const Color(0xFF18A7FF),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'roboto',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_selectedImage != null)
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: FontSizeUtil.CONTAINER_SIZE_15),
                            child: Text(
                              Strings.SELECT_FILE_TEXT,
                              style: TextStyle(
                                color:const Color.fromRGBO(27, 86, 148, 1.0),
                                fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      content,
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: FontSizeUtil.CONTAINER_SIZE_25,
                            horizontal: FontSizeUtil.CONTAINER_SIZE_50),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            var apartId = prefs.getInt('apartmentId');
                            if (showPurposeErrorMessage == false) {
                              if (_selectedApartmentID != null) {
                                if (_selectedImage != null) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  String description =
                                      descriptionController.text;
                                  Provider.of<SmpListViewModel>(context,
                                          listen: false)
                                      .addFeesTypeExcel(
                                          _selectedImage,
                                          apartId!,
                                          _selectedApartmentID,
                                          description)
                                      .then(
                                    (response) async {
                                      if (response.statusCode == 200) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        print("SUCCESS");
                                        var message =
                                            "File uploaded successfully";
                                        successDialog(
                                            context,
                                            message,
                                            DashboardScreen(
                                                isFirstLogin: false));
                                      } else {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        print("ERROR: ${response.statusCode}");
                                        var responseJson = response.body;
                                        print("Error2: $responseJson");
                                        errorDialog(context, responseJson,
                                            const UploadMonthlyMaintananceScreen());
                                      }
                                    },
                                  ).catchError((error) {
                                    print("Error1: $error");
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    errorDialog(context, error,
                                        const UploadMonthlyMaintananceScreen());
                                  });
                                } else {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  errorAlert(
                                      context, Strings.UPLOAD_SOCIETY_DUES_ERROR);
                                }
                              } else {
                                setState(() {
                                  _isLoading = false;
                                });
                                errorAlert(context, Strings.SELECT_FEES_TYPE_ERROR_TEXT);
                              }
                            } else {
                              setState(() {
                                _isLoading = false;
                              });
                              errorAlert(
                                  context, Strings.MANDATORY_FIELD_WARNING_TEXT);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff1B5694),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  FontSizeUtil.CONTAINER_SIZE_15),
                            ),
                            padding:
                                EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_15),
                          ),
                          child: Text(Strings.UPLOAD_SOCIETY_DUES_BTN_TEXT,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: FontSizeUtil.CONTAINER_SIZE_18,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: FontSizeUtil.CONTAINER_SIZE_100,
                      ),
                      SizedBox(height: FontSizeUtil.CONTAINER_SIZE_80),
                    ],
                  ),
                ),
              ),
              if (_isLoading) // Display the loader if _isLoading is true
                const Positioned(child: LoadingDialog()),
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
          var responseType = 'createExcel';

          String description = descriptionController.text;

          NetworkUtils.excelUploadNetWorkCall(
              Constant.uploadMonthlyMaintenanceURL,
              apartId,
              _selectedApartmentID,
              description,
              _selectedImage,
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

  Future<void> _getApartmentData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apartId = prefs.getInt('apartmentId');
    var apartName = prefs.getString('apartmentName');

    setState(() {
      apartmentId = apartId!;
      apartmentName = apartName!;
    });

    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        print(_isNetworkConnected);
        String responseType = "email";
        if (_isNetworkConnected) {
          isLoading = true;
          NetworkUtils.getNetWorkCall(
              Constant.getAllFeesTypeURL, responseType, this);
        } else {
          print("else called");
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
      if (res == "email") {
        setState(() {
          List<FeesTypeModel> apartlist = (json.decode(response) as List)
              .map((item) => FeesTypeModel.fromJson(item))
              .toList();
          apartmentList = apartlist;
        });
      } else if (res == "createExcel") {
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
