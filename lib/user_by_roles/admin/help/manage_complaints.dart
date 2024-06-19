import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/help/admin_issue_list.dart';
import 'package:SMP/user_by_roles/admin/help/search_issue_tickets.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageComplaints extends StatefulWidget {
  const ManageComplaints({super.key});
  @override
  State<ManageComplaints> createState() {
    return _ManageComplaintsState();
  }
}

class _ManageComplaintsState extends State<ManageComplaints>  {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void handleDrawerItemTap1(String item) {
    if (item == "Security List") {
      Navigator.of(context).push(createRoute( AdminIssueList()));
    }

    if (item == "Plumber") {
      Navigator.of(context).push(createRoute(const SearchIssueTicket()));

      // Fluttertoast.showToast(
      //   msg: 'Feature will be coming soon!',
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.red,
      //   textColor: Colors.white,
      //   fontSize: 16.0,
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle headerTitle = TextStyle(
      fontFamily: "Poppins",
      fontSize: MediaQuery.of(context).size.width * 0.050,
      fontWeight: FontWeight.w600,
      color: const Color(0xff1B5694),
    );

    var gridIconSize = MediaQuery.of(context).size.width * 0.13;

    Widget content = Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          childAspectRatio: 1.0,
          // padding: const EdgeInsets.only(left: 10, right: 10),
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          children: [
            GestureDetector(
              onTap: () {
                handleDrawerItemTap1("Security List");
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: AppStyles.decoration(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 5,
                      ),
                      Icon(
                        Icons.home_work_outlined,
                        size: gridIconSize,
                        color: const Color(0xff1B5694),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "View Issues",
                          // LocalizationUtil.translate('dashboardPendingIssues'),
                          style: GoogleFonts.openSans(
                            textStyle: headerTitle,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                handleDrawerItemTap1("Plumber");
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: AppStyles.decoration(context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 5,
                      ),
                      Icon(
                        Icons.search,
                        size: gridIconSize,
                        color: const Color(0xff1B5694),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Search Tickets",
                          // LocalizationUtil.translate('dashboardPendingIssues'),
                          style: GoogleFonts.openSans(
                            textStyle: headerTitle,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        // StaffCard(
        //   scrollController: _scrollController,
        //   handleDrawerItemTap1: handleDrawerItemTap1,
        // ),
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        // Navigator.of(context).push(createRoute(const DashboardScreen()));
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: 'Manage Complaints',
            // onBack: () async {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => const DashboardScreen()),
            //   );
            // },
            // menuOpen: () {
            //   _scaffoldKey.currentState!.openDrawer();
            // },
            profile: () {
              // Navigator.of(context).push(createRoute(const UserProfile()));
            },
            // home: () async {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => const DashboardScreen()),
            //   );
            // },
          ),
        ),
        // drawer: const DrawerScreen(),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
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
                    child: Column(
                      children: <Widget>[content],
                    ),
                  ),
                ),
                const SizedBox(
                  child: FooterScreen(),
                ),
              ],
            ),
            if (_isLoading) // Display the loader if _isLoading is true
              Positioned(child: LoadingDialog()),
          ],
        ),
      ),
    );
  }
}
