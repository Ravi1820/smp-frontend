import 'dart:convert';

import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/error_dialog.dart';
import 'package:SMP/contants/push_notificaation_key.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/model/all_type_visitor_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';

import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResidentWaitingVisitorsList extends StatefulWidget {
  const ResidentWaitingVisitorsList({super.key});

  @override
  State<ResidentWaitingVisitorsList> createState() =>
      _ResidentWaitingVisitorsListListState();
}

class _ResidentWaitingVisitorsListListState
    extends State<ResidentWaitingVisitorsList>
    with ApiListener, NavigatorListener {
  List originalUsers = [];
  List visitorslist = [];
  String query = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  String baseImageIssueApi = '';
  bool _isNetworkConnected = false, _isLoading = true;
  String securityDeviceToken = '';
  String residentName = '';
  int _selectedVisitorId = -1;

  Color _containerBorderColor2 = Colors.white;
  Color _boxShadowColor2 = const Color.fromARGB(255, 100, 100, 100);

  void _filterList(String query) {
    setState(() {
      this.query = query;
    });
  }

  void getList() {
    setState(() {
      if (query.isNotEmpty) {
        originalUsers = visitorslist.where((user) {
          final nameMatches =
              user.name.toLowerCase().contains(query.toLowerCase());
          final purposeMatches =
              user.purpose.toLowerCase().contains(query.toLowerCase());
          final phoneMatches =
              user.mobile.toLowerCase().contains(query.toLowerCase());

          return nameMatches || purposeMatches || phoneMatches;
        }).toList();
      } else {
        originalUsers = visitorslist;
      }
    });
  }

  String visitorName = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();
    _getNotificationList();
    _choose1();
  }

  String deviceId = '';

  _choose1() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission();

    final token = await fcm.getToken();
    print(token);
    if (token != null && token.isNotEmpty) {
      setState(() {
        deviceId = token;
      });
    }
  }

  String securityToken = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> getuserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');

    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "userInfo";

          String userProfileUrl = '${Constant.getUserProfileURL}?userId=$id';

          NetworkUtils.getNetWorkCall(userProfileUrl, responseType, this);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          //Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
          Utils.showCustomToast(context);
        }
      });
    });
  }

  void editUserChoice(users) {}

  @override
  Widget build(BuildContext context) {
    getList();

    BoxDecoration decoration = BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(255, 255, 255, 1),
          Color.fromRGBO(255, 255, 255, 1),
        ],
      ),
      borderRadius: BorderRadius.circular( FontSizeUtil.CONTAINER_SIZE_10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(1, 4),
        ),
      ],
    );

    Widget content;

    if (originalUsers != null && originalUsers.isEmpty) {
      content = _isLoading
          ? Container()
          : Center(
              child: Text(
              "No visitors",
              style: AppStyles.heading(context),
            ));
    } else {
      content = ListView.builder(
        itemCount: originalUsers.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:  EdgeInsets.all( FontSizeUtil.SIZE_08),
            child: Card(
              elevation: 2,
              child: Container(
                decoration: decoration,
                child: Column(
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(top:  FontSizeUtil.SIZE_08, left: FontSizeUtil.SIZE_08),
                      child: Row(
                        children: [
                          Padding(
                            padding:  EdgeInsets.all( FontSizeUtil.SIZE_08),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular( FontSizeUtil.CONTAINER_SIZE_50),
                                child: (originalUsers[index].image != null &&
                                        originalUsers[index].image!.isNotEmpty)
                                    ? Image.network(
                                        '$baseImageIssueApi${originalUsers[index].image.toString()}',
                                        fit: BoxFit.cover,
                                        height: FontSizeUtil.CONTAINER_SIZE_75,
                                        width: FontSizeUtil.CONTAINER_SIZE_75,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const AvatarScreen();
                                        },
                                      )
                                    : const AvatarScreen()),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding:  EdgeInsets.only(left:  FontSizeUtil.SIZE_08),
                                    child: Text(
                                      "${originalUsers[index].name}",
                                      style:  TextStyle(
                                        color: Color(0xff1B5694),
                                        fontSize:  FontSizeUtil.CONTAINER_SIZE_20,
                                        fontWeight: FontWeight.bold,
                                      ),

                                    ),
                                  ),
                                ),
                                 SizedBox(height:  FontSizeUtil.SIZE_02),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding:  EdgeInsets.only(left:  FontSizeUtil.SIZE_08),
                                    child: Text(
                                      "${originalUsers[index].purpose}",
                                      style: TextStyle(
                                        fontSize:  FontSizeUtil.CONTAINER_SIZE_16,
                                        // fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ),
                                 SizedBox(height: FontSizeUtil.SIZE_02),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                             EdgeInsets.only(left:  FontSizeUtil.SIZE_08),
                                        child: Text(
                                          "${originalUsers[index].mobile}",
                                          style: const TextStyle(
                                            color: Color(0xff1B5694),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                originalUsers[index].securityName.isNotEmpty
                                  ?
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                               EdgeInsets.only(left:  FontSizeUtil.SIZE_08),
                                          child: Text(
                                            "${Strings.ALLOWED_BY} ${originalUsers[index].securityName}",
                                            style: const TextStyle(
                                              color: Color(0xff1B5694),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ):Container(),
                                 SizedBox(height: FontSizeUtil.SIZE_04),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [


                        Expanded(
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() {
                                securityDeviceToken =
                                    originalUsers[index].securityDeviceToken;
                                residentName =
                                    originalUsers[index].residentName;
                                visitorName = originalUsers[index].name;
                              });
                              _approveRejectNetworkCall(
                                  'approve', originalUsers[index].visitorId);
                            },
                            icon: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                            label:
                                Text("Approve", style: AppStyles.call(context)),
                          ),
                        ),

                        Container(
                          color: Colors.grey,
                          height:  FontSizeUtil.CONTAINER_SIZE_40,
                          width: 0.7,
                          // width: double.infinity,
                        ),


                        Expanded(
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() {
                                securityDeviceToken =
                                    originalUsers[index].securityDeviceToken;

                                residentName =
                                    originalUsers[index].residentName;

                                visitorName = originalUsers[index].name;
                              });

                              _approveRejectNetworkCall(
                                  'reject', originalUsers[index].visitorId);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Color.fromARGB(250, 200, 0, 0),
                            ),
                            label: Text("Reject",
                                style: AppStyles.reject(context)),
                          ),
                        ),
                      ],
                    )


                  ],
                ),
              ),
            ),
          );
        },
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
        body: AbsorbPointer(
          absorbing: _isLoading,
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal:  FontSizeUtil.CONTAINER_SIZE_15,
                    ),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[
                        Padding(
                          padding:  EdgeInsets.all( FontSizeUtil.SIZE_08),
                          child: FocusScope(
                            child: Focus(
                              onFocusChange: (hasFocus) {
                                setState(() {
                                  _containerBorderColor2 = hasFocus
                                      ? const Color.fromARGB(255, 0, 137, 250)
                                      : Colors.white;
                                  _boxShadowColor2 = hasFocus
                                      ? const Color.fromARGB(162, 63, 158, 235)
                                      : const Color.fromARGB(
                                          255, 100, 100, 100);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular( FontSizeUtil.CONTAINER_SIZE_10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _boxShadowColor2,
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: _containerBorderColor2,
                                  ),
                                ),
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(Strings.EMOJI_DENY_REGEX)
                                  ],
                                  controller: _searchController,
                                  keyboardType: TextInputType.text,
                                  style: AppStyles.heading1(context),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                         EdgeInsets.only(top: FontSizeUtil.CONTAINER_SIZE_14),
                                    hintText:
                                        "Search by Name, Phone, Purpose...",
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon: _searchController
                                            .text.isNotEmpty
                                        ? IconButton(
                                            onPressed: () {
                                              _searchController.clear();
                                              _filterList('');
                                              FocusScope.of(context).unfocus();
                                            },
                                            icon: const Icon(Icons.clear),
                                          )
                                        : null,
                                  ),
                                  onChanged: _filterList,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: content),
                ],
              ),
              if (_isLoading) const Positioned(child: LoadingDialog()),
            ],
          ),
        ),
      ),
    );
  }

  _approveRejectNetworkCall(var isApproved, var notificationId) async {
    setState(() {
      _selectedVisitorId = notificationId;
    });

    print(isApproved);
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "isApproved";
          String isApprovedUrl =
              '${Constant.approveRejectVisitorURL}?visitoId=${notificationId}&permission=$isApproved';

          NetworkUtils.putUrlNetWorkCall(isApprovedUrl, this, responseType);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
        //  Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
          Utils.showCustomToast(context);
        }
      });
    });
  }



  _getNotificationList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    var apartmentId = prefs.getInt('apartmentId');

    var selectedFlatId = prefs.getString(Strings.FLATID);

    setState(() {
      baseImageIssueApi = BaseApiImage.baseImageUrl(apartmentId!, "profile");

      Utils.printLog(baseImageIssueApi);
    });

    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "allDevice";

          // ?flatId=&userId=&status=

          String allDeviceURL =
              '${Constant.allTypeOfVisitorsURL}?flatId=$selectedFlatId&userId=$id&status=WAITING';

          NetworkUtils.getNetWorkCall(allDeviceURL, responseType, this);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
        //  Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
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
      setState(() async {
        _isLoading = false;
        if (responseType == 'allDevice') {
          var jsonResponse = json.decode(response);
          _isLoading = false;
          visitorslist = [];
          AllTypeVisitorModel notice =
              AllTypeVisitorModel.fromJson(jsonResponse);
          if (notice.status == 'success' && notice.value != null) {
            visitorslist = notice.value!;
          }
        } else if (responseType == "isApproved") {
          _isLoading = false;

          if (response is String) {
            if (response == "Visitor rejected") {
              // _sendPushNotification("Visitor got Rejected");

              errorDialogWithListner(context, "Visitor rejected",
                  const ResidentWaitingVisitorsList(), this);
            } else if (response == "Visitor approved") {
              // Send notification for approval
              // _sendPushNotification("Visitor got approved");

              successDialogWithListner(context, "Visitor approved",
                  const ResidentWaitingVisitorsList(), this);
            }
          }
        }
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      Utils.printLog("Error text === $response");
    }
  }

  @override
  onNavigatorBackPressed() {
    //
    Utils.printLog("Removve visitor called $_selectedVisitorId");
    setState(() {
      visitorslist.removeWhere((item) => _selectedVisitorId == item.visitorId);
    });
  }

  _sendPushNotification(String type) {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          _isLoading = true;
          var responseType = 'push';
          String keyName = "";

          final Map<String, dynamic> bodyData = <String, dynamic>{
            "title": "$visitorName $type by $residentName",
            "visitorName": visitorName,
            "residentName": residentName,
            "action": type
          };

          final Map<String, dynamic> data = <String, dynamic>{
            "to": securityDeviceToken,
            "data": bodyData,
          };
          String partURL = Constant.pushNotificationURL;
          NetworkUtils.pushNotificationWorkCall(
              partURL, keyName, data, this, responseType);
        }
      });
    });
  }
}
