import 'package:SMP/contants/base_api.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../user_by_roles/admin/owner_list/messages.dart';
import '../utils/Utils.dart';

class GlobalSeaechedGridView extends StatefulWidget {
  final Function press;
  final List users;
  final String baseImageIssueApi;

  const GlobalSeaechedGridView({
    Key? key,
    required this.users,
    required this.press,
    required this.baseImageIssueApi,
  }) : super(key: key);

  @override
  _GlobalSeaechedGridViewState createState() => _GlobalSeaechedGridViewState();
}

class _GlobalSeaechedGridViewState extends State<GlobalSeaechedGridView> {
  List selectedCountry = [];
  String userType = '';
  int residentId = 0;
  String baseImageIssueApi = '';

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  Future<void> _getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final roles = prefs.getString('roles');
    final id = prefs.getInt('id');
    final apartId = prefs.getInt('apartmentId');
    setState(() {
      userType = roles!;
      residentId = id!;
      baseImageIssueApi = BaseApiImage.baseImageUrl(apartId!, "profile");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        final user = widget.users[index];
        final isSelected = selectedCountry == user;

        return GestureDetector(
          onTap: () => {
            setState(() {
              selectedCountry = user;
            })
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: FontSizeUtil.CONTAINER_SIZE_10,
                horizontal: FontSizeUtil.CONTAINER_SIZE_10),
            child: Column(
              children: [
                GestureDetector(
                  child: Card(
                    elevation: 8.0,
                    color: isSelected
                        ? const Color.fromARGB(255, 201, 200, 200)
                        : null,
                    margin: EdgeInsets.symmetric(
                        horizontal: FontSizeUtil.SIZE_05,
                        vertical: FontSizeUtil.SIZE_06),
                    child: Column(
                      children: [
                        SizedBox(
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: FontSizeUtil.CONTAINER_SIZE_10),
                            leading: SizedBox(
                              height: FontSizeUtil.CONTAINER_SIZE_50,
                              width: FontSizeUtil.CONTAINER_SIZE_50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    FontSizeUtil.CONTAINER_SIZE_50),
                                child: Stack(
                                  children: <Widget>[
                                    if (user.userInfo.picture != null &&
                                        user.userInfo.picture != null &&
                                        user.userInfo.picture.isNotEmpty)
                                      Image.network(
                                        '$baseImageIssueApi${user.userInfo.picture.toString()}',
                                        fit: BoxFit.cover,
                                        height: FontSizeUtil.CONTAINER_SIZE_100,
                                        width: FontSizeUtil.CONTAINER_SIZE_100,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                FontSizeUtil.CONTAINER_SIZE_50),
                                            child: const AvatarScreen(),
                                          );
                                        },
                                      )
                                    else
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            FontSizeUtil.CONTAINER_SIZE_50),
                                        child: const AvatarScreen(),
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
                                    Text(
                                      Strings.GLOBAL_SEARCH_NAME_LABEL,
                                      style: AppStyles.heading1(context),
                                    ),
                                    Expanded(
                                      child: Text(
                                        user.userInfo.name,
                                        style: AppStyles.blockText(context),
                                        maxLines: FontSizeUtil.MAX_LINE_1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      Strings.GLOBAL_SEARCH_BLOCK_LABEL,
                                      style: AppStyles.heading1(context),
                                    ),
                                    Text(
                                      user.flatInfo.blockName!,
                                      style: AppStyles.blockText(context),
                                      maxLines: FontSizeUtil.MAX_LINE_1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      Strings.GLOBAL_SEARCH_FLOOR_LABEL,
                                      style: AppStyles.heading1(context),
                                    ),
                                    Text(
                                      user.flatInfo.floorNumber!.toString(),
                                      style: AppStyles.blockText(context),
                                      maxLines: FontSizeUtil.MAX_LINE_1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      Strings.GLOBAL_SEARCH_FLAT_LABEL,
                                      style: AppStyles.heading1(context),
                                    ),
                                    Text(
                                      user.flatInfo.flatNumber.toString(),
                                      style: AppStyles.blockText(context),
                                      maxLines: FontSizeUtil.MAX_LINE_1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: residentId != user.userInfo.userId
                                ? GestureDetector(
                                    onTap: () => {
                                      Utils.navigateToPushScreen(
                                        context,
                                        Message(
                                            residentId: user.userInfo.userId,
                                            residentDeviseToken: user
                                                .userInfo.pushnotificationToken,
                                            residetName: user.userInfo.name),
                                      ),
                                    },
                                    child: Icon(
                                      Icons.message,
                                      size: FontSizeUtil.CONTAINER_SIZE_30,
                                      color: const Color(0xff1B5694),
                                    ),
                                  )
                                : Container(),
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
}
