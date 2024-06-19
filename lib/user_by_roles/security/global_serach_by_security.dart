import 'dart:async';
import 'dart:convert';
import 'package:SMP/components/security_search_resident.dart';
import 'package:SMP/components/security_search_resident_card.dart';
import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/translate.dart';
import 'package:SMP/model/global_search.dart';
import 'package:SMP/model/resident_model.dart';
import 'package:SMP/model/security_search_resident_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/owner_list/messages.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';

import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalSearchBySecurity extends StatefulWidget {
  const GlobalSearchBySecurity({super.key});

  @override
  State<GlobalSearchBySecurity> createState() {
    return _GlobalSearchBySecurityState();
  }
}

class _GlobalSearchBySecurityState extends State<GlobalSearchBySecurity>
    with ApiListener {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var selectedIndexes = [];
  String apartmentName = '';

  List globalResidentList = [];

  bool showCheckbox = false;
  bool _isNetworkConnected = false, _isLoading = true;

  bool isLoading = false;

  List allResidentsLists = [];
  String query = "";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();
    _getApartment();
    _choose();
    _getResidentList();
  }

  int apartmentId = 0;
  int residentId = 0;

  Future<void> _choose() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');
    final apartId = prefs.getInt('apartmentId');
    setState(() {
      apartmentId = apartId!;
      residentId = id!;
    });
  }

  Future<void> _getResidentList() async {
    setState(() {
      isLoading = true;
    });

    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "ownerList";

          String ownerListUrl =
              '${Constant.allFlatOwnerURL}?apartmentId=$apartmentId';

          NetworkUtils.getNetWorkCall(ownerListUrl, responseType, this);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apartId = prefs.getInt('apartmentId');

    setState(() {
      isLoading = false;
      baseImageIssueApi = BaseApiImage.baseImageUrl(apartId!, "profile");
    });
  }

  String baseImageIssueApi = '';

  Future<void> getList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apartmentId = prefs.getInt('apartmentId');

    setState(() {
      baseImageIssueApi = BaseApiImage.baseImageUrl(apartmentId!, "profile");
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

  List<ResidentModel> selectedSecurity = [];
  List<ApiResponse> selectedSecurity1 = [];

  Timer? _debounce;
  int userId = 0;

  bool showErrorMessage = false;
  bool showPurposeErrorMessage = false;
  Color _containerBorderColor2 = Colors.white;
  Color _boxShadowColor2 = const Color.fromARGB(255, 100, 100, 100);

  void editUserChoice1(users) {
    Navigator.of(context).push(
      createRoute(
        Message(
            residentId: users.id,
            residentDeviseToken: users.pushNotificationToken ?? "",
            residetName: users.fullName),
      ),
    );
  }

  Future<void> _fetchData(String query) async {
    try {
      setState(() {
        isLoading = true;
      });

      if (query.isNotEmpty) {
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
      } else {
        setState(() {
          globalResidentList.clear();
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  _getApartment() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apartName = prefs.getString('apartmentName');

    setState(() {
      apartmentName = apartName!;
    });
  }

  void editUserChoice(users) {
    _formKey.currentState!.save();
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

    if (globalResidentList.isEmpty && query.isNotEmpty) {
      content = _isLoading
          ? Container()
          : Center(
              child: Padding(
                padding:  EdgeInsets.all(FontSizeUtil.SIZE_08),
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
      content = Padding(
        padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
        child: SecuritySearchResidentListViewCard(
            press: editUserChoice1,
            users: allResidentsLists,
            baseImageIssueApi: baseImageIssueApi,
            selectedCountries: selectedSecurity),
      );
    } else {
      content = Padding(
        padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
        child: SecuritySearchView(
          press: editUserChoice,
          users: globalResidentList,
          baseImageIssueApi: baseImageIssueApi,
        ),
      );
    }

    return AbsorbPointer(
      absorbing: _isLoading,
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
                        Color.fromARGB(255, 255, 255, 255),
                        Color.fromARGB(255, 255, 255, 255),
                        Color.fromARGB(255, 255, 255, 255),
                        Color.fromARGB(255, 255, 255, 255),
                      ],
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                       SizedBox(height: FontSizeUtil.CONTAINER_SIZE_20),
                      Padding(
                        padding:
                             EdgeInsets.symmetric(horizontal:  FontSizeUtil.CONTAINER_SIZE_15, vertical: FontSizeUtil.SIZE_05),
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
                                    child:
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(Strings.EMOJI_DENY_REGEX)
                                      ],
                                      controller: _searchController,
                                      keyboardType: TextInputType.text,
                                      style: AppStyles.heading1(context),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                             EdgeInsets.only(top:  FontSizeUtil.CONTAINER_SIZE_14),
                                        hintText: LocalizationUtil.translate(
                                            'apartmentDataDisplaySearchHint'),
                                        prefixIcon: const Icon(Icons.search),
                                        suffixIcon: _searchController.text.isNotEmpty
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

                                      onFieldSubmitted: (value) {
                                        if (value.trim().isNotEmpty) {
                                          _filterList(value);
                                          globalResidentList.clear();
                                        }else{
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
                       SizedBox(height: FontSizeUtil.SIZE_10),
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
      // Utils.printLog("responsetype=$responseType   reponse::$response");
      setState(() {
        globalResidentList = [];
        _isLoading = false;
        if (responseType == 'globalSearch') {
          globalResidentList.clear();
          Utils.printLog("Calling on local List  ${globalResidentList}");
          List<ApiResponse> globalSearchResidentList =
              (json.decode(response) as List)
                  .map((item) => ApiResponse.fromJson(item))
                  .toList();
          globalResidentList = globalSearchResidentList;
          Utils.printLog("Calling on APi List  $globalSearchResidentList");
        } else if (responseType == 'ownerList') {
          List<SecuritySearchResidentModel> residentList =
              (json.decode(response) as List)
                  .map((item) => SecuritySearchResidentModel.fromJson(item))
                  .toList();

          setState(() {
            allResidentsLists = residentList;
          });
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        globalResidentList = [];
        Utils.printLog("Calling on Catch${globalResidentList}");
      });

      Utils.printLog("Error === $response");
    }
  }
}
