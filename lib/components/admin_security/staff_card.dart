import 'package:SMP/theme/common_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StaffCard extends StatelessWidget {
  const StaffCard({
    super.key,
    required this.handleDrawerItemTap1,
    required this.scrollController,
  });

  final Function(String) handleDrawerItemTap1;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    TextStyle headerTitle = TextStyle(
      fontFamily: "Poppins",
      fontSize: MediaQuery.of(context).size.width * 0.050,
      fontWeight: FontWeight.w600,
      color: const Color(0xff1B5694),
    );

    var gridIconSize = MediaQuery.of(context).size.width * 0.13;

    // TextStyle headerTitle = TextStyle(
    //   fontFamily: "Poppins",
    //   fontSize: MediaQuery.of(context).size.width * 0.034,
    //   fontWeight: FontWeight.w600,
    //   color: const Color(0xff1B5694),
    // );

  

    return 
    GridView.count(
      controller: scrollController,
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
                    Icons.security,
                    size: gridIconSize,
                    color: const Color(0xff1B5694),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Security",
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
                    Icons.cleaning_services,
                    size: gridIconSize,
                    color: const Color(0xff1B5694),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Housekeeping",
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
                    Icons.plumbing,
                    size: gridIconSize,
                    color: const Color(0xff1B5694),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Plumber",
                      // LocalizationUtil.translate('dashboardMaintainResident'),

                      // "Maintain Residents",
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
                    Icons.electric_meter_outlined,
                    size: gridIconSize,
                    color: const Color(0xff1B5694),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Electrician",
                      // LocalizationUtil.translate('dashboardMaintainResident'),

                      // "Maintain Residents",
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
                    Icons.people_outline_sharp,
                    size: gridIconSize,
                    color: const Color(0xff1B5694),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Others",
 
                      // "Maintain Residents",
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
    );
  }
}
