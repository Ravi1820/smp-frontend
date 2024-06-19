import 'dart:async';
import 'dart:convert';

import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/success_alert.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/model/notice_board_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/user_by_roles/admin/notice_board/create_notice.dart';
import 'package:SMP/user_by_roles/admin/notice_board/edit_notice.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:SMP/widget/footers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../contants/error_alert.dart';
import '../../../model/delete_notice_model.dart';

class NoticeBoardList extends StatefulWidget {
  const NoticeBoardList({Key? key}) : super(key: key);

  @override
  State<NoticeBoardList> createState() {
    return _NoticeBoardListState();
  }
}

class _NoticeBoardListState extends State<NoticeBoardList>
    with ApiListener, TickerProviderStateMixin, NavigatorListener {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int issueCount = 0;
  int apartmentId = 0;
  String imageUrl = '';
  String profilePicture = '';
  String baseImageIssueApi = '';
  String apartmentName = '';
  String userName = "";
  String userType = "";
  List countries = [];
  Map<int, bool> isRowLongPressedMap = {};
  bool isCallButtonClicked = false;
  bool showCheckbox = false;
  List? hospitalLists;
  bool showCheckboxes = false;
  var selectedCountries = [];
  bool allRowsSelected = false;
  bool _isNetworkConnected = false, _isLoading = true;
  List teamMemberlist = [];
  String seleNoticeId = '';
  bool callselected = false;
  bool deleteselected = false;
  bool messageselected = false;
  late Timer _timer;
  List noticeList = [];
  List noticeModifyList = [];

  @override
  void initState() {
    super.initState();
    _getNoticeList();
    _updateDate();
    _startTimer();
    _choose();
  }

  void _startTimer() {
    // Start a timer that updates every second
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      // Trigger a rebuild of the widget tree to update the displayed time difference
      _updateDate();
      setState(() {
        noticeModifyList;
      });
    });
  }

  void _updateDate() {
    // Utils.printLog("Timer called");
    noticeModifyList = [];
    for (Values values in teamMemberlist) {
      values.timeAgo = Utils.formatTimeDifference(values.createdDate!);
      // Utils.printLog("Timer in loop called ${values.timeAgo}");
      noticeModifyList.add(values);
    }
  }

  Future<void> _choose() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apartmntId = prefs.getInt('apartmentId');

    setState(() {
      apartmentId = apartmntId!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .push(createRoute(DashboardScreen(isFirstLogin: false)));
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: Strings.NOTICE_HEADER_TEXT,
            profile: () async {},
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
                      Color.fromARGB(255, 235, 235, 235),
                      Color.fromARGB(255, 235, 235, 235),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: FontSizeUtil.SIZE_08,
                                vertical: FontSizeUtil.SIZE_08),
                            child: Container(
                              height: MediaQuery.of(context).size.height / 1.36,
                              decoration: AppStyles.decorationTable(context),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: noticeModifyList.isNotEmpty
                                        ? Padding(
                                            padding: EdgeInsets.all(
                                                FontSizeUtil.SIZE_08),
                                            child: ListView.builder(
                                                itemCount:
                                                    noticeModifyList.length,
                                                itemBuilder: (context, index) {
                                                  return buildListItem(
                                                    noticeModifyList[index],
                                                  );
                                                }),
                                          )
                                        : _isLoading
                                            ? Container()
                                            : Padding(
                                                padding: EdgeInsets.all(
                                                    FontSizeUtil.SIZE_08),
                                                child: Center(
                                                  child: Text(
                                                    Strings.NO_NOTICE_AVAILABLE_TEXT,
                                                    style: AppStyles.heading(
                                                        context),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const FooterScreen()
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
              bottom: FontSizeUtil.CONTAINER_SIZE_120,
              right: FontSizeUtil.SIZE_08,
              child: selectedCountries.isNotEmpty
                  ? InkWell(
                      onTap: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.only(
                                  top: FontSizeUtil.SIZE_10,
                                  right: FontSizeUtil.SIZE_10),
                              content: Stack(
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
                                        SizedBox(
                                            height:
                                                FontSizeUtil.CONTAINER_SIZE_16),
                                        Center(
                                          child: Text(
                                            Strings.WARNING_TEXT1,
                                            style: TextStyle(
                                              fontSize: FontSizeUtil
                                                  .CONTAINER_SIZE_25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                FontSizeUtil.CONTAINER_SIZE_16),
                                        Text(
                                          Strings.DELETE_NOTICE_TEXT,
                                          style: TextStyle(
                                            color: const Color.fromRGBO(
                                                27, 86, 148, 1.0),
                                            fontSize:
                                                FontSizeUtil.CONTAINER_SIZE_16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          height:
                                              FontSizeUtil.CONTAINER_SIZE_20,
                                          width: FontSizeUtil.SIZE_05,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: FontSizeUtil
                                                  .CONTAINER_SIZE_30,
                                              child: ElevatedButton(
                                                style: OutlinedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(FontSizeUtil
                                                            .CONTAINER_SIZE_20),
                                                    side: BorderSide(
                                                      width:
                                                          FontSizeUtil.SIZE_01,
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: FontSizeUtil
                                                        .CONTAINER_SIZE_15,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Utils.getNetworkConnectedStatus()
                                                      .then((status) {
                                                    Utils.printLog(
                                                        "network status : $status");
                                                    setState(() {
                                                      _isNetworkConnected =
                                                          status;
                                                      _isLoading = status;
                                                      if (_isNetworkConnected) {
                                                        String responseType =
                                                            "deleteNotice";

                                                        String result =
                                                            selectedCountries
                                                                .toString();
                                                        result =
                                                            result.substring(
                                                                1,
                                                                result.length -
                                                                    1);
                                                        print(result);

                                                        setState(() {
                                                          seleNoticeId = result;
                                                        });

                                                        String
                                                            editShiftTimeURL =
                                                            '${Constant.deleteNoticesURL}?noticeIdList=$result';

                                                        NetworkUtils
                                                            .putUrlNetWorkCall(
                                                          editShiftTimeURL,
                                                          this,
                                                          responseType,
                                                        );
                                                        Navigator.pop(context);
                                                      } else {
                                                        Navigator.pop(context);
                                                        Utils.printLog(
                                                            "else called");
                                                        _isLoading = false;
                                                        Utils.showCustomToast(
                                                            context);
                                                      }
                                                    });
                                                  });
                                                },
                                                child: const Text("Ok"),
                                              ),
                                            ),
                                            SizedBox(
                                              width: FontSizeUtil
                                                  .CONTAINER_SIZE_10,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height:
                                              FontSizeUtil.CONTAINER_SIZE_20,
                                          width: FontSizeUtil.SIZE_05,
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
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Icon(
                                          Icons.close,
                                          size: FontSizeUtil.CONTAINER_SIZE_25,
                                          color: const Color(0xff1B5694),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        width: FontSizeUtil.CONTAINER_SIZE_60,
                        height: FontSizeUtil.CONTAINER_SIZE_60,
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
              bottom: FontSizeUtil.CONTAINER_SIZE_50,
              right: FontSizeUtil.CONTAINER_SIZE_10,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(createRoute(CreteNoticeScreen(
                    navigatorListener: this,
                  )));
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

  @override
  void dispose() {
    selectedCountries.clear();

    _timer.cancel();
    super.dispose();
  }

  void _getNoticeList() {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "noticeList";
          String allNoticeURL =
              '${Constant.notificationURL}?apartmentId=$apartmentId';

          NetworkUtils.getNetWorkCall(allNoticeURL, responseType, this);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          //  Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
          Utils.showCustomToast(context);
        }
      });
    });
  }

  Widget buildListItem(Values teamMember) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          showCheckbox = true;
          selectedCountries.add(teamMember.id);
        });
      },
      onTap: () {
        if (showCheckbox && selectedCountries.isNotEmpty) {
          setState(() {
            if (selectedCountries.contains(teamMember.id)) {
              selectedCountries.remove(teamMember.id); // Unselect
            } else {
              selectedCountries.add(teamMember.id); // Select
            }
          });
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditNoticeScreen(
                id: teamMember.id!,
                navigatorListener: this,
                message: teamMember.message!,
                header: teamMember.noticeHeader!,
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 50,
          decoration: AppStyles.decoration(context),
          child: Row(
            children: [
              if (showCheckbox && selectedCountries.isNotEmpty)
                SizedBox(
                  width: 30,
                  child: Checkbox(
                    value: selectedCountries.contains(teamMember.id),
                    onChanged: (isSelected) {
                      setState(() {
                        if (isSelected!) {
                          selectedCountries.add(teamMember.id);
                        } else {
                          selectedCountries.remove(teamMember.id);
                        }
                      });
                    },
                  ),
                ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: SizedBox(
                  child: GestureDetector(
                    child: Text(
                      teamMember.message!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: AppStyles.heading1(context),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0),
                  child: Text(
                    teamMember.timeAgo!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: AppStyles.heading1(context),
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () {},
                  child: !selectedCountries.isNotEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Color(0xff1B5694),
                          ),
                        )
                      : Container()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  onFailure(status) {
    setState(() {
      _isLoading = false;
    });
    // Utils.sessonExpired(context,  "Session is expired. Please login again");
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
        if (responseType == 'noticeList') {
          // print("Success getting notice");
          _isLoading = false;
          teamMemberlist = [];

          var jsonResponse = json.decode(response);
          Notice notice = Notice.fromJson(jsonResponse);
          if (notice.status == 'success' && notice.values != null) {
            teamMemberlist = notice.values!;
            _updateDate();
            _startTimer();
            Utils.printLog("Notice List ${jsonResponse}");
          }
        } else if (responseType == "deleteNotice") {
          _isLoading = false;
          teamMemberlist
              .removeWhere((item) => selectedCountries.contains(item.id));
          selectedCountries.clear(); // Clear selected items

          DeleteNoticeModel responceModel =
              DeleteNoticeModel.fromJson(json.decode(response));
          if (responceModel.status == "success") {
            successAlert(
              context,
              responceModel.message!,
            );
            Utils.writeCounter("true", Strings.NOTICE_FILE_NAME);
            Utils.printLog("Existing Notice Updated ${responceModel.message}");
          } else {
            errorAlert(
              context,
              responceModel.message!,
            );
          }
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
    _getNoticeList();
  }
}
