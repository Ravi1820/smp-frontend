import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/profile.dart';
import 'package:SMP/user_by_roles/admin/my_approval/my_approval.dart';
import 'package:SMP/user_by_roles/admin/vote_poll/admin_poll_optinn.dart/admin_all_vote.dart';
import 'package:SMP/user_by_roles/admin/vote_poll/admin_poll_optinn.dart/admin_historical_polls.dart';
import 'package:SMP/user_by_roles/admin/vote_poll/admin_poll_optinn.dart/admin_scheduled_poll.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:flutter/material.dart';

import 'my_past_approval_history.dart';

class MyApprovalTabsScreen extends StatefulWidget {
  const MyApprovalTabsScreen({Key? key}) : super(key: key);

  @override
  State<MyApprovalTabsScreen> createState() => _MyApprovalTabsScreenState();
}

class _MyApprovalTabsScreenState extends State<MyApprovalTabsScreen>
    with SingleTickerProviderStateMixin,NavigatorListener {
  late TabController _tabController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

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

        // Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: 'My Approvals',
            profile: () {
              Navigator.of(context).push(createRoute(const UserProfile()));
            },
          ),
        ),
        // drawer: const DrawerScreen(),
        body: Column(
          children: [
            // give the tab bar a height [can change hheight to preferred height]
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  // give the indicator a decoration (color and border radius)
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromRGBO(113, 177, 245, 1),
                        Color.fromRGBO(35, 84, 136, 1),
                      ],
                    ),
                    // color: Colors.green,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: const [
                    // first tab [you can add an icon using the icon property]
                    Tab(
                      text: 'Current',
                    ),
                    Tab(
                      text: 'Past',
                    ),
                  ],
                ),
              ),
            ),

            // tab bar view here
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  // first tab bar view widget
                  ResidentMyApprovalList(),

                  // ActiveVotePollScreen(),
                  MyPastApprovalHistoryList(),

                  // second tab bar view widget


                ],
              ),
            ),
            const FooterScreen(),
          ],
        ),
      ),
    );
  }

  @override
  onNavigatorBackPressed() {
    // Navigator.pop(context);
  }
}
