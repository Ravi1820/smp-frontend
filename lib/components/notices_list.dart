import 'package:SMP/theme/common_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import '../model/notice_board_model.dart';
import '../utils/Utils.dart';

class NoticeCard extends StatefulWidget {
  final List notificationLists;

  const NoticeCard({
    super.key,
    required this.notificationLists,
  });

  @override
  State<NoticeCard> createState() => _NoticeCardState();
}

class _NoticeCardState extends State<NoticeCard> {
  late Timer _timer;
  List noticeList = [];
  List noticeModifyList = [];

  @override
  void initState() {
    super.initState();

    noticeList = widget.notificationLists;
    _updateDate();
    _startTimer();
  }

  void _startTimer() {
    // Start a timer that updates every second
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      // Trigger a rebuild of the widget tree to update the displayed time difference
      _updateDate();
      setState(() {
        noticeModifyList;
      });
    });
  }

  void _updateDate() {
    // Utils.printLog("Timer called");
    noticeModifyList = [];
    for (Values values in noticeList) {
      // if (values.createdDate != null) {
        values.timeAgo = Utils.formatTimeDifference(values.createdDate!);
        // Utils.printLog("Timer in loop called ${values.timeAgo}");
        noticeModifyList.add(values);
      // }
    }
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Cancel the timer when the widget is removed from the tree
  //   WidgetsBinding.instance?.addPostFrameCallback((_) {
  //     if (!mounted) {
  //       _timer.cancel();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: AppStyles.decoration(context),
        child: Column(
          children: [
            Container(
              decoration: AppStyles.noticeHeaderContainer(context),
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 13.0, top: 4, bottom: 4),
                  child: Text(
                    "Admin Notice:",
                    style: AppStyles.noticeHeader1(context),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: ListView.builder(
                  itemCount: noticeModifyList.length,
                  itemBuilder: (context, index) {
                    final notice = noticeModifyList[index];
                    return  Container(
                      decoration: AppStyles.decoration(context),
                      margin: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    notice.noticeHeader,
                                    style: AppStyles.heading1(context),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                if (notice.timeAgo != null)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      notice.timeAgo,
                                      style: AppStyles.heading1(context),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              notice.message,
                              style: AppStyles.noticeBlockText(context),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

//
// class _NoticeCardState extends State<NoticeCard> {
//
//
//   @override
//   void initState() {
//
//
//     formatTimeDifference()
//
//     super.initState();
//   }
//
//
//   String formatTimeDifference(secondsAgo) {
//     final now = DateTime.now();
//     final visitorAddDate = now.subtract(
//       Duration(seconds: secondsAgo),
//     );
//     final difference = now.difference(visitorAddDate);
//     if (difference.inDays > 0) {
//       // If the difference is in days
//       return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
//     } else if (difference.inHours > 0) {
//       // If the difference is in hours
//       return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
//     } else if (difference.inMinutes > 0) {
//       // If the difference is in minutes
//       return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'min' : 'mins'} ago';
//     } else if (difference.inSeconds > 0) {
//       // If the difference is in seconds
//       return '${difference.inSeconds} ${difference.inSeconds == 1 ? 'sec' : 'secs'} ago';
//     } else {
//       return 'just now';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//       child: Container(
//         decoration: AppStyles.decoration(context),
//         child: Column(
//           children: [
//             Container(
//               decoration: AppStyles.noticeHeaderContainer(context),
//               child: Align(
//                 alignment: Alignment.topLeft,
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 13.0, top: 4, bottom: 4),
//                   child: Text(
//                     "Admin Notice:",
//                     style: AppStyles.noticeHeader1(context),
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 5.0),
//                 child: ListView.builder(
//                   itemCount: widget.notificationLists.length,
//                   itemBuilder: (context, index) {
//                     final notice = widget.notificationLists[index];
//                     return Card(
//                       elevation: 2.0,
//                       margin: const EdgeInsets.symmetric(
//                           vertical: 5.0, horizontal: 10.0),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 6.0, vertical: 3),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     notice.noticeHeader,
//                                     style: AppStyles.heading1(context),
//                                   ),
//                                 ),
//                                 const SizedBox(
//                                   width: 10,
//                                 ),
//                                 if (notice.timeAgo != null)
//                                   Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 8.0),
//                                     child: Text(
//                                       formatTimeDifference(
//                                           int.parse(notice.timeAgo)),
//                                       style: AppStyles.heading1(context),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                             const SizedBox(height: 8.0),
//                             Text(
//                               notice.message,
//                               style: AppStyles.noticeBlockText(context),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
