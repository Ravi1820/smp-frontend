import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../firebase_options.dart';
import '../utils/Strings.dart';
import '../utils/Utils.dart';

import 'dart:developer' as developer;

final navigatorKey = GlobalKey<NavigatorState>();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  developer.log("background developer:${message.data}");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (message.data != null) {
    print("Handling a background message: ${message.data}");

    String action = message.data['action'] ?? '';
    String title = message.data['title'] ?? '';
    String messages = message.data['message'] ?? '';

    //SOS Push Notification
    String sosUserName = message.data['name'] ?? '';
    String sosBlock = message.data['block'] ?? '';
    String sosFlat = message.data['flat'] ?? '';

    // Add Visitor Security To Resident

    String checkOutBody = '';
    String body = '';
    String sosBody = '';
    String sosMessage = '';
    String addVisitorPurpose = '';
    String addVisitorMessage = '';
    String visitorGotRejectedBody = '';
    String visitorGotApprovedBody = '';
    String messageBody = '';
    String checkInBody = '';
    String approvalBody = '';
    String approvalMessage = '';
    // Checkout Push Notification
    if (action == "checkout") {
      checkOutBody = message.data['body'];
    } else if (action == "action_accept") {
      addVisitorPurpose = message.data['body'];
      addVisitorMessage = message.data['message'];
    } else if (action == "Visitor got approved") {
      visitorGotApprovedBody = message.data['body'];
    } else if (action == "Visitor got Rejected") {
      visitorGotRejectedBody = message.data['body'];
    } else if (action == "message") {
      messageBody = message.data['body'];
    } else if (action == "checkin") {
      checkInBody = message.data['body'];
    } else if (action == "SOS") {
      sosBody = message.data['body'];
      sosMessage = message.data['message'];
    } else if (action == "approval") {
      approvalBody = message.data['body'];
      approvalMessage = message.data['message'];
    }
    else {
      body = message.data['body'] ?? '';
    }

    String noticeAdded = message.data['isNoticeChanged'] ?? "false";
    String deviceAdded = message.data['isDeviceIdChanged'] ?? "false";
    String isIssueChanged = message.data['isIssueChanged'] ?? "false";

    // String noticeChangedBody = message.data['body'] ?? "";
    // String userIdString = message.data['userIdString'] ?? '';

    String visitorId = message.data['vistorId'] ?? '';
    // String visitorName = message.data['visitorName'] ?? '';
    // String residentName = message.data['residentName'] ?? '';
    // String residentBlock = message.data['residentBlock'] ?? '';
    // String residentFloor = message.data['residentFloor'] ?? '';

    // String time = message.data['time'] ?? '';

    // String action_acceptBody = message.data['body'];
    // String action_acceptMessage = message.data['message'];
    // String visitorGotApprovedBody = message.data['body'];
    // String visitorGotRejectedBody = message.data['body'];

    if (noticeAdded == "true") {
      Utils.writeCounter(noticeAdded, Strings.NOTICE_FILE_NAME);
      developer.log("Notice Changed:$noticeAdded");
    } else if (deviceAdded == "true") {
      developer.log("Device Changed Changed:$deviceAdded");
      Utils.writeCounter(deviceAdded, Strings.DEVICE_ID_FILE_NAME);
    } else if (isIssueChanged == "true") {
      developer.log("Issue Count Changed:$isIssueChanged");
      Utils.writeCounter(isIssueChanged, Strings.ISSUE_COUNT_FILE_NAME);
    }

    Map<String, dynamic> listPayload = {
      'action': action,
      'title': title,
      'messages': messages,
      "checkOutBody": checkOutBody,
      "addVisitorPurpose": addVisitorPurpose,
      "addVisitorMessage": addVisitorMessage,
      "visitorGotApprovedBody": visitorGotApprovedBody,
      "visitorGotRejectedBody": visitorGotRejectedBody,

      "sosMessage": sosMessage,
      "sosUserName": sosUserName,
      "sosBlock": sosBlock,
      "sosFlat": sosFlat,

      "isNoticeAdded": noticeAdded,
      "addVisitorMessage": addVisitorMessage,
      "approvalMessage": approvalMessage,

      "visitorId": visitorId,
      // "visitorName": visitorName,
      // "residentName": residentName,
      // "residentBlock": residentBlock,
      // "residentFloor": residentFloor,
      "checkInBody": checkInBody,
      // "isNoticeAdded": noticeAdded,
      // "isDeviceAdded": deviceAdded,
      // 'userIdString': userIdString,

      // "action_acceptBody":action_acceptBody,
      // "action_acceptMessage" : action_acceptMessage,
    };

    // int userId = int.tryParse(userIdString) ?? 0;

    AndroidNotificationDetails androidPlatformChannelSpecifics;

    if (action == "Visitor got approved" || action == "Visitor got Rejected") {
      androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'notification_channel_id',
        'com.secureMyPlace.SMP.urgent',
        sound: RawResourceAndroidNotificationSound('sound3'),
        playSound: true,
        importance: Importance.max,
        priority: Priority.high,
        timeoutAfter: 5000,
      );
    } else if (action == "SOS") {
      androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'notification_channel_id_1',
        'com.secureMyPlace.SMP.urgent',
        sound: RawResourceAndroidNotificationSound('sound4'),
        playSound: true,
        importance: Importance.max,
        priority: Priority.high,
      );
    } else {
      androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'notification_channel_id_2',
        'com.secureMyPlace.SMP.urgent',
        sound: RawResourceAndroidNotificationSound('sound2'),
        playSound: true,
        importance: Importance.max,
        priority: Priority.high,
      );
    }
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    if (noticeAdded == "true" && body.isNotEmpty) {
      developer.log("onMessage developer:");
      await flutterLocalNotificationsPlugin.show(
        0,
        "Secure My Place",
        body,
        platformChannelSpecifics,
        payload: json.encode(listPayload),
      );
    }else if (action == "approval"){
      await flutterLocalNotificationsPlugin.show(
        0,
        approvalBody,
        approvalMessage,
        platformChannelSpecifics,
        payload: json.encode(listPayload),
      );
    }
    else if (title.isNotEmpty) {
      await flutterLocalNotificationsPlugin.show(
        0,
        title,
        messages,
        platformChannelSpecifics,
        payload: json.encode(listPayload),
      );
    } else if (checkOutBody.isNotEmpty) {
      await flutterLocalNotificationsPlugin.show(
        0,
        checkOutBody,
        messages,
        platformChannelSpecifics,
        payload: json.encode(listPayload),
      );
    } else if (addVisitorMessage.isNotEmpty) {
      await flutterLocalNotificationsPlugin.show(
        0,
        addVisitorPurpose,
        addVisitorMessage,
        platformChannelSpecifics,
        payload: json.encode(listPayload),
      );
    } else if (visitorGotApprovedBody.isNotEmpty) {
      await flutterLocalNotificationsPlugin.show(
        0,
        visitorGotApprovedBody,
        messages,
        platformChannelSpecifics,
        payload: json.encode(listPayload),
      );
    } else if (visitorGotRejectedBody.isNotEmpty) {
      await flutterLocalNotificationsPlugin.show(
        0,
        visitorGotRejectedBody,
        messages,
        platformChannelSpecifics,
        payload: json.encode(listPayload),
      );
    } else if (action == "SOS") {
      await flutterLocalNotificationsPlugin.show(
        0,
        sosBody,
        sosMessage,
        platformChannelSpecifics,
        payload: json.encode(listPayload),
      );
    } else if (messageBody.isNotEmpty) {
      await flutterLocalNotificationsPlugin.show(
        0,
        messageBody,
        messages,
        platformChannelSpecifics,
        payload: json.encode(listPayload),
      );
    } else if (checkInBody.isNotEmpty) {
      await flutterLocalNotificationsPlugin.show(
        0,
        checkInBody,
        messages,
        platformChannelSpecifics,
        payload: json.encode(listPayload),
      );
    }
    // else if (visitorGotApprovedBody.isNotEmpty){
    //   await flutterLocalNotificationsPlugin.show(
    //     0,
    //     visitorGotApprovedBody,
    //     messages,
    //     platformChannelSpecifics,
    //     payload: json.encode(listPayload),
    //   );
    //
    //
    // }
    // else if(visitorGotRejectedBody.isNotEmpty){
    //   await flutterLocalNotificationsPlugin.show(
    //     0,
    //     visitorGotRejectedBody,
    //     messages,
    //     platformChannelSpecifics,
    //     payload: json.encode(listPayload),
    //   );
    // }
  }
}

class FireBaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    WidgetsFlutterBinding.ensureInitialized();
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  }
}
