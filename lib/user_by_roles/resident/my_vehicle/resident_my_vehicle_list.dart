import 'dart:convert';
import 'package:SMP/components/vehicle_list_card.dart';
import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/success_alert.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/model/resident_vehicle_list_model.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/user_by_roles/resident/my_vehicle/add_new_vehilce.dart';
import 'package:SMP/user_by_roles/resident/my_vehicle/rent_vehicle_slot.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_existing_vehicle.dart';

class ViewMyVehicleScreen extends StatefulWidget {
  const ViewMyVehicleScreen({super.key});

  @override
  State<ViewMyVehicleScreen> createState() {
    return ViewMyVehicleState();
  }
}

class ViewMyVehicleState extends State<ViewMyVehicleScreen>
    with ApiListener, NavigatorListener {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isNetworkConnected = false, _isLoading = true;
  List<Map<String, dynamic>> deleteDataList = [];
  List selectedVehicle = [];
  List vehicleList = [];
  String baseImageApi = '';
  List deleteUserData = [];
  String baseImageIssueApi = '';

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();
    _getVehicleList();
    _getUser();
  }

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('apartmentId');

    setState(() {
      baseImageIssueApi = BaseApiImage.baseImageUrl(id!, "profile");
    });
  }

  String blockName = '';

  void editUserChoice(users) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditExistingVehicle(
          id: users.id,
          imageUrl: users.vehicleImage,
          vehicleNumber: users.vehicleNumber,
          slotNumber: "B-101",
          vehicleType: users.vehicleType,
          baseImageIssueApi: baseImageIssueApi,
          navigatorListener: this,
        ),
      ),
    );
  }

  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (vehicleList.isNotEmpty) {
      content = VehicleListViewCard(
        press: editUserChoice,
        users: vehicleList,
        baseImageIssueApi: baseImageApi,
        selectedFamilyMember: selectedVehicle,
        onSelectedMembersChanged: (List updatedSelectedMembers) {
          setState(() {
            selectedVehicle = updatedSelectedMembers;
          });
        },
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

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: Strings.VEHICLE_LIST_HEADER,
          profile: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DashboardScreen(isFirstLogin: false)),
            );
          },
        ),
      ),
      body: AbsorbPointer(
        absorbing: _isLoading,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: Container(
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
                          SizedBox(height: FontSizeUtil.CONTAINER_SIZE_20),
                          Expanded(child: content),
                        ],
                      ),
                    ),
                  ),
                ),
                const FooterScreen()
              ],
            ),
            if (_isLoading) const Positioned(child: LoadingDialog()),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          if (selectedVehicle.isNotEmpty)
            Positioned(
              bottom: FontSizeUtil.CONTAINER_SIZE_190,
              right: FontSizeUtil.CONTAINER_SIZE_10,
              child: FloatingActionButton(
                heroTag: "btn2",
                onPressed: () {
                  if (selectedVehicle.isNotEmpty) {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.only(
                              top: FontSizeUtil.CONTAINER_SIZE_10,
                              right: FontSizeUtil.CONTAINER_SIZE_10),
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
                                        height: FontSizeUtil.CONTAINER_SIZE_16),
                                    Center(
                                      child: Text(
                                        Strings.WARNING_TEXT1,
                                        style: TextStyle(
                                          fontSize:
                                              FontSizeUtil.CONTAINER_SIZE_25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height: FontSizeUtil.CONTAINER_SIZE_16),
                                    Text(
                                      Strings.DELETE_VEHICLE_CONFIRM_TEXT,
                                      style: TextStyle(
                                        color:const Color.fromRGBO(27, 86, 148, 1.0),
                                        fontSize:
                                            FontSizeUtil.CONTAINER_SIZE_16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: FontSizeUtil.CONTAINER_SIZE_20,
                                      width: FontSizeUtil.SIZE_05,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height:
                                              FontSizeUtil.CONTAINER_SIZE_30,
                                          child: ElevatedButton(
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        FontSizeUtil
                                                            .CONTAINER_SIZE_20),
                                                side: const BorderSide(
                                                  width: 1,
                                                ),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: FontSizeUtil
                                                    .CONTAINER_SIZE_15,
                                              ),
                                            ),
                                            onPressed: () {
                                              _deleteVehicle();
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Ok"),
                                          ),
                                        ),
                                        SizedBox(
                                          width: FontSizeUtil.CONTAINER_SIZE_10,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: FontSizeUtil.CONTAINER_SIZE_20,
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
                  } else {
                    Utils.showToast(Strings.DELETE_VEHICLE_WARNING_TEXT);
                  }
                },
                backgroundColor: const Color(0xff1B5694),
                foregroundColor: Colors.white,
                child: const Icon(Icons.delete),
              ),
            ),
          Positioned(
            bottom: FontSizeUtil.CONTAINER_SIZE_120,
            right: FontSizeUtil.CONTAINER_SIZE_10,
            child: FloatingActionButton(
              heroTag: "btn3",
              onPressed: () {
                Navigator.of(context).push(
                  createRoute(
                    RentVehicleSLotScreen(
                      navigatorListener: this,
                    ),
                  ),
                );
              },
              backgroundColor: const Color(0xff1B5694),
              foregroundColor: Colors.white,
              child: const Icon(Icons.sell),
            ),
          ),
          Positioned(
            bottom: FontSizeUtil.CONTAINER_SIZE_50,
            right: FontSizeUtil.CONTAINER_SIZE_10,
            child: FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
                Navigator.of(context).push(createRoute(AddNewVehicle(
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
    );
  }

  Future<void> _deleteVehicle() async {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "deleteVehicle";
          String result = selectedVehicle.toString();
          result = result.substring(1, result.length - 1);
          print(result);

          String editShiftTimeURL =
              '${Constant.deleteVehicleURL}?vehicleIdList=$result';

          NetworkUtils.postUrlNetWorkCall(
            editShiftTimeURL,
            this,
            responseType,
          );
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
        }
      });
    });
  }

  _getVehicleList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');

    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "viewMyVehicle";

          String viewFamilyURL = '${Constant.getVehicleListURL}?userId=$id';
          Utils.printLog(viewFamilyURL);
          NetworkUtils.getNetWorkCall(viewFamilyURL, responseType, this);
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
    Utils.printLog("View Family Member $response");
    try {
      setState(() {
        if (responseType == 'viewMyVehicle') {
          Utils.printLog('Response data: $response');
          _isLoading = false;

          var jsonResponse = json.decode(response);

          ResidentVehicleListModel family =
              ResidentVehicleListModel.fromJson(jsonResponse);

          if (family.value != null) {
            vehicleList = family.value!;
          }
        }
        if (responseType == 'deleteVehicle') {
          ResponceModel responceModel =
              ResponceModel.fromJson(json.decode(response));

          if (responceModel.status == "success") {
            _deletePollData();

            successAlert(
              context,
              responceModel.message!,
            );
          } else {
            Utils.showToast(responceModel.message!);
          }
          _isLoading = false;
        }
      });
    } catch (error) {
      Utils.printLog("Error decoding JSON: $error");
    }
  }

  _deletePollData() {
    setState(() {
      vehicleList.removeWhere((item) => selectedVehicle.contains(item.id));
      selectedVehicle.clear();
    });
  }

  @override
  onNavigatorBackPressed() {
    _getVehicleList();
  }
}
