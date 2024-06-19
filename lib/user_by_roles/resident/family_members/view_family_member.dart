import 'dart:convert';

import 'package:SMP/components/view_family_membar_card.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/model/family_member_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/user_by_roles/resident/family_members/add_family_member.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'view_detailed_family_member.dart';

class ViewFamilyMemberScreen extends StatefulWidget {
  const ViewFamilyMemberScreen({super.key});

  @override
  State<ViewFamilyMemberScreen> createState() {
    return AccountPageState();
  }
}

class AccountPageState extends State<ViewFamilyMemberScreen>
    with ApiListener, NavigatorListener {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isNetworkConnected = false, _isLoading = true;
  List<Map<String, dynamic>> deleteDataList = [];

  List selectedFamily = [];
  List familyList = [];
  String baseImageApi = '';

  List deleteUserData = [];

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();
    _getFamilyMember();
  }

  String blockName = '';

  void editUserChoice(users) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewDetailedFamilyMemberScreen(
          memberId: users.familyTableId ?? 0,
          userName: users.fullName ?? "",
          image: users.profilePicture ?? "",
          relation: users.relation ?? "",
          memberType: users.memberType ?? "",
          phone: users.mobile ?? "",
          emailId: users.emailId ?? "",
          familyTableId: users.familyTableId ?? 0,
          age: users.age ?? "",
          apartmentId: 1 ?? -1,
          profilePicture: users.profilePicture ?? "",
          gender: users.gender ?? "",
          baseImageIssueApi: baseImageApi,
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

    if (familyList.isNotEmpty) {
      content = FamilyMemberListViewCard(
        press: editUserChoice,
        users: familyList,
        baseImageIssueApi: baseImageApi,
        selectedFamilyMember: selectedFamily,
        onSelectedMembersChanged: (List updatedSelectedMembers) {
          setState(() {
            selectedFamily = updatedSelectedMembers;
          });
        },
      );
    } else {
      content = _isLoading
          ? Container()
          : Center(
              child: Text(
                Strings.NO_FMAILY_MEMBER_TEXT,
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
          title: Strings.VIEW_FAMILY_MEMBER_HEADER,
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
          if (selectedFamily.isNotEmpty)
            Positioned(
              bottom: FontSizeUtil.CONTAINER_SIZE_120,
              right: FontSizeUtil.CONTAINER_SIZE_10,
              child: FloatingActionButton(
                heroTag: "btn2",
                onPressed: () {

                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          contentPadding:
                               EdgeInsets.only(top: FontSizeUtil.CONTAINER_SIZE_10, right:FontSizeUtil.CONTAINER_SIZE_10),
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
                                    const Icon(
                                      Icons.error,
                                      size: 64,
                                      color: Colors.red,
                                    ),
                                     SizedBox(height: FontSizeUtil.CONTAINER_SIZE_16),
                                     Center(
                                      child: Text(
                                        Strings.WARNING_TEXT1,
                                        style: TextStyle(
                                          fontSize: FontSizeUtil.CONTAINER_SIZE_25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                     SizedBox(height: FontSizeUtil.CONTAINER_SIZE_16),
                                     Text(
                                      Strings.DELETE_FAMILY_MEMBER_TEXT,
                                      style: TextStyle(
                                        color:
                                            const Color.fromRGBO(27, 86, 148, 1.0),
                                        fontSize: FontSizeUtil.CONTAINER_SIZE_16,
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
                                          height: FontSizeUtil.CONTAINER_SIZE_30,
                                          child: ElevatedButton(
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        FontSizeUtil.CONTAINER_SIZE_20),
                                                side:  BorderSide(
                                                  width: FontSizeUtil.SIZE_01,
                                                ),
                                              ),
                                              padding:
                                                   EdgeInsets.symmetric(
                                                horizontal: FontSizeUtil.CONTAINER_SIZE_15

                                              ),
                                            ),
                                            onPressed: () {
                                              _deleteFamilyMembers();
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
                                      color:const Color(0xff1B5694),
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
                backgroundColor: const Color(0xff1B5694),
                foregroundColor: Colors.white,
                child: const Icon(Icons.delete),
              ),
            ),
          Positioned(
            bottom: FontSizeUtil.CONTAINER_SIZE_50,
            right: FontSizeUtil.CONTAINER_SIZE_10,
            child: FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
                Navigator.of(context).push(createRoute(const AddFamilyMemberScreen(

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

  Future<void> _deleteFamilyMembers() async {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;

        List<Map<String, dynamic>> selectedCategoryIds =
            selectedFamily.map((category) {
          return {
            "useType": category.memberType,
            "memberId": category.memberId,
          };
        }).toList();

        Utils.printLog("Selected Family Memeber$selectedCategoryIds");

        String responseType = "deleteFamilyMembers";
        // List<Map<String, dynamic>> data = deleteDataList;

        String deleteFamilyMembers = Constant.deleteFamilyMember;

        NetworkUtils.postNetWorkCall(
            deleteFamilyMembers, selectedCategoryIds, this, responseType);
        // },
      });
    });
  }

  _getFamilyMember() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');

    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "viewFamily";

          String viewFamilyURL = '${Constant.viewFamilyURL}?userId=$id';
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
        if (responseType == 'viewFamily') {
          Utils.printLog('Response data: $response');
          _isLoading = false;

          var jsonResponse = json.decode(response);

          ResidentModel family = ResidentModel.fromJson(jsonResponse);
          //  familyList=[];
          if (family.values != null) {
            familyList = family.values!.familyDetails!;
          }
        }
        if (responseType == 'deleteFamilyMembers') {
          Utils.printLog('Response data: $response');
          _isLoading = false;
          var jsonResponse = response;

          if (jsonResponse['status'] == 'success') {
            // successAlert(context,jsonResponse['message']);
            // print("familyList : ${familyList}");

            familyList.removeWhere((item) => selectedFamily.contains(item));
            selectedFamily.clear();
          } else {
            Utils.showToast(jsonResponse['message']);
          }
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (error) {
      Utils.printLog("Error decoding JSON: $error");
    }
  }

  @override
  onNavigatorBackPressed() {
    _getFamilyMember();
  }
}
