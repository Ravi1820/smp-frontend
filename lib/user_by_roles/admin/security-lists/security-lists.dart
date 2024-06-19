import 'dart:convert';

import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/success_alert.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/model/security_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/profile.dart';
import 'package:SMP/registration/gate_security_registration.dart';

import 'package:SMP/user_by_roles/admin/security-lists/view_security.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/components/security_list_card.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityLists extends StatefulWidget {
  const SecurityLists({super.key});

  @override
  State<SecurityLists> createState() {
    return _SecurityLists();
  }
}

class _SecurityLists extends State<SecurityLists>
    with ApiListener, NavigatorListener {
  final TextEditingController _searchController = TextEditingController();
  bool setShowlistflag = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true;
  bool _isNetworkConnected = false,
      _isLoading = true;
  List selectedSecurity = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    _getAllSecurity();
    _getRoles();
    super.initState();
  }


  String userType = '';

  Future<void> _getRoles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final roles = prefs.getString('roles');
    setState(() {
      userType = roles!;
    });
  }

  String baseImageIssueApi = '';

  void editUserChoice(users) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ViewSecurity(
              securityId: users.user.id ?? "",
              userName: users.user.fullName ?? "",
              securityImage: users.user.profilePicture ?? "",
              mobile: users.user.mobile ?? "",
              emailId: users.user.emailId ?? "",
              age: users.user?.age ?? "",
              state: users.user.state ?? "",
              apartmentId: users.user.apartmentId ?? "",
              gender: users.user?.gender ?? "",
              address: users.user?.address ?? "",
              pinCode: users.user?.pinCode ?? "",
              shiftStartTime: users.user?.shiftStartTime ?? "",
              shiftEndTime: users.user?.shiftEndTime ?? "",
              status: users.user?.status ?? "",
              baseImageIssueApi: baseImageIssueApi,
              navigatorListener: this,
            ),
      ),
    );
  }

  Future<void> _getAllSecurity() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apartmentId = prefs.getInt("apartmentId");
    var id = prefs.getInt("id");

    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "securityList";

          String securityListURL =
              '${Constant.securityListURL}?apartmentId=$apartmentId';

          NetworkUtils.getNetWorkCall(securityListURL, responseType, this);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });

    setState(() {
      isLoading = false;
      baseImageIssueApi = BaseApiImage.baseImageUrl(apartmentId!, "profile");

      Utils.printLog(baseImageIssueApi);
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
  onSuccess(response, String responseType) async {
    Utils.printLog("responsetype == $responseType response==$response  ");
    try {
      setState(() {
        if (responseType == 'securityList') {
          List<SecurityModel> movieList = (json.decode(response) as List)
              .map((item) => SecurityModel.fromJson(item))
              .toList();
          setState(() {
            securityListLists = movieList;
          });
          _isLoading = false;
        } else if (responseType == 'deleteSecurity') {
          ResponceModel responceModel =
          ResponceModel.fromJson(json.decode(response));

          if (responceModel.status == "success") {
            _deletePollData();

            successAlert(
              context,
              responceModel.message!,
            );
          } else {
            Utils.showToast(responceModel.message!);
          }
          _isLoading = false;
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Utils.printLog("text === $response");
    }
  }

  List securityListLists = [];
  List originalUsers = [];
  String query = "";

  void _filterList(String query) {
    setState(() {
      this.query = query;
    });
  }

  void getList() {
    setState(() {
      if (query.isNotEmpty) {
        originalUsers = securityListLists.where((user) {
          final nameMatches =
          user.user.fullName.toLowerCase().contains(query.toLowerCase());
          final idMatches = user.user.id
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase());

          return nameMatches || idMatches;
        }).toList();
      } else {
        originalUsers = securityListLists;
      }
    });
  }

  bool isselected = false;

  @override
  Widget build(BuildContext context) {
    getList();

    Widget content;

    if (originalUsers.isNotEmpty) {
      content = Padding(
        padding:  EdgeInsets.all(FontSizeUtil.SIZE_08),
        child: SecurityListViewCard(
          press: editUserChoice,
          users: originalUsers,
          isselected: isselected,
          baseImageIssueApi: baseImageIssueApi,
          selectedCountries: selectedSecurity,
          onSelectedMembersChanged: (List updatedSelectedMembers) {
            setState(() {
              selectedSecurity = updatedSelectedMembers;
            });
          },
        ),
      );
    } else {
      content = Center(
        child: Padding(
          padding:  EdgeInsets.only(top: FontSizeUtil.SIZE_08),
          child: Text(
            'There are no security',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: MediaQuery
                  .of(context)
                  .size
                  .width * 0.05,
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
        Navigator.of(context).push(createRoute(DashboardScreen(
          isFirstLogin: false,
        )));

        // Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: 'Security List',

            profile: () {
              Navigator.of(context).push(createRoute(const UserProfile()));
            },
          ),
        ),
        // drawer: const DrawerScreen(),
        body: AbsorbPointer(
          absorbing: _isLoading,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Stack(
              children: [
                Container(
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
                        SizedBox(height: FontSizeUtil.SIZE_10),
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
                              hintText: 'Search by Name / ID...',
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                onPressed: () {
                                  _searchController.clear();
                                  _filterList('');
                                  FocusScope.of(context).unfocus();
                                },
                                icon: const Icon(Icons.clear),
                              )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(FontSizeUtil.SIZE_08),
                              ),
                            ),
                            onChanged: _filterList,
                          ),
                        ),
                        Expanded(child: content),
                        selectedSecurity.isNotEmpty
                            ? Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff1B5694),
                              // ? const Color(0xff1B5694)
                              // : Colors.grey,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_18),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: FontSizeUtil.CONTAINER_SIZE_50,
                                vertical:FontSizeUtil.CONTAINER_SIZE_15,
                              ),
                            ),
                            onPressed: () async {
                              selectedSecurity.isNotEmpty
                                  ? showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    contentPadding:
                                     EdgeInsets.only(
                                        top: FontSizeUtil.CONTAINER_SIZE_10, right: FontSizeUtil.CONTAINER_SIZE_10),
                                    content: Stack(
                                      children: <Widget>[
                                        Container(
                                          padding:
                                           EdgeInsets.only(
                                            top: FontSizeUtil.CONTAINER_SIZE_18,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape:
                                            BoxShape.rectangle,
                                            borderRadius:
                                            BorderRadius
                                                .circular(FontSizeUtil.CONTAINER_SIZE_16),
                                            boxShadow: const <BoxShadow>[
                                              BoxShadow(
                                                color:
                                                Colors.black26,
                                                blurRadius: 0.0,
                                                offset: Offset(
                                                    0.0, 0.0),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisSize:
                                            MainAxisSize.min,
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .stretch,
                                            children: <Widget>[
                                               Icon(
                                                Icons.error,
                                                size: FontSizeUtil.CONTAINER_SIZE_65,
                                                color: Colors.red,
                                              ),
                                               SizedBox(
                                                  height: FontSizeUtil.CONTAINER_SIZE_16),
                                               Center(
                                                child: Text(
                                                  Strings.WARNING_TEXT1,
                                                  style: TextStyle(
                                                    fontSize: FontSizeUtil.CONTAINER_SIZE_18,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                    color:
                                                    Colors.red,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  height: FontSizeUtil.CONTAINER_SIZE_16),
                                               Text(
                                                Strings.DELETE_CONFIRM_TEXT,
                                                style: TextStyle(
                                                  color:const Color
                                                      .fromRGBO(
                                                      27,
                                                      86,
                                                      148,
                                                      1.0),
                                                  fontSize: FontSizeUtil.CONTAINER_SIZE_15,
                                                  fontWeight:
                                                  FontWeight
                                                      .bold,
                                                ),
                                                textAlign: TextAlign
                                                    .center,
                                              ),
                                              SizedBox(
                                                height: FontSizeUtil.CONTAINER_SIZE_20,
                                                width: FontSizeUtil.SIZE_05,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  SizedBox(
                                                    height: FontSizeUtil.CONTAINER_SIZE_30,
                                                    child:
                                                    ElevatedButton(
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        shape:
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              FontSizeUtil.CONTAINER_SIZE_20),
                                                          side:
                                                          const BorderSide(
                                                            width:
                                                            1,
                                                          ),
                                                        ),
                                                        padding:
                                                         EdgeInsets
                                                            .symmetric(
                                                          horizontal:
                                                          FontSizeUtil.CONTAINER_SIZE_15,

                                                        ),
                                                      ),
                                                      onPressed:
                                                          () {
                                                        Utils
                                                            .getNetworkConnectedStatus()
                                                            .then(
                                                                (status) {
                                                              Utils.printLog(
                                                                  "network status : $status");
                                                              setState(
                                                                      () {
                                                                    _isNetworkConnected =
                                                                        status;
                                                                    _isLoading =
                                                                        status;
                                                                    if (_isNetworkConnected) {
                                                                      String
                                                                      responseType =
                                                                          "deleteSecurity";
                                                                      String
                                                                      result =
                                                                      selectedSecurity
                                                                          .toString(); // Convert the list to a string
                                                                      result =
                                                                          result
                                                                              .substring(
                                                                              1,
                                                                              result
                                                                                  .length -
                                                                                  1);
                                                                      print(
                                                                          result);

                                                                      String
                                                                      editShiftTimeURL =
                                                                          '${Constant
                                                                          .deleteMultipleSecurityURL}?securityIdList=$result';

                                                                      NetworkUtils
                                                                          .putUrlNetWorkCall(
                                                                        editShiftTimeURL,
                                                                        this,
                                                                        responseType,
                                                                      );
                                                                    } else {
                                                                      Utils
                                                                          .printLog(
                                                                          "else called");
                                                                      _isLoading =
                                                                      false;
                                                                      Utils
                                                                          .showToast(
                                                                          Strings
                                                                              .NETWORK_CONNECTION_ERROR);
                                                                    }
                                                                  });
                                                            });

                                                        Navigator.pop(
                                                            context);
                                                      },
                                                      child:
                                                      const Text(
                                                          "Ok"),
                                                    ),
                                                  ),
                                                   SizedBox(
                                                    width: FontSizeUtil.CONTAINER_SIZE_10,
                                                  ),
                                                ],
                                              ),
                                               SizedBox(
                                                height: FontSizeUtil.CONTAINER_SIZE_20,
                                                width: FontSizeUtil.SIZE_05,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          right: 0.0,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(
                                                  context);
                                            },
                                            child:  Align(
                                              alignment: Alignment
                                                  .topRight,
                                              child: Icon(
                                                  Icons.close,
                                                  size: FontSizeUtil.CONTAINER_SIZE_25,
                                                  color:
                                                  Colors.red),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                                  : Fluttertoast.showToast(
                                msg: 'Please select any security',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                              );
                            },
                            child: const Text("Delete",style: TextStyle(color: Colors.white),),
                          ),
                        )
                            : Container(),
                        const FooterScreen(),
                      ],
                    ),
                  ),
                ),
                if (_isLoading) const Positioned(child: LoadingDialog()),
              ],
            ),
          ),
        ),

        floatingActionButton: userType == "ROLE_ADMIN" ? Padding(
          padding: EdgeInsets.only(bottom: FontSizeUtil.CONTAINER_SIZE_50, left: FontSizeUtil.CONTAINER_SIZE_50),
          child:
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                createRoute(
                  GateSecurityRegistrationScreen(navigatorListener: this),
                ),
              );
            },
            backgroundColor: const Color(0xff1B5694),
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
          ),
        ):Container(),
      ),
    );
  }

  _deletePollData() {
    setState(() {
      securityListLists
          .removeWhere((item) => selectedSecurity.contains(item.userId));
      selectedSecurity.clear();
    });
  }

  @override
  onNavigatorBackPressed() {
    _getAllSecurity();
  }
}
