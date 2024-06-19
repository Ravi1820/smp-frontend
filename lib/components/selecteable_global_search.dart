import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:flutter/material.dart';

class SelecteableGlobalSearchedGridView extends StatefulWidget {
  final Function press;
  final String selectedUser;
  final List users;
  final String baseImageIssueApi;

  SelecteableGlobalSearchedGridView({
    Key? key,
    required this.users,
    required this.selectedUser,
    required this.press,
    required this.baseImageIssueApi,
  }) : super(key: key);

  @override
  _SelecteableGlobalSearchedGridViewState createState() =>
      _SelecteableGlobalSearchedGridViewState();
}

class _SelecteableGlobalSearchedGridViewState
    extends State<SelecteableGlobalSearchedGridView> {
  var selectedCountry;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        final user = widget.users[index];
        final isSelected = selectedCountry == user;

        return GestureDetector(
          onTap: () => {
            widget.press(user),
            setState(() {
              selectedCountry = user;
            })
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: [
                GestureDetector(
                  child: Card(
                    elevation: 8.0,
                    color:
                        isSelected ? Color.fromARGB(255, 201, 200, 200) : null,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 6.0),
                    child: Column(
                      children: [
                        SizedBox(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            leading:
                            Container(
                              height: 50,
                              width: 50,
                              child: const AvatarScreen(),
                            ),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      Utils.addResidentDetails(
                                        user.userInfo.name,
                                        user.flatInfo.flatNumber.toString(),
                                        // user.flatInfo.floorNumber!.toString(),
                                        user.flatInfo.blockName!,
                                      ),
                                      style: AppStyles.heading1(context),
                                    ),
                                    // Expanded(
                                    //   child: Text(
                                    //     user.userInfo.name,
                                    //     style: AppStyles.blockText(context),
                                    //     maxLines: 1,
                                    //     overflow: TextOverflow.ellipsis,
                                    //   ),
                                    // ),
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       "Block : ",
                                //       style: AppStyles.heading1(context),
                                //     ),
                                //     Text(
                                //       user.flatInfo.blockName!,
                                //       style: AppStyles.blockText(context),
                                //       maxLines: 1,
                                //       overflow: TextOverflow.ellipsis,
                                //     ),
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       "Floor : ",
                                //       style: AppStyles.heading1(context),
                                //     ),
                                //     Text(
                                //       user.flatInfo.floorNumber!.toString(),
                                //       style: AppStyles.blockText(context),
                                //       maxLines: 1,
                                //       overflow: TextOverflow.ellipsis,
                                //     ),
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       "Flat : ",
                                //       style: AppStyles.heading1(context),
                                //     ),
                                //     Text(
                                //       user.flatInfo.flatNumber.toString(),
                                //       style: AppStyles.blockText(context),
                                //       maxLines: 1,
                                //       overflow: TextOverflow.ellipsis,
                                //     ),
                                //   ],
                                // ),
                                //
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
