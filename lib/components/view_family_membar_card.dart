import 'package:SMP/theme/common_style.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../contants/base_api.dart';

class FamilyMemberListViewCard extends StatefulWidget {
  final Function press;
  final List users;
  final String baseImageIssueApi;
  final List selectedFamilyMember;
  final Function(List) onSelectedMembersChanged;

  const FamilyMemberListViewCard({
    Key? key,
    required this.users,
    required this.press,
    required this.baseImageIssueApi,
    required this.selectedFamilyMember,
    required this.onSelectedMembersChanged,

  }) : super(key: key);

  @override
  State<FamilyMemberListViewCard> createState() {
    return _FamilyMemberListViewCardState();
  }
}

class _FamilyMemberListViewCardState extends State<FamilyMemberListViewCard> {
  String baseImageIssueApi = '';

  @override
  void initState() {
    super.initState();

    _getUser();
  }


 _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('apartmentId');

    setState(() {
      baseImageIssueApi = BaseApiImage.baseImageUrl(id!, "profile");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        final user = widget.users[index];
        final isSelected = widget.selectedFamilyMember.contains(user);
        return GestureDetector(

          onLongPress: () {
            setState(() {
              widget.selectedFamilyMember.add(user);
              widget.onSelectedMembersChanged(widget.selectedFamilyMember);
            });
          },
          onTap: () {
            if (widget.selectedFamilyMember.isNotEmpty) {
              setState(() {
                if (widget.selectedFamilyMember.contains(user)) {
                  widget.selectedFamilyMember.remove(user);
                } else {
                  widget.selectedFamilyMember.add(user);
                }
                widget.onSelectedMembersChanged(widget.selectedFamilyMember);
              });
            }
            else{
              widget.press(user);
            }
          },

          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Column(
              children: [
                GestureDetector(
                  child: Card(
                    elevation: 8.0,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 6.0),
                    color: isSelected
                        ? const Color.fromARGB(255, 201, 200, 200)
                        : null,
                    child: Column(
                      children: [
                        SizedBox(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            leading:
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: (user.profilePicture != null &&
                                    user.profilePicture!.isNotEmpty) ?
                                Image.network(
                                  '$baseImageIssueApi${user.profilePicture
                                      .toString()}',
                                  fit: BoxFit.cover,
                                  height: 100,
                                  width: 100,
                                  errorBuilder: (context, error,
                                      stackTrace) {
                                    return const AvatarScreen();
                                  },
                                )
                                    :
                                const AvatarScreen(),
                              ),
                            ),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                user.fullName != null
                                    ? Row(
                                  children: [
                                    Text(
                                      "Name : ",
                                      style: AppStyles.heading1(context),
                                    ),
                                    Expanded(
                                      child: Text(
                                        user.fullName,
                                        style:
                                        AppStyles.blockText(context),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )
                                    : Container(),
                                user.relation != null
                                    ? Row(
                                  children: [
                                    Text(
                                      "Relation : ",
                                      style: AppStyles.heading1(context),
                                    ),
                                    Text(
                                      user.relation,
                                      style: AppStyles.blockText(context),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                )
                                    : Container(),
                                user.age != null
                                    ? Row(
                                  children: [
                                    Text(
                                      "Age : ",
                                      style: AppStyles.heading1(context),
                                    ),
                                    Expanded(
                                      child: Text(
                                        user.age,
                                        style:
                                        AppStyles.blockText(context),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )
                                    : Container()
                              ],
                            ),
                trailing: widget.selectedFamilyMember.isEmpty
                    ? const Icon(
                  Icons.arrow_forward,
                  size: 24,
                  color: Color(0xff1B5694),
                )
                    : const SizedBox()),
                            // trailing: GestureDetector(
                            //   onTap: (){
                            //     widget.press(user);
                            //   },
                            //   child: Container(
                            //     decoration: AppStyles.circle(context),
                            //     child: const Padding(
                            //       padding:   EdgeInsets.all(5.0),
                            //       child:   Icon(
                            //         Icons.edit,
                            //         color: Colors.white,
                            //
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          // ),
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