import 'package:SMP/contants/base_api.dart';
import 'package:SMP/model/resident_model.dart';
import 'package:SMP/model/security_search_resident_model.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/owner_list/block_selection.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResidentListViewCard extends StatefulWidget {
  final Function press;
  final List users;
  final int blockCount;
  final String baseImageIssueApi;
  final List selectedCountries;
  final Function(List) onSelectedMembersChanged;

  const ResidentListViewCard({
    Key? key,
    required this.users,
    required this.press,
    required this.baseImageIssueApi,
    required this.selectedCountries,
    required this.blockCount,
    required this.onSelectedMembersChanged,
  }) : super(key: key);

  @override
  _ResidentListViewCardState createState() => _ResidentListViewCardState();
}

class _ResidentListViewCardState extends State<ResidentListViewCard> {
  bool showSecurtiy = true;

  String baseImageIssueApi = '';

  String userType = '';

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('apartmentId');
    // final userTyp = prefs.getString('userType');
    final roles = prefs.getString('roles');

    // Utils.printLog(roles!);

    setState(() {
      userType = roles!;

      baseImageIssueApi = BaseApiImage.baseImageUrl(id!, "profile");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (userType == "ROLE_ADMIN")
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(createRoute(const BlockSelectionScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [
                  GestureDetector(
                    child: Card(
                      elevation: 8.0,
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 6.0),
                      child: Column(
                        children: [
                          SizedBox(
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              leading: Container(
                                decoration: AppStyles.circle(context),
                                height: 50,
                                width: 50,
                                child: const Icon(
                                  Icons.group,
                                  color: Colors.white,
                                ),
                              ),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Broadcast to apartment",
                                        style: AppStyles.heading(context),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward,
                                color: Color(0xff1B5694),
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
        if (userType == "ROLE_ADMIN")
          const SizedBox(
            height: 10,
          ),
        if (widget.blockCount < 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Broadcast to resident",
                style: AppStyles.heading1(context),
              ),
            ],
          ),
        if (userType == "ROLE_ADMIN")
          const Divider(
            height: 0.2,
            color: Color.fromARGB(255, 89, 0, 255),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.users.length,
            itemBuilder: (context, index) {
              final user = widget.users[index];
              final isSelected = widget.selectedCountries.contains(user);

              return GestureDetector(
                onLongPress: () {
                  setState(() {
                    widget.selectedCountries.add(user);
                    widget.onSelectedMembersChanged(widget.selectedCountries);
                  });
                },
                onTap: () {
                  if (widget.selectedCountries.isNotEmpty) {
                    setState(() {
                      if (widget.selectedCountries.contains(user)) {
                        widget.selectedCountries.remove(user);
                      } else {
                        widget.selectedCountries.add(user);
                      }
                      widget.onSelectedMembersChanged(widget.selectedCountries);
                    });
                  } else {
                    widget.press(user);
                    // _showDetailsDialog(
                    //   context,
                    //   user,
                    //   widget.press,
                    //   widget.baseImageIssueApi,
                    // );
                  }
                },

                // onLongPress: () {
                //   setState(() {
                //     if (isSelected) {
                //       widget.selectedCountries.remove(user);
                //     } else {
                //       showSecurtiy = false;
                //       widget.selectedCountries.add(user);
                //     }
                //   });
                // },
                // onTap: () {
                //   widget.press(user);
                // },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Column(
                    children: [
                      GestureDetector(
                        child: Card(
                          elevation: 8.0,
                          color: isSelected
                              ? const Color.fromARGB(255, 201, 200, 200)
                              : null,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 6.0),
                          child: Column(
                            children: [
                              SizedBox(
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 10.0),
                                  leading: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Stack(
                                        children: <Widget>[
                                          if (user.picture != null &&
                                              user.picture!.isNotEmpty)
                                            Image.network(
                                              '$baseImageIssueApi${user.picture.toString()}',
                                              fit: BoxFit.cover,
                                              height: 100,
                                              width: 100,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Name : ",
                                            style: AppStyles.heading1(context),
                                          ),
                                          Expanded(
                                            child: Text(
                                              user.fullName ?? "",
                                              style:
                                                  AppStyles.blockText(context),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Block : ",
                                            style: AppStyles.heading1(context),
                                          ),
                                          Expanded(
                                            child: Text(
                                              user.blockName ?? "",
                                              style:
                                                  AppStyles.blockText(context),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Floor ",
                                            style: AppStyles.heading1(context),
                                          ),
                                          Text(
                                            user.floorNumber ?? "",
                                            style: AppStyles.blockText(context),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Flat ",
                                            style: AppStyles.heading1(context),
                                          ),
                                          Text(
                                            user.flatNummber ?? "",
                                            style: AppStyles.blockText(context),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xff1B5694),
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
          ),
        ),
      ],
    );
  }
}
