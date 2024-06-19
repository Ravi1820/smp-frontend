import 'dart:convert';

import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../contants/push_notificaation_key.dart';

class AdminVehicleListViewCard extends StatefulWidget {
  final List users;
  final String baseImageIssueApi;

  const AdminVehicleListViewCard({
    Key? key,
    required this.users,
    required this.baseImageIssueApi,
  }) : super(key: key);

  @override
  State<AdminVehicleListViewCard> createState() {
    return _AdminVehicleListViewCardState();
  }
}

class _AdminVehicleListViewCardState extends State<AdminVehicleListViewCard> {
  String? baseImageIssueApi = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      baseImageIssueApi = widget.baseImageIssueApi;
    });
  }

  String formatTimeDifference(int secondsAgo) {
    final now = DateTime.now();
    final visitorAddDate = now.subtract(Duration(seconds: secondsAgo));

    final difference = now.difference(visitorAddDate);

    if (difference.inDays > 0) {
      // If the difference is in days
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      // If the difference is in hours
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      // If the difference is in minutes
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'min' : 'mins'} ago';
    } else if (difference.inSeconds > 0) {
      // If the difference is in seconds
      return '${difference.inSeconds} ${difference.inSeconds == 1 ? 'sec' : 'secs'} ago';
    } else {
      // If the difference is less than a minute
      return 'just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        final user = widget.users[index];

        return GestureDetector(
          // onTap: () => _showDetailsDialog(
          //   context,
          //   user,
          //   // widget.press,
          //   // widget.
          //   baseImageIssueApi,
          // ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: [
                GestureDetector(
                  child: Container(
                    // elevation: 8.0,
                    decoration: AppStyles.decoration(context),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            leading: SizedBox(
                              height: 50,
                              width: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Stack(
                                  children: <Widget>[
                                    if (user.image != null &&
                                        user.image!.isNotEmpty)
                                      Image.network(
                                        '$baseImageIssueApi${user.image.toString()}',
                                        fit: BoxFit.cover,
                                        height: 100,
                                        width: 100,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            decoration:
                                                AppStyles.profile(context),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.asset(
                                                "assets/images/no-img.png",
                                                gaplessPlayback: true,
                                                fit: BoxFit.cover,
                                                width: 100,
                                                height: 100,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    else
                                      Container(
                                        decoration: AppStyles.profile(context),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.asset(
                                            "assets/images/no-img.png",
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
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Tn 29 BP 8852",
                                        style: AppStyles.blockText(context),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "4 Wheeler",
                                        style: AppStyles.blockText(context),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "B-101",
                                        style: AppStyles.blockText(context),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )
                                //      : Container(),
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          child:
                              // user.residentName != null
                              //     ?
                              Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.only(),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        Utils.addResidentDetails(
                                          user.userName,
                                          user.flatNumber.toString(),
                                          user.blockName!,
                                        ),
                                        style: AppStyles.blockText(context),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Utils.makingPhoneCall(
                                        user.residentMobileNumber);
                                  },
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        10.0,
                                    child: Container(
                                      decoration:
                                          AppStyles.circleGreen(context),
                                      child: const Padding(
                                        padding: EdgeInsets.all(3.0),
                                        child: Icon(
                                          Icons.call,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
      },
    );
  }
  //
  // void _showDetailsDialog(BuildContext context, user, baseImageIssueApi) {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         contentPadding: const EdgeInsets.all(0), // Adjust padding as needed
  //         content: SizedBox(
  //           width: 340,
  //           height: MediaQuery.of(context).size.height / 1.345,
  //           child: Column(
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   Expanded(
  //                     child: Center(
  //                       child: Padding(
  //                         padding: const EdgeInsets.only(left: 15.0),
  //                         child: Text("Visitor Details",
  //                             style: AppStyles.heading(context)),
  //                       ),
  //                     ),
  //                   ),
  //                   GestureDetector(
  //                     onTap: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: const Icon(
  //                       Icons.cancel,
  //                       size: 40,
  //                       color: Colors.red,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: ClipRRect(
  //                   borderRadius: BorderRadius.circular(50),
  //                   child: Stack(
  //                     children: <Widget>[
  //                       if (user.image != null && user.image!.isNotEmpty)
  //                         Container(
  //                           decoration: AppStyles.profile(context),
  //                           child: ClipRRect(
  //                               borderRadius: BorderRadius.circular(50),
  //                               child: Image.network(
  //                                 '$baseImageIssueApi${user.image.toString()}',
  //                                 fit: BoxFit.cover,
  //                                 height: 100,
  //                                 width: 100,
  //                                 errorBuilder: (context, error, stackTrace) {
  //                                   return Container(
  //                                     decoration: AppStyles.profile(context),
  //                                     child: ClipRRect(
  //                                       borderRadius: BorderRadius.circular(50),
  //                                       child: Image.asset(
  //                                         "assets/images/no-img.png",
  //                                         gaplessPlayback: true,
  //                                         fit: BoxFit.cover,
  //                                         width: 100,
  //                                         height: 100,
  //                                       ),
  //                                     ),
  //                                   );
  //                                 },
  //                               )),
  //                         )
  //                       else
  //                         Container(
  //                           decoration: AppStyles.profile(context),
  //                           child: ClipRRect(
  //                             borderRadius: BorderRadius.circular(50),
  //                             child: Image.asset(
  //                               "assets/images/no-img.png",
  //                               gaplessPlayback: true,
  //                               fit: BoxFit.cover,
  //                               width: 100,
  //                               height: 100,
  //                             ),
  //                           ),
  //                         ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               Expanded(
  //                 child: SingleChildScrollView(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: <Widget>[
  //                       Table(
  //                         children: <TableRow>[
  //                           if (user.name != null && user.name.isNotEmpty)
  //                             TableRow(
  //                               children: <Widget>[
  //                                 TableCell(
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(10),
  //                                     child: Text("Visitor Name",
  //                                         style: AppStyles.heading1(context)),
  //                                   ),
  //                                 ),
  //                                 TableCell(
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(10),
  //                                     child: Text(
  //                                       user.name,
  //                                       style: AppStyles.blockText(context),
  //                                       overflow: TextOverflow.ellipsis,
  //                                       maxLines: 1,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           if (user.mobileNumber != null &&
  //                               user.mobileNumber.isNotEmpty)
  //                             TableRow(
  //                               children: <Widget>[
  //                                 TableCell(
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(10),
  //                                     child: Text(
  //                                       "Mobile",
  //                                       style: AppStyles.heading1(context),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 TableCell(
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(10),
  //                                     child: Text(
  //                                       user.mobileNumber,
  //                                       style: AppStyles.blockText(context),
  //                                       overflow: TextOverflow.ellipsis,
  //                                       maxLines: 1,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           if (user.idProof != null && user.idProof.isNotEmpty)
  //                             TableRow(
  //                               children: <Widget>[
  //                                 TableCell(
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(10),
  //                                     child: Text("Proof Type",
  //                                         style: AppStyles.heading1(context)),
  //                                   ),
  //                                 ),
  //                                 TableCell(
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(10),
  //                                     child: Text(
  //                                       user.idProof,
  //                                       style: AppStyles.blockText(context),
  //                                       overflow: TextOverflow.ellipsis,
  //                                       maxLines: 1,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           if (user.idProofNumber != null &&
  //                               user.idProofNumber.isNotEmpty)
  //                             TableRow(
  //                               children: <Widget>[
  //                                 TableCell(
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(10),
  //                                     child: Text(
  //                                       "Proof Details",
  //                                       style: AppStyles.heading1(context),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 TableCell(
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(10),
  //                                     child: Text(
  //                                       user.idProofNumber,
  //                                       style: AppStyles.blockText(context),
  //                                       overflow: TextOverflow.ellipsis,
  //                                       maxLines: 1,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           if (user.residentName != null &&
  //                               user.residentName.isNotEmpty)
  //                             TableRow(
  //                               children: <Widget>[
  //                                 TableCell(
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(10),
  //                                     child: Text(
  //                                       "Resident Name",
  //                                       style: AppStyles.heading1(context),
  //                                     ),
  //                                   ),
  //                                 ),
  //                                 TableCell(
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(10),
  //                                     child: Text(
  //                                       user.residentName,
  //                                       style: AppStyles.blockText(context),
  //                                       overflow: TextOverflow.ellipsis,
  //                                       maxLines: 1,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           if (user.blockName != null &&
  //                               user.blockName.isNotEmpty)
  //                             TableRow(
  //                               children: <Widget>[
  //                                 TableCell(
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(10),
  //                                     child: Text("Block Name",
  //                                         style: AppStyles.heading1(context)),
  //                                   ),
  //                                 ),
  //                                 TableCell(
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(10),
  //                                     child: Text(
  //                                       user.blockName,
  //                                       style: AppStyles.blockText(context),
  //                                       overflow: TextOverflow.ellipsis,
  //                                       maxLines: 1,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           if (user.floorNumber != null &&
  //                               user.floorNumber.isNotEmpty)
  //                             TableRow(
  //                               children: <Widget>[
  //                                 TableCell(
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(10),
  //                                     child: Text("Floor Number",
  //                                         style: AppStyles.heading1(context)),
  //                                   ),
  //                                 ),
  //                                 TableCell(
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(10),
  //                                     child: Text(
  //                                       user.floorNumber,
  //                                       style: AppStyles.blockText(context),
  //                                       overflow: TextOverflow.ellipsis,
  //                                       maxLines: 1,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           if (user.flatNumber != null &&
  //                               user.flatNumber.isNotEmpty)
  //                             TableRow(
  //                               children: <Widget>[
  //                                 TableCell(
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.all(10),
  //                                     child: Text("Flat Number",
  //                                         style: AppStyles.heading1(context)),
  //                                   ),
  //                                 ),
  //                                 TableCell(
  //                                   child: Padding(
  //                                       padding: const EdgeInsets.all(10),
  //                                       child: user.flatNumber.isNotEmpty
  //                                           ? Text(
  //                                               user.flatNumber,
  //                                               // DateFormat('y-MM-dd hh:mm:ss a')
  //                                               //     .format(DateTime.parse(
  //                                               //     user.flatNumber)),
  //                                               style: AppStyles.blockText(
  //                                                   context),
  //                                             )
  //                                           : Container()),
  //                                 ),
  //                               ],
  //                             ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }



}
