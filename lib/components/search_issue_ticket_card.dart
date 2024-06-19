import 'package:SMP/model/issue_list_model.dart';
import 'package:SMP/model/resident_issue_model.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:flutter/material.dart';

class TicketListViewCard extends StatefulWidget {
  // final Function onItemSelected;
  final Function(List) onItemSelected; // Callback to notify parent

  final List users;
  final String baseImageIssueApi;
  final List selectedCountries;

  final Function edit;

  const TicketListViewCard(
      {Key? key,
      required this.users,
      required this.onItemSelected,
      required this.baseImageIssueApi,
      required this.selectedCountries,
      required this.edit})
      : super(key: key);

  @override
  _TicketListViewCardState createState() => _TicketListViewCardState();
}

class _TicketListViewCardState extends State<TicketListViewCard> {
  int? selectedIndex;
  bool showClick = false;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        final user = widget.users[index];
        var issueCatagory = user.issueStatus.statusName
            .replaceAll("ISSUE_STATUS_", "")
            .toUpperCase();

        final isSelected = widget.selectedCountries.contains(user);

        return GestureDetector(
          onLongPress: () {
            setState(() {
              widget.selectedCountries.add(user);
              widget.onItemSelected(widget.selectedCountries);
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
                widget.onItemSelected(widget.selectedCountries);
              });
            } else {
              widget.edit(user);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Ticket Name : ",
                                        style: AppStyles.heading1(context),
                                      ),
                                      Expanded(
                                        child: Text(
                                          user.issueUniqueId!,
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
                                        "Issue Description : ",
                                        style: AppStyles.heading1(context),
                                      ),
                                      Expanded(
                                        child: Text(
                                          user.description!,
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
                                        "Status :",
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
                                ],
                              ),
                              trailing: widget.selectedCountries.isEmpty
                                  ? const Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xff1B5694),
                                    )
                                  : const SizedBox()
                              // ),
                              // trailing: const Icon(
                              //   Icons.arrow_forward,
                              //   color: Color(0xff1B5694),
                              // ),
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
