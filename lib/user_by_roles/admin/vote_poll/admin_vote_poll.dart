import 'package:SMP/profile.dart';
import 'package:SMP/user_by_roles/admin/vote_poll/admin_poll_optinn.dart/admin_all_vote.dart';
import 'package:SMP/user_by_roles/admin/vote_poll/admin_poll_optinn.dart/admin_historical_polls.dart';
import 'package:SMP/user_by_roles/admin/vote_poll/admin_poll_optinn.dart/admin_scheduled_poll.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:flutter/material.dart';

class AdminVotePollScreen extends StatefulWidget {
  const AdminVotePollScreen({Key? key}) : super(key: key);

  @override
  State<AdminVotePollScreen> createState() => _AdminVotePollScreenState();
}

class _AdminVotePollScreenState extends State<AdminVotePollScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
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
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: Strings.ADMIN_POLL_HEADER_TEXT,
            profile: () {
              Navigator.of(context).push(createRoute(const UserProfile()));
            },
          ),
        ),
        // drawer: const DrawerScreen(),
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
                    // color: Colors.green,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: const [
                    Tab(
                      text: Strings.ADMIN_SCHEDULED_POLL_HEADER_TEXT,
                    ),
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

            // tab bar view here
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  AdminShcudlueVoteOptionScreen(),
                  AdminAllVoteOptionScreen(),
                  AdminHistoricalVoteOptionScreen()
                ],
              ),
            ),
            const FooterScreen(),
          ],
        ),
      ),
    );
  }
}
