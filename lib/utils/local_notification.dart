import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'Utils.dart';
import 'dart:developer' as developer;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
class LocalNotification {
  static Future<void> showNotification(RemoteMessage message) async {
    // log("shownotification is called");
    developer.log("onMessage developer: ${message.data}");

    if (message.data != null) {
      String action = message.data['action'] ?? '';

      //SoS Push Notification

      String sosUserName = message.data['name'] ?? '';
      String sosBlock = message.data['block'] ?? '';
      String sosFlat = message.data['flat'] ?? '';

      String checkOutBody = '';
      String body = '';
      String sosBody = '';
      String sosMessage = '';
      String addVisitorPurpose = '';
      String addVisitorMessage = '';
      String visitorGotApprovedBody = '';
      String visitorGotRejectedBody = '';
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
      } else {
        body = message.data['body'] ?? '';
      }

      print("Handling a Foreground message: ${message.data}");

      String isNoticeAdded = message.data['isNoticeChanged'] ?? "false";
      developer.log(" Is Notice Added $isNoticeAdded");
      String isIssueAdded = message.data['isIssueAdded'] ?? "false";
      developer.log(" Is Notice Added $isNoticeAdded");
      String userIdString = message.data['userIdString'] ?? '';
      String title = message.data['title'] ?? '';
      String messages = message.data['message'] ?? '';

      String visitorId = message.data['vistorId'] ?? '';

      String visitorName = message.data['visitorName'] ?? '';
      String residentName = message.data['residentName'] ?? '';

      String time = message.data['time'] ?? '';

      // String checkOutBody = message.data['checkOutBody'] ?? '';
      //   String action_acceptBody = message.data['body']??'';
      Map<String, dynamic> listPayload = {
        'action': action,
        // 'userIdString': userIdString,
        'title': title,
        'messages': messages,
        "visitorGotApprovedBody": visitorGotApprovedBody,
        "visitorGotRejectedBody": visitorGotRejectedBody,
        "visitorId": visitorId,
        // "visitorName": visitorName,
        "sosMessage": messages,
        "sosUserName": sosUserName,
        "sosBlock": sosBlock,
        // "residentName": residentName,
        "sosFlat": sosFlat,
        "checkInBody": checkInBody,
        "isNoticeAdded": isNoticeAdded,
        "checkOutBody": checkOutBody,

        "addVisitorPurpose": addVisitorPurpose,
        "addVisitorMessage": addVisitorMessage,
        "approvalMessage": approvalMessage,
        // "action_acceptBody":action_acceptBody,
        // "action_acceptMessage" : action_acceptMessage,
      };
      int userId = int.tryParse(userIdString) ?? 0;
      AndroidNotificationDetails androidPlatformChannelSpecifics;
      if (action == "Visitor got approved" ||
          action == "Visitor got Rejected") {
        androidPlatformChannelSpecifics = const AndroidNotificationDetails(
          'notification_channel_id',
          'com.secureMyPlace.SMP.urgent',
          sound: RawResourceAndroidNotificationSound('sound3'),
          playSound: true,
          importance: Importance.max,
          priority: Priority.high,
          timeoutAfter: 30000,
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
      if (isNoticeAdded == "true" && body.isNotEmpty) {
        developer.log(" inside if conidtion Is Notice Added $isNoticeAdded");
        await flutterLocalNotificationsPlugin.show(
          userId,
          "Secure My Place",
          body,
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
    }
  }
}
