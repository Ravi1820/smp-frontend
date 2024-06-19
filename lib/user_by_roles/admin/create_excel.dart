import 'dart:convert';
import 'dart:io';

import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/model/management_role_model.dart';
import 'package:SMP/model/movies.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/profile.dart';
import 'package:SMP/user_by_roles/admin/manage_team/management_team_list.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/contants/error_dialog.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/view_model/smp_view_model.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:SMP/widget/footers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateExcel extends StatefulWidget {
  const CreateExcel({super.key});
  @override
  State<CreateExcel> createState() {
    return _CreateExcelState();
  }
}

class _CreateExcelState extends State<CreateExcel> with ApiListener {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isNetworkConnected = false, isLoading = true;
  File? _selectedImage;
  String? _selectedHospitalId;

  bool _isLoading = false;

  List apartmentList = [];

  int apartmentId = 0;
  String apartmentName = "";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();
    _getApartmentData();
  }

  List roles = [];

  int selectedRoleId = 0;

  ApartmentModel? selectedUser;
  int? _selectedApartmentID;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      // ignore: avoid_print
      print('Selected file: ${file.name}');

      setState(() {
        _selectedImage = File(file.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content =  Card(
      elevation: 5,
      margin: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(FontSizeUtil.CONTAINER_SIZE_10)),
          side: BorderSide(width: 1, color: Color(0xFF18A7FF))),
      child: SizedBox(
        height: FontSizeUtil.CONTAINER_SIZE_50,
        child: Center(
            child: Text("No File Selected", style: TextStyle(fontSize: FontSizeUtil.CONTAINER_SIZE_20))),
      ),
    );

    if (_selectedImage != null) {
      content = Card(
        elevation: 4,
        margin: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_16),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(FontSizeUtil.CONTAINER_SIZE_10),
                topRight: Radius.circular(FontSizeUtil.CONTAINER_SIZE_10)),
            side: BorderSide(width: 1, color: Color(0xFF18A7FF))),
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
        Navigator.of(context).push(createRoute( DashboardScreen(isFirstLogin:false)));
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: "Upload Resident Details",
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
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                onTap: pickFile,
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 1.03,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                        0x3018A7FF), // Adjust opacity as needed
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: const Color(
                                          0x8218A7FF), // Adjust opacity as needed
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
                                          'Click here to import excel',
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
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (_selectedImage != null)
                        Text(
                          'Selected File',
                          style: TextStyle(
                            color: Color.fromRGBO(27, 86, 148, 1.0),
                            fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      content,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 50),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_selectedImage != null) {
                              setState(() {
                                _isLoading = true;
                              });
                              Provider.of<SmpListViewModel>(context,
                                      listen: false)
                                  .addExcel(_selectedImage, apartmentId)
                                  .then(
                                (response) async {
                                  if (response.statusCode == 200) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    print("SUCCESS");
                                    var message = "File uploaded successfully";
                                    successDialog(context, message,
                                         DashboardScreen(isFirstLogin:false));
                                  } else {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    print("ERROR: ${response.statusCode}");
                                    var responseJson = response.body;
                                    print("Error2: $responseJson");
                                    errorDialog(context, responseJson,
                                        const CreateExcel());
                                  }
                                },
                              ).catchError((error) {
                                print("Error1: $error");
                                setState(() {
                                  _isLoading = false;
                                });
                                errorDialog(context, error, const CreateExcel());
                              });
                            } else {
                              setState(() {
                                _isLoading = false;
                              });
                              errorAlert(
                                  context, "Please select resident Excel file");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff1B5694),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_15),
                            ),
                            padding:  EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_15),
                          ),
                          child: const Text("Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
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
  Future<void> _getApartmentData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apartId = prefs.getInt('apartmentId');
    var apartName = prefs.getString('apartmentName');

    setState(() {
      apartmentId = apartId!;
      apartmentName = apartName!;
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
          List<ApartmentModel> apartlist = (json.decode(response) as List)
              .map((item) => ApartmentModel.fromJson(item))
              .toList();

          // setState(() {
          apartmentList = apartlist;
          // });
        });
      } else if (res == "createExcel") {
        ResponceModel responceModel =
            ResponceModel.fromJson(json.decode(response));

        if (responceModel.status == "success") {
          successDialog(
              context, responceModel.message!,  DashboardScreen(isFirstLogin:false));
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
