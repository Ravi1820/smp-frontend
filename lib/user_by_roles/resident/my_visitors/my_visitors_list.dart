import 'package:SMP/profile.dart';
import 'package:SMP/user_by_roles/resident/my_visitors/approved_visitors.dart';
import 'package:SMP/user_by_roles/resident/my_visitors/entered_visitors.dart';
import 'package:SMP/user_by_roles/resident/my_visitors/rejected_visitors.dart';
import 'package:SMP/user_by_roles/resident/my_visitors/waiting_visitors.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:flutter/material.dart';

import '../../../utils/Strings.dart';

class MyVisitorsListScreen extends StatefulWidget {
  const MyVisitorsListScreen({Key? key}) : super(key: key);

  @override
  _MyVisitorsListScreenState createState() => _MyVisitorsListScreenState();
}

class _MyVisitorsListScreenState extends State<MyVisitorsListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
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
        Navigator.pop(context);

        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: Strings.MY_VISITORS_HEADER,
            profile: () {
              Navigator.of(context).push(createRoute(const UserProfile()));
            },
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
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
                  labelPadding:
                      EdgeInsets.symmetric(horizontal: FontSizeUtil.SIZE_05),
                  tabs: const [
                    Tab(
                      text: Strings.WAITING_TXT,
                    ),
                    Tab(
                      text: Strings.EXPECTED_TXT,
                    ),
                    Tab(
                      text: Strings.IN_OUT_TEXT,
                    ),
                    Tab(
                      text: Strings.REJECTED_TXT,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  ResidentWaitingVisitorsList(),
                  ResidentApprovedVisitorsList(),
                  ResidentEnteredVisitorsList(),
                  ResidentRejectedVisitorsList(),
                ],
              ),
            ),
            const FooterScreen()
          ],
        ),
      ),
    );
  }
}
