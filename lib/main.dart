import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/push_notificaation_key.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/home_screen.dart';
import 'package:SMP/login.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/registration/waiting_for_approval.dart';
import 'package:SMP/splash_screen/splash_screen.dart';
import 'package:SMP/services/firebase.api.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/my_approval/my_approval_tabs.dart';
import 'package:SMP/user_by_roles/resident/resident_message_list.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/local_notification.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/view_model/smp_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'contants/constant_url.dart';
import 'firebase_options.dart';
import 'network/NetworkUtils.dart';
import 'dart:developer' as developer;
import 'package:clear_all_notifications/clear_all_notifications.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

final StreamController<String> selectNotificationStream =
    StreamController<String>.broadcast();

String routeToGo = '/';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeLocalNotifications(
    ApiListener apiListener, bool _isNetworkConnected) async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // final IOSInitializationSettings _initialzationSettingsIOS =
  // IOSInitializationSettings(
  //   requestAlertPermission: false,
  //   requestBadgePermission: false,
  //   requestSoundPermission: false,
  // );

  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin);

  void notificationTapBackground(
      int id, String title, String? body, String? payload) async {}

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final isApprovedOrRejected = prefs.getString('isApprovedOrRejected');
      // prefs.setString('isApprovedOrRejected', "isApprovedOrRejected");
      final currentContext = navigatorKey.currentContext;

      print('payload ${response.payload}');

      Map<String, dynamic> payloadMap = response.payload is String
          ? jsonDecode(response.payload as String)
          : response.payload as Map<String, dynamic>;

      String sosMessage = payloadMap['sosMessage'] ?? '';
      String sosUserName = payloadMap['sosUserName'] ?? '';
      String sosBlock = payloadMap['sosBlock'] ?? '';
      String sosFlat = payloadMap['sosFlat'] ?? '';
      String checkOutBody = payloadMap['checkOutBody'] ?? '';

      String? action = payloadMap['action'];
      String message = payloadMap['messages'] ?? '';
      String isNoticeAdded = payloadMap['isNoticeAdded'] ?? "false";
      String title = payloadMap['title'] ?? '';
      String userIdString = payloadMap['userIdString'] ?? '';
      String visitorName = payloadMap['visitorName'] ?? '';
      String residentName = payloadMap['residentName'] ?? '';
      String residentBlock = payloadMap['residentBlock'] ?? '';
      String residentFloor = payloadMap['residentFloor'] ?? '';
      String visitorId = payloadMap['visitorId'] ?? '';
      String time = payloadMap['time'] ?? '';

      String addVisitorPurpose = payloadMap['addVisitorPurpose'] ?? "";
      String addVisitorMessage = payloadMap['addVisitorMessage'] ?? "";
      String visitorGotApprovedBody =
          payloadMap['visitorGotApprovedBody'] ?? "";
      String visitorGotRejectedBody =
          payloadMap['visitorGotRejectedBody'] ?? "";

      String checkInBody = payloadMap['checkInBody'] ?? "";

      print("userIdString ==== $userIdString");
      print("Visitor Id === $visitorId");
      Utils.printLog("action $action");
      developer.log("action From On Message Pressed : $isNoticeAdded");

      print(payloadMap);
      if (isNoticeAdded == "true") {
        developer.log("action true : $isNoticeAdded");
        Utils.navigateToAnotherScreenWithPush(
            currentContext!, DashboardScreen(isFirstLogin: true));
      } else if (action == "message") {
        Utils.navigateToAnotherScreenWithPush(
            currentContext!, const ResidentMessage());
      } else if (action == "approval") {
        Utils.navigateToAnotherScreenWithPush(
            currentContext!, const MyApprovalTabsScreen());
      } else if (action == "SOS") {
        showDialog(
          barrierDismissible: false,
          context: currentContext!,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Emergency Alert",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              decoration: AppStyles.profile(context),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  "assets/images/sos.jpg",
                                  gaplessPlayback: true,
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildTableRow("Block", sosBlock),
                      _buildTableRow("Flat", sosFlat),
                      _buildTableRow("From", sosUserName),
                      _buildTableRow("Message", sosMessage),
                    ],
                  ),
                ],
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(233, 83, 83, 1),
                          borderRadius:
                              BorderRadius.circular(10.0), // Border radius
                        ),
                        padding: const EdgeInsets.all(10.0), // Padding
                        child: const Text(
                          'Ok',
                          style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            );
          },
        );
      } else if (action == 'action_accept') {
        developer.log("Add Visitor Handler ::: ${Utils.pushCount}");
        // if (Utils.pushCount == 0) {
        developer.log("Add Visitor Handler ::: ${Utils.pushCount}  ");
        Utils.pushCount = 1;
        showDialog(
          barrierDismissible: false,
          context: currentContext!,
          builder: (BuildContext contexts) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.person,
                    size: 64,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    addVisitorPurpose,
                    style: const TextStyle(
                      color: Color.fromRGBO(27, 86, 148, 1.0),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    addVisitorMessage,
                    style: const TextStyle(
                      color: Color.fromRGBO(27, 86, 148, 1.0),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // SizedBox(height: 6),
                ],
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: () async {
                        approveRejectNetworkCall(
                            "reject",
                            visitorId,
                            contexts,
                            _isNetworkConnected,
                            apiListener,
                            visitorName,
                            residentName,
                            userIdString);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(233, 83, 83, 1),
                          borderRadius:
                              BorderRadius.circular(10.0), // Border radius
                        ),
                        padding: const EdgeInsets.all(10.0), // Padding
                        child: const Text(
                          'Reject',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      onPressed: () async {
                        approveRejectNetworkCall(
                            "approve",
                            visitorId,
                            contexts,
                            _isNetworkConnected,
                            apiListener,
                            visitorName,
                            residentName,
                            userIdString);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: const Center(
                          child: Text(
                            'Approve',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
        // }
      } else if (action == "checkout") {
        showDialog(
          barrierDismissible: false,
          context: currentContext!,
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
                      margin: const EdgeInsets.only(
                        top: 13.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Icon(
                            Icons.check_circle,
                            size: 64,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 16),
                          const SizedBox(height: 16),
                          Text(
                            title,
                            style: const TextStyle(
                              color: Color.fromRGBO(27, 86, 148, 1.0),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            checkOutBody,
                            style: const TextStyle(
                              color: Color.fromRGBO(27, 86, 148, 1.0),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
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
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else if (action == "checkin") {
        showDialog(
          barrierDismissible: false,
          context: currentContext!,
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
                      margin: const EdgeInsets.only(
                        top: 13.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Icon(
                            Icons.check_circle,
                            size: 64,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 16),
                          const SizedBox(height: 16),
                          Text(
                            checkInBody,
                            style: const TextStyle(
                              color: Color.fromRGBO(27, 86, 148, 1.0),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
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
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else if (action == "Visitor got approved") {
        showDialog(
          barrierDismissible: false,
          context: currentContext!,
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
                      margin: const EdgeInsets.only(
                        top: 13.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Icon(
                            Icons.check_circle,
                            size: 64,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 16),
                          const SizedBox(height: 16),
                          Text(
                            visitorGotApprovedBody,
                            style: const TextStyle(
                              color: Color.fromRGBO(27, 86, 148, 1.0),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          // const Text(
                          //   "Got approved by ",
                          //   style: TextStyle(
                          //     color: Color.fromRGBO(27, 86, 148, 1.0),
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          //   textAlign: TextAlign.center,
                          // ),
                          // Text(
                          //   residentName,
                          //   style: const TextStyle(
                          //     color: Color.fromRGBO(27, 86, 148, 1.0),
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          //   textAlign: TextAlign.center,
                          // ),
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
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else if (action == "Visitor got Rejected") {
        showDialog(
          barrierDismissible: false,
          context: currentContext!,
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
                      margin: const EdgeInsets.only(
                        top: 13.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Icon(
                            Icons.cancel,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          const SizedBox(height: 16),
                          Text(
                            visitorName,
                            style: const TextStyle(
                              color: Color.fromRGBO(27, 86, 148, 1.0),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          // const Text(
                          //   "Got rejected by",
                          //   style: TextStyle(
                          //     color: Color.fromRGBO(27, 86, 148, 1.0),
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          //   textAlign: TextAlign.center,
                          // ),
                          Text(
                            visitorGotRejectedBody,
                            style: const TextStyle(
                              color: Color.fromRGBO(27, 86, 148, 1.0),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
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
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        developer.log("action finally : $isNoticeAdded");
        showDialog(
          barrierDismissible: false,
          context: currentContext!,
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
                      margin: const EdgeInsets.only(
                        top: 13.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const SizedBox(
                            height: 10.0,
                          ),
                          const Icon(
                            Icons.check_circle,
                            size: 64,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 16),
                          const SizedBox(height: 16),
                          Text(
                            message.isNotEmpty ? message : title,
                            style: const TextStyle(
                              color: Color.fromRGBO(27, 86, 148, 1.0),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
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
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    },
  );
}

approveRejectNetworkCall(
    var isApproved,
    var notificationId,
    BuildContext contexts,
    isNetworkConnected,
    apiListener,
    visitorName,
    residentName,
    userIdString) async {
  print(isApproved);
  Utils.getNetworkConnectedStatus().then((status) {
    Utils.printLog("network status : $status");

    isNetworkConnected = status;

    if (isNetworkConnected) {
      String responseType = "isApproved";
      String isApprovedUrl =
          '${Constant.approveRejectVisitorFromPushURL}?visitoId=${notificationId}&permission=$isApproved';

      NetworkUtils.putUrlNetWorkCall(isApprovedUrl, apiListener, responseType);

      // _pushNotificationNetworkCall(
      //     visitorName, residentName, userIdString, apiListener, isApproved);
    } else {
      Utils.printLog("else called");
    }
    Navigator.pop(contexts);
  });
}
//
// _pushNotificationNetworkCall(String visitorName, String residentName,
//     String userIdString, apiListener, type) {
//   Utils.printLog(visitorName);
//   Utils.printLog(residentName);
//   Utils.printLog(userIdString);
//   Utils.getNetworkConnectedStatus().then((status) {
//     Utils.printLog("network status : $status");
//
//     if (status) {
//       var responseType = 'push';
//       String keyName = "";
//       if (type == "approve") {
//         final Map<String, dynamic> bodyData = <String, dynamic>{
//           "title": "$visitorName got approved by $residentName",
//           "visitorName": visitorName,
//           "residentName": residentName,
//           "action": "Visitor got approved"
//         };
//
//         final Map<String, dynamic> data = <String, dynamic>{
//           "to": userIdString,
//           "data": bodyData,
//         };
//         String partURL = Constant.pushNotificationURL;
//         NetworkUtils.pushNotificationWorkCall(
//             partURL, keyName, data, apiListener, responseType);
//       } else {
//         final Map<String, dynamic> bodyData = <String, dynamic>{
//           "title": "$visitorName got rejected by $residentName",
//           "visitorName": visitorName,
//           "residentName": residentName,
//           "action": "Visitor got Rejected"
//         };
//
//         final Map<String, dynamic> data = <String, dynamic>{
//           "to": userIdString,
//           "data": bodyData,
//         };
//         String partURL = Constant.pushNotificationURL;
//         NetworkUtils.pushNotificationWorkCall(
//             partURL, keyName, data, apiListener, responseType);
//       }
//     }
//     else {
//       Utils.printLog("else called");
//
//       //Utils.showCustomToast(context);
//       Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
//     }
//   });
// }

Widget _buildTableRow(
  String leftText,
  String rightText,
) {
  return Row(
    children: <Widget>[
      Expanded(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            leftText,
            style: const TextStyle(
              color: Color.fromRGBO(27, 86, 148, 1.0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      const Text(":"),
      Expanded(
        flex: 3,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            rightText,
            style: const TextStyle(
              color: Color.fromRGBO(27, 86, 148, 1.0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ],
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

@pragma('vm:entry-point')
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  FireBaseApi().initNotification();

  HttpOverrides.global = MyHttpOverrides();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) async => {runApp(const MyApp())});
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with ApiListener {
  final List _notifications = []; // Store notifications locally
  bool _isNetworkConnected = false;

  @override
  void initState() {
    initializeLocalNotifications(this, _isNetworkConnected);

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        debugPrint("onMessage::");
        developer.log("onMessage developer: ${message.data}");
        log("onMessage: ${message.data}");
        String action = message.data['action'] ?? '';

        //SOS Push
        String sosMessage = message.data['message'] ?? '';
        String sosUserName = message.data['name'] ?? '';
        String sosBlock = message.data['block'] ?? '';
        String sosFlat = message.data['flat'] ?? '';

        String checkOutBody = '';

        // Checkout Push Notification
        if (action == "checkout") {
          checkOutBody = message.data['body'];
        }
        log("Notice key ${message.data.keys}");

        String isDeviceIdChanged = message.data['isDeviceIdChanged'] ?? "false";
        log("Device Changed $isDeviceIdChanged");
        String isNoticeChanged = message.data['isNoticeChanged'] ?? "false";
        log("Notice Changed $isNoticeChanged");

        String isIssueChanged = message.data['isIssueChanged'] ?? "false";
        log("Notice Changed $isIssueChanged");

        String noticeChangedBody = message.data['body'] ?? "";
        log("Notice Changed body  $noticeChangedBody");

        String userIdString = message.data['userIdString'] ?? '';
        String title = message.data['title'] ?? '';
        String subtitle = message.data['messages'] ?? '';

        String visitorName = message.data['visitorName'] ?? '';
        String messages = message.data['body'] ?? '';

        String visitorId = message.data['vistorId'] ?? '';
        String time = message.data['time'] ?? '';
        String residentName = message.data['residentName'] ?? '';
        String residentBlock = message.data['residentBlock'] ?? '';
        String residentFloor = message.data['residentFloor'] ?? '';

        final currentContext = navigatorKey.currentContext;
        String action_acceptBody = message.data['body'] ?? '';
        String action_acceptMessage = message.data['message'] ?? "";
        String visitorGotApprovedBody = message.data['body'] ?? "";
        String visitorGotRejectedBody = message.data['body'] ?? "";

        if (isNoticeChanged == "true") {
          log("came inside if for notice");
          Utils.writeCounter(isNoticeChanged, Strings.NOTICE_FILE_NAME);
          LocalNotification.showNotification(message);
        } else if (isDeviceIdChanged == "true") {
          log("came inside if for device");
          Utils.writeCounter(isDeviceIdChanged, Strings.DEVICE_ID_FILE_NAME);
        } else if (isIssueChanged == "true") {
          log("came inside if for issue");
          Utils.writeCounter(isIssueChanged, Strings.ISSUE_COUNT_FILE_NAME);
        } else if (action == "SOS") {
          showDialog(
            barrierDismissible: false,
            context: currentContext!,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Emergency Alert",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: AppStyles.profile(context),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(
                                    "assets/images/sos.jpg",
                                    gaplessPlayback: true,
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildTableRow("Block", sosBlock),
                        _buildTableRow("Flat", sosFlat),
                        _buildTableRow("From", sosUserName),
                        _buildTableRow("Message", sosMessage),
                      ],
                    ),
                  ],
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(233, 83, 83, 1),
                            borderRadius:
                                BorderRadius.circular(10.0), // Border radius
                          ),
                          padding: const EdgeInsets.all(10.0), // Padding
                          child: const Text(
                            'Ok',
                            style: TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ],
              );
            },
          );

          LocalNotification.showNotification(message);
        } else if (action == 'action_accept') {
          Utils.pushCount = 1;
          LocalNotification.showNotification(message);
          showDialog(
            barrierDismissible: false,
            context: currentContext!,
            builder: (BuildContext contexts) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person,
                      size: 64,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      action_acceptBody,
                      style: const TextStyle(
                        color: Color.fromRGBO(27, 86, 148, 1.0),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      action_acceptMessage,
                      style: const TextStyle(
                        color: Color.fromRGBO(27, 86, 148, 1.0),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // SizedBox(height: 6),
                  ],
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          developer.log("onMessage developer: ${visitorId}");
                          Utils.printLog("Visitor Id === ${visitorId}");
                          approveRejectNetworkCall(
                              "reject", visitorId, contexts, this);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(233, 83, 83, 1),
                            borderRadius:
                                BorderRadius.circular(10.0), // Border radius
                          ),
                          padding: const EdgeInsets.all(10.0), // Padding
                          child: const Text(
                            'Reject',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          approveRejectNetworkCall(
                              "approve", visitorId, contexts, this);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: const Center(
                            child: Text(
                              'Approve',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        } else if (action == "Visitor got approved") {
          showDialog(
            barrierDismissible: false,
            context: currentContext!,
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
                        margin: const EdgeInsets.only(
                          top: 13.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 0.0,
                              offset: Offset(0.0, 0.0),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Icon(
                              Icons.check_circle,
                              size: 64,
                              color: Colors.green,
                            ),
                            const SizedBox(height: 16),
                            const SizedBox(height: 16),
                            Text(
                              visitorGotApprovedBody,
                              style: const TextStyle(
                                color: Color.fromRGBO(27, 86, 148, 1.0),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
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
                            child:
                                Icon(Icons.close, size: 25, color: Colors.red),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          LocalNotification.showNotification(message);
        } else if (action == "Visitor got Rejected") {
          showDialog(
            barrierDismissible: false,
            context: currentContext!,
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
                        margin: const EdgeInsets.only(
                          top: 13.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 0.0,
                              offset: Offset(0.0, 0.0),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Icon(
                              Icons.cancel,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            const SizedBox(height: 16),
                            Text(
                              visitorGotRejectedBody,
                              style: const TextStyle(
                                color: Color.fromRGBO(27, 86, 148, 1.0),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
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
                            child:
                                Icon(Icons.close, size: 25, color: Colors.red),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          LocalNotification.showNotification(message);
        } else if (action == "checkout") {
          showDialog(
            barrierDismissible: false,
            context: currentContext!,
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
                        margin: const EdgeInsets.only(
                          top: 13.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 0.0,
                              offset: Offset(0.0, 0.0),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Icon(
                              Icons.check_circle,
                              size: 64,
                              color: Colors.green,
                            ),
                            const SizedBox(height: 16),
                            const SizedBox(height: 16),
                            Text(
                              checkOutBody,
                              style: const TextStyle(
                                color: Color.fromRGBO(27, 86, 148, 1.0),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
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
                            child:
                                Icon(Icons.close, size: 25, color: Colors.red),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          LocalNotification.showNotification(message);
        } else {
          LocalNotification.showNotification(message);
        }
      },
    );
    super.initState();
  }

  approveRejectNetworkCall(
      isApproved, notificationId, BuildContext contexts, apiListener) async {
    print(isApproved);
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");

      // setState(() {
      //   _isNetworkConnected = status;
      if (status) {
        String responseType = "isApproved";
        String isApprovedUrl =
            '${Constant.approveRejectVisitorFromPushURL}?visitoId=${notificationId}&permission=$isApproved';

        NetworkUtils.putUrlNetWorkCall(isApprovedUrl, this, responseType);
      } else {
        Utils.printLog("else called");
        Utils.showCustomToast(context);
        // Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
      }
      // });
      Navigator.pop(contexts);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: SmpListViewModel()),
      ],
      child: MaterialApp(
          title: 'SMP',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(),
            primarySwatch: Colors.indigo,
            hintColor: const Color.fromARGB(255, 67, 89, 112),
          ),
          navigatorKey: navigatorKey,
          initialRoute: (routeToGo.isNotEmpty) ? routeToGo : '/',
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(
                  builder: (_) => const SplashScreen(),
                );

              case '/main':
                return MaterialPageRoute(
                  builder: (_) => HomeScreen(),
                );

              case '/login':
                return MaterialPageRoute(
                  builder: (_) => LoginScreen(),
                );

              case '/waiting':
                return MaterialPageRoute(
                  builder: (_) => WaitingForApprovalScreen(
                    isFirstLogin: false,
                  ),
                );
              case '/dashboard':
                return MaterialPageRoute(
                  builder: (_) => DashboardScreen(isFirstLogin: true),
                );

              default:
                return _errorRoute();
            }
          }),
    );
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Icon(
                        Icons.delete_forever,
                        size: 48,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: CircularProgressIndicator(
                          strokeWidth: 4, value: 1.0
                          // valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.withOpacity(0.5)),
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text('Page Not Found'),
              SizedBox(
                height: 10,
              ),
              Text(
                'Press back button on your phone',
                style: TextStyle(color: Color(0xff39399d), fontSize: 28),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  onSuccess(response, String responseType) async {
    if (responseType == "isApproved") {
      await flutterLocalNotificationsPlugin.cancel(0);
      Utils.pushCount = 0;
      Utils.showToast(response);
    }
  }
}

void onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) {
  final currentContext = navigatorKey.currentContext;
  Utils.navigateToAnotherScreenWithPush(currentContext!, ResidentMessage());
}
