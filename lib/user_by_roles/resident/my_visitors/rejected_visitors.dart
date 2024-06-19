import 'dart:convert';
import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/model/all_type_visitor_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResidentRejectedVisitorsList extends StatefulWidget {
  const ResidentRejectedVisitorsList({super.key});

  @override
  State<ResidentRejectedVisitorsList> createState() =>
      _ResidentRejectedVisitorsListState();
}

class _ResidentRejectedVisitorsListState
    extends State<ResidentRejectedVisitorsList> with ApiListener {
  final TextEditingController _searchController = TextEditingController();

  List originalUsers = [];
  List visitorslist = [];
  String query = "";

  String baseImageIssueApi = '';

  bool _isNetworkConnected = false, _isLoading = true;
  String securityDeviceToken = '';
  String residentName = '';

  String visitorName = '';

  Color _containerBorderColor2 = Colors.white;

  Color _boxShadowColor2 = const Color.fromARGB(255, 100, 100, 100);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    super.initState();
    _getNotificationList();
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
        //  Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
           Utils.showCustomToast(context);
        }
      });
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getList();
    BoxDecoration decoration = BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white,
          Colors.white,
        ],
      ),
      borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_10),
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

    if (originalUsers.isEmpty && originalUsers != null) {
      content = _isLoading
          ? Container()
          : Center(
              child: Text(
              "No rejected visitors",
              style: AppStyles.heading(context),
            ));
    } else {
      content = ListView.builder(
        itemCount: originalUsers.length,
        itemBuilder: (context, index) {
          return Padding(
            padding:  EdgeInsets.all(FontSizeUtil.SIZE_08),
            child: Card(
              elevation: 2,
              child: Container(
                decoration: decoration,
                child: Padding(
                  padding: EdgeInsets.all( FontSizeUtil.SIZE_08),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_50),
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
                                    padding:  EdgeInsets.only(left: FontSizeUtil.SIZE_08),
                                    child: Text(
                                      "${originalUsers[index].name}",
                                      style:  TextStyle(
                                        color:const Color(0xff1B5694),
                                        fontSize:  FontSizeUtil.CONTAINER_SIZE_20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                // const SizedBox(height: 3),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left:  FontSizeUtil.SIZE_08),
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

                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: FontSizeUtil.SIZE_08),
                                    child: Text(
                                      originalUsers[index]
                                              .visitorType
                                              .substring(0, 1)
                                              .toUpperCase() +
                                          originalUsers[index]
                                              .visitorType
                                              .substring(1)
                                              .toLowerCase(),
                                      // "${originalUsers[index].visitorType}",
                                      style: const TextStyle(
                                        color: Color(0xff1B5694),
                                      ),
                                    ),
                                  ),
                                ),

                                originalUsers[index].chekinTime.isNotEmpty
                                    ? Align(
                                        alignment: Alignment.topLeft,
                                        child: Row(
                                          children: [
                                             Icon(
                                              Icons.arrow_downward,
                                              color: Color.fromARGB(
                                                  255, 81, 255, 0),
                                              size:  FontSizeUtil.CONTAINER_SIZE_25,
                                            ),
                                            Expanded(
                                              child: Text(
                                                DateFormat('y-MM-dd hh:mm:ss a')
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
                                            Icons.arrow_upward,
                                            color:
                                                Color.fromARGB(255, 255, 0, 0),
                                            size:  FontSizeUtil.CONTAINER_SIZE_25,
                                          ),
                                          Expanded(
                                            child: Text(
                                              DateFormat('y-MM-dd hh:mm:ss a')
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
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(),

                      Row(
                        children: [
                          Expanded(
                            child: TextButton.icon(
                              onPressed: () {
                                Utils.makingPhoneCall(originalUsers[index].mobile);
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
                    padding:  EdgeInsets.symmetric(
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
                                      : const Color.fromARGB(255, 100, 100, 100);
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
                                        const EdgeInsets.only(top: 14),
                                    hintText: "Search by Name, Phone, Purpose...",
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
              '${Constant.allTypeOfVisitorsURL}?flatId=$selectedFlatId&userId=$id&status=REJECT';

          NetworkUtils.getNetWorkCall(allDeviceURL, responseType, this);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
         // Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
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

          AllTypeVisitorModel notice =
              AllTypeVisitorModel.fromJson(jsonResponse);
          if (notice.status == 'success' && notice.value != null) {
            visitorslist = notice.value!;
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
}
