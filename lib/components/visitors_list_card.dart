import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class VisitorsListViewCard extends StatefulWidget {
  final Function press;
  final List users;
  final String baseImageIssueApi;
  final String userType;

  const VisitorsListViewCard({
    Key? key,
    required this.users,
    required this.press,
    required this.baseImageIssueApi,
    required this.userType,
  }) : super(key: key);

  @override
  State<VisitorsListViewCard> createState() {
    return _VisitorsListViewCardState();
  }
}

class _VisitorsListViewCardState extends State<VisitorsListViewCard> {
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
                                borderRadius: BorderRadius.circular(
                                    FontSizeUtil.CONTAINER_SIZE_50),
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
                                      const AvatarScreen(),
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
                                          if (widget.userType ==
                                              Strings.ROLESECURITY1)
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    widget.press(
                                                        user.visitorId,
                                                        user.name,
                                                        user.residentToken);
                                                  },
                                                  child: SvgPicture.asset(
                                                    'assets/images/checkout.svg',
                                                    width: FontSizeUtil
                                                        .CONTAINER_SIZE_40,
                                                    height: FontSizeUtil
                                                        .CONTAINER_SIZE_40,
                                                    color:
                                                        const Color(0xff1B5694),
                                                  ),
                                                ),
                                              ],
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
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(
                                                  Icons.arrow_downward_sharp,
                                                  color: const Color.fromARGB(
                                                      255, 81, 255, 0),
                                                  size: FontSizeUtil
                                                      .CONTAINER_SIZE_25,
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
                                                      Icon(
                                                        Icons.arrow_downward,
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 81, 255, 0),
                                                        size: FontSizeUtil
                                                            .CONTAINER_SIZE_25,
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
                        const Divider(),
                        user.residentName != null
                            ? SizedBox(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: FontSizeUtil.SIZE_08,
                                      bottom: FontSizeUtil.SIZE_08),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 4,
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            Utils.addResidentDetails(
                                                user.residentName,
                                                user.flatNumber,
                                                user.blockName),
                                            style: AppStyles.blockText(context),
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
      },
    );
  }
}
