import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:flutter/material.dart';

import '../widget/avatar.dart';

class AssociationListViewCard extends StatefulWidget {
  final Function press;
  final List users;
  final String baseImageIssueApi;
  final List selectedMembers;
  final Function(List) onSelectedMembersChanged;

  const AssociationListViewCard({
    Key? key,
    required this.users,
    required this.press,
    required this.selectedMembers,
    required this.onSelectedMembersChanged,
    required this.baseImageIssueApi,
  }) : super(key: key);

  @override
  State<AssociationListViewCard> createState() {
    return _AssociationListViewCardState();
  }
}

class _AssociationListViewCardState extends State<AssociationListViewCard> {
  String baseImageIssueApi = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      baseImageIssueApi = widget.baseImageIssueApi;
    });
    print(baseImageIssueApi);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        final user = widget.users[index];
        final isSelected = widget.selectedMembers.contains(user);

        return GestureDetector(
          onLongPress: () {
            setState(() {
              widget.selectedMembers.add(user);
              widget.onSelectedMembersChanged(widget.selectedMembers);
            });
          },
          onTap: () {
            if (widget.selectedMembers.isNotEmpty) {
              setState(() {
                if (widget.selectedMembers.contains(user)) {
                  widget.selectedMembers.remove(user);
                } else {
                  widget.selectedMembers.add(user);
                }
                widget.onSelectedMembersChanged(widget.selectedMembers);
              });
            } else {}
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: FontSizeUtil.SIZE_05,
                horizontal: FontSizeUtil.SIZE_05),
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
                        SizedBox(
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: FontSizeUtil.SIZE_10,
                                vertical: FontSizeUtil.SIZE_10),
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
                                        '${widget.baseImageIssueApi}${user.image.toString()}',
                                        fit: BoxFit.cover,
                                        height: FontSizeUtil.CONTAINER_SIZE_100,
                                        width: FontSizeUtil.CONTAINER_SIZE_100,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      FontSizeUtil
                                                          .CONTAINER_SIZE_50),
                                              child: const AvatarScreen(),
                                            ),
                                          );
                                        },
                                      )
                                    else
                                      Container(
                                        decoration: AppStyles.profile(context),
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                FontSizeUtil.CONTAINER_SIZE_50),
                                            child: const AvatarScreen()),
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
                                        Utils.addResidentDetails(
                                          user.userName,
                                          user.flatNumber.toString(),
                                          user.blockName!,
                                        ),
                                        style: AppStyles.blockText(context),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                user.position != null
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              user.position,
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
