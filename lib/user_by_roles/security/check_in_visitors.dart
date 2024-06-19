import 'dart:convert';

import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/push_notificaation_key.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/security/visitors_list.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/components/visitors_list_card.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/approved_visitor_list_model.dart';
import 'package:http/http.dart' as http;

class CheckInVisitorsList extends StatefulWidget {
  const CheckInVisitorsList({super.key});

  @override
  State<CheckInVisitorsList> createState() {
    return _CheckInVisitorsList();
  }
}

class _CheckInVisitorsList extends State<CheckInVisitorsList>
    with ApiListener, NavigatorListener {
  final TextEditingController _searchController = TextEditingController();
  bool setShowlistflag = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isNetworkConnected = false, _isLoading = true;

  List originalUsers = [];
  List visitorslist = [];
  String query = "";
  String userRole = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    _getResidentList();
  }

  int selectedVisitorId = 0;

  String visitorsName = '';
  String residentsToken = '';

  Color _containerBorderColor2 = Colors.white;

  Color _boxShadowColor2 = const Color.fromARGB(255, 100, 100, 100);

  String baseImageApi = '';

  _getResidentList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final roles = prefs.getString('roles');
    final id = prefs.getInt('id');

    final apartId = prefs.getInt('apartmentId');

    try {
      Utils.getNetworkConnectedStatus().then((status) {
        Utils.printLog("network status : $status");
        setState(() {
          _isNetworkConnected = status;
          _isLoading = status;
          if (_isNetworkConnected) {
            String responseType = "ownersList";

            String visitorsListURL =
                '${Constant.visitorsListURL}?apartmentId=$apartId';

            NetworkUtils.getNetWorkCall(visitorsListURL, responseType, this);
          } else {
            Utils.printLog("else called");
            _isLoading = false;
            // Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
            Utils.showCustomToast(context);
          }
        });
      });

      String? baseImageApis = BaseApiImage.baseImageUrl(apartId!, "visitor");

      setState(() {
        baseImageApi = baseImageApis;
        userRole = roles!;
      });
    } catch (e) {
      print('Error: $e');
    }
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

        if (responseType == 'ownersList') {
          var jsonResponse = json.decode(response);
          ApprovedVisitorListModel visitorsList =
              ApprovedVisitorListModel.fromJson(jsonResponse);
          if (visitorsList.status == 'success' && visitorsList.values != null) {
            visitorslist = visitorsList.values!;
          }
        } else if (responseType == "updatecheckOut") {
          ResponceModel responceModel =
              ResponceModel.fromJson(json.decode(response));

          if (responceModel.status == "success") {
            successDialogWithListner(
                context,
                responceModel.message!,
                VisitorsList(
                  title: 'Visitors List',
                ),
                this);

            // _pushNotificationNetworkCall();

          } else {
            Utils.showToast(responceModel.message!);
          }
        }

      });
    } catch (error) {
      Utils.printLog("Error === $response");
      setState(() {
        _isLoading = false;
      });


    }
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

    if (originalUsers.isNotEmpty) {
      content = Padding(
        padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
        child: VisitorsListViewCard(
            press: updateCheckout,
            users: originalUsers,
            baseImageIssueApi: baseImageApi,
            userType: userRole),
      );
    } else {
      content = _isLoading
          ? Container()
          : Center(
              child: Text(
                Strings.NO_VISITORS_TEXT,
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
        Navigator.of(context)
            .push(createRoute(DashboardScreen(isFirstLogin: false)));
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
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
                      Padding(
                        padding:  EdgeInsets.symmetric(
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
                                           Strings.CHECK_OUT_SEARCH_HEADER,
                                        prefixIcon: const Icon(Icons.search),
                                        suffixIcon:
                                            _searchController.text.isNotEmpty
                                                ? IconButton(
                                                    onPressed: () {
                                                      _searchController.clear();
                                                      _filterList('');
                                                      FocusScope.of(context)
                                                          .unfocus();
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
                ),
              ),
              if (_isLoading) const Positioned(child: LoadingDialog()),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateCheckout(visitorId, visitorName, residentToken) async {
    setState(() {
      selectedVisitorId = visitorId;
    });
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        visitorsName = visitorName;
        residentsToken = residentToken;
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "updatecheckOut";

          String visitorsListURL =
              '${Constant.updateCheckedURL}?visitorId=$visitorId';

          NetworkUtils.putUrlNetWorkCall(visitorsListURL, this, responseType);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }


  _pushNotificationNetworkCall() {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          _isLoading = true;
          var responseType = 'push';
          String keyName = "userownerOrTenantDeviceId";

          final Map<String, dynamic> bodyData = <String, dynamic>{


                "title": "Your visitor $visitorsName,",
                "message": "left out premises",
                "action": "checkout",

          };

          final Map<String, dynamic> data = <String, dynamic>{
            "to": residentsToken,
            "data": bodyData,
          };
          String partURL = Constant.pushNotificationURL;
          NetworkUtils.pushNotificationWorkCall(
              partURL, keyName, data, this, responseType);
        }
      });
    });
  }



  Future<void> applyFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apartId = prefs.getInt('apartmentId');
    try {
      Utils.getNetworkConnectedStatus().then((status) {
        Utils.printLog("network status : $status");
        setState(() {
          _isNetworkConnected = status;
          _isLoading = status;
          if (_isNetworkConnected) {
            String responseType = "ownersList";
            String startDate = _startDateController.text;
            String endDate = _endDateController.text;

            String visitorsListURL =
                '${Constant.visitorsListURL}?apartmentId=$apartId&fromDate=$startDate&toDate=$endDate';

            NetworkUtils.getNetWorkCall(visitorsListURL, responseType, this);
          } else {
            Utils.printLog("else called");
            _isLoading = false;
           // Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
             Utils.showCustomToast(context);
          }
        });
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  DateTime currentDate = DateTime.now();
  String? _enteredAdmittedDate;
  String? _enteredDichargedDate;
  final TextEditingController _endDateController = TextEditingController();

  final TextEditingController _startDateController = TextEditingController();

  Future<void> datePicker(BuildContext context, String type) async {
    DateTime? userSelectedDateTime = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (userSelectedDateTime == null) {
      return;
    }

    String formattedDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(userSelectedDateTime);

    if (type == "Admitted Date") {
      setState(() {
        _enteredAdmittedDate = formattedDateTime;
        _startDateController.text = _enteredAdmittedDate ?? '';
      });
    } else if (type == "Discharged Date") {
      setState(() {
        _enteredDichargedDate = formattedDateTime;
        _endDateController.text = _enteredDichargedDate ?? '';
      });
    }
  }


  int selectedIndex = -1;

  Widget buildBottomSheet(Function getList, Function applyFilters) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter mystate) {
        Widget radioContent;

        radioContent = Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  Container(
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
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 0, right: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                datePicker(context, "Admitted Date");
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _startDateController,
                                  decoration: const InputDecoration(
                                    hintText: 'Start Time',
                                    hintStyle: TextStyle(color: Colors.black38),
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Start date can't  be empty.";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _enteredAdmittedDate = value!;
                                  },
                                  onChanged: (value) {},
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              datePicker(context, "Admitted Date");
                            },
                            child: const Icon(
                              Icons.date_range,
                              color: Color(0xff4d004d),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  Container(
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
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10, top: 0, right: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                datePicker(context, "Discharged Date");
                              },
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: _endDateController,
                                  decoration: const InputDecoration(
                                    hintText: 'End Time',
                                    hintStyle: TextStyle(color: Colors.black38),
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "End date can't be empty.";
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _enteredDichargedDate = value!;
                                  },
                                  onChanged: (value) {},
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              datePicker(context, "Discharged Date");
                            },
                            child: const Icon(
                              Icons.date_range,
                              color: Color(0xff4d004d),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        );

        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filters', style: AppStyles.heading(context)),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Close',
                      style: AppStyles.heading(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              const Divider(
                height: 0.2,
                color: Color.fromARGB(255, 89, 0, 255),
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Center(
                    child: radioContent,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              const Divider(
                height: 0.2,
                color: Color.fromARGB(255, 89, 0, 255),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: SizedBox(
                      height: 30,
                      child: ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: const BorderSide(
                                color: Color.fromARGB(255, 0, 123, 255),
                                width: 2),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 5),
                        ),
                        onPressed: () async {
                          mystate(() {
                            _endDateController.clear();
                            _startDateController.clear();
                            _enteredAdmittedDate = '';
                            _enteredDichargedDate = '';
                          });

                          Navigator.pop(context);
                        },
                        child: const Text("Clear"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: SizedBox(
                      height: 30,
                      child: ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: const BorderSide(
                                color: Color.fromARGB(255, 0, 123, 255),
                                width: 2),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 5),
                        ),
                        onPressed: () async {
                          // if(_endDateController !=null)

                          if (_endDateController.text.isNotEmpty &&
                              _startDateController.text.isNotEmpty) {
                            applyFilters();
                          }
                          Utils.showToast("Please select a date");
                          // Navigator.pop(context);
                        },
                        child: const Text("Apply"),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  onNavigatorBackPressed() {

    Utils.printLog("Removve visitor called $selectedVisitorId");
    setState(() {
      visitorslist.removeWhere((item) => selectedVisitorId == item.visitorId);
    });

  }
}
