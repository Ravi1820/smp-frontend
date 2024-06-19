import 'package:SMP/model/security_model.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:flutter/material.dart';

import '../utils/Utils.dart';
import '../utils/colors_utils.dart';

class SecurityListViewCard extends StatefulWidget {
  final Function press;
  final List users;
  final String baseImageIssueApi;
  final List selectedCountries;
  final Function(List) onSelectedMembersChanged;
  bool isselected;

  SecurityListViewCard({
    Key? key,
    required this.users,
    required this.press,
    required this.baseImageIssueApi,
    required this.onSelectedMembersChanged,
    required this.selectedCountries,
    required this.isselected,
  }) : super(key: key);

  @override
  _SecurityListViewCardState createState() => _SecurityListViewCardState();
}

class _SecurityListViewCardState extends State<SecurityListViewCard> {
  bool showSecurtiy = true;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        final user = widget.users[index];

        final isSelected = widget.selectedCountries.contains(user.userId);

        return GestureDetector(
          onLongPress: () {
            setState(() {
              widget.selectedCountries.add(user.userId);
              widget.onSelectedMembersChanged(widget.selectedCountries);
            });
          },
          onTap: () {
            if (widget.selectedCountries.isNotEmpty) {
              setState(() {
                if (widget.selectedCountries.contains(user.userId)) {
                  widget.selectedCountries.remove(user.userId);
                } else {
                  widget.selectedCountries.add(user.userId);
                }
                widget.onSelectedMembersChanged(widget.selectedCountries);
              });
            } else {
              widget.press(user);
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: FontSizeUtil.SIZE_10,
                horizontal: FontSizeUtil.SIZE_10),
            child: Column(
              children: [
                GestureDetector(
                  child: Card(
                    elevation: FontSizeUtil.SIZE_08,
                    color: isSelected
                        ? const Color.fromARGB(255, 201, 200, 200)
                        : null,
                    margin: EdgeInsets.symmetric(
                        horizontal: FontSizeUtil.SIZE_05,
                        vertical: FontSizeUtil.SIZE_06),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: FontSizeUtil.SIZE_05),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(left: FontSizeUtil.SIZE_05),
                                child: Icon(
                                  Icons.circle,
                                  size: FontSizeUtil.CONTAINER_SIZE_20,
                                  color: user.user.onDuty &&
                                          user.user.onDuty != null
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ),
                              SizedBox(
                                width: FontSizeUtil.SIZE_05,
                              ),
                              Text(
                                user.user.onDuty && user.user.onDuty != null
                                    ? Strings.SECURITYONLINE
                                    : Strings.SECURITYOFFLINE,
                                style: user.user.onDuty &&
                                        user.user.onDuty != null
                                    ? AppStyles.securityOnlineText(context)
                                    : AppStyles.securityOffLineText(context),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          child: ListTile(
                            contentPadding: EdgeInsets.only(
                                bottom: FontSizeUtil.SIZE_10,
                                left: FontSizeUtil.SIZE_10,
                                right: FontSizeUtil.SIZE_10),
                            leading: Stack(
                              children: [
                                SizedBox(
                                  height: FontSizeUtil.CONTAINER_SIZE_50,
                                  width: FontSizeUtil.CONTAINER_SIZE_50,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        FontSizeUtil.CONTAINER_SIZE_50),
                                    child: Stack(
                                      children: <Widget>[
                                        if (user.user.profilePicture != null &&
                                            user.user.profilePicture!
                                                .isNotEmpty)
                                          Image.network(
                                            '${widget.baseImageIssueApi}${user.user.profilePicture.toString()}',
                                            fit: BoxFit.cover,
                                            height:
                                                FontSizeUtil.CONTAINER_SIZE_100,
                                            width:
                                                FontSizeUtil.CONTAINER_SIZE_100,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        FontSizeUtil
                                                            .CONTAINER_SIZE_50),
                                                child: const AvatarScreen(),
                                              );
                                            },
                                          )
                                        else
                                          Container(
                                            decoration:
                                                AppStyles.profile(context),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      FontSizeUtil
                                                          .CONTAINER_SIZE_50),
                                              child: const AvatarScreen(),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      Utils.makingPhoneCall(user.user.mobile);
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.all(FontSizeUtil.SIZE_08),
                                      decoration:const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                          SmpAppColors.containerColor),
                                      child: Icon(
                                        Icons.call,
                                        size: FontSizeUtil.CONTAINER_SIZE_10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        user.user.fullName,
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
                                        user.user.emailId,
                                        style: AppStyles.blockText(context),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      user.user.mobile,
                                      style: AppStyles.blockText(context),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: widget.selectedCountries.isEmpty
                                ? const Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xff1B5694),
                                  )
                                : const SizedBox(),
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
