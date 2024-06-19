import 'dart:convert';

import 'package:SMP/components/flat_list_card.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/model/in_active_flats_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../presenter/flat_data_listener.dart';

class FlatList extends StatefulWidget {
  FlatList({
    super.key,
    required this.apartmentId,
    required this.blockId,
    required this.dataListener,
  });

  int blockId;
  int apartmentId;
  FlatDataListener dataListener;

  @override
  State<FlatList> createState() {
    return _FlatList();
  }
}

class _FlatList extends State<FlatList> with ApiListener {
  final TextEditingController _searchController = TextEditingController();
  bool setShowlistflag = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isNetworkConnected = false, _isLoading = false;

  List originalUsers = [];
  List apartmentList = [];

  int apartmentId = 0;
  String query = "";

  @override
  void initState() {
    super.initState();
    _choose();
  }

  int? selectedFlatId;
  int? selecteUserId = 0;

  String selectedFlatName = '';
  String selecteUserName = '';
  String userDeviceId = "";

  void editUserChoice(users) {
    print("object");
    print(users.id);

    setState(() {
      selectedFlatId = users.id;
      selectedFlatName = users.flatNumber.toString();

      if (users != null &&
          users.tenant != null &&
          users.tenant.fullName != null) {
        selecteUserName = users.tenant.fullName ?? '';
        selecteUserId = users.tenant.id;
        userDeviceId = users.tenant.pushNotificationToken;
      } else if (users.owner != null && users.owner.fullName != null) {
        selecteUserName = users.owner.fullName ?? '';
        selecteUserId = users.owner.id;
        userDeviceId = users.owner.pushNotificationToken;
      }

      print("Selected User ID  $selecteUserId");
      print("Selected User NMaE  $selecteUserName");

      Navigator.pop(context);

      widget.dataListener.onFlatDataClicked(selectedFlatId, selectedFlatName,
          selecteUserId, selecteUserName, userDeviceId);
    });
  }

  Future<void> _choose() async {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "flatList";

          int blockId = widget.blockId;
          // int floorID = widget.floorID;
          int apartId = widget.apartmentId;

          String blockListUrl = '';

          if (blockId != 0) {
            blockListUrl =
                '${Constant.getAllFlatsURL}?blockId=$blockId&apartmentId=$apartId';
          } else {
            blockListUrl = '${Constant.getAllFlatsURL}?apartmentId=$apartId';
          }
          NetworkUtils.getNetWorkCall(blockListUrl, responseType, this);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  void _filterList(String query) {
    setState(() {
      this.query = query;
    });
  }

  void getList() {
    setState(() {
      if (query.isNotEmpty) {
        originalUsers = apartmentList.where((user) {
          final nameMatches =
              user.flatNumber.toLowerCase().contains(query.toLowerCase());
          return nameMatches;
        }).toList();
      } else {
        originalUsers = apartmentList;
      }
    });
  }

  Color _containerBorderColor2 = Colors.white;
  Color _boxShadowColor2 = const Color.fromARGB(255, 100, 100, 100);

  var selectedUser = '';

  @override
  Widget build(BuildContext context) {
    getList();
    Widget content;

    if (originalUsers.isNotEmpty) {
      content = Padding(
        padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
        child: FlatListViewCard(
          press: editUserChoice,
          users: originalUsers,
          selectedUser: selectedUser,
        ),
      );
    } else {
      content = _isLoading
          ? Container()
          : Center(
              child: Padding(
                padding: EdgeInsets.only(top: FontSizeUtil.SIZE_08),
                child: Text(
                  Strings.NO_FLATS_TEXT,
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
    }

    return Scaffold(
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
                    SizedBox(height: FontSizeUtil.CONTAINER_SIZE_40),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: FontSizeUtil.SIZE_03,
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
                                      contentPadding: EdgeInsets.only(
                                          top: FontSizeUtil.CONTAINER_SIZE_14),
                                      hintText: Strings.FLAT_SEARCH_PLACEHOLDER,
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
                    SizedBox(height: FontSizeUtil.SIZE_10),
                    Expanded(child: content),
                    const FooterScreen(),
                  ],
                ),
              ),
            ),
            if (_isLoading) const Positioned(child: LoadingDialog()),
          ],
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
      Utils.printLog("responseType :: $responseType responses::$response");

      setState(() {
        _isLoading = false;
        if (responseType == "flatList") {
          setState(() {
            apartmentList = (json.decode(response) as List)
                .map((item) => InActiveFlatModel.fromJson(item))
                .toList();
          });
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
