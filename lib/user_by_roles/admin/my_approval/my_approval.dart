import 'dart:convert';

import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/model/waiting_registered_tenant.model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/my_approval/view_tenant_owner.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResidentMyApprovalList extends StatefulWidget {
  const ResidentMyApprovalList({super.key});

  @override
  State<ResidentMyApprovalList> createState() => _ResidentMyApprovalListState();
}

class _ResidentMyApprovalListState extends State<ResidentMyApprovalList>
    with ApiListener, NavigatorListener {
  String baseImageIssueApi = '';
  List notifications = [];
  bool _isNetworkConnected = false, _isLoading = false;
  String securityDeviceToken = '';
  String residentName = '';
  String visitorName = '';
  int selectedUserId = 0;
  String securityToken = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Color _containerBorderColor1 = Colors.white;
  Color _containerBorderColor2 = Colors.white;
  Color _boxShadowColor1 = const Color.fromARGB(255, 100, 100, 100);
  Color _boxShadowColor2 = const Color.fromARGB(255, 100, 100, 100);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    // readJson();
    _getNotificationList();
    super.initState();
  }

  void editUserChoice(users) {}

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (notifications.isEmpty && notifications != null) {
      content = _isLoading
          ? Container()
          : Center(
              child: Text(
              "No new request from owner/tenant",
              style: AppStyles.heading(context),
              textAlign: TextAlign.center,
            ));
    } else {
      content = ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          var user = notifications[index];
          return GestureDetector(
            onTap: () {
              selectedUserId = user.requestId;
              Navigator.of(context).push(
                createRoute(
                  ViewTenantOwnerScreen(
                      blockName: user.blockName,
                      flatNumber: user.flatNumber,
                      userId: user.requestId,
                      userName: user.fullName,
                      emailId: user.email,
                      mobile: user.phone,
                      role: user.role,
                      status: "Waiting",
                      documentImage: user.document,
                      navigatorListener: this,
                      screen: "current"),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
              child: Card(
                elevation: FontSizeUtil.SIZE_02,
                child: Container(
                  decoration: AppStyles.decoration(context),
                  child: Padding(
                    padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(FontSizeUtil.SIZE_01),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      FontSizeUtil.CONTAINER_SIZE_50),
                                  child: (notifications[index].profilePicture !=
                                              null &&
                                          notifications[index]
                                              .profilePicture!
                                              .isNotEmpty)
                                      ? Image.network(
                                          '$baseImageIssueApi${notifications[index].profilePicture.toString()}',
                                          fit: BoxFit.cover,
                                          height:
                                              FontSizeUtil.CONTAINER_SIZE_75,
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
                                      padding: EdgeInsets.only(
                                          left: FontSizeUtil.SIZE_08),
                                      child: Text(
                                          "${notifications[index].fullName}",
                                          style: AppStyles.heading(context)),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: FontSizeUtil.SIZE_08),
                                          child: Text(
                                            "${notifications[index].role}",
                                            style: TextStyle(
                                              fontSize: FontSizeUtil
                                                  .CONTAINER_SIZE_16,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: FontSizeUtil.SIZE_08),
                                      child: Text(
                                        "${notifications[index].email}",
                                        style: const TextStyle(
                                          color: Color(0xff1B5694),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: FontSizeUtil.SIZE_05),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: FontSizeUtil.SIZE_08),
                                          child: Text(
                                            "${notifications[index].phone}",
                                            style: const TextStyle(
                                              color: Color(0xff1B5694),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward,
                              color: Color(0xff1B5694),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    selectedUserId =
                                        notifications[index].requestId;
                                  });
                                  var userId = notifications[index].requestId;
                                  _approveRejectNetworkCall(
                                      'approve', userId, "trimmedOption");
                                },
                                icon: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                label: Text(Strings.APPROVAL_APPROVE_TEXT,
                                    style: AppStyles.call(context)),
                              ),
                            ),
                            Container(
                              color: Colors.grey,
                              height: 40,
                              width: 0.7,
                            ),
                            Expanded(
                              child: TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    selectedUserId =
                                        notifications[index].requestId;
                                  });
                                  var userId = notifications[index].requestId;
                                  // _approveRejectNetworkCall('reject', userId);
                                  _showCustomDialog(context,
                                      _containerBorderColor1, _boxShadowColor1);
                                },
                                icon: const Icon(
                                  Icons.cancel_outlined,
                                  color: Color.fromARGB(250, 200, 0, 0),
                                ),
                                label: Text(Strings.APPROVAL_REJECT_TEXT,
                                    style: AppStyles.reject(context)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
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

  _approveRejectNetworkCall(
      var isApproved, var notificationId, var trimmedOption) async {
    print(isApproved);
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "isApproved";

          // trimmedOption
          if (isApproved == "reject") {

            https://localhost:8082/smp/admin/approveTheResidentOrTanent?userId=86&status=REJECTED&reason=u dont have proper documents
            String isApprovedUrl =
                '${Constant.approvedRejectURL}?userId=${notificationId}&status=$isApproved&reason=$trimmedOption';

            NetworkUtils.postUrlNetWorkCall(isApprovedUrl, this, responseType);
          } else {
            String isApprovedUrl =
                '${Constant.approvedRejectURL}?userId=${notificationId}&status=$isApproved';

            NetworkUtils.postUrlNetWorkCall(isApprovedUrl, this, responseType);
          }
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  _getNotificationList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id');
    final apartmntId = prefs.getInt('apartmentId');

    setState(() {
      baseImageIssueApi = BaseApiImage.baseImageUrl(apartmntId!, "profile");
    });

    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "allDevice";

          String allDeviceURL =
              '${Constant.waitingUserForApprovalURL}?apartmentId=$apartmntId';

          NetworkUtils.getNetWorkCall(allDeviceURL, responseType, this);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  void _showCustomDialog(
      BuildContext context, containerBorderColor1, boxShadowColor) {
    String newOption = '';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              width: 330,
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
                              padding: EdgeInsets.only(
                                  left: FontSizeUtil.CONTAINER_SIZE_30),
                              child: Text(
                                Strings.PURPOSE_FOR_REJECT_TEXT,
                                style: TextStyle(
                                  color: const Color.fromRGBO(27, 86, 148, 1.0),
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
                      padding: EdgeInsets.symmetric(
                          horizontal: FontSizeUtil.CONTAINER_SIZE_18),
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
                                      borderRadius: BorderRadius.circular(
                                          FontSizeUtil.CONTAINER_SIZE_10),
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
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(Strings.EMOJI_DENY_REGEX)
                                      ],
                                      maxLines:10 ,
                                      style: const TextStyle(
                                          color: Colors.black87),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                          left:FontSizeUtil.CONTAINER_SIZE_10,
                                            top:
                                                FontSizeUtil.CONTAINER_SIZE_14),

                                        hintText: Strings
                                            .PURPOSE_FOR_REJECT_PLACEHOLDER,
                                        hintStyle: const TextStyle(
                                            color: Colors.black38),
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value.trim().length <= 1 ||
                                            value.trim().length > 200) {
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
                                    backgroundColor: const Color(0xff1B5694),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          FontSizeUtil.CONTAINER_SIZE_20),
                                      side: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 0, 123, 255),
                                          width: FontSizeUtil.SIZE_02),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            FontSizeUtil.CONTAINER_SIZE_15,
                                        vertical: FontSizeUtil.SIZE_05),
                                  ),
                                  onPressed: () {
                                    String trimmedOption = newOption.trim();
                                    if (trimmedOption.isNotEmpty) {
                                      _approveRejectNetworkCall('reject',
                                          selectedUserId, trimmedOption);
                                      Navigator.pop(context);
                                    }
                                    else{
                                      Utils.showToast(Strings.PUR_REQ_TXT);
                                    }
                                  },
                                  child: const Text(
                                    Strings.REJECT_TEXT,
                                    style: TextStyle(color: Colors.white),
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

  _removeList() {
    setState(() {
      notifications.removeWhere((item) => selectedUserId == item.requestId);
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
        if (responseType == 'allDevice') {
          var jsonResponse = json.decode(response);
          _isLoading = false;
          notifications = [];
          WaitingRegisteredTenantModel notice =
              WaitingRegisteredTenantModel.fromJson(jsonResponse);
          if (notice.status == 'success' && notice.value != null) {
            notifications = notice.value!;
            print(notifications);
          }
        } else if (responseType == "isApproved") {
          _isLoading = false;
          ResponceModel responceModel =
              ResponceModel.fromJson(json.decode(response));
          if (responceModel.status == "success") {
            successDialogWithListner(context, responceModel.message!,
                const ResidentMyApprovalList(), this);
            _removeList();
          } else {
            Utils.showToast(responceModel.message!);
          }
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      Utils.printLog("Error text === $response");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  onNavigatorBackPressed() {
    _removeList();
  }
}
