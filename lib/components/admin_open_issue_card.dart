import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:flutter/material.dart';

class AdminOpenIssiesGridViewCard extends StatefulWidget {
  final Function press;

  final List users;
  final String baseImageIssueApi;
  final List selectedIssues;
  final Function(List) onSelectedMembersChanged;

  const AdminOpenIssiesGridViewCard({
    super.key,
    required this.users,
    required this.press,
    required this.baseImageIssueApi,
    required this.selectedIssues,
    required this.onSelectedMembersChanged,
  });

  @override
  State<AdminOpenIssiesGridViewCard> createState() =>
      _AdminOpenIssiesGridViewCardState();
}

class _AdminOpenIssiesGridViewCardState
    extends State<AdminOpenIssiesGridViewCard> {
  bool showSecurtiy = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: widget.users.length,
        itemBuilder: (context, index) {
          final user = widget.users[index];
          var issueCatagory = user.issueCatagory.catagoryName
              .replaceAll("ISSUE_CATAGORY_", "")
              .toUpperCase();

          var issuePriority = user.issuePriority.priorityName
              .replaceAll("ISSUE_PRIORITY_", "")
              .toUpperCase();
          final isSelected = widget.selectedIssues.contains(user);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onLongPress: () {
                        setState(() {
                          widget.selectedIssues.add(user);
                          widget
                              .onSelectedMembersChanged(widget.selectedIssues);
                        });
                      },
                      onTap: () {
                        if (widget.selectedIssues.isNotEmpty) {
                          setState(() {
                            if (widget.selectedIssues.contains(user)) {
                              widget.selectedIssues.remove(user);
                            } else {
                              widget.selectedIssues.add(user);
                            }
                            widget.onSelectedMembersChanged(
                                widget.selectedIssues);
                          });
                        } else {
                          widget.press(user);
                        }
                      },
                      child: Container(
                        decoration:
                            AppStyles.selectedDecoration(context, isSelected),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 6.0),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: FontSizeUtil.SIZE_08,
                                    top: FontSizeUtil.SIZE_05),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        if (user.issuePriority.priorityName ==
                                            Strings.ISSUE_PRIORITY_HIGH)
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: FontSizeUtil.SIZE_05,
                                                top: FontSizeUtil.SIZE_05),
                                            child: const Icon(
                                              Icons.circle,
                                              color: Colors.red,
                                            ),
                                          )
                                        else if (user
                                                .issuePriority.priorityName ==
                                            Strings.ISSUE_PRIORITY_MEDIUM)
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: FontSizeUtil.SIZE_05),
                                            child: const Icon(
                                              Icons.circle,
                                              color: Colors.orange,
                                            ),
                                          )
                                        else if (user
                                                .issuePriority.priorityName ==
                                            Strings.ISSUE_PRIORITY_LOW)
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: FontSizeUtil.SIZE_05),
                                            child: const Icon(Icons.circle,
                                                color: Colors.yellow),
                                          ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          issuePriority
                                                  .substring(0, 1)
                                                  .toUpperCase() +
                                              issuePriority
                                                  .substring(1)
                                                  .toLowerCase(),
                                          style: AppStyles.heading1(context),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: FontSizeUtil.SIZE_10,
                                    vertical: FontSizeUtil.SIZE_10),
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          Strings.ISSUE_ID,
                                          style: AppStyles.heading1(context),
                                        ),
                                        Expanded(
                                          child: Text(
                                            user.issueUniqueId,
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
                                          Strings.ISSUE_DESCRIPTION,
                                          style: AppStyles.heading1(context),
                                        ),
                                        Expanded(
                                          child: Text(
                                            user.description,
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
                                          Strings.ISSUE_CATAGORY,
                                          style: AppStyles.heading1(context),
                                        ),
                                        Text(
                                          issueCatagory
                                                  .substring(0, 1)
                                                  .toUpperCase() +
                                              issueCatagory
                                                  .substring(1)
                                                  .toLowerCase(),
                                          style: AppStyles.blockText(context),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          Strings.ISSUE_REPORTED_BY,
                                          style: AppStyles.heading1(context),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    FontSizeUtil.SIZE_08),
                                            child: Text(
                                              '${user.user.fullName}',
                                              style:
                                                  AppStyles.blockText(context),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
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
            ],
          );
        },
      ),
    );
  }
}
