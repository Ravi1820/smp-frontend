import 'dart:convert';

import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/pending_aproval_list_card.dart';
import '../../model/pending_visitor_model.dart';

class ApprovalList extends StatefulWidget {
  const ApprovalList({super.key});
  @override
  State<ApprovalList> createState() {
    return _ApprovalListState();
  }
}

class _ApprovalListState extends State<ApprovalList> with ApiListener {
  final TextEditingController _searchController = TextEditingController();
  bool setShowlistflag = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isNetworkConnected = false, _isLoading = true;

  List originalUsers = [];
  List visitorslist = [];
  String query = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    _getResidentList();
  }

  String baseImageApi = '';

  _getResidentList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apartId = prefs.getInt('apartmentId');
    final id = prefs.getInt('id');

    try {
      Utils.getNetworkConnectedStatus().then((status) {
        Utils.printLog("network status : $status");
        setState(() {
          _isNetworkConnected = status;
          _isLoading = status;
          if (_isNetworkConnected) {
            String responseType = "teamMember";
            String teamMemberURL =
                '${Constant.waitingVisitorsURL}?apartmentId=$apartId';
            NetworkUtils.getNetWorkCall(teamMemberURL, responseType, this);
          } else {
            Utils.printLog("else called");
            _isLoading = false;
            Utils.showCustomToast(context);
          }
        });
      });

      String? baseImageApis = BaseApiImage.baseImageUrl(apartId!, "visitor");

      setState(() {
        baseImageApi = baseImageApis;
      });
    } catch (e) {
      print('Error: $e');
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
        _isLoading = false;

        if (responseType == 'teamMember') {
          List<PendingVisitorsModel> teamMemberlst =
              (json.decode(response) as List)
                  .map((item) => PendingVisitorsModel.fromJson(item))
                  .toList();

          visitorslist = teamMemberlst;
          print(visitorslist);
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      Utils.printLog("Error === $response");
    }
  }

  void editUserChoice(users) {}

  void _filterList(String query) {
    setState(() {
      this.query = query;
    });
  }

  void getList() {
    setState(() {
      if (query.isNotEmpty) {
        originalUsers = visitorslist.where((user) {
          final nameMatches =
              user.name.toLowerCase().contains(query.toLowerCase());
          final purposeMatches =
              user.purpose.toLowerCase().contains(query.toLowerCase());
          return nameMatches || purposeMatches;
        }).toList();
      } else {
        originalUsers = visitorslist;
      }
    });
  }

  Future<void> _handleRefresh() async {
    print("Refreshing");
    _getResidentList();
  }

  @override
  Widget build(BuildContext context) {
    getList();

    Widget content;

    if (originalUsers.isNotEmpty) {
      content = Padding(
        padding: const EdgeInsets.all(8.0),
        child: PendingApprovalVisitorsListViewCard(
          users: originalUsers,
          baseImageIssueApi: baseImageApi,
        ),
      );
    } else {
      content = _isLoading
          ? Container()
          : Center(
              child: Text(
                Strings.NO_VISITORS_TEXT,
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
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: Strings.PENDING_APPROVAL_LIST,
            profile: () async {
              Navigator.of(context)
                  .push(createRoute(DashboardScreen(isFirstLogin: false)));
            },
          ),
        ),
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
                      SizedBox(height:FontSizeUtil.CONTAINER_SIZE_10),
                      Expanded(
                          child: RefreshIndicator(
                              onRefresh: _handleRefresh, child: content)),
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
}
