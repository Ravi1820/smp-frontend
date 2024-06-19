import 'package:SMP/model/issue_list_model.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:flutter/material.dart';

class ResidentPendingIssiesGridViewCard extends StatefulWidget {
  final Function press;

  final List users;
  final String baseImageIssueApi;
  final List<IssueListModel> selectedIssues;

  const ResidentPendingIssiesGridViewCard({
    super.key,
    required this.users,
    required this.press,
    required this.baseImageIssueApi,
    required this.selectedIssues,
  });

  @override
  State<ResidentPendingIssiesGridViewCard> createState() =>
      _ResidentPendingIssiesGridViewCardState();
}

class _ResidentPendingIssiesGridViewCardState
    extends State<ResidentPendingIssiesGridViewCard> {
  bool showSecurtiy = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStyles.decoration(context),
      // constraints: const BoxConstraints(maxHeight: 600),
      padding: EdgeInsets.all(8),
      child: ListView.builder(
        primary: false,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
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
                          if (isSelected) {
                            widget.selectedIssues.remove(user);
                          } else {
                            showSecurtiy = false;
                            widget.selectedIssues.add(user);
                          }
                        });
                      },
                      onTap: () => {widget.press(user)},
                      child: Card(
                        elevation: 8.0,
                        color: isSelected
                            ? const Color.fromARGB(255, 201, 200, 200)
                            : null,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 6.0),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  children: [
                                    // colorContent,
                                    if (user.issuePriority.priorityName ==
                                        "ISSUE_PRIORITY_HIGH")
                                      const Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Icon(
                                          Icons.circle,
                                          color: Colors.red,
                                        ),
                                      )
                                    else if (user.issuePriority.priorityName ==
                                        "ISSUE_PRIORITY_MEDIUM")
                                      const Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Icon(
                                          Icons.circle,
                                          color: Colors.orange,
                                        ),
                                      )
                                    else if (user.issuePriority.priorityName ==
                                        "ISSUE_PRIORITY_LOW")
                                      const Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Icon(Icons.circle,
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
                              ),
                            ),
                            SizedBox(
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10.0),
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Issue ID : ",
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
                                          "Description : ",
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
                                          "Category : ",
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
                                          "Reported By : ",
                                          style: AppStyles.heading1(context),
                                        ),
                                        Text(
                                          '${user.user.userName}',
                                          //  , ${double.parse(user.user.blockNumber).toInt()},  ${double.parse(user.user.flatNumber).toInt()}',
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
            ],
          );
        },
      ),
    );
  }
}
