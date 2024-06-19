import 'package:SMP/user_by_roles/resident/resident_polls/resident_active_poll.dart';
import 'package:SMP/user_by_roles/resident/resident_polls/resident_historical_polls.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/utils/routes_animation.dart';

import 'package:flutter/material.dart';

class ResidentVotePollScreen extends StatefulWidget {
  const ResidentVotePollScreen({Key? key}) : super(key: key);

  @override
  State<ResidentVotePollScreen> createState() => _ResidentVotePollScreenState();
}

class _ResidentVotePollScreenState extends State<ResidentVotePollScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: Strings.ADMIN_POLL_HEADER_TEXT,
          // menuOpen: () {
          //   _scaffoldKey.currentState!.openDrawer();
          // },
          profile: () async {
            Navigator.of(context).push(createRoute( DashboardScreen(isFirstLogin:false)));
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
                unselectedLabelColor: const Color(0xff1B5694),
                tabs:  const [
                  Tab(
                    text: Strings.ADMIN_ACTIVE_POLL_HEADER_TEXT,
                  ),
                  Tab(
                    text: Strings.ADMIN_HISTORICAL_POLL_HEADER_TEXT,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ResidentActiveVotePollScreen(),
                ResidentAllVoteOptionScreen()
              ],
            ),
          ),
          const FooterScreen(),

          // FooterScreen()
        ],
      ),
    );
  }
}
