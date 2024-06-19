import 'dart:convert';
import 'dart:io';
import 'package:SMP/login.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../presenter/AlertListener.dart';
import '../theme/common_style.dart';
import 'dart:io' show Platform;
import 'SharedPreferenceUtils.dart';
import 'Strings.dart';

class Utils {
  /*
  * This method to call stateless widget screen.
  * */

  static const double appBarTitleText = 20.0;
  static const double drawerText = 18.0;

  static const double headerText = 18;
  static const double titleText = 15;
  static const double subTitleText = 12;

  static const String NOTICECHANGED = "new_notice_add";

  // final bool noticeChangedValue = true;
  static List ALLDEVICEIDS = [];
  static List ALLNOTICES = [];

  static void routeTransition(
      BuildContext context, StatelessWidget statelessWidget) {
    Navigator.of(context)
        .push(CupertinoPageRoute<Null>(builder: (BuildContext context) {
      return statelessWidget;
    }));
  }

  static void navigateToPushAndRemoveUntilScreen(BuildContext context, screen) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => screen),
      (route) => false,
    );
  }

  static void backPressed(BuildContext context,) {
    Navigator.pop(context);
  }

  static void navigateToPushScreen(BuildContext context, screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  static void routeTransitionWithReplace(
      BuildContext context, StatelessWidget statelessWidget) {
//    Navigator.of(context).popAndPushNamed();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => statelessWidget,
      ),
    );
  }

  static void routeTransitionStateFullWithReplace(
      BuildContext context, StatefulWidget statefulWidget) {
//    Navigator.of(context).popAndPushNamed();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => statefulWidget,
      ),
    );
  }

  static showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static showSuccessToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static showErrorToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static createStackWidget(Function() onTakePicture) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(alignment: Alignment.center, child: const AvatarScreen()),
        Positioned(
          bottom: FontSizeUtil.SIZE_08,
          right: FontSizeUtil.SIZE_09,
          child: GestureDetector(
            onTap: onTakePicture,
            child: Container(
              padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromRGBO(38, 105, 177, 1)),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          top: FontSizeUtil.SIZE_01,
          right: FontSizeUtil.SIZE_01,
          child: GestureDetector(
            child: Container(
              padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
              child: Text(
                '*',
                style: TextStyle(
                  color: const Color.fromRGBO(255, 0, 0, 1),
                  fontSize: FontSizeUtil.CONTAINER_SIZE_25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static showCustomToast(BuildContext context) {
    const textStyleBold = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white);
    const textStyleNormal = TextStyle(color: Colors.white);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xff1B5694),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: const Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'No Connectivity !\n',
              style: textStyleBold,
            ),
            TextSpan(
              text: 'Please check your internet connectivity',
              style: textStyleNormal,
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
    OverlayState? overlay = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned(
          top: MediaQuery.of(context).size.height / 2 - 8.0,
          left: MediaQuery.of(context).size.width * 0.1,
          right: MediaQuery.of(context).size.width * 0.1,
          child: Material(
            color: Colors.transparent,
            child: toast,
          ),
        );
      },
    );

    // Insert the overlay entry
    overlay.insert(overlayEntry);

    // Remove the overlay entry after a delay
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  static TextInputFormatter createEmailInputFormatter() {
    return FilteringTextInputFormatter.allow(
      RegExp(r"[a-zA-Z0-9._%+-@]+|\s"),
    );
  }

  static Widget showCircleProgressBar() {
    return Container(
        color: Colors.transparent,
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  backgroundColor: Colors.grey,
                ),
                Text(
                  "Loading",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ));
  }

  static Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  // static void refreshState() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  // }

  static double screenHeight(BuildContext context, {double dividedBy = 1}) {
    return screenSize(context).height / dividedBy;
  }

  static double screenWidth(BuildContext context, {double dividedBy = 1}) {
    return screenSize(context).width / dividedBy;
  }

  static Widget showNetworkErrorMessage(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: Utils.screenHeight(context, dividedBy: 2.5)),
        child: Text(
            "There is no network connection in your device. Please check your connectivity & try again later!",
            style: new TextStyle(fontSize: 18.0)));
  }

  static bool isConnected = false;

  static Future<bool> getNetworkConnectedStatus() async {
    try {
      Utils.printLog("called getNetworkConnectedStatus()");
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        isConnected = true;
      } else {
        isConnected = false;
        Utils.printLog("Network is not connected");
      }
      Utils.getToken();
    } on SocketException catch (_) {
      print('not connected');
      isConnected = false;
    }
    return isConnected;
  }

  static bool isNetworkConnected() {
    return isConnected;
  }

  static bool isBackPressed = false, isSummaryLoggedOut = false;

  static void setBackPressed(bool backpressed) {
    isBackPressed = backpressed;
  }

  static bool getBackPressed() {
    return isBackPressed;
  }

  static void setSummaryLoggedOut(bool isLoggedOut) {
    isSummaryLoggedOut = isLoggedOut;
  }

  static void printLog(String message) {
    print(message);
  }

  static int serviceMainId = 0;

  static void setBookedServiceId(int serviceMainIds) {
    serviceMainId = serviceMainIds;
  }

  static TextStyle getTitleWhiteStyle() {
    return TextStyle(
      fontFamily: 'OpenSans-Semibold',
      fontSize: 20.0,
      color: Colors.white,
    );
  }

  static TextStyle getActionbarHeaderStyle() {
    return TextStyle(
      fontFamily: 'Arial',
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }

  static TextStyle getHeaderStyle() {
    return TextStyle(
      fontFamily: 'OpenSans-Regular',
      fontSize: 18.0,
      color: Colors.black87,
    );
  }

  // static TextStyle getTextColorStyle() {
  //   return TextStyle(
  //     fontFamily: 'OpenSans-Regular',
  //     fontSize: 18.0,
  //     color: Color(ColorCode.TEXT_COLOR),
  //   );
  // }

  static TextStyle getHeaderWhiteStyle() {
    return TextStyle(
      fontFamily: 'OpenSans-Regular',
      fontSize: 18.0,
      color: Colors.white,
    );
  }

  // static TextStyle getHeaderPrimaryStyle() {
  //   return TextStyle(
  //     fontFamily: 'OpenSans-Regular',
  //     fontSize: 18.0,
  //     // letterSpacing: 0.18,

  //     color: Color(ColorCode.PRIMARY_COLOR),
  //   );
  // }

  static TextStyle getSubTitleStyle() {
    return TextStyle(
      fontFamily: 'Arial',
      fontSize: 16.0,
      letterSpacing: 0.18,
      color: Colors.grey,
    );
  }

  static TextStyle getTitleStyle() {
    return TextStyle(
      fontFamily: 'OpenSans-Light',
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      //fontSize: 14,
      letterSpacing: 0.18,
      color: Colors.grey,
    );
  }

  static TextStyle getButtonWhiteStyle() {
    return TextStyle(
      fontFamily: 'OpenSans-Semibold',
      fontSize: 18.0,
      color: Colors.white,
    );
  }

  // static TextStyle getLabelPrimaryStyle() {
  //   return TextStyle(
  //     fontFamily: 'OpenSans-Semibold',
  //     fontSize: 14.0,
  //     color: Color(ColorCode.PRIMARY_COLOR),
  //   );
  // }
  static String? token = "";

  static void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    print("UTTL Tokent ==== $token");
  }

  static void sessonExpired(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    showToast("Session expired. Please login again!");
    token = "";

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  static TextStyle getLabelWhiteStyle() {
    return TextStyle(
      fontFamily: 'OpenSans-Semibold',
      fontSize: 16.0,
      color: Colors.white,
    );
  }

  static TextStyle getLabelSmallStyle() {
    return TextStyle(
      fontFamily: 'Arial-Semibold',
      fontSize: 13.0,
      fontWeight: FontWeight.w800,
      color: Colors.blueGrey,
    );
  }

  static TextStyle getButtonBlackStyle() {
    return TextStyle(
      fontFamily: 'OpenSans-Semibold',
      fontSize: 18.0,
      color: Colors.black87,
    );
  }

  static TextStyle getTextBlackStyle() {
    return TextStyle(
      fontFamily: 'OpenSans-Semibold',
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );
  }

  static onBackPressed(BuildContext context) {
    Navigator.pop(context);
  }

  static Widget createDrawerHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image:
                    AssetImage('assets/images/drawer_header_background.png'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Row(
                children: <Widget>[
                  Icon(Icons.account_circle, size: 36.0, color: Colors.white),
                  Text(" Dr. Abhinash",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500)),
                ],
              )),
        ]));
  }

  static bool validation(String input, RegExp regExp) {
    return regExp.hasMatch(input);
  }

  static makingPhoneCall(contact) async {
    if (contact == null && contact.isEmpty) {
      return;
    }
    var url = Uri.parse("tel:$contact");
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  static String addResidentDetails(var name, var flatNumber, var blockName) {
    return ((name != null && name.length > 0)
            ? (flatNumber != null && flatNumber.length > 0)
                ? "$name, "
                : name
            : " ") +
        ((flatNumber != null && flatNumber.length > 0)
            ? flatNumber + ", "
            : "") +
        blockName;
  }

  static String getApprovalPendingText(String date) {
    return Strings.APPROVAL_PENDING_TEXT_TEMPLATE.replaceFirst('{date}', date);
  }

  static void showLogoutDialog(BuildContext context, AlertListener listener) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(top: 10.0, right: 10.0),
          content: Container(
            margin: const EdgeInsets.only(left: 0.0, right: 0.0),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                    top: 18.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        "Log out?",
                        style: AppStyles.heading(context),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 16),
                      const Text(
                        "Are you sure, Do you want to logout?",
                        style: TextStyle(
                          color: Color.fromRGBO(27, 86, 148, 1.0),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 30,
                            child: ElevatedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: const BorderSide(
                                    width: 1,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 0,
                                ),
                              ),
                              onPressed: () async {
                                Navigator.pop(context);
                                listener.onRightButtonAction(context);
                              },
                              child: const Text("Logout"),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                        width: 5.0,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0.0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.close,
                        size: 25,
                        color: Color(0xff1B5694),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<ImageSource?> takePicture(BuildContext context) async {
    return showDialog<ImageSource>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.only(top: 10.0, right: 10.0),
        content: Container(
          margin: const EdgeInsets.only(left: 0.0, right: 0.0),
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                  top: 18.0,
                ),
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   shape: BoxShape.rectangle,
                //   borderRadius: BorderRadius.circular(16.0),
                // ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Choose image source',
                        // style: AppStyles.heading(context), // You can define your style if needed
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                      width: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: const BorderSide(
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 0,
                              ),
                            ),
                            onPressed: () =>
                                Navigator.pop(context, ImageSource.gallery),
                            child: const Text("Gallery"),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: const BorderSide(
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 0,
                              ),
                            ),
                            onPressed: () =>
                                Navigator.pop(context, ImageSource.camera),
                            child: const Text("Camera"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                      width: 5.0,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.close, size: 25, color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void clearLogoutData(BuildContext context) async {
    await SharedPreferenceUtils.deleteValueFromSF();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  /* Navigation */
  static void navigateToAnotherScreenWithPush(
      BuildContext context, StatefulWidget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _localFile(String fileName) async {
    final path = await _localPath;
    Utils.printLog("path::$path filename: $fileName");
    return File('$path/$fileName.txt');
  }

  static Future<File> writeCounter(String counter, String fileName) async {
    final file = await _localFile(fileName);
    Utils.printLog("File path::${file.path}");
    Future<File> textFile = file.writeAsString('$counter');
    return textFile;
  }

  static Future<String> readCounter(String fileName) async {
    try {
      final file = await _localFile(fileName);
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "false";
    }
  }

  static deleteFile(String fileName) async {
    try {
      final file = await _localFile(fileName);
      await file.delete();
      Utils.printLog("Push file deleted successfully");
    } catch (e) {
      e.printError();
    }
  }

  static int pushCount = 0;

  static String formatTimeDifference(String dateTime) {
    String value = "just now";
    if (dateTime != null && dateTime.isNotEmpty) {
      // String date = "2024-04-13 08:45:54";
      DateTime createdDate = DateTime.parse(dateTime);
      final now = DateTime.now();
      final difference = now.difference(createdDate);
      // Utils.printLog("difference : ${difference.inDays} :  ${difference.inHours} : ${difference.inMinutes} : ${difference.inSeconds}");
      if (difference.inDays > 0) {
        value =
            '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
      } else if (difference.inHours > 0) {
        value =
            '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inMinutes > 0) {
        value =
            '${difference.inMinutes} ${difference.inMinutes == 1 ? 'min' : 'mins'} ago';
      } else if (difference.inSeconds > 0) {
        value =
            '${difference.inSeconds} ${difference.inSeconds == 1 ? 'sec' : 'secs'} ago';
      } else if (difference.inMilliseconds > 0) {
        value = 'just now';
      }
    }
    return value;
  }

  static bool get showBackButton {
    if (Platform.isIOS) {
      return true;
    } else if (Platform.isAndroid) {
      return false;
    }
    return false;
  }

  static int updateDate(String currentDateTime) {
    try {
      Utils.printLog("Registration Time $currentDateTime");

      DateTime storedDate = DateTime.parse(currentDateTime);
      DateTime now = DateTime.now();

      Utils.printLog("Stored Date: $storedDate");
      Utils.printLog("Current Date: $now");

      Duration difference = now.difference(storedDate);
      int differenceInSeconds = difference.inSeconds;

      Utils.printLog("Difference in seconds: $differenceInSeconds");
      Utils.printLog("Difference in Minutes: ${difference.inMinutes}");
      Utils.printLog("Difference in Hours: ${difference.inHours}");

      return differenceInSeconds;
    } catch (e) {
      Utils.printLog("Error parsing date: $e");
      return 0;
    }
  }

  static Widget dashboardExpandedContainer(BuildContext context, IconData icon,
      String label, Function(String) handleDrawerItemTap1) {
    return Container(
        margin: EdgeInsets.all(FontSizeUtil.SIZE_03),
      child: ElevatedButton(
        onPressed: () {
          handleDrawerItemTap1(label);
        },
        style: ElevatedButton.styleFrom(
          elevation: 5,
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FontSizeUtil.SIZE_10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: MediaQuery.of(context).size.width * 0.06,
              color: const Color(0xff1B5694),
            ),
            SizedBox(height: FontSizeUtil.SIZE_03),
            Padding(
              padding: EdgeInsets.all(FontSizeUtil.SIZE_03),
              child: Text(
                label,
                style: AppStyles.dashboardFont(context),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

   static void showRejectVisitorDialog(
      BuildContext context, AlertListener listener) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.only(
              top: FontSizeUtil.CONTAINER_SIZE_10,
              right: FontSizeUtil.CONTAINER_SIZE_10),
          content: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: FontSizeUtil.CONTAINER_SIZE_18,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: FontSizeUtil.CONTAINER_SIZE_16),
                    Text(
                      Strings.REJECT_WARNING_TEXT,
                      style: TextStyle(
                        color: const Color.fromRGBO(27, 86, 148, 1.0),
                        fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: FontSizeUtil.CONTAINER_SIZE_20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: FontSizeUtil.CONTAINER_SIZE_30,
                          child: ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    FontSizeUtil.CONTAINER_SIZE_20),
                                side: const BorderSide(
                                  width: 1,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: FontSizeUtil.CONTAINER_SIZE_15,
                              ),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                              listener.onRightButtonAction(context);
                            },
                            child: const Text(Strings.REJECT_TEXT),
                          ),
                        ),
                        SizedBox(
                          width: FontSizeUtil.CONTAINER_SIZE_10,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: FontSizeUtil.CONTAINER_SIZE_20,
                      width: FontSizeUtil.SIZE_05,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.close,
                      size: FontSizeUtil.CONTAINER_SIZE_25,
                      color: const Color(0xff1B5694),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
