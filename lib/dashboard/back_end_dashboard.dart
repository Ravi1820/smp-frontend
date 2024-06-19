import 'package:SMP/contants/translate.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BackEndDashboard extends StatelessWidget {
  const BackEndDashboard(
      {super.key,
      required this.treatingDoctersList,
      required this.handleDrawerItemTap1,
      required this.dutyDoctersList,
      required this.scrollController,
      required this.nurseStationDoctersList});

  final int treatingDoctersList;
  final int dutyDoctersList;
  final int nurseStationDoctersList;
  final Function(String) handleDrawerItemTap1;

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    TextStyle headerTitle = TextStyle(
        fontFamily: "Poppins",
        fontSize: MediaQuery.of(context).size.width * 0.044,
        fontWeight: FontWeight.w700,
        color: const Color.fromARGB(255, 255, 255, 255));

    BoxDecoration decoration = BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(113, 177, 245, 1),
          Color.fromRGBO(35, 84, 136, 1),
        ],
      ),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    );

    return GridView.count(
        controller: scrollController,
        childAspectRatio: 1.0,
        padding: const EdgeInsets.only(left: 16, right: 16),
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        children: [
          GestureDetector(
            onTap: () {
              handleDrawerItemTap1("Apartment List");
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: decoration,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/images/apartment.png",
                      width: 52,
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Tooltip(
                        message: 'Apartment',
                        child: Text(
                          // AppText.dashboardApartmentDataDisplay,
                          LocalizationUtil.translate(
                              'dashboardApartmentDataDisplay'),
                          style: GoogleFonts.openSans(
                            textStyle: headerTitle,
                          ),
                          textAlign: TextAlign.center, // Center the text
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              handleDrawerItemTap1("Flat Excel Upload");
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: decoration,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 10,
                    ),
                    Icon(
                      Icons.file_copy,
                      size: MediaQuery.of(context).size.width * 0.119,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        // AppText.dashboardSecurityDetails,

                        "Flat Excel Upload",
                        style: GoogleFonts.openSans(
                          textStyle: headerTitle,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]);
  }
}
