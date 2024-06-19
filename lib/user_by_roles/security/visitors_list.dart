import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/profile.dart';
import 'package:SMP/user_by_roles/security/check_in_visitors.dart';
import 'package:SMP/user_by_roles/security/check_out_visitor.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:flutter/material.dart';

import 'all_visitors_list/all_rejected_visitors.dart';

class VisitorsList extends StatefulWidget {
  VisitorsList({super.key, required this.title});
  String title;
  @override
  _VisitorsListState createState() => _VisitorsListState();
}

class _VisitorsListState extends State<VisitorsList>
    with SingleTickerProviderStateMixin, NavigatorListener {
  late TabController _tabController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {

        Navigator.of(context).push(createRoute(DashboardScreen(
          isFirstLogin: false,
        )));

        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: widget.title,
            profile: () {
              Navigator.of(context).push(createRoute(const UserProfile()));
            },
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding:  EdgeInsets.all(FontSizeUtil.SIZE_08),
              child: Container(
                height: FontSizeUtil.CONTAINER_SIZE_45,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(
                    FontSizeUtil.CONTAINER_SIZE_25,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      FontSizeUtil.CONTAINER_SIZE_25,
                    ),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(113, 177, 245, 1),
                        Color.fromRGBO(35, 84, 136, 1),
                      ],
                    ),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  labelPadding:  EdgeInsets.symmetric(horizontal: FontSizeUtil.SIZE_05),
                  tabs: const [
                    Tab(
                      text: Strings.CURRENT_VISITOR_TAB,
                    ),
                    Tab(
                      text: Strings.PAST_VISITOR_TAB,
                    ),
                    Tab(
                      text: Strings.REJECTED_VISITOR_TAB,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const CheckInVisitorsList(),
                  CheckOutVisitorsList(),
                  AllRejectedVisitorsList()
                ],
              ),
            ),
            const FooterScreen()
          ],
        ),
      ),
    );
  }

  @override
  onNavigatorBackPressed() {}
}
