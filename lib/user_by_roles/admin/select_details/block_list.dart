import 'dart:convert';
import 'package:SMP/components/block_list_card.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/model/block_model.dart';
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

class BlockList extends StatefulWidget {
  BlockList({super.key, required this.apartmentId, required this.dataListener});
  int apartmentId;

  AppartmentDataListener dataListener;
  @override
  State<BlockList> createState() {
    return _BlockListState();
  }
}

class _BlockListState extends State<BlockList> with ApiListener {
  final TextEditingController _searchController = TextEditingController();
  bool setShowlistflag = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isNetworkConnected = false, _isLoading = false;

  List originalUsers = [];
  List apartmentList = [];

  String query = "";

  @override
  void initState() {
    super.initState();
    _choose();
  }

  int? selectedBlockId;
  String selectedBlockName = '';

  bool floorAvailable = false;

  void editUserChoice(users) {
    print(users.blockName);
    print(users.id);

    setState(() {
      Navigator.pop(context);
      widget.dataListener.onDataClicked(
          users.id, users.blockName, floorAvailable, Strings.BLOCK_NAME);
    });
  }

  Future<void> _choose() async {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        print(_isNetworkConnected);
        String responseType = "email";
        if (_isNetworkConnected) {
          int apartId = widget.apartmentId;
          _isLoading = true;
          String blockListUrl = '${Constant.blockListURL}?apartmentId=$apartId';
          NetworkUtils.getNetWorkCall(blockListUrl, responseType, this);
        } else {
          print("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  Color _containerBorderColor2 = Colors.white;
  Color _boxShadowColor2 = const Color.fromARGB(255, 100, 100, 100);

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
              user.blockName.toLowerCase().contains(query.toLowerCase());
          return nameMatches;
        }).toList();
      } else {
        originalUsers = apartmentList;
      }
    });
  }

  var selectedUser = '';

  @override
  Widget build(BuildContext context) {
    getList();

    Widget content = Padding(
      padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
      child: BlockListViewCard(
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
                          EdgeInsets.symmetric(horizontal: FontSizeUtil.SIZE_03, vertical:FontSizeUtil.SIZE_05),
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
                                      hintText: Strings.BLOCK_LIST_SEARCH_PLACEHOLDER,
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
        if (responseType == "email") {
          print("Block List $responseType");

          apartmentList = (json.decode(response) as List)
              .map((item) => BlockModel.fromJson(item))
              .toList();

          _isLoading = false;
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
