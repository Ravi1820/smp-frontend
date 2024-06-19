import 'dart:convert';

import 'package:SMP/components/search_issue_ticket_card.dart';
import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/model/resident_issue_model.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/profile.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/help/search_ticket_view_issue.dart';
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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchIssueTicket extends StatefulWidget {
  const SearchIssueTicket({super.key});

  @override
  State<SearchIssueTicket> createState() {
    return _SearchIssueTicketState();
  }
}

class _SearchIssueTicketState extends State<SearchIssueTicket>
    with ApiListener, NavigatorListener {
  final TextEditingController _searchController = TextEditingController();
  bool setShowlistflag = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = true; // Add this line
  bool _isNetworkConnected = false, _isLoading = true;
  final Color _containerBorderColor1 = Colors.white; // Added this line
  final Color _boxShadowColor1 = const Color.fromARGB(255, 100, 100, 100);

  int issueId = 0;
  List selectedSecurity = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();
    _choose();
  }

  String baseImageIssueApi = '';

  final issueCatagoryLists = ['Open', 'In Progress', 'Resolved'];
  String? _selectedGender;

  void editUserChoice(users) {
    // setState(() {
    //   issueStatus = users.issueStatus.statusName;
    // });
    Navigator.of(context).push(
      createRoute(
        SearchTicketViewIssue(
            id: users.id,
            residentPushNotificationToken:
                users.user.pushNotificationToken ?? "",
            description: users.description ?? "",
            baseImageIssueApi: baseImageIssueApi,
            issueImage: users.picture ?? "",
            issueId: users.issueUniqueId,
            createdTime: users.createdTime ?? "",
            issueCatagory: users.issueCatagory.catagoryName
                    .replaceAll("ISSUE_CATAGORY_", "")
                    .toLowerCase() ??
                "",
            fullName: users.user.fullName ?? "",
            userId: users.user.id,
            issueStatus: users.issueStatus.statusName
                    .replaceAll("ISSUE_STATUS_", "")
                    .toLowerCase() ??
                "",
            issuePriority: users.issuePriority.priorityName
                    .replaceAll("ISSUE_PRIORITY_", "")
                    .toLowerCase() ??
                "",
            issueAssignedBy: users.user.fullName ?? "",
            assignedTo: users.staffTeam.roleName ?? "",
            issueResponce: users.response ?? "",
            navigatorListener: this),
      ),
    );
  }

  Future<void> _choose() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');
    var apartId = prefs.getInt('apartmentId');
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "securityList";
          String resolvedIssue =
              '${Constant.getAllIssueByURL}?apartmentId=$apartId';

          NetworkUtils.getNetWorkCall(resolvedIssue, responseType, this);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });

    setState(() {
      isLoading = false;
      baseImageIssueApi = BaseApiImage.baseImageUrl(apartId!, "issues");
    });
  }

  @override
  onFailure(status) {
    setState(() {
      _isLoading = false;
    });
    // Utils.sessonExpired(context,  "Session is expired. Please login again");
    if (status == 401) {
      Utils.sessonExpired(context);
    } else {
      Utils.showToast(Strings.API_ERROR_MSG_TEXT);
    }
  }

  @override
  onSuccess(response, String responseType) async {
    setState(() {
      _isLoading = false;
    });
    try {
      setState(() {
        _isLoading = false;
        if (responseType == 'securityList') {
          List<ResidentIssueModel> movieList = (json.decode(response) as List)
              .map((item) => ResidentIssueModel.fromJson(item))
              .toList();

          setState(() {
            securityListLists = movieList;
          });
        } else if (responseType == 'assignTask') {
          selectedSecurity = [];
          ResponceModel responceModel =
              ResponceModel.fromJson(json.decode(response));

          if (responceModel.status == "success") {
            successDialogWithListner(context, responceModel.message!,
                const SearchIssueTicket(), this);
          } else {
            Utils.showToast(responceModel.message!);
          }
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Utils.printLog("text === $response");
    }
  }

  List securityListLists = [];
  List originalUsers = [];
  List usersList = [];
  String query = "";

  void _filterList(String query) {
    setState(() {
      this.query = query;
    });
  }

  void getList() {
    setState(() {
      if (query.isNotEmpty) {
        originalUsers = securityListLists.where((user) {
          final nameMatches =
              user.issueUniqueId.toLowerCase().contains(query.toLowerCase());
          final idMatches = user.user.id
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase());

          return nameMatches || idMatches;
        }).toList();
      } else {
        originalUsers = securityListLists;
      }
    });
  }

  int selectedIssueId = 0;

  @override
  Widget build(BuildContext context) {
    getList();

    Widget content;

    if (originalUsers.isNotEmpty) {
      content = Padding(
          padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
          child: TicketListViewCard(
            edit: editUserChoice,
            users: originalUsers,
            selectedCountries: selectedSecurity,
            baseImageIssueApi: baseImageIssueApi,
            onItemSelected: (List updatedSelectedMembers) {
              setState(() {
                selectedSecurity = updatedSelectedMembers;
              });
            },
          ));
    } else {
      content = _isLoading
          ? Container()
          : Center(
              child: Text(
                Strings.NO_ISSUE_TEXT,
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: Strings.SEARCH_TICKET_HEADER,
            profile: () {
              Navigator.of(context).push(createRoute(const UserProfile()));
            },
          ),
        ),
             body: Stack(
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
                child: Center(
                  child: Column(
                    children: <Widget>[
                       SizedBox(height: FontSizeUtil.SIZE_10),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: FontSizeUtil.CONTAINER_SIZE_20, vertical: FontSizeUtil.SIZE_05),
                        child: TextField(
                          inputFormatters: [
                           FilteringTextInputFormatter.deny(Strings.EMOJI_DENY_REGEX)
                          ],
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: Strings.SEARCH_ISSUE_TICKET_LABEL,
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
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(FontSizeUtil.SIZE_08),
                            ),
                          ),
                          onChanged: _filterList,
                        ),
                      ),
                      Expanded(child: content),
                      selectedSecurity.isNotEmpty
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: FontSizeUtil.CONTAINER_SIZE_15, horizontal: FontSizeUtil.CONTAINER_SIZE_80),
                              width: double.infinity,
                              height: FontSizeUtil.CONTAINER_SIZE_80,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (selectedSecurity.isNotEmpty) {
                                    _openAddOptionDialog(
                                      context,
                                      _boxShadowColor1,
                                      _containerBorderColor1,
                                    );
                                  } else {
                                    Utils.showToast(Strings.SELECT_ISSUE_WARNING_TEXT);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff1B5694),
                                  elevation: FontSizeUtil.SIZE_05,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_15),
                                  ),
                                  padding:  EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_15),
                                ),
                                child:  Text(
                                  Strings.EDIT_BUTTON_TEXT,
                                  style: TextStyle(
                                    color:  Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: FontSizeUtil.CONTAINER_SIZE_18,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      const FooterScreen(),
                    ],
                  ),
                ),
              ),
            ),
            if (_isLoading) // Display the loader if _isLoading is true
              const Positioned(child: LoadingDialog()),
          ],
        ),
      ),
    );
  }

  void _openAddOptionDialog(
      BuildContext context, containerBorderColor1, boxShadowColor) {
    String newOption = '';
    bool isSaveButtonDisabled = true; // Track the state of the "Save" button

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: Container(
            width: 350,
            // height: MediaQuery.of(context).size.height * 0.35,
            decoration: AppStyles.decoration(context),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Expanded(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: Text(
                                'Update Status',
                                style: TextStyle(
                                  color: Color.fromRGBO(27, 86, 148, 1.0),
                                  fontSize: 16,
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
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 30,
                              width: 30,
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
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 10),
                          const Text(
                            'Select status',
                            style: TextStyle(
                              color: Color.fromRGBO(27, 86, 148, 1.0),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 100, 100, 100),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                height: 50,
                                child: DropdownButtonFormField<String>(
                                  value: _selectedGender,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.accessibility),
                                  ),
                                  items: issueCatagoryLists
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    final gender = entry.value;
                                    return DropdownMenuItem<String>(
                                      value: gender,
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 6),
                                          Text(gender),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value;
                                    });
                                  },
                                  hint: const Text(
                                    "Select Status",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Enter Action',
                            style: TextStyle(
                              color: Color.fromRGBO(27, 86, 148, 1.0),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: <Widget>[
                              const SizedBox(width: 8),
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
                                      borderRadius: BorderRadius.circular(10),
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
                                    height: 100,
                                    child: TextFormField(
                                      keyboardType: TextInputType.multiline,
                                      scrollPadding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom *
                                              6.10),
                                      maxLines: null,
                                      style: const TextStyle(
                                          color: Colors.black87),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(top: 14),
                                        prefixIcon: Icon(
                                          Icons.description,
                                          color: Color(0xff4d004d),
                                        ),
                                        hintText: 'Enter Message',
                                        hintStyle:
                                            TextStyle(color: Colors.black38),
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
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 30,
                                child: ElevatedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: const BorderSide(
                                          color:
                                              Color.fromARGB(255, 0, 123, 255),
                                          width: 2),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 0),
                                  ),
                                  onPressed: () {
                                    String trimmedOption = newOption.trim();
                                    print(trimmedOption);
                                    print(_selectedGender);
                                    if (trimmedOption.isNotEmpty) {
                                      Utils.getNetworkConnectedStatus()
                                          .then((status) {
                                        setState(() {
                                          _isNetworkConnected = status;
                                          _isLoading = status;

                                          print(_isNetworkConnected);
                                          if (_isNetworkConnected) {
                                            _isLoading = true;
                                            String responseType = "assignTask";

                                            var isSelectedIds = selectedSecurity
                                                .map((securityModel) =>
                                                    securityModel.id);
                                            String result =
                                                isSelectedIds.join(',');
                                            print(result);

                                            var _selectedStatus = '';

                                            if (_selectedGender ==
                                                "In Progress") {
                                              _selectedStatus = 'InProgress';
                                            } else {
                                              _selectedStatus =
                                                  _selectedGender!;
                                            }

                                            String loginURL =
                                                '${Constant.updateIssueStatueURL}?issueId=$result&status=$_selectedStatus&action=$trimmedOption';

                                            NetworkUtils.putUrlNetWorkCall(
                                                loginURL, this, responseType);
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
                                        msg: "Please enter the message",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    }
                                  },
                                  child: const Text("Submit"),
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
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
    _choose();
  }
}
