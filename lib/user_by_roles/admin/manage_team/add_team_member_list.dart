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
import 'package:SMP/user_by_roles/admin/manage_team/management_team_list.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';

class AddTeamMemberScreen extends StatefulWidget {
  AddTeamMemberScreen({super.key, required this.navigatorListener});

  NavigatorListener? navigatorListener;

  @override
  State<AddTeamMemberScreen> createState() {
    return _AddTeamMemberScreenState();
  }
}

class _AddTeamMemberScreenState extends State<AddTeamMemberScreen>
    with ApiListener, NavigatorListener {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isNetworkConnected = false, _isLoading = true;
  ManagementRole? selectedValue;

  List allResidentsLists = [];
  int selectedRoleId = 0;

  var selectedUser = '';

  bool setShowlistflag = false;
  List usersList = [];
  bool isLoading = false;

  String query = "";

  List selectedMember = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();

    _choose();
    _getResidentList();
    _getAllMemberRole();
  }

  int apartmentId = 0;

  Future<void> _choose() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apartmntId = prefs.getInt('apartmentId');

    setState(() {
      apartmentId = apartmntId!;
    });
  }

  String baseImageIssueApi = '';

  List originalUsers = [];

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


  List roles = [];


  String apartmentName = '';
  int residentId = 0;

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
            title: "Add Association Member",
            profile: () {},
          ),
        ),

        // drawer: const DrawerScreen(),
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
                        Color.fromARGB(255, 255, 255, 255),
                        Color.fromARGB(255, 255, 255, 255),
                        Color.fromARGB(255, 255, 255, 255),
                        Color.fromARGB(255, 255, 255, 255),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Assign Role ',
                                    style: TextStyle(
                                      color: Color.fromRGBO(27, 86, 148, 1.0),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Stack(
                          alignment: Alignment.centerLeft,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
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
                                height: 50,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<ManagementRole>(
                                    isExpanded: true,
                                    hint: const Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Select Role',
                                            style: TextStyle(fontSize: 16),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    items: roles
                                        .map((role) =>
                                            DropdownMenuItem<ManagementRole>(
                                              value: role,
                                              child: Text(
                                                role.roleName,
                                                style:
                                                    const TextStyle(fontSize: 16),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ))
                                        .toList(),
                                    value: selectedValue,
                                    onChanged: (ManagementRole? value) {
                                      setState(() {
                                        selectedValue = value;
                                        // Access id and roleName of the selected role
                                        if (value != null) {
                                          selectedRoleId = value.id;
                                          print('Selected Role ID: ${value.id}');
                                          print(
                                              'Selected Role Name: ${value.roleName}');
                                        }
                                      });
                                    },
                                    buttonStyleData: const ButtonStyleData(
                                      height: 50,
                                      padding:
                                          EdgeInsets.only(left: 14, right: 14),
                                      elevation: 2,
                                    ),
                                    iconStyleData: const IconStyleData(
                                      icon: Icon(
                                        Icons.arrow_drop_down_outlined,
                                      ),
                                      iconSize: 18,
                                      iconEnabledColor: Colors.black,
                                      iconDisabledColor: Colors.grey,
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      maxHeight: 200,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      offset: const Offset(0, 0),
                                      scrollbarTheme: ScrollbarThemeData(
                                        radius: const Radius.circular(40),
                                        thickness:
                                            MaterialStateProperty.all<double>(6),
                                        thumbVisibility:
                                            MaterialStateProperty.all<bool>(true),
                                      ),
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      height: 40,
                                      padding:
                                          EdgeInsets.only(left: 14, right: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(Strings.EMOJI_DENY_REGEX)
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
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 0, 140, 255),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(
                                  color: Colors
                                      .grey, // Set your enabled border color
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 10,
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
                        const SizedBox(height: 10),
                        Expanded(child: content),
                        if (selectedRoleId != 0 && residentId != 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 50),
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                Utils.printLog(
                                    "Selected Resident Id $residentId");
                                Utils.printLog(
                                    "Selected Role Id $selectedRoleId");
                                // if (selectedRoleId != 0 && residentId != 0) {
                                _addTeamMemberData();
                                // } else {
                                //   Utils.showToast(
                                //       "Please select role and resident");
                                // }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff1B5694),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.all(15),
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
                        // Utils.showToast(
                        //     "Please select role and resident"),

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
