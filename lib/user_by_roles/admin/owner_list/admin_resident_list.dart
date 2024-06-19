import 'dart:async';
import 'dart:convert';

import 'package:SMP/components/global_searched_grid_view.dart';
import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/translate.dart';
import 'package:SMP/model/block_model.dart';
import 'package:SMP/model/global_search.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/owner_list/group_messae_list.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:SMP/contants/success_alert.dart';
import 'package:SMP/model/flat_model.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/user_by_roles/admin/owner_list/messages.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:grouped_list/grouped_list.dart';

class AdminResidentListScreen extends StatefulWidget {
  const AdminResidentListScreen({
    Key? key,
    required this.id,
    required this.blockName,
    required this.blockCount,
    required this.screenName,
  }) : super(key: key);

  final int id;
  final String? blockName;
  final int? blockCount;
  final String? screenName;

  @override
  State<AdminResidentListScreen> createState() {
    return _AdminResidentListState();
  }
}

class _AdminResidentListState extends State<AdminResidentListScreen>
    with ApiListener, NavigatorListener {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String apartmentName = '';
  List<BlockModel> blocklist = [];
  List globalResidentList = [];
  bool showCheckbox = false;
  bool _isNetworkConnected = false, _isLoading = true;
  bool isLoading = false;
  String screen = "";
  String query = "";
  int apartmentId = 0;
  int residentId = 0;
  String userType = '';
  String baseImageIssueApi = '';
  Timer? _debounce;
  bool showErrorMessage = false;
  bool showPurposeErrorMessage = false;
  Color _containerBorderColor2 = Colors.white;
  Color _boxShadowColor2 = const Color.fromARGB(255, 100, 100, 100);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    _getFlatList();
    blockid = widget.id;
    screen = widget.screenName!;
    super.initState();
    _choose();
  }

  Future<void> _choose() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');
    final apartId = prefs.getInt('apartmentId');
    final apartName = prefs.getString('apartmentName');
    final roles = prefs.getString('roles');

    setState(() {
      apartmentId = apartId!;
      apartmentName = apartName!;
      residentId = id!;
      userType = roles!;
    });
  }

  Future<void> getList() async {
    setState(() {
      baseImageIssueApi = BaseApiImage.baseImageUrl(apartmentId, "profile");
    });
  }

  void _filterList(String query) {
    setState(() {
      this.query = query;
    });

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetchData(query);
    });
  }

  Future<void> _fetchData(String query) async {
    try {
      setState(() {
        isLoading = true;
      });

      if (query.isNotEmpty) {
        try {
          Utils.getNetworkConnectedStatus().then((status) {
            Utils.printLog("network status : $status");
            setState(() {
              _isNetworkConnected = status;
              _isLoading = status;
              if (_isNetworkConnected) {
                String responseType = "globalSearch";

                String globalSearchResidentURL =
                    '${Constant.globalSearchURL}?data=$query&apartmentId=$apartmentId';
                NetworkUtils.getNetWorkCall(
                    globalSearchResidentURL, responseType, this);
              } else {
                Utils.printLog("else called");
                _isLoading = false;
                Utils.showCustomToast(context);
              }
            });
          });

          setState(() {
            isLoading = false;
          });
        } catch (e) {
          print('Error: $e');
          setState(() {
            isLoading = false;
          });
        }

        getList();
      } else {}
    } catch (error) {
      print('Error fetching data: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void editUserChoice(users) {
    _formKey.currentState!.save();
  }

  double _xOffset = 0;
  double _yOffset = 0;
  List<dynamic> availableData = [];
  Set<String> selectedFloors = <String>{};
  Set<int> selectedIndexes = <int>{};

  int blockid = 0;
  List flatlist = [];
  String chatMessage = '';

  _getFlatList() {
    try {
      Utils.getNetworkConnectedStatus().then((status) {
        Utils.printLog("network status : $status");
        setState(() {
          _isNetworkConnected = status;
          _isLoading = status;
          if (_isNetworkConnected) {
            String responseType = "flatList";

            int blockCount = widget.blockCount!;
            String blockListUrl = '';
            Utils.printLog("blockcount==$blockCount");
            if (blockCount > 2) {
              blockListUrl =
                  '${Constant.flatListURL}?apartmentId=$apartmentId&blockId=$blockid';
            } else {
              blockListUrl = '${Constant.flatListURL}?apartmentId=$apartmentId';
            }

            NetworkUtils.getNetWorkCall(blockListUrl, responseType, this);
          } else {
            Utils.printLog("else called");
            _isLoading = false;
            Utils.showCustomToast(context);
          }
        });
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _updateOwnerName() async {
    setState(() {
      baseImageIssueApi = BaseApiImage.baseImageUrl(apartmentId, "profile");

      Utils.printLog("Base Image$baseImageIssueApi");
      availableData = [
        ...flatlist,
      ];
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    globalResidentList = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle headerLeftTitle = TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.04,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      color: const Color(0xff1B5694),
    );

    TextStyle headerPlaceHolder = TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.05,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      color: const Color(0xff1B5694),
    );
    Widget content;

    if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (globalResidentList.isEmpty && query.isNotEmpty) {
      content = _isLoading
          ? Container()
          : Center(
              child: Padding(
                padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                child: Text(
                  Strings.NO_RESIDNT_AVAILABLE,
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
    } else if (query.isEmpty) {
      content = flatlist.isNotEmpty
          ? GroupedListView<dynamic, String>(
              elements: availableData,
              groupBy: (element) {
                if (element is FlatModel) {
                  return element.floorNumber.toString();
                } else {
                  return '';
                }
              },
              itemComparator: (item1, item2) =>
                  item1.floorNumber.compareTo(item2.floorNumber),
              order: GroupedListOrder.ASC,
              floatingHeader: true,
              groupSeparatorBuilder: (String value) => Padding(
                padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Container(
                        decoration:   BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.all(
                            Radius.circular(FontSizeUtil.CONTAINER_SIZE_10),
                          ),
                        ),
                        padding:   EdgeInsets.symmetric(
                          horizontal: FontSizeUtil.CONTAINER_SIZE_14,
                          vertical: 3.0,
                        ),
                        child: Text(
                          "Floor $value",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              itemBuilder: (ctx, element) {
                return Padding(
                  padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                  child: Stack(
                    children: [
                      Container(
                        decoration: AppStyles.background(context),
                        child: Padding(
                          padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(FontSizeUtil.SIZE_05),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xff1B5694),
                                    width: FontSizeUtil.SIZE_01,
                                  ),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(
                                      FontSizeUtil.SIZE_08),
                                ),
                                child: Text(
                                  "${element.flatNumber.toString()}",
                                  style: const TextStyle(
                                    color: Color(0xff1B5694),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              element.owner == null && element.tenant == null
                                  ? Container(
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            FontSizeUtil.SIZE_08),
                                        child: Center(
                                            child: Text(
                                          Strings.NOT_OCCUPIED_TEXT,
                                          style: AppStyles.heading(context),
                                        )),
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        element.owner != null
                                            ? Row(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                             EdgeInsets
                                                                    .only(
                                                                top:  FontSizeUtil.CONTAINER_SIZE_16,
                                                                left:  FontSizeUtil.CONTAINER_SIZE_15),
                                                        child: SizedBox(
                                                          height:  FontSizeUtil.CONTAINER_SIZE_50,
                                                          width:  FontSizeUtil.CONTAINER_SIZE_50,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                    FontSizeUtil.CONTAINER_SIZE_50),
                                                            child: Stack(
                                                              children: <Widget>[
                                                                if (element.owner != null &&
                                                                    element.owner
                                                                            .profilePicture !=
                                                                        null &&
                                                                    element
                                                                        .owner
                                                                        .profilePicture
                                                                        .isNotEmpty)
                                                                  Image.network(
                                                                    '$baseImageIssueApi${element.owner?.profilePicture.toString()}',
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    height:  FontSizeUtil.CONTAINER_SIZE_100,
                                                                    width:  FontSizeUtil.CONTAINER_SIZE_100,
                                                                    errorBuilder:
                                                                        (context,
                                                                            error,
                                                                            stackTrace) {
                                                                      return ClipRRect(
                                                                          borderRadius:
                                                                        BorderRadius.circular( FontSizeUtil.CONTAINER_SIZE_50),
                                                                          child:
                                                                        const AvatarScreen(),
                                                                        );
                                                                    },
                                                                  )
                                                                else
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            FontSizeUtil.CONTAINER_SIZE_50),
                                                                    child:
                                                                        const AvatarScreen(),
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      if ((screen !=
                                                              Strings
                                                                  .MESSAGE_SCRREN) &&
                                                          (residentId !=
                                                              element
                                                                  .owner?.id))
                                                        Positioned(
                                                          bottom: 0,
                                                          right: 0,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              Utils.makingPhoneCall(
                                                                  element.owner
                                                                      ?.mobile);
                                                            },
                                                            child: Container(
                                                              padding: EdgeInsets
                                                                  .all(FontSizeUtil
                                                                      .SIZE_08),
                                                              decoration: const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          38,
                                                                          105,
                                                                          177,
                                                                          1)),
                                                              child: Icon(
                                                                Icons.call,
                                                                size:
                                                                    FontSizeUtil
                                                                        .SIZE_10,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: FontSizeUtil.SIZE_10,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets
                                                                      .only(
                                                                  top:  FontSizeUtil.CONTAINER_SIZE_16),
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              element.owner
                                                                      ?.fullName ??
                                                                  "",
                                                              style:
                                                                  headerPlaceHolder,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                "Owner",
                                                                style:
                                                                    headerLeftTitle,
                                                              ),
                                                            ),
                                                            if (residentId !=
                                                                element
                                                                    .owner?.id && element.owner.status == "ACTIVE")
                                                              GestureDetector(
                                                                onTap: () => {
                                                                  if (element
                                                                          .owner !=
                                                                      null  && element.owner.status == "ACTIVE")
                                                                    {
                                                                      if (element.owner.pushNotificationToken !=
                                                                              null &&
                                                                          element.owner.id !=
                                                                              null)
                                                                        {
                                                                          Navigator.of(context)
                                                                              .push(
                                                                            createRoute(
                                                                              Message(residentId: element.owner.id, residentDeviseToken: element.owner.pushNotificationToken, residetName: element.owner.fullName),
                                                                            ),
                                                                          ),
                                                                        }
                                                                      else
                                                                        {
                                                                          Utils.showToast(
                                                                              Strings.NO_USER_AVAILABLE),
                                                                        }
                                                                    }
                                                                  else
                                                                    {
                                                                      Utils.showToast(
                                                                          Strings
                                                                              .NO_OWNER_INFORMATION_AVAILABLE),
                                                                    }
                                                                },
                                                                child: Icon(
                                                                  Icons.message,
                                                                  size: FontSizeUtil
                                                                      .CONTAINER_SIZE_30,
                                                                  color: const Color(
                                                                      0xff1B5694),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Container(),
                                        element.tenant != null
                                            ? Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                top: FontSizeUtil
                                                                    .CONTAINER_SIZE_16,
                                                                left: FontSizeUtil
                                                                    .CONTAINER_SIZE_15),
                                                            child: SizedBox(
                                                              height: FontSizeUtil
                                                                  .CONTAINER_SIZE_50,
                                                              width: FontSizeUtil
                                                                  .CONTAINER_SIZE_50,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        FontSizeUtil
                                                                            .CONTAINER_SIZE_50),
                                                                child: Stack(
                                                                  children: <Widget>[
                                                                    if (element.tenant.profilePicture !=
                                                                            null &&
                                                                        element
                                                                            .tenant
                                                                            .profilePicture!
                                                                            .isNotEmpty)
                                                                      Image
                                                                          .network(
                                                                        '$baseImageIssueApi${element.tenant?.profilePicture.toString()}',
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        height:
                                                                            FontSizeUtil.CONTAINER_SIZE_100,
                                                                        width: FontSizeUtil
                                                                            .CONTAINER_SIZE_100,
                                                                        errorBuilder: (context,
                                                                            error,
                                                                            stackTrace) {
                                                                          return const AvatarScreen();
                                                                        },
                                                                      )
                                                                    else
                                                                      const AvatarScreen(),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          if ((screen !=
                                                                  Strings
                                                                      .MESSAGE_SCRREN) &&
                                                              (residentId !=
                                                                      element
                                                                          .owner
                                                                          ?.id ||
                                                                  residentId !=
                                                                      element
                                                                          .tenant
                                                                          ?.id))
                                                            Positioned(
                                                              bottom: 0,
                                                              right: 0,
                                                              child:
                                                                  GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  Utils.makingPhoneCall(
                                                                      element
                                                                          .tenant
                                                                          ?.mobile);
                                                                },
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets.all(
                                                                      FontSizeUtil
                                                                          .SIZE_08),
                                                                  decoration: const BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Color.fromRGBO(
                                                                          38,
                                                                          105,
                                                                          177,
                                                                          1)),
                                                                  child: Icon(
                                                                    Icons.call,
                                                                    size: FontSizeUtil
                                                                        .SIZE_10,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: FontSizeUtil
                                                            .SIZE_10,
                                                      ),
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                  top: FontSizeUtil
                                                                      .CONTAINER_SIZE_16),
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Text(
                                                                  element.tenant
                                                                          ?.fullName ??
                                                                      "",
                                                                  style:
                                                                      headerPlaceHolder,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child: Text(
                                                                    "Tenant",
                                                                    style:
                                                                        headerLeftTitle,
                                                                  ),
                                                                ),
                                                                if (residentId !=
                                                                    element
                                                                        .tenant
                                                                        ?.id &&  element.tenant.status == "ACTIVE")
                                                                  GestureDetector(
                                                                    onTap: () =>
                                                                        {
                                                                      if (element
                                                                              .tenant !=
                                                                          null &&  element.tenant.status == "ACTIVE")
                                                                        {
                                                                          if (element.tenant.pushNotificationToken != null &&
                                                                              element.tenant.id != null)
                                                                            {
                                                                              Navigator.of(context).push(
                                                                                createRoute(
                                                                                  Message(residentId: element.tenant.id, residentDeviseToken: element.tenant.pushNotificationToken, residetName: element.tenant.fullName),
                                                                                ),
                                                                              ),
                                                                            }
                                                                          else
                                                                            {
                                                                              Utils.showToast(Strings.NO_USER_AVAILABLE),
                                                                            }
                                                                        }
                                                                      else
                                                                        {
                                                                          Utils.showToast(
                                                                              Strings.NO_OWNER_INFORMATION_AVAILABLE),
                                                                        }
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .message,
                                                                      size: FontSizeUtil
                                                                          .CONTAINER_SIZE_30,
                                                                      color: const Color(
                                                                          0xff1B5694),
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Divider(),
                                                ],
                                              )
                                            : Container(),
                                      ],
                                    ),
                              if ((screen != Strings.MESSAGE_SCRREN) &&
                                  (element.familyMemberDetails != null &&
                                      element.familyMemberDetails.isNotEmpty))
                                ...element.familyMemberDetails.map((member) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Row(
                                          children: [
                                            Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 1.0),
                                                  child: SizedBox(
                                                    height: FontSizeUtil
                                                        .CONTAINER_SIZE_50,
                                                    width: FontSizeUtil
                                                        .CONTAINER_SIZE_50,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius
                                                          .circular(FontSizeUtil
                                                              .CONTAINER_SIZE_50),
                                                      child: Stack(
                                                        children: <Widget>[
                                                          if (member.profilePicture !=
                                                                  null &&
                                                              member
                                                                  .profilePicture!
                                                                  .isNotEmpty)
                                                            Image.network(
                                                              '$baseImageIssueApi${member.profilePicture.toString()}',
                                                              fit: BoxFit.cover,
                                                              height: FontSizeUtil
                                                                  .CONTAINER_SIZE_100,
                                                              width: FontSizeUtil
                                                                  .CONTAINER_SIZE_100,
                                                              errorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                                return const AvatarScreen();
                                                              },
                                                            )
                                                          else
                                                            const AvatarScreen(),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: FontSizeUtil.SIZE_10,
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      member.fullName,
                                                      style: headerPlaceHolder,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          member.relation!,
                                                          style:
                                                              headerLeftTitle,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Divider(),
                                    ],
                                  );
                                }).toList(),
                            ],
                          ),
                        ),
                      ),
                      if ((screen != Strings.MESSAGE_SCRREN))
                        Positioned(
                          top: FontSizeUtil.SIZE_07,
                          right: FontSizeUtil.SIZE_07,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xff1B5694),
                                width: FontSizeUtil.SIZE_01,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: FontSizeUtil.SIZE_04,
                                top: FontSizeUtil.SIZE_02,
                                left: FontSizeUtil.SIZE_02,
                                bottom: FontSizeUtil.SIZE_02,
                              ),
                              child: Text(
                                " ${element.totalNumberOfResidents.toString()}",
                                style: const TextStyle(
                                  color: Color(0xff1B5694),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            )
          : _isLoading
              ? Container()
              : Center(
                  child: Text(
                    Strings.NO_RESIDENT_TEXT,
                    style: AppStyles.heading(context),
                  ),
                );
    } else {
      content = Padding(
        padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
        child: GlobalSeaechedGridView(
            press: editUserChoice,
            users: globalResidentList,
            baseImageIssueApi: baseImageIssueApi),
      );
    }

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
            title: screen != Strings.MESSAGE_SCRREN
                ? apartmentName
                : Strings.RESIDENT_LIST_HEADER,
            profile: () {},
          ),
        ),
        body: AbsorbPointer(
          absorbing: _isLoading,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
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
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: FontSizeUtil.CONTAINER_SIZE_15,
                            vertical: FontSizeUtil.SIZE_05),
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
                                          ? const Color.fromARGB(
                                              255, 0, 137, 250)
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
                                        FilteringTextInputFormatter.deny(Strings.EMOJI_DENY_REGEX),
                                      ],
                                      controller: _searchController,
                                      keyboardType: TextInputType.text,
                                      style: AppStyles.heading1(context),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            top:
                                                FontSizeUtil.CONTAINER_SIZE_15),
                                        hintText: LocalizationUtil.translate(
                                            'apartmentDataDisplaySearchHint'),
                                        prefixIcon: const Icon(Icons.search),
                                        suffixIcon: _searchController
                                                .text.isNotEmpty
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
                                      onFieldSubmitted: (value) {
                                        if (value.trim().isNotEmpty) {
                                          _filterList(value);
                                          globalResidentList.clear();
                                        } else {
                                          _filterList('');
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: content),
                      SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                      const FooterScreen(),
                    ],
                  ),
                ),
              ),
              if (_isLoading) const Positioned(child: LoadingDialog()),
              if (widget.blockCount! < 2 && userType != Strings.ROLEOWNER &&  userType != Strings.ROLETENANT)
                Positioned(
                  bottom: 50 - _yOffset,
                  right: 10 - _xOffset,
                  child: GestureDetector(
                    onPanStart: (details) {},
                    onPanUpdate: (details) {
                      setState(() {
                        _xOffset += details.delta.dx;
                        _yOffset += details.delta.dy;
                      });
                    },
                    onPanEnd: (details) {},
                    child: FloatingActionButton(
                      heroTag: "btn2",
                      onPressed: () {
                        Navigator.of(context)
                            .push(createRoute(const GroupMessageScreen()));
                      },
                      backgroundColor: const Color(0xff1B5694),
                      foregroundColor: Colors.white,
                      child: Image.asset(
                        "assets/images/megaphone.png",
                        color: Colors.white,
                        height: FontSizeUtil.CONTAINER_SIZE_30,
                        width: FontSizeUtil.CONTAINER_SIZE_30,
                      ),
                    ),
                  ),
                ),
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

    if (status == 401) {
      Utils.sessonExpired(context);
    } else {
      Utils.showToast(Strings.API_ERROR_MSG_TEXT);
    }
  }

  @override
  onSuccess(response, String responseType) async {
    try {
      Utils.printLog("Responce Type $responseType Responce$response");
      setState(() {
        globalResidentList = [];

        if (responseType == 'blockList') {
          blocklist = (json.decode(response) as List)
              .map((item) => BlockModel.fromJson(item))
              .toList();
          print("blocklist size==${blocklist.length}");
          _isLoading = false;
        } else if (responseType == 'globalSearch') {
          _isLoading = false;

          List<ApiResponse> globalSearchResidentList =
              (json.decode(response) as List)
                  .map((item) => ApiResponse.fromJson(item))
                  .toList();
          globalResidentList = globalSearchResidentList;
        } else if (responseType == 'flatList') {
          List<FlatModel> flatlst = (json.decode(response) as List)
              .map((item) => FlatModel.fromJson(item))
              .toList();

          flatlist = flatlst;
          Utils.printLog("flatlist lenth = ${flatlist.length}");
          setState(() {
            _isLoading = false;
          });
          _updateOwnerName();
        } else if (responseType == 'postMessage') {
          successAlert(
            context,
            response,
          );
          selectedIndexes.clear();
          chatMessage = '';
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (error) {
      setState(() {
        globalResidentList = [];
        _isLoading = false;
      });

      Utils.printLog("Error === $response");
    }
  }

  @override
  onNavigatorBackPressed() {
    Navigator.pop(context);
  }
}
