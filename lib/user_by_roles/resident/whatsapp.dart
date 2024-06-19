import 'dart:io';

import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/resident/my_visitors/my_visitors_list.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:SMP/widget/header.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Whatsapp extends StatefulWidget {
  Whatsapp(
      {super.key,
      required this.guestId,
      required this.fromDate,
      required this.toDate,
      required this.floorNumber,
      required this.blockNumber,
      required this.flatNumber,
      required this.address1,
      required this.state,
      required this.countary,
      required this.pincode,
      required this.userName,
      required this.navigatorListener,
      required this.type});

  final String guestId;
  final String? flatNumber;
  final String? floorNumber;
  final String? blockNumber;
  final String? address1;
  final String? state;
  final String? countary;
  final String? pincode;
  final String fromDate;
  final String toDate;
  final String userName;
  NavigatorListener? navigatorListener;

  final String type;

  @override
  State<Whatsapp> createState() {
    return _Whatsapp();
  }
}

class _Whatsapp extends State<Whatsapp> with NavigatorListener {
  final ScrollController _scrollController = ScrollController();
  final screenshotController = ScreenshotController();

  // bool _isNetworkConnected = false, _isLoading = false;

  String? guestId;
  String? flatNumber = '';
  String? floorNumber = '';
  String? blockNumber = '';
  String? address1 = '';
  String? state = '';
  String? countary = '';
  String? pincode = '';
  String userName = '';
  String fromDate = '';
  String toDate = '';

  String? passcode = '';
  String apartmentName = '';

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    passcode = widget.guestId;
    fromDate = widget.fromDate;
    toDate = widget.toDate;
    flatNumber = widget.flatNumber;
    floorNumber = widget.floorNumber;
    blockNumber = widget.blockNumber;
    address1 = widget.address1;
    state = widget.state;
    countary = widget.countary;
    pincode = widget.pincode;
    userName = widget.userName;

    getapartmentName();
  }

  getapartmentName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apartName = prefs.getString('apartmentName');

    setState(() {
      apartmentName = apartName!;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.type == "pree-approve") {
          Navigator.pop(context);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardScreen(
                isFirstLogin: false,
              ),
            ),
          );
        }
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: Strings.SHARE_OTP_HEADER,
            profile: () async {},
          ),
        ),
        // drawer: const DrawerScreen(),
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white,
                    ],
                  ),
                ),
                child: Screenshot(
                  controller: screenshotController,
                  child: cardWidget(passcode),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: FontSizeUtil.CONTAINER_SIZE_15,
                  horizontal: FontSizeUtil.CONTAINER_SIZE_90),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _shareCardToWhatsApp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1B5694),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_15),
                  ),
                  padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.share,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: FontSizeUtil.SIZE_08,
                    ),
                    Text(
                      Strings.SHARE_BUTTION_TEXT,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: FontSizeUtil.CONTAINER_SIZE_18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareCardToWhatsApp() async {
    final Uint8List? imageBytes = await screenshotController.capture();
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/card_screenshot.png');

    await file.writeAsBytes(imageBytes!);

    await Share.shareFiles([file.path],
        text:
            '$userName has invited you on $fromDate - $toDate. Please use $passcode as entry code at gate.');
  }

  Widget cardWidget(passcode) {
    return Padding(
      padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
      child: Container(
        decoration: AppStyles.decoration(context),
        child: Align(
          alignment: Alignment.center,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '$userName has invited you',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff1B5694),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                Text(Strings.SHARTE_TO_SECURITY_TEXT,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff1B5694),
                    )),

                SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: FontSizeUtil.CONTAINER_SIZE_10),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff1B5694),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(FontSizeUtil.SIZE_05),
                        ),
                        padding: EdgeInsets.all(FontSizeUtil.SIZE_05),
                      ),
                      child: Text(
                        passcode.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: FontSizeUtil.CONTAINER_SIZE_20,
                        ),
                      ),
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                Flexible(
                  child: Text(Strings.SHARE_OTP_OR_TEXT,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff1B5694),
                      )),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                QrImageView(
                  data: passcode.toString(),
                  size: MediaQuery.of(context).size.width * 0.40,
                  gapless: false,
                ),

                Text(
                    '${DateFormat("y-MM-dd hh:mm a").format(DateTime.parse(fromDate))} To',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff1B5694),
                    )),
                // const SizedBox(
                //   height: 10,
                // ),

                Flexible(
                  child: Text(
                      '${DateFormat("y-MM-dd hh:mm a").format(DateTime.parse(toDate))}',
                      // toDate,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff1B5694),
                      )),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                Text(apartmentName, style: AppStyles.heading(context)),
                SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                // const SizedBox(
                //   height: 10,
                // ),
                Flexible(
                  child:
                      Text('$blockNumber, Floor $floorNumber, Flat $flatNumber',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff1B5694),
                          )),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                Flexible(
                  child: Text(
                    '$address1, $state , $pincode',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff1B5694),
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                Padding(
                  padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                  child: SizedBox(
                    height: FontSizeUtil.CONTAINER_SIZE_60,
                    width: FontSizeUtil.CONTAINER_SIZE_60,
                    child: Container(
                      decoration: AppStyles.circle(context),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            FontSizeUtil.CONTAINER_SIZE_50),
                        child: Image.asset(
                          "assets/images/SMP.png",
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: FontSizeUtil.CONTAINER_SIZE_10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
  // Widget cardWidget(passcode) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: Container(
  //       decoration: AppStyles.decoration(context),
  //       child: Align(
  //         alignment: Alignment.center,
  //         child: Center(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               FittedBox(
  //                 fit: BoxFit.scaleDown,
  //                 child: Text(
  //                   '$userName has invited you',
  //                   style: TextStyle(
  //                     fontFamily: 'Roboto',
  //                     fontSize: MediaQuery.of(context).size.width * 0.05,
  //                     fontStyle: FontStyle.normal,
  //                     fontWeight: FontWeight.w600,
  //                     color: const Color(0xff1B5694),
  //                   ),
  //                   textAlign: TextAlign.center,
  //                 ),
  //               ),
  //
  //               Flexible(
  //                 child: Text('Show this OTP to Security at gate',
  //                     style: TextStyle(
  //                       fontFamily: 'Roboto',
  //                       fontSize: MediaQuery.of(context).size.width * 0.04,
  //                       fontStyle: FontStyle.normal,
  //                       fontWeight: FontWeight.w600,
  //                       color: const Color(0xff1B5694),
  //                     )),
  //               ),
  //
  //               SizedBox(
  //                 width: double.infinity,
  //                 child: Container(
  //                   padding: const EdgeInsets.symmetric(
  //                       vertical: 10, horizontal: 50),
  //                   width: double.infinity,
  //                   child: ElevatedButton(
  //                     onPressed: () async {},
  //                     style: ElevatedButton.styleFrom(
  //                       backgroundColor: const Color(0xff1B5694),
  //                       elevation: 5,
  //                       shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(15),
  //                       ),
  //                       padding: const EdgeInsets.all(15),
  //                     ),
  //                     child: Text(
  //                       passcode.toString(),
  //                       style: const TextStyle(
  //                         color: Colors.white,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 18,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //               Flexible(
  //                 child: Text("──── OR ─────",
  //                     style: TextStyle(
  //                       fontFamily: 'Roboto',
  //                       fontSize: MediaQuery.of(context).size.width * 0.04,
  //                       fontStyle: FontStyle.normal,
  //                       fontWeight: FontWeight.w600,
  //                       color: const Color(0xff1B5694),
  //                     )),
  //               ),
  //               // const SizedBox(
  //               //   height: 10,
  //               // ),
  //               QrImageView(
  //                 data: passcode.toString(),
  //                 size: MediaQuery.of(context).size.width * 0.34,
  //                 gapless: false,
  //               ),
  //
  //               // const SizedBox(
  //               //   height: 10,
  //               // ),
  //
  //               Flexible(
  //                 child: Text('$fromDate To',
  //                     style: TextStyle(
  //                       fontFamily: 'Roboto',
  //                       fontSize: MediaQuery.of(context).size.width * 0.04,
  //                       fontStyle: FontStyle.normal,
  //                       fontWeight: FontWeight.w600,
  //                       color: const Color(0xff1B5694),
  //                     )),
  //               ),
  //               // const SizedBox(
  //               //   height: 10,
  //               // ),
  //
  //               Flexible(
  //                 child: Text(toDate,
  //                     style: TextStyle(
  //                       fontFamily: 'Roboto',
  //                       fontSize: MediaQuery.of(context).size.width * 0.04,
  //                       fontStyle: FontStyle.normal,
  //                       fontWeight: FontWeight.w600,
  //                       color: const Color(0xff1B5694),
  //                     )),
  //               ),
  //               // const SizedBox(
  //               //   height: 10,
  //               // ),
  //               Flexible(
  //                 child: Text(apartmentName, style: AppStyles.heading(context)),
  //               ),
  //               // const SizedBox(
  //               //   height: 10,
  //               // ),
  //               Flexible(
  //                 child:
  //                     Text('$blockNumber, Floor $floorNumber, Flat $flatNumber',
  //                         style: TextStyle(
  //                           fontFamily: 'Roboto',
  //                           fontSize: MediaQuery.of(context).size.width * 0.04,
  //                           fontStyle: FontStyle.normal,
  //                           fontWeight: FontWeight.w600,
  //                           color: const Color(0xff1B5694),
  //                         )),
  //               ),
  //               // const SizedBox(
  //               //   height: 10,
  //               // ),
  //               Flexible(
  //                 child: Text(
  //                   '$address1, $state , $pincode',
  //                   style: TextStyle(
  //                     fontFamily: 'Roboto',
  //                     fontSize: MediaQuery.of(context).size.width * 0.03,
  //                     fontStyle: FontStyle.normal,
  //                     fontWeight: FontWeight.w600,
  //                     color: const Color(0xff1B5694),
  //                   ),
  //                 ),
  //               ),
  //               // const SizedBox(
  //               //   height: 10,
  //               // ),
  //               Padding(
  //                 padding: const EdgeInsets.all(18.0),
  //                 child: SizedBox(
  //                   height: 60,
  //                   width: 60,
  //                   child: Container(
  //                     decoration: AppStyles.circle(context),
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.circular(50),
  //                       child: Image.asset(
  //                         "assets/images/SMP.png",
  //                         width: double.infinity,
  //                         fit: BoxFit.cover,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //
  //               const SizedBox(
  //                 height: 10,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  onNavigatorBackPressed() {
    Navigator.pop(context);
  }
}
