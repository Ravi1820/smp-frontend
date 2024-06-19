import 'package:SMP/profile.dart';
import 'package:SMP/user_by_roles/admin/help/issue_list_by_status.dart/admin_inprogress_issue.dart';
import 'package:SMP/user_by_roles/admin/help/issue_list_by_status.dart/admin_pending_issues.dart';
import 'package:SMP/user_by_roles/admin/help/issue_list_by_status.dart/admin_resolved_issues.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:flutter/material.dart';

class Categories {
  final int id;
  final String name;

  Categories({
    required this.id,
    required this.name,
  });
}

class AdminIssueList extends StatefulWidget {
  const AdminIssueList({Key? key}) : super(key: key);

  @override
  _AdminIssueListState createState() => _AdminIssueListState();
}

class _AdminIssueListState extends State<AdminIssueList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
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
            title: Strings.MANAGE_COMPLAINTS_HEADER,
            profile: () {
              Navigator.of(context).push(createRoute(const UserProfile()));
            },
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(FontSizeUtil.SIZE_03),
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
                      text: Strings.TAB_HEADER_01,
                    ),
                    Tab(
                      text: Strings.TAB_HEADER_02,
                    ),
                    Tab(
                      text: Strings.TAB_HEADER_03,
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
                  AdminPendingIssueScreen(),
                  AdminInprogressIssueScreen(),
                  AdminResolvedIssueScreen()
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
