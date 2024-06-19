import 'package:SMP/profile.dart';
import 'package:SMP/user_by_roles/resident/resident_raised_issues/resident_inprogress_issues.dart';
import 'package:SMP/user_by_roles/resident/resident_raised_issues/resident_pending_issue.dart';
import 'package:SMP/user_by_roles/resident/resident_raised_issues/resident_resolved_issue.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:flutter/material.dart';
 
 
class ViewListScreen extends StatefulWidget {
  const ViewListScreen({Key? key}) : super(key: key);

  @override
  _ViewListScreenState createState() => _ViewListScreenState();
}

class _ViewListScreenState extends State<ViewListScreen>
    with SingleTickerProviderStateMixin {
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
        Navigator.pop(context);
        // Navigator.of(context)
        //     .push(createRoute(DashboardScreen(isFirstLogin: false)));
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: 'Raised Issue List',
            profile: () {
              Navigator.of(context).push(createRoute(const UserProfile()));
            },
          
          ),
        ),
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
                   backgroundBlendMode: BlendMode.multiply,
                  // backgroundBlendMode: 
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
                      text: 'Pending',
                    ),
                    Tab(
                      text: 'In-progress',
                    ),
                    Tab(
                      text: 'Resolved',
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  ResidentPendingIssueScreen(),
                  ResidentInprogressIssueScreen(),
                  ResidentResolvedIssueScreen()
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
