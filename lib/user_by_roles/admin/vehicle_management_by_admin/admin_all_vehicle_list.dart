

import 'dart:convert';
import 'package:SMP/components/admin_vehicle_list.dart';
import 'package:SMP/components/association_list_card.dart';
import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/success_alert.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/model/team_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/manage_team/add_team_member_list.dart';
import 'package:SMP/user_by_roles/admin/vehicle_management_by_admin/add_slots_to_resident.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminALlVehicleListScreen extends StatefulWidget {
  const AdminALlVehicleListScreen({super.key});
  @override
  State<AdminALlVehicleListScreen> createState() {
    return _AdminALlVehicleListState();
  }
}

class _AdminALlVehicleListState extends State<AdminALlVehicleListScreen>
    with ApiListener, NavigatorListener {
  final TextEditingController _searchController = TextEditingController();
  bool setShowlistflag = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isNetworkConnected = false, _isLoading = true;
  List selectedmember = [];

  final Color _containerBorderColor1 = Colors.white;
  final Color _boxShadowColor1 = const Color.fromARGB(255, 100, 100, 100);

  List originalUsers = [];
  List teamMemberlist = [];
  String query = "";
  String baseImageApi = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    _getFlatList();
    _getImage();
  }

  _getImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('apartmentId');

    setState(() {
      baseImageApi = BaseApiImage.baseImageUrl(id!, "profile");
    });
  }

  void editUserChoice(users) {}


  void _filterList(String query) {
    setState(() {
      this.query = query;
    });
  }

  void getList() {
    setState(() {
      if (query.isNotEmpty) {
        originalUsers = teamMemberlist.where((user) {
          final nameMatches =
          user.visitorName.toLowerCase().contains(query.toLowerCase());
          final purposeMatches =
          user.purpose.toLowerCase().contains(query.toLowerCase());
          return nameMatches || purposeMatches;
        }).toList();
      } else {
        originalUsers = teamMemberlist;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getList();
    Widget content;
    if (originalUsers.isNotEmpty) {
      content = Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: AdminVehicleListViewCard(

          users: originalUsers,
          baseImageIssueApi: baseImageApi,

        ),
      );
    } else {
      content = _isLoading
          ? Container()
          : Center(
        child: Text(
          Strings.NO_VEHICLE_LABEL,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w600,
            color: const Color(0xff1B5694),
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
            title: Strings.VEHICLE_LIST_HEADER,
            profile: () async {
              Navigator.of(context)
                  .push(createRoute(DashboardScreen(isFirstLogin: false)));
            },
          ),
        ),
        body: AbsorbPointer(
          absorbing: _isLoading,
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
                      Expanded(child: content),
                      const FooterScreen(),
                    ],
                  ),
                ),
              ),
              if (_isLoading) const Positioned(child: LoadingDialog()),
            ],
          ),
        ),
        floatingActionButton: Stack(
          children: [
            Positioned(
              bottom: FontSizeUtil.CONTAINER_SIZE_190,
              right: FontSizeUtil.CONTAINER_SIZE_10,
              child: selectedmember.isNotEmpty
                  ? InkWell(
                onTap: () {
                  _openAddOptionDialog(
                      context, _containerBorderColor1, _boxShadowColor1);
                },
                child: Container(
                  width: FontSizeUtil.CONTAINER_SIZE_60,
                  height: FontSizeUtil.CONTAINER_SIZE_60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff1B5694),
                  ),
                  child: const Icon(
                    Icons.message,
                    color: Colors.white,
                  ),
                ),
              )
                  : Container(),
            ),
            Positioned(
              bottom: FontSizeUtil.CONTAINER_SIZE_120,
              right: FontSizeUtil.CONTAINER_SIZE_10,
              child: selectedmember.isNotEmpty
                  ? InkWell(
                onTap: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding:
                         EdgeInsets.only(top: FontSizeUtil.CONTAINER_SIZE_10, right: FontSizeUtil.CONTAINER_SIZE_10),
                        content: Container(
                          margin: const EdgeInsets.only(
                              left: 0.0, right: 0.0),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                  top: FontSizeUtil.CONTAINER_SIZE_18,
                                ),

                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                     Icon(
                                      Icons.error,
                                      size: FontSizeUtil.CONTAINER_SIZE_65,
                                      color: Colors.red,
                                    ),
                                     SizedBox(height: FontSizeUtil.CONTAINER_SIZE_16),
                                     Center(
                                      child: Text(
                                        Strings.WARNING_TEXT1,
                                        style: TextStyle(
                                          fontSize: FontSizeUtil.CONTAINER_SIZE_25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                     SizedBox(height:  FontSizeUtil.CONTAINER_SIZE_16),
                                     Text(
                                      Strings.DELETE_VEHICLE_CONFIRM_TEXT,
                                      style: TextStyle(
                                        color:const Color.fromRGBO(
                                            27, 86, 148, 1.0),
                                        fontSize:  FontSizeUtil.CONTAINER_SIZE_16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                     SizedBox(
                                      height:  FontSizeUtil.CONTAINER_SIZE_20,
                                      width: FontSizeUtil.SIZE_05,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: FontSizeUtil.CONTAINER_SIZE_30,
                                          child: ElevatedButton(
                                            style:
                                            OutlinedButton.styleFrom(
                                              shape:
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    FontSizeUtil.CONTAINER_SIZE_20),
                                                side: const BorderSide(
                                                  width: 1,
                                                ),
                                              ),
                                              padding: EdgeInsets
                                                  .symmetric(
                                                horizontal:  FontSizeUtil.CONTAINER_SIZE_15,
                                                vertical: 0,
                                              ),
                                            ),
                                            onPressed: () {
                                              _deleteMember();
                                              Navigator.pop(context);
                                            },
                                            child: const Text(Strings.DELETE_VEHICLE_OK_TEXT),
                                          ),
                                        ),
                                        SizedBox(
                                          width:  FontSizeUtil.CONTAINER_SIZE_10,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height:  FontSizeUtil.CONTAINER_SIZE_20,
                                      width:  FontSizeUtil.SIZE_05,
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
                                  child:  Align(
                                    alignment: Alignment.topRight,
                                    child: Icon(
                                      Icons.close,
                                      size:  FontSizeUtil.CONTAINER_SIZE_25,
                                      color:const Color(0xff1B5694),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  width:  FontSizeUtil.CONTAINER_SIZE_60,
                  height:  FontSizeUtil.CONTAINER_SIZE_60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff1B5694),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              )
                  : Container(),
            ),
            Positioned(
              bottom:  FontSizeUtil.CONTAINER_SIZE_50,
              right:  FontSizeUtil.CONTAINER_SIZE_10,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(createRoute(
                      AddSlotToResidentScreen(navigatorListener: this)));
                },
                backgroundColor: const Color(0xff1B5694),
                foregroundColor: Colors.white,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAddOptionDialog(
      BuildContext context, containerBorderColor1, boxShadowColor) {
    String newOption = '';
    bool isSaveButtonDisabled = true; // Track the state of the "Save" button

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all( FontSizeUtil.SIZE_01),
          content: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              width:  FontSizeUtil.CONTAINER_SIZE_330,
              decoration: AppStyles.decoration(context),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                         Expanded(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(left:  FontSizeUtil.CONTAINER_SIZE_30),
                              child: Text(
                                'Message',
                                style: TextStyle(
                                  color:const Color.fromRGBO(27, 86, 148, 1.0),
                                  fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                            child: Container(
                              height: FontSizeUtil.CONTAINER_SIZE_30,
                              width: FontSizeUtil.CONTAINER_SIZE_30,
                              decoration: AppStyles.circle1(context),
                              child: const Icon(
                                Icons.close_sharp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: FontSizeUtil.CONTAINER_SIZE_18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: <Widget>[
                              FocusScope(
                                child: Focus(
                                  onFocusChange: (hasFocus) {
                                    setState(() {
                                      containerBorderColor1 = hasFocus
                                          ? const Color.fromARGB(
                                          255, 0, 137, 250)
                                          : Colors.white;
                                      boxShadowColor = hasFocus
                                          ? const Color.fromARGB(
                                          162, 63, 158, 235)
                                          : const Color.fromARGB(
                                          255, 100, 100, 100);
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: boxShadowColor,
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: containerBorderColor1,
                                      ),
                                    ),
                                    height: FontSizeUtil.CONTAINER_SIZE_100,
                                    child: TextFormField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      style: const TextStyle(
                                          color: Colors.black87),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                        EdgeInsets.only(top: 14),
                                        prefixIcon: Icon(
                                          Icons.description,
                                          color: Color(0xff4d004d),
                                        ),
                                        hintText: 'Enter Message',
                                        hintStyle:
                                        TextStyle(color: Colors.black38),
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value.trim().length <= 1 ||
                                            value.trim().length > 20) {
                                          setState(() {
                                            // showErrorMessage = true;
                                          });
                                        } else {
                                          setState(() {
                                            // showErrorMessage = false;
                                          });
                                          return null;
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        newOption = value;
                                      },
                                      onSaved: (value) {
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: FontSizeUtil.CONTAINER_SIZE_40,
                                child: ElevatedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_20),
                                      side:  BorderSide(
                                          color:
                                          const Color.fromARGB(255, 0, 123, 255),
                                          width: FontSizeUtil.SIZE_02),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: FontSizeUtil.CONTAINER_SIZE_15, vertical: FontSizeUtil.SIZE_05),
                                  ),
                                  onPressed: () {
                                    String trimmedOption = newOption.trim();
                                    if (trimmedOption.isNotEmpty) {
                                      _sendMessageToMember(trimmedOption);
                                      Navigator.of(context).pop();
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: "Please enter the message",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                      );
                                    }
                                  },
                                  child:  Row(
                                    children: [
                                      const Icon(Icons.send),
                                      SizedBox(width: FontSizeUtil.CONTAINER_SIZE_10),
                                     const Text(
                                        "Send",
                                      )
                                    ],
                                  ),
                                ),
                              ),
                               SizedBox(width: FontSizeUtil.CONTAINER_SIZE_10),
                            ],
                          ),
                           SizedBox(height: FontSizeUtil.CONTAINER_SIZE_15),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _deleteMember() {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "deleteMember";

          List selectedCategoryIds =
          selectedmember.map((category) => category.mamberId).toList();

          String result = selectedCategoryIds.toString();
          result = result.substring(1, result.length - 1);
          print(result);

          String editShiftTimeURL =
              '${Constant.deleteMemberURL}?membersId=$result';

          NetworkUtils.putUrlNetWorkCall(
            editShiftTimeURL,
            this,
            responseType,
          );
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  _getFlatList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apartId = prefs.getInt('apartmentId');
    try {
      Utils.getNetworkConnectedStatus().then((status) {
        Utils.printLog("network status : $status");
        setState(() {
          _isNetworkConnected = status;
          _isLoading = status;
          if (_isNetworkConnected) {
            String responseType = "teamMember";
            String teamMemberURL =
                '${Constant.teamMemberURL}?apartmentId=$apartId';
            NetworkUtils.getNetWorkCall(teamMemberURL, responseType, this);
          } else {
            Utils.printLog("else called");
            _isLoading = false;
            Utils.showCustomToast(context);
          }
        });
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  _sendMessageToMember(trimmedOption) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apartId = prefs.getInt('apartmentId');

    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() async {
        _isNetworkConnected = status;
        _isLoading = status;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        final userId = prefs.getInt('id');
        print(userId);
        if (_isNetworkConnected) {
          String responseType = "postMessage";

          List selectedCategoryIds =
          selectedmember.map((category) => category.userId).toList();

          String result = selectedCategoryIds.toString();
          result = result.substring(1, result.length - 1);
          print(result);

          var message = trimmedOption;

          String messageUrl =
              '${Constant.postChatMessageURL}?senderId=$userId&receiverId=$result&content=$message&apartmentId=$apartId';

          NetworkUtils.postUrlNetWorkCall(messageUrl, this, responseType);
        } else {
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
  onSuccess(response, String responseType) async {
    try {
      setState(() {
        _isLoading = false;

        if (responseType == 'teamMember') {
          var jsonResponse = json.decode(response);
          _isLoading = false;

          TeamModel notice = TeamModel.fromJson(jsonResponse);
          if (notice.status == 'success' && notice.messages != null) {
            teamMemberlist = notice.messages!;
          }
        } else if (responseType == "deleteMember") {
          ResponceModel responceModel =
          ResponceModel.fromJson(json.decode(response));

          if (responceModel.status == "success") {
            successAlert(context, responceModel.message!);



            List selectedCategoryIds =
            selectedmember.map((category) => category.mamberId).toList();

            teamMemberlist
                .removeWhere((item) => selectedCategoryIds.contains(item.mamberId));
            selectedmember.clear();
          } else {
            Utils.showToast(responceModel.message!);
          }
          setState(() {
            _isLoading = false;
          });
        } else if (responseType == "postMessage") {
          print("Success");
          // ResponceModel responceModel =
          //     ResponceModel.fromJson(json.decode(response));

          // if (responceModel.status == "success") {
          successAlert(
            context,
            response,
          );
          // } else {
          //   Utils.showToast(responceModel.message!);
          // }
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      Utils.printLog("Error === $response");
    }
  }

  @override
  onNavigatorBackPressed() {
    _getFlatList();
  }
}
