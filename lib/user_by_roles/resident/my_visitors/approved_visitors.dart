import 'dart:convert';

import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/error_dialog.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/model/all_type_visitor_model.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/AlertListener.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/resident/my_visitors/my_visitors_list.dart';
import 'package:SMP/user_by_roles/resident/whatsapp.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/avatar.dart';

import 'package:SMP/widget/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/resident_notification_model.dart';
import 'edit_pre_approved_guest.dart';

class ResidentApprovedVisitorsList extends StatefulWidget {
  const ResidentApprovedVisitorsList({super.key});

  @override
  State<ResidentApprovedVisitorsList> createState() =>
      _ResidentApprovedVisitorsListState();
}

class _ResidentApprovedVisitorsListState
    extends State<ResidentApprovedVisitorsList>
    with ApiListener, AlertListener, NavigatorListener {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  List originalUsers = [];
  List visitorslist = [];
  String query = "";
  int visitorId = 0;
  String baseImageIssueApi = '';
  bool _isNetworkConnected = false, _isLoading = true;
  String securityDeviceToken = '';
  String residentName = '';

  String visitorName = '';

  int _selectedVisitorId = -1;

  String userName = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();
    _getNotificationList();
    _smpStorage();
  }

  void _smpStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var id = prefs.getInt('id');
    var apartId = prefs.getInt('apartmentId');

    var userNam = prefs.getString('userName');

    setState(() {
      // token = token!;

      userName = userNam!;
    });
  }

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

  String securityToken = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void editUserChoice(users) {}

  @override
  Widget build(BuildContext context) {
    getList();

    Widget content;

    if (originalUsers.isEmpty && originalUsers != null) {
      content = _isLoading
          ? Container()
          : Center(
              child: Text(
              Strings.NO_VISITORS_TEXT,
              style: AppStyles.heading(context),
            ));
    } else {
      content = ListView.builder(
        itemCount: originalUsers.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
            child: Card(
              elevation: 2,
              child: Container(
                decoration: AppStyles.decoration(context),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: FontSizeUtil.SIZE_08,
                          left: FontSizeUtil.SIZE_08),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
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
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: FontSizeUtil.SIZE_08),
                                          child: Text(
                                            "${originalUsers[index].name}",
                                            style: TextStyle(
                                              color: const Color(0xff1B5694),
                                              fontSize: FontSizeUtil
                                                  .CONTAINER_SIZE_18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditPreApproveGuest(
                                                    visitorId:
                                                        originalUsers[index]
                                                            .visitorId,
                                                    guestName:
                                                        originalUsers[index]
                                                            .name,
                                                    mobile: originalUsers[index]
                                                        .mobile,
                                                    fromDate: originalUsers[index]
                                                        .chekinTime,
                                                    toDate: originalUsers[index]
                                                        .checkOutTime,
                                                    numberOfGuest:
                                                        originalUsers[index]
                                                                .numberOfGuest ??
                                                            0,
                                                    purposeToMeet:
                                                        originalUsers[index]
                                                            .purpose,
                                                    profilePicture:
                                                        originalUsers[index]
                                                            .image,
                                                    baseImageIssueApi:
                                                        baseImageIssueApi!,
                                                    navigatorListener: this),
                                              ),
                                            );
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                right: FontSizeUtil
                                                    .CONTAINER_SIZE_15,
                                                top: FontSizeUtil
                                                    .CONTAINER_SIZE_10),
                                            child: const Icon(
                                              Icons.edit,
                                              color: Color.fromARGB(
                                                  181, 27, 85, 148),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: FontSizeUtil.SIZE_08),
                                    child: Container(
                                      child: Text(
                                        "${originalUsers[index].purpose}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize:
                                              FontSizeUtil.CONTAINER_SIZE_18,
                                          // fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: FontSizeUtil.SIZE_03),
                                originalUsers[index].chekinTime.isNotEmpty
                                    ? Align(
                                        alignment: Alignment.topLeft,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_month,
                                              color: Colors.green,
                                              size: FontSizeUtil
                                                  .CONTAINER_SIZE_25,
                                            ),
                                            Expanded(
                                              child: Text(
                                                DateFormat('y-MM-dd hh:mm a')
                                                    .format(DateTime.parse(
                                                        originalUsers[index]
                                                            .chekinTime)),
                                                style: const TextStyle(
                                                  color: Color(0xff1B5694),
                                                ),
                                                // style: AppStyles.blockText(context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                originalUsers[index].checkOutTime.isNotEmpty
                                    ? Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_month,
                                            color:
                                                Color.fromARGB(250, 200, 0, 0),
                                            size:
                                                FontSizeUtil.CONTAINER_SIZE_25,
                                          ),
                                          Expanded(
                                            child: Text(
                                              DateFormat('y-MM-dd hh:mm a')
                                                  .format(DateTime.parse(
                                                      originalUsers[index]
                                                          .checkOutTime)),
                                              style: const TextStyle(
                                                color: Color(0xff1B5694),
                                              ),
                                              // style: AppStyles.blockText(context),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
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
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              var address = prefs.getString(Strings.ADDRESS);

                              var pinCode = prefs.getString(Strings.PINCODE);
                              var state = prefs.getString(Strings.STATE);

                              print("object");
                              Navigator.of(context).push(createRoute(Whatsapp(
                                userName: userName ?? "",
                                guestId: originalUsers[index].passcode ?? "",
                                fromDate: originalUsers[index].chekinTime ?? "",
                                toDate: originalUsers[index].checkOutTime ?? "",
                                flatNumber:
                                    originalUsers[index].residentFlat ?? "",
                                blockNumber:
                                    originalUsers[index].residentBlock ?? "",
                                floorNumber:
                                    originalUsers[index].residentFloor ?? "",
                                address1: address ?? "",
                                state: state ?? "",
                                countary: "",
                                pincode: pinCode ?? "",
                                type: "pree-approve",
                                navigatorListener: this,
                              )));
                            },
                            icon: const Icon(
                              Icons.share,
                              color: Color(0xff1B5694),
                            ),
                            label: Text(
                              "Share",
                              style: AppStyles.share(context),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: FontSizeUtil.SIZE_03),
                          child: Container(
                            color: Colors.grey[350],
                            height: FontSizeUtil.CONTAINER_SIZE_35,
                            width: 0.7,
                            // width: double.infinity,
                          ),
                        ),
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () {
                              Utils.makingPhoneCall(
                                  originalUsers[index].mobile);
                            },
                            icon: const Icon(
                              Icons.call,
                              color: Colors.green,
                            ),
                            label: Text("Call", style: AppStyles.call(context)),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: FontSizeUtil.SIZE_03),
                          child: Container(
                            color: Colors.grey[350],
                            height: FontSizeUtil.CONTAINER_SIZE_35,
                            width: 0.7,
                            // width: double.infinity,
                          ),
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
                                visitorId = originalUsers[index].visitorId;
                              });
                              Utils.showRejectVisitorDialog(context, this);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Color.fromARGB(250, 200, 0, 0),
                            ),
                            label: Text(Strings.REJECT_TEXT,
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
                      horizontal: FontSizeUtil.CONTAINER_SIZE_15,
                    ),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
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
                                  borderRadius: BorderRadius.circular(
                                      FontSizeUtil.CONTAINER_SIZE_10),
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
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r"[a-zA-Z0-9._%+-@]+|\s"),
                                    ),
                                  ],
                                  controller: _searchController,
                                  keyboardType: TextInputType.text,
                                  style: AppStyles.heading1(context),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        top: FontSizeUtil.CONTAINER_SIZE_14),
                                    hintText: Strings.SEARCH_BY_N_P_PU,
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
              if (_isLoading) // Display the loader if _isLoading is true
                const Positioned(child: LoadingDialog()),
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
              '${Constant.cancelEntryURL}?guestId=${notificationId}';

          NetworkUtils.postUrlNetWorkCall(isApprovedUrl, this, responseType);
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
    var selectedFlatId = prefs.getString('flatId');

    setState(() {
      baseImageIssueApi = BaseApiImage.baseImageUrl(id!, "profile");
    });

    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "allDevice";

          String allDeviceURL =
              '${Constant.allTypeOfVisitorsURL}?flatId=$selectedFlatId&userId=$id&status=APPROVED';

          NetworkUtils.getNetWorkCall(allDeviceURL, responseType, this);
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
      setState(() async {
        _isLoading = false;
        if (responseType == 'allDevice') {
          var jsonResponse = json.decode(response);
          _isLoading = false;

          AllTypeVisitorModel notice =
              AllTypeVisitorModel.fromJson(jsonResponse);

          if (notice.status == 'success' && notice.value != null) {
            visitorslist = [];
            visitorslist = notice.value!;
          } else if (notice.status == 'error') {
            visitorslist = [];
          }
        } else if (responseType == "isApproved") {
          ResponceModel responceModel =
              ResponceModel.fromJson(json.decode(response));
          if (responceModel.status == "error") {
            errorDialog(context, responceModel.message!,
                const ResidentApprovedVisitorsList());
            _isLoading = false;
          } else {
            successDialogWithListner(context, responceModel.message!,
                const ResidentApprovedVisitorsList(), this);
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
  onNavigatorBackPressed() {
    _getNotificationList();
    Utils.printLog("Removve visitor called $_selectedVisitorId");
    setState(() {
      visitorslist.removeWhere((item) => _selectedVisitorId == item.visitorId);
      _isLoading = false;
    });
  }

  @override
  onRightButtonAction(BuildContext context) {
    _approveRejectNetworkCall('reject', visitorId);
  }
}
