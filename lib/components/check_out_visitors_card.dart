import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class CheckOutVisitorsListViewCard extends StatefulWidget {
  final Function press;
  final List users;
  final String baseImageIssueApi;
  final String userType;

  const CheckOutVisitorsListViewCard({
    Key? key,
    required this.users,
    required this.press,
    required this.baseImageIssueApi,
    required this.userType,
  }) : super(key: key);

  @override
  State<CheckOutVisitorsListViewCard> createState() {
    return _CheckOutVisitorsListViewCardState();
  }
}

class _CheckOutVisitorsListViewCardState
    extends State<CheckOutVisitorsListViewCard> {
  String baseImageIssueApi = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      baseImageIssueApi = widget.baseImageIssueApi;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        final user = widget.users[index];
        return GestureDetector(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: FontSizeUtil.SIZE_10,
                horizontal: FontSizeUtil.SIZE_10),
            child: Column(
              children: [
                GestureDetector(
                  child: Container(
                    decoration: AppStyles.decoration(context),
                    margin: EdgeInsets.symmetric(
                      horizontal: FontSizeUtil.SIZE_05,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: FontSizeUtil.SIZE_10,
                            ),
                            leading: SizedBox(
                              height: FontSizeUtil.CONTAINER_SIZE_50,
                              width: FontSizeUtil.CONTAINER_SIZE_50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_50),
                                child: Stack(
                                  children: <Widget>[
                                    if (user.image != null &&
                                        user.image!.isNotEmpty)
                                      Image.network(
                                        '$baseImageIssueApi${user.image.toString()}',
                                        fit: BoxFit.cover,
                                        height: FontSizeUtil.CONTAINER_SIZE_100,
                                        width: FontSizeUtil.CONTAINER_SIZE_100,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const AvatarScreen();
                                        },
                                      )
                                    else
                                      const AvatarScreen()
                                  ],
                                ),
                              ),
                            ),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                user.name != null
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              user.name,
                                              style:
                                                  AppStyles.blockText(context),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                user.purpose != null
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              user.purpose,
                                              style:
                                                  AppStyles.blockText(context),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                user.mobileNumber != null
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              user.mobileNumber!,
                                              style:
                                                  AppStyles.blockText(context),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                user.checkInTime != null
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Text(
                                                  DateFormat('y-MM-dd hh:mm a')
                                                      .format(DateTime.parse(
                                                          user.checkInTime!)),
                                                  style: AppStyles.blockText(
                                                      context),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(
                                                  width: FontSizeUtil
                                                      .CONTAINER_SIZE_10,
                                                ),
                                                const Icon(
                                                  Icons.arrow_downward_sharp,
                                                  color: Color.fromARGB(
                                                      255, 81, 255, 0),
                                                  size: 25,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                user.checkOutTime.isNotEmpty
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: user.checkOutTime.isNotEmpty
                                                ? Row(
                                                    children: [
                                                      Text(
                                                        DateFormat(
                                                                'y-MM-dd hh:mm a')
                                                            .format(DateTime
                                                                .parse(user
                                                                    .checkOutTime)),
                                                        style:
                                                            AppStyles.blockText(
                                                                context),
                                                      ),
                                                       SizedBox(
                                                        width: FontSizeUtil.SIZE_10,
                                                      ),
                                                      const Icon(
                                                        Icons.arrow_upward,
                                                        color: Color.fromARGB(
                                                            255, 255, 0, 0),
                                                        size: 25,
                                                      ),
                                                    ],
                                                  )
                                                : Text(
                                                    user.checkOutTime,
                                                    style: AppStyles.blockText(
                                                        context),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                          ),
                                        ],
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                        user.residentName != null
                            ? SizedBox(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: FontSizeUtil.SIZE_08,
                                      bottom: FontSizeUtil.SIZE_08),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, // Align children to the start
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.only(),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              Utils.addResidentDetails(
                                                  user.residentName,
                                                  user.flatNumber,
                                                  user.blockName),
                                              style:
                                                  AppStyles.blockText(context),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

        // GestureDetector(
        //   child: Card(
        //     elevation: 8.0,
        //     margin: const EdgeInsets.symmetric(
        //         horizontal: 5.0, vertical: 6.0),
        //     child: Column(
        //       children: [
        //         SizedBox(
        //           child: ListTile(
        //             contentPadding: const EdgeInsets.symmetric(
        //                 horizontal: 10.0, vertical: 10.0),
        //             leading:
        //             SizedBox(
        //               height: 50,
        //               width: 50,
        //               child: ClipRRect(
        //                 borderRadius: BorderRadius.circular(50),
        //                 child: Stack(
        //                   children: <Widget>[
        //                     if (user.image != null &&
        //                         user.image!.isNotEmpty)
        //                       Image.network(
        //                         '$baseImageIssueApi${user.image.toString()}',
        //                         fit: BoxFit.cover,
        //                         height: 100,
        //                         width: 100,
        //                         errorBuilder:
        //                             (context, error, stackTrace) {
        //                           // Handle image loading errors here
        //                           return Container(
        //                             decoration:
        //                                 AppStyles.profile(context),
        //                             child: ClipRRect(
        //                               borderRadius:
        //                                   BorderRadius.circular(50),
        //                               child: Image.asset(
        //                                 "assets/images/no-img.png",
        //                                 gaplessPlayback: true,
        //                                 fit: BoxFit.cover,
        //                                 width: 100,
        //                                 height: 100,
        //                               ),
        //                             ),
        //                           );
        //                         },
        //                       )
        //                     else
        //                       Container(
        //                         decoration: AppStyles.profile(context),
        //                         child: ClipRRect(
        //                           borderRadius:
        //                               BorderRadius.circular(50),
        //                           child: Image.asset(
        //                             "assets/images/no-img.png",
        //                             gaplessPlayback: true,
        //                             fit: BoxFit.cover,
        //                             width: 100,
        //                             height: 100,
        //                           ),
        //                         ),
        //                       ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //             title: Column(
        //               mainAxisAlignment: MainAxisAlignment.start,
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 user.name != null
        //                     ? Row(
        //                         children: [
        //                           Text(
        //                             "Name : ",
        //                             style: AppStyles.heading1(context),
        //                           ),
        //                           Expanded(
        //                             child: Text(
        //                               user.name,
        //                               style:
        //                                   AppStyles.blockText(context),
        //                               maxLines: 1,
        //                               overflow: TextOverflow.ellipsis,
        //                             ),
        //                           ),
        //                         ],
        //                       )
        //                     : Container(),
        //                 user.mobileNumber != null
        //                     ? Row(
        //                         children: [
        //                           Text(
        //                             "Phone : ",
        //                             style: AppStyles.heading1(context),
        //                           ),
        //                           Text(
        //                             user.mobileNumber,
        //                             style: AppStyles.blockText(context),
        //                             maxLines: 1,
        //                             overflow: TextOverflow.ellipsis,
        //                           ),
        //                         ],
        //                       )
        //                     : Container(),
        //                 user.purpose != null
        //                     ? Row(
        //                         children: [
        //                           Text(
        //                             "Purpose : ",
        //                             style: AppStyles.heading1(context),
        //                           ),
        //                           Expanded(
        //                             child: Text(
        //                               user.purpose,
        //                               style:
        //                                   AppStyles.blockText(context),
        //                               maxLines: 1,
        //                               overflow: TextOverflow.ellipsis,
        //                             ),
        //                           ),
        //                         ],
        //                       )
        //                     : Container()
        //               ],
        //             ),
        //             trailing: const Icon(
        //               Icons.arrow_forward,
        //               color: Color(0xff1B5694),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

        // ],
        // ),
        // ),
        // );
      },
    );
  }

  void _showDetailsDialog(
      BuildContext context, user, press, baseImageIssueApi) {
    // var staus = user.status.toUpperCase();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            contentPadding: const EdgeInsets.all(0), // Adjust padding as needed
            content: SizedBox(
              width: 340,
              height: MediaQuery.of(context).size.height / 1.745,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text("Visitor Details",
                                style: AppStyles.heading(context)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.cancel,
                          size: 40,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Stack(
                        children: <Widget>[
                          if (user.image != null && user.image!.isNotEmpty)
                            Container(
                              decoration: AppStyles.profile(context),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    '$baseImageIssueApi${user.image.toString()}',
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
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
                                      );
                                    },
                                  )),
                            )
                          else
                            Container(
                              decoration: AppStyles.profile(context),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
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
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Table(
                            children: <TableRow>[
                              if (user.name != null && user.name.isNotEmpty)
                                TableRow(
                                  children: <Widget>[
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text("Visitor Name",
                                            style: AppStyles.heading1(context)),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          user.name,
                                          style: AppStyles.blockText(context),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (user.gender != null && user.gender.isNotEmpty)
                                TableRow(
                                  children: <Widget>[
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text("Gender",
                                            style: AppStyles.heading1(context)),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          user.gender,
                                          style: AppStyles.blockText(context),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (user.mobileNumber != null &&
                                  user.mobileNumber.isNotEmpty)
                                TableRow(
                                  children: <Widget>[
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          "Mobile",
                                          style: AppStyles.heading1(context),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          user.mobileNumber,
                                          style: AppStyles.blockText(context),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (user.checkInTime != null &&
                                  user.checkInTime.isNotEmpty)
                                TableRow(
                                  children: <Widget>[
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text("Check In",
                                            style: AppStyles.heading1(context)),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: user.checkInTime.isNotEmpty
                                              ? Text(
                                                  DateFormat(
                                                          'y-MM-dd hh:mm:ss a')
                                                      .format(DateTime.parse(
                                                          user.checkInTime)),
                                                  style: AppStyles.blockText(
                                                      context),
                                                )
                                              : Container()),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
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
                            horizontal: 15, vertical: 0),
                      ),
                      onPressed: () {
                        Navigator.pop(context);

                        // Navigator.of(context).pushAndRemoveUntil(
                        //   MaterialPageRoute(builder: (context) => screen),
                        //   (Route<dynamic> route) => false,
                        // );
                      },
                      child: const Text("Checkout"),
                    ),
                  ),
                ],
              ),
            ]);
      },
    );
  }
}
