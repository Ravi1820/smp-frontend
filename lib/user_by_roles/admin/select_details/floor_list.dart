import 'dart:convert';

import 'package:SMP/components/floor_list.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/model/floor_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/appartment_data_listener.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';

class FloorList extends StatefulWidget {
  // const FloorList({super.key});
  FloorList(
      {super.key,
      required this.apartmentId,
      required this.blockId,
      required this.dataListener});
  int blockId;
  int apartmentId;
  AppartmentDataListener dataListener;

  @override
  State<FloorList> createState() {
    return _FloorListList();
  }
}

class _FloorListList extends State<FloorList> with ApiListener {
  final TextEditingController _searchController = TextEditingController();
  bool setShowlistflag = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isNetworkConnected = false, _isLoading = false;
  List originalUsers = [];
  List apartmentList = [];
  int apartmentId = 0;
  String query = "";
  int? selectedFloorId;
  String selectedFloorName = '';
  bool flatAvailable = false;
  Color _containerBorderColor2 = Colors.white;
  Color _boxShadowColor2 = const Color.fromARGB(255, 100, 100, 100);
  var selectedUser = '';

  @override
  void initState() {
    super.initState();
    _choose();
  }



  void editUserChoice(users) {
    print("object");
    print(users.id);
    Navigator.pop(context);

    widget.dataListener.onDataClicked(users.id, users.floorNumber.toString(),
        flatAvailable, Strings.FLOOR_NAME);
  }

  Future<void> _choose() async {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "floorsList";
          int apartId = widget.apartmentId;
          int blockId = widget.blockId;
          String blockListUrl = '';
          if (blockId != 0) {
            blockListUrl =
                '${Constant.getAllFloorsURL}?apartmentId=$apartId&blockId=$blockId';
          } else {
            blockListUrl = '${Constant.getAllFloorsURL}?apartmentId=$apartId';
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
              user.name.toLowerCase().contains(query.toLowerCase());
          return nameMatches;
        }).toList();
      } else {
        originalUsers = apartmentList;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    getList();

    Widget content = Padding(
      padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
      child: FloorListViewCard(
        press: editUserChoice,
        users: originalUsers,
        selectedUser: selectedUser,
      ),
    );

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
                      padding:
                          EdgeInsets.symmetric(horizontal: FontSizeUtil.SIZE_03, vertical: FontSizeUtil.SIZE_05),
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
                                    borderRadius: BorderRadius.circular(FontSizeUtil.SIZE_10),
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
                                    controller: _searchController,
                                    keyboardType: TextInputType.text,
                                    style: AppStyles.heading1(context),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.only(top: FontSizeUtil.CONTAINER_SIZE_14),
                                      hintText: Strings.FLOOR_SEARCH_PLACEHOLDER,
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
      setState(() {
        _isLoading = false;
        if (responseType == "floorsList") {
          setState(() {
            apartmentList = (json.decode(response) as List)
                .map((item) => FloorModel.fromJson(item))
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
