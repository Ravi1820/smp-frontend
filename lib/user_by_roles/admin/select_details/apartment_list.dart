import 'dart:convert';

import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/model/movies.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/appartment_data_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/components/hospital_list_card.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';

class AprtmentList extends StatefulWidget {
  AprtmentList({super.key, required this.dataListener});
  AppartmentDataListener dataListener;

  @override
  State<AprtmentList> createState() {
    return _AprtmentList();
  }
}

class _AprtmentList extends State<AprtmentList>
    with ApiListener, NavigatorListener {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isNetworkConnected = false, _isLoading = false;
  bool _isMounted = false;
  List originalUsers = [];
  List apartmentList = [];
  String query = "";
  var selectedUser = '';
  Color _containerBorderColor2 = Colors.white;
  Color _boxShadowColor2 = const Color.fromARGB(255, 100, 100, 100);
  bool blockAvailable = false;
  int? selectedApartmentId;
  int? _blockCount;
  String selectedApartmentName = '';


  @override
  void initState() {
    _isMounted = true;
    super.initState();
    _getAppartmentData();
  }


  Future<void> editUserChoice(users) async {
    print("object");
    setState(() {
      selectedApartmentId = users.apartmentId;
      _blockCount = users.blockCount;
      selectedApartmentName = users.name;
    });

    Navigator.pop(context);
    widget.dataListener.onDataClicked(
      selectedApartmentId,
      selectedApartmentName,
      _blockCount,
      Strings.APPARTMENT_NAME,
    );
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
      padding: EdgeInsets.symmetric(horizontal: FontSizeUtil.SIZE_08),
      child: HospitalListViewCard(
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
                                    controller: _searchController,
                                    keyboardType: TextInputType.text,
                                    style: AppStyles.heading1(context),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.only(top:  FontSizeUtil.CONTAINER_SIZE_14),
                                      hintText: Strings.APARTMENT_LIST,
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

  Future<void> _getAppartmentData() async {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      if (_isMounted) {
        setState(() {
          _isNetworkConnected = status;
          print(_isNetworkConnected);
          String responseType = Strings.APPARTMENT_DATA_TYPE;
          if (_isNetworkConnected) {
            _isLoading = true;
            NetworkUtils.getNetWorkCall(
                Constant.apartmentListURL, responseType, this);
          } else {
            print("else called");
            _isLoading = false;
            Utils.showCustomToast(context);
          }
        });
      }
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
      if (_isMounted) {
        Utils.printLog("responseType :: $responseType responses::$response");

        setState(() {
          _isLoading = false;
          if (responseType == Strings.APPARTMENT_DATA_TYPE) {
            setState(() {
              List<ApartmentModel> apartlist = (json.decode(response) as List)
                  .map((item) => ApartmentModel.fromJson(item))
                  .toList();

              apartmentList = apartlist;
            });
          }
        });
      }
    } catch (error) {
      if (_isMounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
        widget.dataListener.onDataClicked(
          selectedApartmentId,
          selectedApartmentName,
          0,
          Strings.APPARTMENT_NAME,
        );

        Utils.printLog("Error text === $response");
      }
    }
  }

  @override
  onNavigatorBackPressed() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }
}
