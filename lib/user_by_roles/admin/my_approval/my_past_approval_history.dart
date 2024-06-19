import 'dart:convert';
import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/model/my_past_approvals.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/my_approval/view_tenant_owner.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/size_utility.dart';

class MyPastApprovalHistoryList extends StatefulWidget {
  const MyPastApprovalHistoryList({super.key});

  @override
  State<MyPastApprovalHistoryList> createState() =>
      _MyPastApprovalHistoryListState();
}

class _MyPastApprovalHistoryListState extends State<MyPastApprovalHistoryList>
    with ApiListener, NavigatorListener {
  int selectedUserId = 0;
  String securityToken = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String baseImageIssueApi = '';
  List notifications = [];
  bool _isNetworkConnected = false, _isLoading = false;
  String securityDeviceToken = '';
  String residentName = '';

  String visitorName = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

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
              Strings.NO_NEW_OWNER_TEXT,
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
                      flatNumber: user.flatName,
                      userId: user.requestId,
                      userName: user.ownerName,
                      emailId: user.emailId,
                      mobile: user.mobile,
                      documentImage: user.document,
                      role: user.appliedRoleFor,
                      status: user.status,
                      navigatorListener: this,
                      screen: "past"),
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
                    padding:  EdgeInsets.all(FontSizeUtil.SIZE_08),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_50),
                                  child: (notifications[index].image != null &&
                                          notifications[index]
                                              .image!
                                              .isNotEmpty)
                                      ? Image.network(
                                          '$baseImageIssueApi${notifications[index].image.toString()}',
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
                                      padding: EdgeInsets.only(left: FontSizeUtil.SIZE_08),
                                      child: Text(
                                          "${notifications[index].ownerName}",
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
                                          padding:
                                              EdgeInsets.only(left: FontSizeUtil.SIZE_08),
                                          child: Text(
                                            "${notifications[index].appliedRoleFor}",
                                            style: TextStyle(
                                              fontSize: FontSizeUtil.CONTAINER_SIZE_16,
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
                                      padding: EdgeInsets.only(left: FontSizeUtil.SIZE_08),
                                      child: Text(
                                        "${notifications[index].emailId}",
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
                                          padding:
                                               EdgeInsets.only(left: FontSizeUtil.SIZE_08),
                                          child: Text(
                                            "${notifications[index].mobile}",
                                            style: const TextStyle(
                                              color: Color(0xff1B5694),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: FontSizeUtil.SIZE_08),
                                      child: Text(
                                        "${notifications[index].status}",
                                        style: TextStyle(
                                          fontSize:
                                              FontSizeUtil.LABEL_TEXT_SIZE_14,
                                          color: notifications[index].status !=
                                                  "REJECTED"
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward,
                              color: const Color(0xff1B5694),
                            ),
                          ],
                        ),
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
              if (_isLoading)
                const Positioned(child: LoadingDialog()),
            ],
          ),
        ),
      ),
    );
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
              '${Constant.pastApprovalURL}?apartmentId=$apartmntId';

          NetworkUtils.getNetWorkCall(allDeviceURL, responseType, this);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
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
          MyPastApprovalsModel notice =
              MyPastApprovalsModel.fromJson(jsonResponse);
          if (notice.status == 'success' && notice.values != null) {
            notifications = notice.values!;
            Utils.printLog("$jsonResponse");
          }
        } else if (responseType == "isApproved") {
          _isLoading = false;
          ResponceModel responceModel =
              ResponceModel.fromJson(json.decode(response));
          if (responceModel.status == "success") {
            successDialogWithListner(context, responceModel.message!,
                const MyPastApprovalHistoryList(), this);
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
