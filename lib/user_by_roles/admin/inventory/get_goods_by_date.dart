import 'dart:convert';

import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/model/inventory_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/profile.dart';
import 'package:SMP/user_by_roles/admin/inventory/inventoray.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/components/inventory_grid_view.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/src/material/date_picker_theme.dart'
    show DatePickerTheme;

import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

class GetGoodsByDate extends StatefulWidget {
  const GetGoodsByDate({super.key});

  @override
  State<GetGoodsByDate> createState() {
    return _GetGoodsByDate();
  }
}

class _GetGoodsByDate extends State<GetGoodsByDate>
    with ApiListener, NavigatorListener {
  final TextEditingController _searchController = TextEditingController();
  bool setShowlistflag = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  bool _isNetworkConnected = false, _isLoading = false;
  var apartId;
  List<Value> goodsInvList = [];
  List<Value> allGoodsInvList = [];

  DateTime currentDate = DateTime.now();

  String? _enteredAdmittedDate;
  String? _enteredDichargedDate;

  final TextEditingController _dichargeDateController = TextEditingController();

  final TextEditingController _admittedDateController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    _getAppartmentData();
    _getGoodsInventoryApi();
  }

  String baseImageIssueApi = '';

  _getAppartmentData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('apartmentId');

    setState(() {
      baseImageIssueApi = BaseApiImage.baseImageUrl(id!, "apartment");
      apartId = prefs.getInt('apartmentId');
    });
  }

  void editUserChoice(users) {}

  Future<void> datePicker(BuildContext context, String type) async {
    DateTime currentDate = DateTime.now();
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2100);

    DatePicker.showDatePicker(
      context,
      theme: picker.DatePickerTheme(
        containerHeight: 210.0,
      ),
      showTitleActions: true,
      onConfirm: (date) {
        print('Confirm date: $date ');
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);

        DatePicker.showTimePicker(
          context,
          theme: picker.DatePickerTheme(
            containerHeight: 210.0,
          ),
          showTitleActions: true,
          showSecondsColumn: false,
          onConfirm: (time) {
            print('confirm $time');
            // Set the selected time to a formatted string
            String formattedTime = '${time.hour}:${time.minute}:${time.second}';

            // Combine the selected date and time
            DateTime selectedDateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
              time.second,
            );

            // Format the combined date and time
            String formattedDateTime =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDateTime);

            if (type == Strings.START_DATE) {
              if (_enteredDichargedDate != null &&
                  date.isAfter(DateTime.parse(_enteredDichargedDate!))) {
                Utils.showToast(Strings.START_DATE_ERROR_TEXT);
                return;
              }
              setState(() {
                _enteredDichargedDate = '';
                _dichargeDateController.text = '';
                _enteredAdmittedDate = formattedDateTime;
                _admittedDateController.text = _enteredAdmittedDate ?? '';
              });
            } else if (type == Strings.END_DATE) {
              if (_enteredAdmittedDate != null &&
                  date.isBefore(DateTime.parse(_enteredAdmittedDate!))) {
                Utils.showToast(Strings.END_DATE_ERROR_TEXT);
                return;
              }
              setState(() {
                _enteredDichargedDate = formattedDateTime;
                _dichargeDateController.text = _enteredDichargedDate ?? '';
              });
            }

            if (_enteredAdmittedDate!.isNotEmpty &&
                _enteredDichargedDate!.isNotEmpty) {
              _getGoodsInventoryByDateApi();
            }

            (context as Element).markNeedsBuild(); // Rebuild the UI
          },
          currentTime: DateTime.now(),
          // Set the current time as initial time
          locale: picker.LocaleType.en,
        );
      },
      currentTime: currentDate,
      locale: LocaleType.en,
      minTime: firstDate,
      maxTime: lastDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (goodsInvList.isEmpty &&
        _enteredAdmittedDate != null &&
        _enteredDichargedDate != null) {
      content = Center(
        child: Padding(
          padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
          child: Text(
            Strings.NO_INVENTORARY,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: MediaQuery.of(context).size.width * 0.05,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w600,
              color: const Color(0xff1B5694),
            ),
          ),
        ),
      );
    } else if (goodsInvList.isEmpty &&
        _enteredAdmittedDate == null &&
        _enteredDichargedDate == null) {
      content = allGoodsInvList.isNotEmpty
          ? Padding(
              padding:  EdgeInsets.all(FontSizeUtil.SIZE_08),
              child: InventoryGridViewCard(
                press: editUserChoice,
                baseImageIssueApi: baseImageIssueApi,
                goodsInvList: allGoodsInvList,
              ),
            )
          : Center(
              child: Padding(
                padding:  EdgeInsets.all(FontSizeUtil.SIZE_08),
                child: Text(
                  Strings.NO_INVENTORARY,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff1B5694),
                  ),
                ),
              ),
            );
    } else {
      content = Padding(
        padding:  EdgeInsets.all(FontSizeUtil.SIZE_08),
        child: InventoryGridViewCard(
          press: editUserChoice,
          baseImageIssueApi: baseImageIssueApi,
          goodsInvList: goodsInvList,
        ),
      );
    }

    Function()? add;

    add = () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DashboardScreen(isFirstLogin: false)),
      );
    };

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
            title: Strings.INVENTOR_HEADER,
            onBack: () {
              Navigator.pop(context);
            },
            profile: () {
              Navigator.of(context).push(createRoute(const UserProfile()));
            },
          ),
        ),
        // drawer: const DrawerScreen(),
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
                      Color.fromARGB(255, 255, 255, 255),
                      Color.fromARGB(255, 255, 255, 255),
                      Color.fromARGB(255, 255, 255, 255),
                      Color.fromARGB(255, 255, 255, 255),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    children: <Widget>[
                       SizedBox(height: FontSizeUtil.CONTAINER_SIZE_20),
                      Padding(
                        padding:  EdgeInsets.symmetric(
                            horizontal: FontSizeUtil.CONTAINER_SIZE_20, vertical: FontSizeUtil.SIZE_05),
                        child: Form(
                          key: _formKey,
                          child: Row(
                            children: [
                              Expanded(
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(FontSizeUtil.SIZE_10),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                255, 100, 100, 100),
                                            blurRadius: 6,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      height: FontSizeUtil.CONTAINER_SIZE_50,
                                      child: Padding(
                                        padding:  EdgeInsets.only(
                                            left: FontSizeUtil.SIZE_10 , right: FontSizeUtil.SIZE_05),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  datePicker(
                                                      context, Strings.START_DATE);
                                                },
                                                child: AbsorbPointer(
                                                  child: TextFormField(
                                                    controller:
                                                        _admittedDateController,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText:
                                                          Strings.START_DATE_HINT_TEXT,
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Colors.black38),
                                                      border: InputBorder.none,
                                                    ),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return Strings.START_DATE_ERROR_TEXT_1;
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      _enteredAdmittedDate =
                                                          value!;
                                                      setState(() {
                                                        _dichargeDateController
                                                            .text = '';
                                                        _enteredDichargedDate ==
                                                            '';
                                                      });
                                                    },
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _dichargeDateController
                                                            .text = '';

                                                        _enteredDichargedDate ==
                                                            '';
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                datePicker(
                                                    context, Strings.START_DATE);
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
                              ),
                               SizedBox(width: FontSizeUtil.CONTAINER_SIZE_16),
                              Expanded(
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(FontSizeUtil.SIZE_10),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                255, 100, 100, 100),
                                            blurRadius: 6,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      height: FontSizeUtil.CONTAINER_SIZE_50,
                                      child: Padding(
                                        padding:  EdgeInsets.only(
                                            left: FontSizeUtil.SIZE_10, right: FontSizeUtil.SIZE_05),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  datePicker(context,
                                                      Strings.END_DATE);
                                                },
                                                child: AbsorbPointer(
                                                  child: TextFormField(
                                                    controller:
                                                        _dichargeDateController,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText:
                                                          Strings.END_DATE_HINT_TEXT,
                                                      hintStyle: TextStyle(
                                                          color:
                                                              Colors.black38),
                                                      border: InputBorder.none,
                                                    ),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return Strings.END_DATE_ERROR_TEXT_1;
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (value) {
                                                      _enteredDichargedDate =
                                                          value!;
                                                    },
                                                    onChanged: (value) {
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                datePicker(
                                                    context, Strings.END_DATE);
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
                              ),
                               SizedBox(
                                width: FontSizeUtil.CONTAINER_SIZE_10,
                              ),
                            ],
                          ),
                        ),
                      ),
                       SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                      Expanded(child: content),
                      const FooterScreen(),
                    ],
                  ),
                ),
              ),
              if (_isLoading) // Display the loader if _isLoading is true
                const Positioned(child: LoadingDialog()),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding:  EdgeInsets.only(bottom: FontSizeUtil.CONTAINER_SIZE_100, left: FontSizeUtil.CONTAINER_SIZE_50),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(createRoute(AddInventoryScreen(
                navigatorListener: this,
              )));
            },
            backgroundColor: const Color(0xff1B5694),
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  _getGoodsInventoryByDateApi() async {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          _isLoading = true;
          var responseType = 'goodsInventoryByDate';
          String createInvURL =
              '${Constant.goodInventoryURL}?apartmentId=$apartId&startDate=$_enteredAdmittedDate&endDate=$_enteredDichargedDate';
          NetworkUtils.getNetWorkCall(createInvURL, responseType, this);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  _getGoodsInventoryApi() async {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          _isLoading = true;
          var responseType = 'goodsInventory';
          String createInvURL =
              '${Constant.getAllGoodsByAdmin}?apartmentId=$apartId';
          NetworkUtils.getNetWorkCall(createInvURL, responseType, this);
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
  onSuccess(response, String responseType) {
    try {
      if (responseType == "goodsInventoryByDate") {
        Utils.printLog('response===' + response);
        setState(() {
          goodsInvList = [];
        });
        InventoryModel inventoryModel =
            InventoryModel.fromJson(json.decode(response));
        setState(() {
          _isLoading = false;
          if (inventoryModel.status! == "success") {
            goodsInvList = inventoryModel.value!;
          }
        });
      } else if (responseType == "goodsInventory") {
        Utils.printLog('response===' + response);
        InventoryModel inventoryModel =
            InventoryModel.fromJson(json.decode(response));
        setState(() {
          _isLoading = false;
          if (inventoryModel.status! == "success") {
            allGoodsInvList = inventoryModel.value!;
          }
        });
      }
    } catch (error) {
      setState(() {
        goodsInvList = [];
      });
      print("Error 1");
      errorAlert(context, response.toString());
    }
  }

  @override
  onNavigatorBackPressed() {
    _getGoodsInventoryApi();
  }
}
