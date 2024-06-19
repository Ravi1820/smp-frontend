import 'dart:convert';
import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/error_dialog.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/model/all_approved_visitor_model.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/resident/my_visitors/my_visitors_list.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/avatar.dart';

import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResidentEnteredVisitorsList extends StatefulWidget {
  const ResidentEnteredVisitorsList({super.key});

  @override
  State<ResidentEnteredVisitorsList> createState() =>
      _ResidentEnteredVisitorsListState();
}

class _ResidentEnteredVisitorsListState
    extends State<ResidentEnteredVisitorsList>
    with ApiListener, NavigatorListener {
  final TextEditingController _searchController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List originalUsers = [];
  List visitorslist = [];
  String query = "";

  @override
  void dispose() {
    super.dispose();
  }

  Color _containerBorderColor2 = Colors.white;
  Color _boxShadowColor2 = const Color.fromARGB(255, 100, 100, 100);

  String baseImageIssueApi = '';

  bool _isNetworkConnected = false, _isLoading = true;
  String securityDeviceToken = '';
  String residentName = '';

  String visitorName = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();
    _getNotificationList();
  }

  String securityToken = '';

  void editUserChoice(users) {}

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
              user.mobileNumber.toLowerCase().contains(query.toLowerCase());

          return nameMatches || purposeMatches || phoneMatches;
        }).toList();
      } else {
        originalUsers = visitorslist;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getList();

    Widget content;

    if (originalUsers != null && originalUsers.isEmpty) {
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
          String visitorStatus = originalUsers[index].status;
          return Padding(
            padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
            child: Card(
              elevation: FontSizeUtil.SIZE_02,
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
                                borderRadius: BorderRadius.circular(
                                    FontSizeUtil.CONTAINER_SIZE_50),
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
                                    padding: EdgeInsets.only(
                                        left: FontSizeUtil.SIZE_08),
                                    child: Text(
                                      "${originalUsers[index].name}",
                                      style: TextStyle(
                                        color: const Color(0xff1B5694),
                                        fontSize:
                                            FontSizeUtil.CONTAINER_SIZE_20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: FontSizeUtil.SIZE_03),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: FontSizeUtil.SIZE_08),
                                    child: Text(
                                      "${originalUsers[index].purpose}",
                                      style: TextStyle(
                                        fontSize:
                                            FontSizeUtil.CONTAINER_SIZE_16,
                                        // fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: FontSizeUtil.SIZE_03),
                                originalUsers[index].securityName.isNotEmpty
                                    ? Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: FontSizeUtil.SIZE_08),
                                          child: Text(
                                            "${Strings.ALLOWED_BY} ${originalUsers[index].securityName}",
                                            style: const TextStyle(
                                              color: Color(0xff1B5694),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                SizedBox(height: FontSizeUtil.SIZE_03),
                                originalUsers[index].checkInTime.isNotEmpty
                                    ? Align(
                                        alignment: Alignment.topLeft,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.arrow_downward,
                                              color: Colors.green,
                                              size: FontSizeUtil
                                                  .CONTAINER_SIZE_25,
                                            ),
                                            Expanded(
                                              child: Text(
                                                DateFormat('y-MM-dd hh:mm a')
                                                    .format(DateTime.parse(
                                                        originalUsers[index]
                                                            .checkInTime)),
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
                                          const Icon(
                                            Icons.arrow_upward,
                                            color:
                                                Color.fromARGB(250, 200, 0, 0),
                                            size: 25,
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
                    const Divider(),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () {
                              Utils.makingPhoneCall(
                                  originalUsers[index].mobileNumber);
                            },
                            icon: const Icon(
                              Icons.call,
                              color: Colors.green,
                            ),
                            label: Text("Call", style: AppStyles.call(context)),
                          ),
                        ),
                      ],
                    ),
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
                      horizontal: FontSizeUtil.SIZE_15,
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
                                      FontSizeUtil.SIZE_10),
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
                                        const EdgeInsets.only(top: 14),
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
              if (_isLoading) // Display the loader if _isLoading is true
                const Positioned(child: LoadingDialog()),
            ],
          ),
        ),
      ),
    );
  }

  _getNotificationList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apartId = prefs.getInt('apartmentId');
    var id = prefs.getInt('id');
    var selectedFlatId = prefs.getString('flatId');

    setState(() {
      baseImageIssueApi = BaseApiImage.baseImageUrl(id!, "profile");
    });

    print("Base Image $baseImageIssueApi");

    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "allDevice";

          String allDeviceURL =
              '${Constant.allInOutEntryURL}?flatId=${selectedFlatId}&userId=${id}';

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
        if (responseType == 'allDevice') {
          var jsonResponse = json.decode(response);
          _isLoading = false;

          AllApprovedVisitorModel notice =
              AllApprovedVisitorModel.fromJson(jsonResponse);

          if (notice.status == 'success' && notice.values != null) {
            visitorslist = [];
            visitorslist = notice.values!;
          } else if (notice.status == 'error') {
            visitorslist = [];
          }
        } else if (responseType == "isApproved") {
          ResponceModel responceModel =
              ResponceModel.fromJson(json.decode(response));
          if (responceModel.status == "error") {
            errorDialog(context, "Added to wrong entry successfully",
                const MyVisitorsListScreen());
            _isLoading = false;
          } else {
            successDialogWithListner(
                context,
                "added to wrong entry successfully",
                const MyVisitorsListScreen(),
                this);
          }
        }
      });
    } catch (error) {
      if(mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      Utils.printLog("Error text === $response");
    }
  }

  @override
  onNavigatorBackPressed() {
    _getNotificationList();
  }
}
