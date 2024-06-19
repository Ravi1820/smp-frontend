import 'dart:async';
import 'dart:convert';

import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/contants/translate.dart';
import 'package:SMP/model/admin_resident_list_model.dart';
import 'package:SMP/model/all_owner_for_apartment.dart';
import 'package:SMP/model/global_search.dart';
import 'package:SMP/model/management_role_model.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/manage_team/management_team_list.dart';
import 'package:SMP/user_by_roles/admin/vehicle_management_by_admin/admin_all_vehicle_list.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddSlotToResidentScreen extends StatefulWidget {
  AddSlotToResidentScreen({super.key, required this.navigatorListener});

  NavigatorListener? navigatorListener;

  @override
  State<AddSlotToResidentScreen> createState() {
    return _AddSlotToResidentState();
  }
}

class _AddSlotToResidentState extends State<AddSlotToResidentScreen>
    with ApiListener, NavigatorListener {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isNetworkConnected = false, _isLoading = true;
  ManagementRole? selectedValue;
  bool showVehicleNumberErrorMessage = false;
  List allResidentsLists = [];
  int selectedRoleId = 0;
  String? _selectedSlot;
  var selectedUser = '';
  bool showVehicleSlotErrorMessage = false;
  final slots = ['B-101', 'B-102', 'B-103'];
  bool setShowlistflag = false;
  List usersList = [];
  bool isLoading = false;
  Color _containerBorderColor1 = Colors.white;
  Color _boxShadowColor1 = const Color.fromARGB(255, 100, 100, 100);
  String query = "";
  List selectedMember = [];
  int apartmentId = 0;
  String baseImageIssueApi = '';
  List originalUsers = [];
  List roles = [];
  String apartmentName = '';
  int residentId = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    super.initState();
    _choose();
    _getResidentList();
    _getAllMemberRole();
  }

  Future<void> _choose() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apartmntId = prefs.getInt('apartmentId');

    setState(() {
      apartmentId = apartmntId!;
    });
  }

  void _filterList(String query) {
    setState(() {
      this.query = query;
    });
  }

  void getList() {
    setState(() {
      if (query.isNotEmpty) {
        originalUsers = allResidentsLists.where((user) {
          final nameMatches =
          user.fullName.toLowerCase().contains(query.toLowerCase());
          final blockMatches = user.blockName
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase());

          final flatMatches = user.flatNumber
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase());


          return nameMatches || blockMatches ||flatMatches ;
        }).toList();
      } else {
        originalUsers = allResidentsLists;
      }
    });
  }



  void editUserChoice(users) {
    setState(() {
      residentId = users.userInfo.userId;
      print(residentId);
    });
  }

  void editUserChoice1(users) {
    setState(() {
      residentId = users.id;
      print(residentId);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    usersList = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getList();
    Widget content;
    if (originalUsers.isNotEmpty) {
      content = Padding(
        padding: const EdgeInsets.all(8.0),
        child: AdminResidentListModel(
            press: editUserChoice1,
            users: originalUsers,
            baseImageIssueApi: baseImageIssueApi,
            selectedCountries: selectedMember),
      );
    } else {
      content = Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'No Owner, Flat, Block… Found',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: MediaQuery.of(context).size.width * 0.05,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              color: const Color(0xff1B5694),
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
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: Strings.ALLOCATE_SLOT_HEADER,
            profile: () {},
          ),
        ),

        body: AbsorbPointer(
          absorbing: _isLoading,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Container(
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
                  child: Center(
                    child: Column(
                      children: <Widget>[
                         SizedBox(height: FontSizeUtil.CONTAINER_SIZE_20),


                        SizedBox(height: FontSizeUtil.PADDING_HEIGHT_10),
                        Row(

                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: FontSizeUtil.CONTAINER_SIZE_20),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: Strings.ASSIGN_SLOT_LABEL,
                                              style: TextStyle(
                                                color:const Color.fromRGBO(27, 86, 148, 1.0),
                                                fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: ' *',
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
                                  SizedBox(height:FontSizeUtil.SIZE_05),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal:FontSizeUtil.CONTAINER_SIZE_20),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_10),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                255, 100, 100, 100),
                                            blurRadius: 6,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      height: FontSizeUtil.CONTAINER_SIZE_45,

                                      child:
                                      DropdownButtonHideUnderline(
                                        child: ButtonTheme(
                                          alignedDropdown: true,
                                          child:
                                          DropdownButtonFormField<
                                              String>(
                                            isExpanded: true,
                                            value: _selectedSlot,
                                            items: slots.map((item) {
                                              return DropdownMenuItem<
                                                  String>(
                                                value: item,
                                                child: Text(item,
                                                    style: AppStyles
                                                        .heading1(
                                                        context)),
                                              );
                                            }).toList(),
                                            style: AppStyles.heading1(
                                                context),
                                            onChanged: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                setState(() {
                                                  showVehicleSlotErrorMessage =
                                                  true;
                                                });
                                              } else {
                                                setState(() {

                                                });
                                                setState(() {
                                                  showVehicleSlotErrorMessage =
                                                  false;
                                                });
                                              }
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                setState(() {
                                                  showVehicleSlotErrorMessage =
                                                  true;
                                                });
                                              } else {
                                                setState(() {
                                                  showVehicleSlotErrorMessage =
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

                                              hintText: "Select Slot",
                                              contentPadding:
                                              EdgeInsets
                                                  .symmetric(
                                                  horizontal:
                                                  FontSizeUtil.CONTAINER_SIZE_16),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: FontSizeUtil.CONTAINER_SIZE_20),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: Strings.ENTER_AMOUNT,
                                              style: TextStyle(
                                                color: const Color.fromRGBO(27, 86, 148, 1.0),
                                                fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                             TextSpan(
                                              text: ' *',
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
                                  SizedBox(height:FontSizeUtil.SIZE_05),
                                  Padding(
                                    padding:  EdgeInsets.symmetric(horizontal:FontSizeUtil.CONTAINER_SIZE_20),
                                    child:
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
                                            _boxShadowColor1 =
                                            hasFocus
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
                                            borderRadius:
                                            BorderRadius.circular(
                                                10),
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                _boxShadowColor1,
                                                blurRadius: 6,
                                                offset: const Offset(
                                                    0, 2),
                                              ),
                                            ],
                                            border: Border.all(
                                              color:
                                              _containerBorderColor1,
                                            ),
                                          ),
                                          height: 44,
                                          child: TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .allow(
                                                RegExp(
                                                    r"[a-zA-Z0-9._%+-@]+|\s"),

                                              ),
                                            ],


                                            scrollPadding: EdgeInsets.only(
                                                bottom: MediaQuery.of(
                                                    context)
                                                    .viewInsets
                                                    .bottom *
                                                    1.40),
                                            textInputAction:
                                            TextInputAction.done,
                                            style: AppStyles.heading1(
                                                context),
                                            decoration:
                                             InputDecoration(
                                              border:
                                              InputBorder.none,
                                              contentPadding:
                                              EdgeInsets.only(
                                                  left: FontSizeUtil.CONTAINER_SIZE_14),
                                              hintText: Strings
                                                  .ENTER_AMOUNT_PLACEHOLDER,
                                              hintStyle:const TextStyle(
                                                  color:
                                                  Colors.black38),
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
                                              // _enteredVehicleNumber =
                                              // value!;
                                            },
                                          ),
                                        ),
                                      ),
                                    ),

                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: FontSizeUtil.PADDING_HEIGHT_10),

                        Padding(
                          padding:  EdgeInsets.symmetric(
                              horizontal: FontSizeUtil.CONTAINER_SIZE_20, vertical: FontSizeUtil.SIZE_05),
                          child: TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r"[a-zA-Z0-9._%+-@]+|\s"),
                              ),
                            ],
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: LocalizationUtil.translate(
                                  'apartmentDataDisplaySearchHint'),
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  _filterList('');
                                  FocusScope.of(context).unfocus();
                                  residentId = 0;
                                },
                                icon: const Icon(Icons.clear),
                              )
                                  : null,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(FontSizeUtil.SIZE_08),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 0, 140, 255),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(FontSizeUtil.SIZE_08),
                                borderSide: const BorderSide(
                                  color: Colors
                                      .grey, // Set your enabled border color
                                ),
                              ),
                              contentPadding:  EdgeInsets.symmetric(
                                vertical: FontSizeUtil.CONTAINER_SIZE_15,
                                horizontal: FontSizeUtil.CONTAINER_SIZE_10,
                              ),
                            ),
                            onChanged: (value) {
                              if (value.trim().isNotEmpty) {
                                _filterList(value);
                                usersList.clear();
                              } else {
                                _filterList('');
                              }
                            },
                          ),
                        ),
                         SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                        Expanded(child: content),
                        if (  residentId != 0)
                          Container(
                            padding:  EdgeInsets.symmetric(
                                vertical: FontSizeUtil.CONTAINER_SIZE_15, horizontal: FontSizeUtil.CONTAINER_SIZE_50),
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                successDialogWithListner(context, "Coming soon",
                                    const AdminALlVehicleListScreen(), this);
                                FocusScope.of(context).unfocus();
                                Utils.printLog(
                                    "Selected Resident Id $residentId");
                                Utils.printLog(
                                    "Selected Role Id $selectedRoleId");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff1B5694),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_15),
                                ),
                                padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_15),
                              ),
                              child: const Text("Save",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Utils.titleText,
                                  )),
                            ),
                          )
                        else
                          Container(),

                        const FooterScreen(),
                      ],
                    ),
                  ),
                ),
              ),
              if (_isLoading) const Positioned(child: LoadingDialog()),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getResidentList() async {
    setState(() {
      isLoading = true;
    });

    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "ownerList";

          String ownerListUrl =
              '${Constant.allOwnerForApartmentURL}?apartmentId=$apartmentId';

          NetworkUtils.getNetWorkCall(ownerListUrl, responseType, this);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apartId = prefs.getInt('apartmentId');

    setState(() {
      isLoading = false;
      baseImageIssueApi = BaseApiImage.baseImageUrl(apartId!, "profile");
    });
  }

  void _getAllMemberRole() {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        // _isLoading = status;

        if (_isNetworkConnected) {
          String responseType = "allRole";

          String societyManagementRoleURL =
              '${Constant.getAllManagementRoleURL}?apartmentId=$apartmentId';

          NetworkUtils.getNetWorkCall(
              societyManagementRoleURL, responseType, this);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  void _addTeamMemberData() {
    Utils.getNetworkConnectedStatus().then((status) {
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        print(_isNetworkConnected);
        if (_isNetworkConnected) {
          _isLoading = true;
          String responseType = "login";

          String loginURL =
              '${Constant.addTeamMemberCountURL}?userId=$residentId&apartmentId=$apartmentId&roleId=$selectedRoleId';

          NetworkUtils.postUrlNetWorkCall(loginURL, this, responseType);
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
  onSuccess(response, responseType) async {
    Utils.printLog("Responce Type ==$responseType response === $response");

    try {
      if (response != null && responseType == "login") {
        ResponceModel responceModel =
        ResponceModel.fromJson(json.decode(response));

        if (responceModel.status == "success") {
          successDialogWithListner(context, responceModel.message!,
              const ManagementTeamList(), this);
        } else {
          Utils.showToast(responceModel.message!);
        }
        setState(() {
          _isLoading = false;
        });
      } else if (responseType == 'globalSearch') {
        // _isLoading = false;
        setState(() {
          _isLoading = false;
        });
        usersList.clear(); // Clear the list when the query is empty

        List<ApiResponse> globalSearchResidentList =
        (json.decode(response) as List)
            .map((item) => ApiResponse.fromJson(item))
            .toList();
        usersList = globalSearchResidentList;
        // setState(() {});
      } else if (responseType == 'ownerList') {
        setState(() {
          _isLoading = false;
        });
        var jsonResponse = json.decode(response);
        AllOwnerForApartment notice =
        AllOwnerForApartment.fromJson(jsonResponse);
        if (notice.status == 'success' && notice.value != null) {
          allResidentsLists = notice.value!;
        }
      } else if (responseType == "allRole") {
        setState(() {
          _isLoading = false;
        });
        setState(() {
          List<ManagementRole> movieList = (json.decode(response) as List)
              .map((item) => ManagementRole.fromJson(item))
              .toList();
          roles = movieList;
        });
      }
    } catch (error) {
      print("Error 1");
      setState(() {
        _isLoading = false;
      });
      if (responseType == 'ownerList') {
        Utils.printLog("Error Resonce $response");
      } else {
        errorAlert(
          context,
          response.body.toString(),
        );
      }
    }
  }

  @override
  onNavigatorBackPressed() {
    Navigator.pop(context);
    widget.navigatorListener!.onNavigatorBackPressed();
  }
}
