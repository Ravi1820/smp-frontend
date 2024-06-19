import 'dart:async';
import 'dart:convert';

import 'package:SMP/components/global_searched_grid_view.dart';
import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/contants/translate.dart';
import 'package:SMP/model/block_model.dart';
import 'package:SMP/model/global_search.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/owner_list/admin_resident_list.dart';
import 'package:SMP/user_by_roles/admin/owner_list/group_messae_list.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() {
    return _CategoryScreenState();
  }
}

class _CategoryScreenState extends State<CategoryScreen> with ApiListener {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var selectedIndexes = [];
  String apartmentName = '';
  List<BlockModel> blocklist = [];
  List globalResidentList = [];
  bool showCheckbox = false;
  bool _isNetworkConnected = false, _isLoading = true;
  bool isLoading = false;
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

    super.initState();
    _choose();
    _getAllBlockList();
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
      globalResidentList.clear();
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
      } else {
        globalResidentList.clear();
      }
    } catch (error) {
      print('Error fetching data: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  _getAllBlockList() {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "blockList";
          String blockListUrl =
              '${Constant.blockListURL}?apartmentId=$apartmentId';
          NetworkUtils.getNetWorkCall(blockListUrl, responseType, this);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  void editUserChoice(users) {
    _formKey.currentState!.save();
  }

  void _handleBlockTap(tappedBlock) {
    Navigator.of(context).push(createRoute(AdminResidentListScreen(
      id: tappedBlock.id,
      blockName: tappedBlock.blockName,
      blockCount: blocklist.length,
      screenName: Strings.ADMIN_BLOCK_SCREEN,
    )));
  }

  @override
  void dispose() {
    _searchController.dispose();
    globalResidentList = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  Strings.NO_BLOCK_TEXT,
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
    } else if (globalResidentList.isEmpty && query.isEmpty) {
      content = ListView(
        children: blocklist.map((block) {
          return Column(
            children: <Widget>[
              GestureDetector(
                onTap: () => _handleBlockTap(block),
                child: Card(
                  child: Container(
                    decoration: AppStyles.decoration(context),
                    child: Padding(
                      padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  block.blockName!,
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff1B5694)),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      );
    } else {
      content = Padding(
        padding: const EdgeInsets.all(8.0),
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
            title: apartmentName,
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
                      SizedBox(height: FontSizeUtil.CONTAINER_SIZE_20),
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
                                      onChanged: (value) {
                                        if (value.trim().isNotEmpty) {
                                          _filterList(value);
                                          globalResidentList.clear();
                                        } else {
                                          _filterList('');
                                          globalResidentList.clear();
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
                      SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                      Expanded(child: content),
                      SizedBox(height: FontSizeUtil.CONTAINER_SIZE_30),
                      const FooterScreen(),
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
            if (userType != Strings.ROLETENANT)
              Positioned(
                bottom: 50,
                right: 10,
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
                    width:  FontSizeUtil.CONTAINER_SIZE_30,
                  ),
                ),
              ),
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
      Utils.printLog("Responce Type $responseType Responce$response");
      setState(() {
        if (responseType == 'blockList') {
          blocklist = (json.decode(response) as List)
              .map((item) => BlockModel.fromJson(item))
              .toList();
          _isLoading = false;
        } else if (responseType == 'globalSearch') {
          _isLoading = false;
          globalResidentList.clear();

          List<ApiResponse> globalSearchResidentList =
              (json.decode(response) as List)
                  .map((item) => ApiResponse.fromJson(item))
                  .toList();
          globalResidentList = globalSearchResidentList;
        } else if (responseType == 'postMessage') {
          successDialog(context, response, const CategoryScreen());
          _isLoading = false;
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        if (query.isNotEmpty) {
          globalResidentList = [];
        }
        globalResidentList.clear();
      });

      Utils.printLog("Error === $response");
    }
  }
}
