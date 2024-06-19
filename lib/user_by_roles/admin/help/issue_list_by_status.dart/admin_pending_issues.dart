import 'dart:convert';

import 'package:SMP/components/admin_open_issue_card.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/model/resident_issue_model.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/model/staff_role_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/help/admin_issue_list.dart';
import 'package:SMP/user_by_roles/admin/help/manage_complaints.dart';
import 'package:SMP/user_by_roles/admin/help/view_issue.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/loader.dart';

// import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:flutter/src/material/date_picker_theme.dart'
    show DatePickerTheme;

import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

import 'package:path_provider/path_provider.dart';

class Categories {
  final int id;
  final String name;

  Categories({
    required this.id,
    required this.name,
  });
}

class AdminPendingIssueScreen extends StatefulWidget {
  const AdminPendingIssueScreen({Key? key}) : super(key: key);

  @override
  State<AdminPendingIssueScreen> createState() =>
      _AdminPendingIssueScreenState();
}

class _AdminPendingIssueScreenState extends State<AdminPendingIssueScreen>
    with ApiListener, NavigatorListener {
  Future<List>? _futureIssues;

  String baseImageIssueApi = '';
  bool _isNetworkConnected = false, _isLoading = true;
  bool isLoading = true;
  List resolvedListLists = [];
  StaffRoleModel? selectedStaffRoleValue;

  late int id = 1;
  String radioButtonItem = 'Category';

  List originalUsers = [];

  var selectedCatagoryLabels = [];
  var selectedStaffLabels = [];
  var selectedPriorityLabels = [];

  bool showErrorMessage = false;
  bool showUserIDErrorMessage = false;

  Map<int, String> statusMap = {};
  Map<int, String> priorityMap = {};
  List roles = [];

  DateTime currentDate = DateTime.now();

  String? _enteredAdmittedDate;
  String? _enteredDichargedDate;

  final TextEditingController _endDateController = TextEditingController();

  final TextEditingController _startDateController = TextEditingController();

  String issueStatus = '';

  int selectedRoleId = 0;

  int selectedStaffRoleId = 0;
  int complainCount = 0;

  bool showCatagoryList = false;
  bool showPriorityList = false;
  bool showDateRangeList = false;
  bool showAssignToList = false;

  void editUserChoice(users) {
    setState(() {
      issueStatus = users.issueStatus.statusName;
    });
    Navigator.of(context).push(
      createRoute(
        ViewIssue(
          id: users.id,
          residentPushNotificationToken: users.user.pushNotificationToken ?? "",
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
          navigatorListner: this,
        ),
      ),
    );
  }

  bool showInStockOnly = false;
  double maxPrice = 100.0;

  Future<void> datePicker(BuildContext context, String type) async {
    DateTime currentDate = DateTime.now();
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2100);

    DatePicker.showDatePicker(
      context,
      theme: picker.DatePickerTheme(
        containerHeight: 210.0,
      ),
      showTitleActions: true,
      onConfirm: (date) {
        print('confirmDate : ${date}');
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);

        if (type == "Admitted Date") {
          setState(() {
            _enteredAdmittedDate = formattedDate;
            _startDateController.text = _enteredAdmittedDate ?? '';
          });
        } else if (type == "Discharged Date") {
          setState(() {
            _enteredDichargedDate = formattedDate;
            _endDateController.text = _enteredDichargedDate ?? '';
          });
        }
      },
      currentTime: currentDate,
      locale: picker.LocaleType.en,
      minTime: firstDate,
      maxTime: lastDate,
    );
  }

  final List<MultiSelectItem<Categories>> _items = [];

  final List<MultiSelectItem<Categories>> priorityList = [];
  List selectedIssues = [];

  @override
  void initState() {
    super.initState();
    loadIssueData();
    _futureIssues = getList();
    getCategoryList();
    getPriorityList();
    _getAllStaffRole();
  }

  void _getAllStaffRole() {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "allRole";

          NetworkUtils.getNetWorkCall(
              Constant.getAllStaffRoleURL, responseType, this);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  getCategoryList() async {
    try {
      Utils.getNetworkConnectedStatus().then((status) {
        Utils.printLog("network status : $status");
        setState(() {
          _isNetworkConnected = status;
          _isLoading = status;
          if (_isNetworkConnected) {
            String responseType = "catagoryIssues";

            NetworkUtils.getNetWorkCall(
                Constant.catagoryListURL, responseType, this);
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
  }

  _assaginIssueToStaff() {
    Utils.getNetworkConnectedStatus().then((status) {
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        print(_isNetworkConnected);
        if (_isNetworkConnected) {
          _isLoading = true;
          String responseType = "assignTask";

          List issueIds = selectedIssues.map((issue) => issue.id).toList();

          String issueIdString = issueIds.join(',');

          print("selectedRoleId==$selectedRoleId");

          String asignURL =
              '${Constant.assingTaskToStaffURL}?issueList=$issueIdString&teamId=$selectedRoleId';

          NetworkUtils.postUrlNetWorkCall(asignURL, this, responseType);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  getPriorityList() async {
    try {
      Utils.getNetworkConnectedStatus().then((status) {
        Utils.printLog("network status : $status");
        setState(() {
          _isNetworkConnected = status;
          _isLoading = status;
          if (_isNetworkConnected) {
            String responseType = "issuesPriority";
            NetworkUtils.getNetWorkCall(
                Constant.priorityListURL, responseType, this);
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
  }

  loadIssueData() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var apartId = prefs.getInt('apartmentId');
      Utils.getNetworkConnectedStatus().then((status) {
        Utils.printLog("network status : $status");
        setState(() {
          _isNetworkConnected = status;
          _isLoading = status;
          if (_isNetworkConnected) {
            String responseType = "pendingIssue";
            String issueStatus = "open";

            String resolvedIssue =
                '${Constant.getAllIssueByAdminURL}?status=$issueStatus&apartmentId=$apartId';

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
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
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
        if (responseType == 'pendingIssue') {
          _isLoading = false;

          Utils.printLog("Succcess === $response");

          List<ResidentIssueModel> resolvedIssueList =
              (json.decode(response) as List)
                  .map((item) => ResidentIssueModel.fromJson(item))
                  .toList();

          setState(() {
            resolvedListLists = resolvedIssueList;
          });
        } else if (responseType == 'catagoryIssues') {
          final Map<String, dynamic> data = jsonDecode(response);

          Map<int, String> resultMap = {};

          data.forEach((key, value) {
            resultMap[int.parse(key)] = value;
          });

          statusMap = resultMap;
          _items.clear();
          selectedCatagoryLabels.clear();

          _items.addAll(statusMap.entries.map((entry) =>
              MultiSelectItem<Categories>(
                  Categories(id: entry.key, name: entry.value), entry.value)));
        } else if (responseType == 'issuesPriority') {
          // _isLoading = false;

          final Map<String, dynamic> data = jsonDecode(response);
          Map<int, String> resultMap = {};

          data.forEach((key, value) {
            resultMap[int.parse(key)] = value;
          });

          priorityMap = resultMap;
          priorityList.clear();
          selectedPriorityLabels.clear();

          priorityList.addAll(priorityMap.entries.map((entry) =>
              MultiSelectItem<Categories>(
                  Categories(id: entry.key, name: entry.value), entry.value)));
        } else if (responseType == "allRole") {
          setState(() {
            List<StaffRoleModel> movieList = (json.decode(response) as List)
                .map((item) => StaffRoleModel.fromJson(item))
                .toList();
            roles = movieList;
          });
        } else if (responseType == "assignTask") {
          _isLoading = false;

          ResponceModel responceModel =
              ResponceModel.fromJson(json.decode(response));
          if (responceModel.status == "success") {
            successDialogWithListner(
                context, responceModel.message!, const AdminIssueList(), this);
            selectedIssues.clear();
          }
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Utils.printLog("Error === $response");
    }
  }

  List<String> radioOptions = ["Category", 'Priority'];

  String getRadioText(int value) {
    if (value >= 1 && value <= radioOptions.length) {
      return radioOptions[value - 1];
    }
    return '';
  }

  List allFilteredList = [];

  String selectedFilteredStaffIds = '';

  Future<List> getList() async {
    print("Selected Role $selectedRoleId");
    List selectedCategoryIds =
        selectedCatagoryLabels.map((category) => category.id).toList();
    List selectedPriorityIds =
        selectedPriorityLabels.map((priority) => priority.id).toList();
    List selectedStaffIds =
        selectedStaffLabels.map((staff) => staff.id).toList();

    setState(() {
      selectedFilteredStaffIds = selectedStaffIds.toString();
    });
    DateTime? startDate, endDate;
    String? selectedStartDate, selectedEndDate;
    if (_startDateController.text.isNotEmpty &&
        _endDateController.text.isNotEmpty) {
      startDate = DateTime.parse(_startDateController.text);
      endDate = DateTime.parse(_endDateController.text);

      selectedStartDate = DateFormat('yyyy-MM-dd').format(startDate);
      selectedEndDate = DateFormat('yyyy-MM-dd').format(endDate);

      print("Selected Date Start Date ====>$selectedStartDate");
      print("Selected Date End Date ====>$selectedEndDate");
    }

    try {
      List filteredList = resolvedListLists.where((issue) {
        //  2024-03-06 00:00:00.000
        DateTime issueDate = DateTime.parse(issue.createdTime!);

        String apiIssueData = DateFormat('yyyy-MM-dd').format(issueDate);

        // print(issueDate);

        print("API Date before filter ====>$apiIssueData");

        bool categoryMatch = selectedCategoryIds.isEmpty ||
            selectedCategoryIds.contains(issue.catagoryId);
        bool priorityMatch = selectedPriorityIds.isEmpty ||
            selectedPriorityIds.contains(issue.priorityId);
        bool staffMatch = selectedStaffIds.isEmpty ||
            selectedStaffIds.contains(issue.assignedId);
        String apiDate = apiIssueData.split(" ")[0];
        bool isEqualDate =
            (selectedStartDate != null && selectedEndDate != null)
                ? (apiDate == selectedStartDate && apiDate == selectedEndDate)
                : false;

        print(
            "Is Same Date Selection $isEqualDate   TO STRING==${apiDate.toString()}");

        bool dateMatch = startDate == null ||
            endDate == null ||
            ((issueDate.isAfter(startDate) && issueDate.isBefore(endDate)) ||
                (issueDate.isAtSameMomentAs(startDate) &&
                    issueDate.isAtSameMomentAs(endDate)) ||
                isEqualDate);

        print(
            "Selected Date ====> Selected Catagory$categoryMatch selected priority $priorityMatch selected Saff $staffMatch");

        return categoryMatch && priorityMatch && staffMatch && dateMatch;
      }).toList();
      setState(() {
        allFilteredList = filteredList;
      });

      return filteredList;
    } catch (e) {
      print('Error parsing dates: $e');
      return [];
    }
  }

  Future<void> downloadExcelFile(String url) async {
    final token = Utils.token;

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    Utils.printLog(url);
    Utils.printLog(token!);

    if (response.statusCode == 200) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      if (statuses[Permission.storage]!.isGranted) {
        var documents;
        if (Utils.showBackButton) {
          documents = (await getApplicationDocumentsDirectory())
              .absolute
              .path; // Await the result here
        } else {
          Directory dir = Directory('/storage/emulated/0/Download');
          documents = dir?.path;
          // var dir = await DownloadsPathProvider.downloadsDirectory;
          // documents = dir?.path;
        }
        String savename = "Smp_${complainCount}.xlsx";
        final filePath = '${documents}/${savename}';

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print('File downloaded successfully: $filePath');
        setState(() {
          complainCount++;
        });

        Fluttertoast.showToast(
          msg: "File downloaded successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        setState(() {
          _isLoading = false;
        });

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('excelFilePath', filePath);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print('Failed to download file. Status code: ${response.statusCode}');
      Fluttertoast.showToast(
        msg: "Failed to download file. Status code: ${response.statusCode}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> _handleRefresh() async {
    print("Refreshing");
    loadIssueData();
  }

  Future<void> _resetData() async {
    print("Refreshing");
    // loadIssueData();
    setState(() {
      selectedCatagoryLabels = [];
      selectedPriorityLabels = [];
      selectedStaffLabels = [];
      _startDateController.text = '';
      _endDateController.text = '';
    });
  }

  bool isopen = false;
  bool isopen1 = false;

  void applyFilters(dynamic futureIssues) {
    setState(() {
      _futureIssues = futureIssues;
    });
  }

  @override
  Widget build(BuildContext context) {
    _futureIssues = getList();

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).push(createRoute(const ManageComplaints()));
        return false;
      },
      child: Scaffold(
        body: AbsorbPointer(
          absorbing: _isLoading,
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
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
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 1.450,
                        child: RefreshIndicator(
                          onRefresh: _handleRefresh,
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  const SizedBox(height: 15),
                                  Expanded(
                                    child: FutureBuilder<List>(
                                      future: _futureIssues,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError ||
                                            snapshot.data == null) {
                                          return Center(
                                            child: Text(
                                              'Error fetching data',
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xff1B5694),
                                              ),
                                            ),
                                          );
                                        } else {
                                          originalUsers = snapshot.data!;

                                          if (originalUsers.isNotEmpty) {
                                            return Container(
                                              decoration:
                                                  AppStyles.decoration(context),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child:
                                                    AdminOpenIssiesGridViewCard(
                                                  press: editUserChoice,
                                                  users: originalUsers,
                                                  baseImageIssueApi:
                                                      baseImageIssueApi,
                                                  selectedIssues:
                                                      selectedIssues,
                                                  onSelectedMembersChanged: (List
                                                      updatedSelectedMembers) {
                                                    setState(() {
                                                      selectedIssues =
                                                          updatedSelectedMembers;
                                                    });
                                                  },
                                                ),
                                              ),
                                            );
                                          } else {
                                            return _isLoading
                                                ? Container()
                                                : Center(
                                                    child: Text(
                                                      'There are no pending issues',
                                                      style: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: const Color(
                                                            0xff1B5694),
                                                      ),
                                                    ),
                                                  );
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              if (_isLoading)
                                const Positioned(child: LoadingDialog()),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Stack(
          children: [
            Positioned(
                bottom: 145,
                right: 10,
                child: InkWell(
                  onTap: () {
                    // setState(() {
                    //   selectedCatagoryLabels.clear();
                    //   selectedStaffLabels.clear();
                    //   selectedPriorityLabels.clear();
                    // });

                    showModalBottomSheet<dynamic>(
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.0)),
                      ),
                      context: context,
                      builder: (BuildContext context) {
                        return FractionallySizedBox(
                          heightFactor: 0.8,
                          child: buildBottomSheet(getList, applyFilters),
                        );
                      },
                    );
                    // _openAddOptionDialog(
                    //     context, _containerBorderColor1, _boxShadowColor1);
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff1B5694),
                    ),
                    child: const Icon(
                      Icons.filter_alt_outlined,
                      color: Colors.white,
                    ),
                  ),
                )),
            Positioned(
                bottom: 70,
                right: 10,
                child: InkWell(
                  onTap: () {
                    if (allFilteredList.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          double dialogWidth =
                              MediaQuery.of(context).size.width - 5.0;
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              width: dialogWidth,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white,
                                    Colors.white,
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            FontSizeUtil.CONTAINER_SIZE_10,
                                        vertical:
                                            FontSizeUtil.CONTAINER_SIZE_20),
                                    child: Text(Strings.SELECT_ISSUE_TEAM_TEXT,
                                        style: AppStyles.heading(context),
                                        textAlign: TextAlign.center),
                                  ),
                                  StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Stack(
                                            alignment: Alignment.centerLeft,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: FontSizeUtil
                                                        .CONTAINER_SIZE_20),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius
                                                        .circular(FontSizeUtil
                                                            .CONTAINER_SIZE_10),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Color.fromARGB(
                                                            255, 100, 100, 100),
                                                        blurRadius: 6,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  height: FontSizeUtil
                                                      .CONTAINER_SIZE_50,
                                                  child:
                                                      DropdownButtonHideUnderline(
                                                    child: DropdownButton2<
                                                        StaffRoleModel>(
                                                      isExpanded: true,
                                                      hint: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              Strings
                                                                  .SELECT_ISSUE_ROLE_TEXT,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      FontSizeUtil
                                                                          .CONTAINER_SIZE_16),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      items: roles
                                                          .map((role) =>
                                                              DropdownMenuItem<
                                                                  StaffRoleModel>(
                                                                value: role,
                                                                child: Text(
                                                                  role.roleName,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          FontSizeUtil
                                                                              .CONTAINER_SIZE_16),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ))
                                                          .toList(),
                                                      value:
                                                          selectedStaffRoleValue,
                                                      onChanged:
                                                          (StaffRoleModel?
                                                              value) {
                                                        setState(() {
                                                          selectedStaffRoleValue =
                                                              value;
                                                          // Access id and roleName of the selected role
                                                          if (value != null) {
                                                            selectedStaffRoleId =
                                                                value.id;
                                                          }
                                                        });
                                                      },
                                                      buttonStyleData:
                                                          ButtonStyleData(
                                                        height: FontSizeUtil
                                                            .CONTAINER_SIZE_50,
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 14,
                                                                right: 14),
                                                        elevation: 2,
                                                      ),
                                                      iconStyleData:
                                                          IconStyleData(
                                                        icon: const Icon(
                                                          Icons
                                                              .arrow_drop_down_outlined,
                                                        ),
                                                        iconSize: FontSizeUtil
                                                            .CONTAINER_SIZE_18,
                                                        iconEnabledColor:
                                                            Colors.black,
                                                        iconDisabledColor:
                                                            Colors.grey,
                                                      ),
                                                      dropdownStyleData:
                                                          DropdownStyleData(
                                                        maxHeight: FontSizeUtil
                                                            .CONTAINER_SIZE_200,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  FontSizeUtil
                                                                      .CONTAINER_SIZE_14),
                                                        ),
                                                        offset:
                                                            const Offset(0, 0),
                                                        scrollbarTheme:
                                                            ScrollbarThemeData(
                                                          radius: Radius.circular(
                                                              FontSizeUtil
                                                                  .CONTAINER_SIZE_40),
                                                          thickness:
                                                              MaterialStateProperty
                                                                  .all<double>(
                                                                      6),
                                                          thumbVisibility:
                                                              MaterialStateProperty
                                                                  .all<bool>(
                                                                      true),
                                                        ),
                                                      ),
                                                      menuItemStyleData:
                                                          MenuItemStyleData(
                                                        height: FontSizeUtil
                                                            .CONTAINER_SIZE_40,
                                                        padding: EdgeInsets.only(
                                                            left: FontSizeUtil
                                                                .CONTAINER_SIZE_14,
                                                            right: FontSizeUtil
                                                                .CONTAINER_SIZE_14),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  SizedBox(
                                      height: FontSizeUtil.CONTAINER_SIZE_10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: FontSizeUtil.CONTAINER_SIZE_30,
                                        child: ElevatedButton(
                                          style: OutlinedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      FontSizeUtil
                                                          .CONTAINER_SIZE_20),
                                              side: const BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 0, 123, 255),
                                                  width: 2),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: FontSizeUtil
                                                    .CONTAINER_SIZE_15),
                                          ),
                                          onPressed: () {
                                            String filteredTeamId =
                                                selectedFilteredStaffIds
                                                    .toString();
                                            filteredTeamId =
                                                filteredTeamId.substring(1,
                                                    filteredTeamId.length - 1);
                                            print(filteredTeamId);

                                            if (selectedStaffRoleId != 0) {
                                              List issueId = allFilteredList
                                                  .map((block) => block.id)
                                                  .toList();

                                              String result =
                                                  issueId.toString();
                                              result = result.substring(
                                                  1, result.length - 1);
                                              print(result);

                                              if (selectedIssues.isNotEmpty) {
                                                List issueId = selectedIssues
                                                    .map((block) => block.id)
                                                    .toList();

                                                String result =
                                                    issueId.toString();
                                                result = result.substring(
                                                    1, result.length - 1);
                                                print(result);

                                                Utils.getNetworkConnectedStatus()
                                                    .then((status) {
                                                  setState(() {
                                                    _isNetworkConnected =
                                                        status;
                                                    _isLoading = status;
                                                    print(_isNetworkConnected);
                                                    if (_isNetworkConnected) {
                                                      _isLoading = true;
                                                      String responseType =
                                                          "assignTask";

                                                      String asignURL =
                                                          '${Constant.assingTaskToStaffURL}?issueList=$result&teamId=$selectedStaffRoleId';

                                                      NetworkUtils
                                                          .postUrlNetWorkCall(
                                                              asignURL,
                                                              this,
                                                              responseType);
                                                    } else {
                                                      Utils.printLog(
                                                          "else called");
                                                      _isLoading = false;
                                                      Utils.showCustomToast(
                                                          context);
                                                    }
                                                  });
                                                });
                                              } else {
                                                Utils.getNetworkConnectedStatus()
                                                    .then((status) {
                                                  setState(() {
                                                    _isNetworkConnected =
                                                        status;
                                                    _isLoading = status;
                                                    print(_isNetworkConnected);
                                                    if (_isNetworkConnected) {
                                                      _isLoading = true;
                                                      String responseType =
                                                          "assignTask";

                                                      String asignURL =
                                                          '${Constant.assingTaskToStaffURL}?issueList=$result&teamId=$selectedStaffRoleId';

                                                      NetworkUtils
                                                          .postUrlNetWorkCall(
                                                              asignURL,
                                                              this,
                                                              responseType);
                                                    } else {
                                                      Utils.printLog(
                                                          "else called");
                                                      _isLoading = false;
                                                      Utils.showCustomToast(
                                                          context);
                                                    }
                                                  });
                                                });
                                              }
                                            } else {
                                              Utils.showToast(
                                                  "Please select any staff");
                                            }

                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          },
                                          child: const Text("Assign"),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      Utils.showToast("Please select any issues");
                    }
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff1B5694),
                    ),
                    child: const Icon(
                      Icons.assignment_add,
                      color: Colors.white,
                    ),
                  ),
                )
                // : Container(),
                ),
            Positioned(
              bottom: 1,
              right: 10,
              child: FloatingActionButton(
                onPressed: () async {
                  if (allFilteredList.isNotEmpty) {
                    List ownerIds =
                        allFilteredList.map((block) => block.id).toList();

                    String result = ownerIds.toString();
                    result = result.substring(1, result.length - 1);
                    print(result);

                    Utils.getNetworkConnectedStatus().then((status) {
                      setState(() {
                        _isNetworkConnected = status;
                        _isLoading = status;
                        print(_isNetworkConnected);
                        if (_isNetworkConnected) {
                          _isLoading = true;
                          downloadExcelFile(
                            "${Constant.baseUrl}${Constant.exportIssueURL}?issueId=$result",
                          );
                        } else {
                          Utils.printLog("else called");
                          _isLoading = false;
                          Utils.showCustomToast(context);
                        }
                      });
                    });
                  } else {
                    Utils.showToast("Please select any issues");
                  }
                },
                backgroundColor: const Color(0xff1B5694),
                foregroundColor: Colors.white,
                child: const Icon(Icons.download),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int selectedIndex = -1;

  Widget buildBottomSheet(Function getList, Function applyFilters) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter mystate) {
        Widget radioContent;

        if (showCatagoryList) {
          radioContent = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
            child: Wrap(
              spacing: 50.0,
              direction: Axis.horizontal,
              runSpacing: 10.0,
              alignment: WrapAlignment.start,
              children: _items.map((category) {
                return Stack(
                  children: [
                    ChoiceChip(
                      label: Text(
                        category.label,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      selected: category.selected,
                      onSelected: (isSelected) async {
                        mystate(() {
                          category.selected = isSelected;
                          if (isSelected) {
                            selectedCatagoryLabels.add(category.value);
                          } else {
                            selectedCatagoryLabels.remove(category.value);
                          }
                          _futureIssues = getList();
                        });
                      },
                      selectedColor: category.selected
                          ? const Color(0xff1B5694)
                          : Colors.grey,
                      backgroundColor: category.selected
                          ? const Color(0xff1B5694)
                          : Colors.grey,
                    ),
                    if (category.selected)
                      Positioned(
                        top: -2,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            mystate(() {
                              category.selected = !category.selected;
                              if (category.selected) {
                                selectedCatagoryLabels.add(category.value);
                              } else {
                                selectedCatagoryLabels.remove(category.value);
                              }
                            });
                            _futureIssues = getList();
                          },
                          child: const Icon(
                            Icons.cancel_rounded,
                            color: Colors.black,
                          ),
                        ),
                      ),
                  ],
                );
              }).toList(),
            ),
          );
        } else if (showPriorityList) {
          radioContent = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
            child: Wrap(
              spacing: 98.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.start, // Align chips to the start
              children: priorityList.map((priority) {
                return Stack(
                  children: [
                    ChoiceChip(
                      label: Text(
                        priority.label,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      selected: priority.selected,
                      onSelected: (isSelected) async {
                        mystate(() {
                          priority.selected = isSelected;
                          if (isSelected) {
                            selectedPriorityLabels.add(priority.value);
                          } else {
                            selectedPriorityLabels.remove(priority.value);
                          }
                        });
                        _futureIssues = getList();
                      },
                      selectedColor: priority.selected
                          ? const Color(0xff1B5694)
                          : Colors.grey,
                      backgroundColor: priority.selected
                          ? const Color(0xff1B5694)
                          : Colors.grey,
                    ),
                    if (priority.selected)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            mystate(() {
                              priority.selected = !priority.selected;
                              if (priority.selected) {
                                selectedPriorityLabels.add(priority.value);
                              } else {
                                selectedPriorityLabels.remove(priority.value);
                              }
                            });
                            _futureIssues = getList();
                          },
                          child: const Icon(
                            Icons.cancel_rounded,
                            color: Colors.black,
                          ),
                        ),
                      ),
                  ],
                );
              }).toList(),
            ),
          );
        } else if (showDateRangeList) {
          radioContent = Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 0, right: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  datePicker(context, "Admitted Date");
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: _startDateController,
                                    decoration: const InputDecoration(
                                      hintText: 'Start Time',
                                      hintStyle:
                                          TextStyle(color: Colors.black38),
                                      border: InputBorder.none,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Start date can't  be empty.";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _enteredAdmittedDate = value!;
                                    },
                                    onChanged: (value) {},
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                datePicker(context, "Admitted Date");
                              },
                              child: const Icon(
                                Icons.date_range,
                                color: Color(0xff4d004d),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
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
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 0, right: 5),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  datePicker(context, "Discharged Date");
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: _endDateController,
                                    decoration: const InputDecoration(
                                      hintText: 'End Time',
                                      hintStyle:
                                          TextStyle(color: Colors.black38),
                                      border: InputBorder.none,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "End date can't be empty.";
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      _enteredDichargedDate = value!;
                                    },
                                    onChanged: (value) {},
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                datePicker(context, "Discharged Date");
                              },
                              child: const Icon(
                                Icons.date_range,
                                color: Color(0xff4d004d),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          );
        } else if (showAssignToList) {
          radioContent = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.start,
              children: List.generate(roles.length, (index) {
                final staff = roles[index];
                return Stack(
                  children: [
                    ChoiceChip(
                      label: Text(
                        staff.roleName,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      selected: selectedIndex == index,
                      onSelected: (isSelected) async {
                        mystate(() {
                          if (isSelected) {
                            selectedIndex = index; // Update selected index
                            selectedStaffLabels
                                .clear(); // Clear previous selection
                            selectedStaffLabels
                                .add(staff); // Add newly selected staff
                          } else {
                            selectedIndex = -1; // Deselect if already selected
                            selectedStaffLabels
                                .remove(staff); // Remove deselected staff
                          }
                        });
                        _futureIssues = getList();
                      },
                      selectedColor: const Color(0xff1B5694),
                      backgroundColor: Colors.grey,
                    ),
                    if (selectedIndex == index)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            mystate(() {
                              selectedIndex = -1;
                              selectedStaffLabels.remove(staff);
                            });
                            _futureIssues = getList();
                          },
                          child: const Icon(
                            Icons.cancel_rounded,
                            color: Colors.black,
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
          );
        } else {
          radioContent = Container();
        }

        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Filters', style: AppStyles.heading(context)),
                  GestureDetector(
                    onTap: () {
                      _resetData();

                      mystate(() {
                        // Clear selected categories
                        for (var category in _items) {
                          category.selected = false;
                        }
                        // Clear selected priorities
                        for (var priority in priorityList) {
                          priority.selected = false;
                        }
                        // Clear other selected states if any
                        selectedIndex = -1;
                        // Clear other selected labels if any
                        selectedCatagoryLabels.clear();
                        selectedStaffLabels.clear();
                        selectedPriorityLabels.clear();
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Close',
                      style: AppStyles.heading(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              const Divider(
                height: 0.2,
                color: Color.fromARGB(255, 89, 0, 255),
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: AppStyles.decorationTable(context),
                      width: 130,
                      height: MediaQuery.of(context).size.height,
                      child: ListView(
                        children: [
                          Material(
                            color: showCatagoryList ? Colors.blue : null,
                            child: ListTile(
                              onTap: () {
                                mystate(() {
                                  showCatagoryList = true;
                                  showAssignToList = false;
                                  showDateRangeList = false;
                                  showPriorityList = false;
                                });
                              },
                              title: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                                  'Category',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            height: FontSizeUtil.SIZE_001,
                            color: Colors.grey,
                          ),
                          Material(
                            color: showPriorityList ? Colors.blue : null,
                            child: ListTile(
                              onTap: () {
                                // print("Priority Is selected");

                                mystate(() {
                                  showCatagoryList = false;
                                  showAssignToList = false;
                                  showDateRangeList = false;
                                  showPriorityList = true;
                                });
                              },
                              title: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                                  'Priority',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            height: FontSizeUtil.SIZE_001,
                            color: Colors.grey,
                          ),
                          Material(
                            color: showDateRangeList ? Colors.blue : null,
                            child: ListTile(
                              onTap: () {
                                // print("Date Range Is selected");

                                mystate(() {
                                  showCatagoryList = false;
                                  showAssignToList = false;
                                  showDateRangeList = true;
                                  showPriorityList = false;
                                });
                              },
                              title: Container(
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                                  'Date Range',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            height: FontSizeUtil.SIZE_001,
                            color: Colors.grey,
                          ),
                          Material(
                            color: showAssignToList ? Colors.blue : null,
                            child: ListTile(
                              onTap: () {
                                mystate(() {
                                  showCatagoryList = false;
                                  showAssignToList = true;
                                  showDateRangeList = false;
                                  showPriorityList = false;
                                });
                              },
                              title: Container(
                                // color: showAssignToList ? Colors.blue : null,
                                padding: const EdgeInsets.all(8.0),
                                child: const Text(
                                  'Assign To',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            height: FontSizeUtil.SIZE_001,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Center(
                          child: radioContent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              const Divider(
                height: 0.2,
                color: Color.fromARGB(255, 89, 0, 255),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: SizedBox(
                      height: 30,
                      child: ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: const BorderSide(
                                color: Color.fromARGB(255, 0, 123, 255),
                                width: 2),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 5),
                        ),
                        onPressed: () async {
                          _resetData();

                          mystate(() {
                            // Clear selected categories
                            for (var category in _items) {
                              category.selected = false;
                            }
                            // Clear selected priorities
                            for (var priority in priorityList) {
                              priority.selected = false;
                            }
                            // Clear other selected states if any
                            selectedIndex = -1;
                            // Clear other selected labels if any
                            selectedCatagoryLabels.clear();
                            selectedStaffLabels.clear();
                            selectedPriorityLabels.clear();
                          });
                        },
                        child: const Text("Clear"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: SizedBox(
                      height: 30,
                      child: ElevatedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            side: const BorderSide(
                                color: Color.fromARGB(255, 0, 123, 255),
                                width: 2),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 5),
                        ),
                        onPressed: () async {
                          applyFilters(_futureIssues);
                          Navigator.pop(context);
                        },
                        child: const Text("Apply"),
                      ),
                    ),
                  ),
                  // TextButton(
                  //   onPressed: () {
                  //     applyFilters(_futureIssues);

                  //     Navigator.pop(context);
                  //   },
                  //   child: Text(
                  //     'Apply',
                  //     style: AppStyles.heading(context),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  onNavigatorBackPressed() {
    loadIssueData();
    _futureIssues = getList();

    // TODO: implement onBackPressed
    // throw UnimplementedError();
  }
}
