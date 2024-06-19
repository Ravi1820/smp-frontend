import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:flutter/material.dart';

class PendingApprovalVisitorsListViewCard extends StatefulWidget {
  final List users;
  final String baseImageIssueApi;

  const PendingApprovalVisitorsListViewCard({
    Key? key,
    required this.users,
    required this.baseImageIssueApi,
  }) : super(key: key);

  @override
  State<PendingApprovalVisitorsListViewCard> createState() {
    return _PendingApprovalVisitorsListViewCardState();
  }
}

class _PendingApprovalVisitorsListViewCardState
    extends State<PendingApprovalVisitorsListViewCard> {
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
          onTap: () => _showDetailsDialog(
            context,
            user,
            baseImageIssueApi,
          ),
          child: Padding(
            padding:  EdgeInsets.symmetric(vertical: FontSizeUtil.CONTAINER_SIZE_10, horizontal: FontSizeUtil.CONTAINER_SIZE_10),
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
                            contentPadding:  EdgeInsets.symmetric(
                              horizontal: FontSizeUtil.CONTAINER_SIZE_10,
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
                                          return Container(
                                            decoration:
                                                AppStyles.profile(context),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_50),
                                              child: Image.asset(
                                                "assets/images/no-img.png",
                                                gaplessPlayback: true,
                                                fit: BoxFit.cover,
                                                width: FontSizeUtil.CONTAINER_SIZE_100,
                                                height: FontSizeUtil.CONTAINER_SIZE_100,
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
                                              BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_50),
                                          child: Image.asset(
                                            "assets/images/no-img.png",
                                            gaplessPlayback: true,
                                            fit: BoxFit.cover,
                                            width: FontSizeUtil.CONTAINER_SIZE_100,
                                            height: FontSizeUtil.CONTAINER_SIZE_100,
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
                                user.waitingMunite != null
                                    ? Row(
                                        children: [

                                          Expanded(
                                            child: Text(
                                              formatTimeDifference(
                                                  user.waitingMunite!),

                                              style:
                                                  AppStyles.blockText(context),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                        if (user.residentName != null) Divider(),
                        SizedBox(
                          child: user.residentName != null
                              ? Padding(
                                  padding:  EdgeInsets.all(FontSizeUtil.SIZE_08),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      GestureDetector(
                                        onTap: () {
                                          Utils.makingPhoneCall(
                                              user.residentMobileNumber);
                                        },
                                        child: SizedBox(
                                          // width: MediaQuery.of(context)
                                          //         .size
                                          //         .width /
                                          //     FontSizeUtil.CONTAINER_SIZE_10,
                                          child: Container(
                                            decoration:
                                                AppStyles.circleGreen(context),
                                            child:  Padding(
                                              padding: EdgeInsets.all(FontSizeUtil.SIZE_03),
                                              child:const Icon(
                                                Icons.call,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
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

  void _showDetailsDialog(BuildContext context, user, baseImageIssueApi) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0), // Adjust padding as needed
          content: SizedBox(
            width: 340,
            height: MediaQuery.of(context).size.height / 1.345,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding:  EdgeInsets.only(left: FontSizeUtil.CONTAINER_SIZE_15),
                          child: Text(Strings.VISTOR_DETAILS_LABEL,
                              style: AppStyles.heading(context)),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child:  Icon(
                        Icons.cancel,
                        size: FontSizeUtil.CONTAINER_SIZE_40,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_50),
                    child: Stack(
                      children: <Widget>[
                        if (user.image != null && user.image!.isNotEmpty)
                          Container(
                            decoration: AppStyles.profile(context),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_50),
                                child: Image.network(
                                  '$baseImageIssueApi${user.image.toString()}',
                                  fit: BoxFit.cover,
                                  height: FontSizeUtil.CONTAINER_SIZE_100,
                                  width: FontSizeUtil.CONTAINER_SIZE_100,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: AppStyles.profile(context),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_50),
                                        child: Image.asset(
                                          "assets/images/no-img.png",
                                          gaplessPlayback: true,
                                          fit: BoxFit.cover,
                                          width: FontSizeUtil.CONTAINER_SIZE_100,
                                          height: FontSizeUtil.CONTAINER_SIZE_100,
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
                              borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_50),
                              child: Image.asset(
                                "assets/images/no-img.png",
                                gaplessPlayback: true,
                                fit: BoxFit.cover,
                                width: FontSizeUtil.CONTAINER_SIZE_100,
                                height: FontSizeUtil.CONTAINER_SIZE_100,
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
                                      padding:  EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                                      child: Text(Strings.VISITOR_NAME_LABEL,
                                          style: AppStyles.heading1(context)),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding:  EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
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
                            if (user.mobileNumber != null &&
                                user.mobileNumber.isNotEmpty)
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    child: Padding(
                                      padding:  EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                                      child: Text(
                                        Strings.MOBILE_LABEL,
                                        style: AppStyles.heading1(context),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
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
                            if (user.idProof != null && user.idProof.isNotEmpty)
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                                      child: Text(Strings.PROOF_TYPE_LABEL,
                                          style: AppStyles.heading1(context)),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                                      child: Text(
                                        user.idProof,
                                        style: AppStyles.blockText(context),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (user.idProofNumber != null &&
                                user.idProofNumber.isNotEmpty)
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                                      child: Text(
                                        Strings.PROOF_DETAILS_LABEL,
                                        style: AppStyles.heading1(context),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                                      child: Text(
                                        user.idProofNumber,
                                        style: AppStyles.blockText(context),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (user.residentName != null &&
                                user.residentName.isNotEmpty)
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                                      child: Text(
                                        Strings.RESIDENT_NAME_LABEL,
                                        style: AppStyles.heading1(context),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding:  EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                                      child: Text(
                                        user.residentName,
                                        style: AppStyles.blockText(context),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (user.blockName != null &&
                                user.blockName.isNotEmpty)
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                                      child: Text(Strings.BLOCK_NUMBER_LABEL,
                                          style: AppStyles.heading1(context)),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                                      child: Text(
                                        user.blockName,
                                        style: AppStyles.blockText(context),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (user.floorNumber != null &&
                                user.floorNumber.isNotEmpty)
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                                      child: Text(Strings.FLOOR_NUMBER_LABEL,
                                          style: AppStyles.heading1(context)),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                                      child: Text(
                                        user.floorNumber,
                                        style: AppStyles.blockText(context),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (user.flatNumber != null &&
                                user.flatNumber.isNotEmpty)
                              TableRow(
                                children: <Widget>[
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                                      child: Text(Strings.FLAT_NUMBER_LABEL,
                                          style: AppStyles.heading1(context)),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                        padding:  EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                                        child: user.flatNumber.isNotEmpty
                                            ? Text(
                                                user.flatNumber,
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
        );
      },
    );
  }
}
