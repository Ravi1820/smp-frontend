import 'dart:async';
import 'dart:convert';
import 'package:SMP/components/resident_list_card.dart';
import 'package:SMP/components/search_and_send_message.dart';
import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/contants/translate.dart';
import 'package:SMP/model/global_search.dart';
import 'package:SMP/model/security_search_resident_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/owner_list/messages.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupMessageScreen extends StatefulWidget {
  const GroupMessageScreen({super.key});

  @override
  State<GroupMessageScreen> createState() {
    return _GroupMessageScreenState();
  }
}

class _GroupMessageScreenState extends State<GroupMessageScreen>
    with ApiListener, NavigatorListener {
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
  int apartmentId = 0;
  int residentId = 0;
  int? blockCount = 0;
  String baseImageIssueApi = '';
  List selectedSecurity = [];
  List<ApiResponse> selectedSecurity1 = [];
  Timer? _debounce;
  int userId = 0;
  bool showErrorMessage = false;
  bool showPurposeErrorMessage = false;
  Color _containerBorderColor1 = Colors.white;
  Color _containerBorderColor2 = Colors.white;
  Color _boxShadowColor1 = const Color.fromARGB(255, 100, 100, 100);
  Color _boxShadowColor2 = const Color.fromARGB(255, 100, 100, 100);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();
    _getApartment();
    _choose();
    _getResidentList();
  }

  Future<void> _choose() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final id = prefs.getInt('id');
    final apartId = prefs.getInt('apartmentId');
    setState(() {
      apartmentId = apartId!;
      residentId = id!;
      blockCount = prefs.getInt('blockCount');
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
    setState(() {
      isLoading = false;
      baseImageIssueApi = BaseApiImage.baseImageUrl(residentId, "profile");
    });
  }

  Future<void> getList() async {
    setState(() {
      baseImageIssueApi = BaseApiImage.baseImageUrl(residentId, "profile");
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

  void editUserChoice1(users) {
    Navigator.of(context).push(
      createRoute(
        Message(
            residentId: users.id,
            residentDeviseToken: "",
            residetName: users.fullName),
      ),
    );
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
          setState(() {
            isLoading = false;
          });
        }

        getList();
      } else {
        globalResidentList.clear();
      }
    } catch (error) {
      Utils.printLog('Error fetching data: $error');
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

    if (isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (globalResidentList.isEmpty && query.isNotEmpty) {
      content = Center(
        child: Padding(
          padding: EdgeInsets.all(FontSizeUtil.SIZE_05),
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
    } else if (globalResidentList.isEmpty && query.isEmpty) {
      content = Padding(
        padding: EdgeInsets.all(FontSizeUtil.SIZE_05),
        child: ResidentListViewCard(
          press: editUserChoice1,
          users: allResidentsLists,
          blockCount: blockCount!,
          baseImageIssueApi: baseImageIssueApi,
          selectedCountries: selectedSecurity,
          onSelectedMembersChanged: (List updatedSelectedMembers) {
            setState(() {
              selectedSecurity = updatedSelectedMembers;
            });
          },
        ),

        // ),
      );
    } else {
      content = Padding(
        padding: EdgeInsets.all(FontSizeUtil.SIZE_05),
        child: GlobalSearchResidentGridView(
            press: editUserChoice,
            users: globalResidentList,
            baseImageIssueApi: baseImageIssueApi,
            selectedCountries: selectedSecurity1),
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
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(Strings.EMOJI_DENY_REGEX)
                                      ],
                                      controller: _searchController,
                                      keyboardType: TextInputType.text,
                                      style: AppStyles.heading1(context),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            top:
                                                FontSizeUtil.CONTAINER_SIZE_14),
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
        floatingActionButton: Padding(
          padding: EdgeInsets.only(
              bottom: FontSizeUtil.CONTAINER_SIZE_100,
              left: FontSizeUtil.CONTAINER_SIZE_50),
          child: FloatingActionButton(
            onPressed: () {
              if (selectedSecurity.isNotEmpty || selectedSecurity1.isNotEmpty) {
                _showCustomDialog(
                    context, _containerBorderColor1, _boxShadowColor1);
              } else {
                Fluttertoast.showToast(
                  msg: Strings.LONG_PRESS_MESSAGE_TEXT,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                );
              }
            },
            backgroundColor: const Color(0xff1B5694),
            foregroundColor: Colors.white,
            child: const Icon(Icons.message_sharp),
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
      setState(() {
        _isLoading = false;
        globalResidentList = [];
       if (responseType == 'globalSearch') {
          List<ApiResponse> globalSearchResidentList =
              (json.decode(response) as List)
                  .map((item) => ApiResponse.fromJson(item))
                  .toList();
          globalResidentList = globalSearchResidentList;
          setState(() {
            _isLoading = false;
          });
        } else if (responseType == 'postMessage') {
          successDialogWithListner(
              context, response, const GroupMessageScreen(), this);
        } else if (responseType == 'ownerList') {
          List<SecuritySearchResidentModel> movieList =
              (json.decode(response) as List)
                  .map((item) => SecuritySearchResidentModel.fromJson(item))
                  .toList();

          setState(() {
            allResidentsLists = movieList;
          });
        }
      });
    } catch (error) {
      setState(() {
        globalResidentList = [];
        _isLoading = false;
        if (query.isNotEmpty) {
          globalResidentList = [];
        }
      });
      Utils.printLog("Error === $response");
    }
  }

  void _showCustomDialog(
      BuildContext context, containerBorderColor1, boxShadowColor) {
    String newOption = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              width: 330,
              decoration: AppStyles.decoration(context),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                         Expanded(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: FontSizeUtil.CONTAINER_SIZE_30),
                              child:Text(
                                Strings.MESSAGE,
                                style: TextStyle(
                                  color:const Color.fromRGBO(27, 86, 148, 1.0),
                                  fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                            child: Container(
                              height: FontSizeUtil.CONTAINER_SIZE_30,
                              width: FontSizeUtil.CONTAINER_SIZE_30,
                              decoration: AppStyles.circle1(context),
                              child: const Icon(
                                Icons.close_sharp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: FontSizeUtil.CONTAINER_SIZE_18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: <Widget>[
                              FocusScope(
                                child: Focus(
                                  onFocusChange: (hasFocus) {
                                    setState(() {
                                      containerBorderColor1 = hasFocus
                                          ? const Color.fromARGB(
                                              255, 0, 137, 250)
                                          : Colors.white;
                                      boxShadowColor = hasFocus
                                          ? const Color.fromARGB(
                                              162, 63, 158, 235)
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
                                          color: boxShadowColor,
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: containerBorderColor1,
                                      ),
                                    ),
                                    height: FontSizeUtil.CONTAINER_SIZE_100,
                                    child: TextFormField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      style: const TextStyle(
                                          color: Colors.black87),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(top: FontSizeUtil.CONTAINER_SIZE_14),
                                        prefixIcon:const Icon(
                                          Icons.description,
                                          color: Color(0xff4d004d),
                                        ),
                                        hintText: Strings.ISSUE_ACTION_PLACEHOLDER,
                                        hintStyle:
                                          const TextStyle(color: Colors.black38),
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty ||
                                            value.trim().length <= 1 ||
                                            value.trim().length > 20) {
                                          setState(() {
                                            // showErrorMessage = true;
                                          });
                                        } else {
                                          setState(() {
                                            // showErrorMessage = false;
                                          });
                                          return null;
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        newOption = value;
                                      },
                                      onSaved: (value) {
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: FontSizeUtil.CONTAINER_SIZE_40,
                                child: ElevatedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: const Color(0xff1B5694),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_20),
                                      side: BorderSide(
                                          color:
                                             const Color.fromARGB(255, 0, 123, 255),
                                          width: FontSizeUtil.SIZE_02),
                                    ),
                                    padding:  EdgeInsets.symmetric(
                                        horizontal: FontSizeUtil.CONTAINER_SIZE_15, vertical: FontSizeUtil.SIZE_05),
                                  ),
                                  onPressed: () {
                                    String trimmedOption = newOption.trim();

                                    if (trimmedOption.isNotEmpty) {
                                      List<int>? selectedIds;
                                      if (selectedSecurity.isNotEmpty) {
                                        selectedIds = selectedSecurity
                                            .map((securityModel) =>
                                                securityModel.id)
                                            .cast<int>()
                                            .toList();
                                      } else if (selectedSecurity1.isNotEmpty) {
                                        selectedIds = selectedSecurity1
                                            .map((securityModel) =>
                                                securityModel.userInfo?.userId)
                                            .cast<int>()
                                            .toList();
                                      }

                                      if (selectedIds != null &&
                                          selectedIds.isNotEmpty) {
                                        String result = selectedIds
                                            .toString(); // Convert the list to a string
                                        result = result.substring(
                                            1, result.length - 1);

                                        print(result);

                                        Utils.getNetworkConnectedStatus()
                                            .then((status) {
                                          Utils.printLog(
                                              "network status : $status");
                                          setState(() {
                                            _isNetworkConnected = status;
                                            _isLoading = status;
                                            if (_isNetworkConnected) {
                                              String responseType =
                                                  "postMessage";
                                              var message = trimmedOption;
                                              String messageUrl =
                                                  '${Constant.postChatMessageURL}?senderId=$userId&receiverId=$result&content=$message&apartmentId=$apartmentId';

                                              NetworkUtils.postUrlNetWorkCall(
                                                  messageUrl,
                                                  this,
                                                  responseType);
                                            } else {
                                              Utils.printLog("else called");
                                              _isLoading = false;
                                              Utils.showCustomToast(context);
                                            }
                                          });
                                        });

                                        Navigator.of(context).pop();
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: Strings.ISSUE_ACTION_ERROR_MESSAGE,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                        );
                                      }
                                    }
                                  },
                                  child: Row(
                                    children: [
                                     const Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: FontSizeUtil.CONTAINER_SIZE_10),
                                      const Text(
                                        Strings.MESSAGE_SEND_TEXT,
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: FontSizeUtil.CONTAINER_SIZE_10),
                            ],
                          ),
                          SizedBox(height: FontSizeUtil.CONTAINER_SIZE_15),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  onNavigatorBackPressed() {
    selectedSecurity.clear();
    selectedSecurity1.clear();
    _choose();
  }
}
