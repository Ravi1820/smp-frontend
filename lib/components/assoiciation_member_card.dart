import 'package:SMP/theme/common_style.dart';
import 'package:flutter/material.dart';

class AssociationListViewCard extends StatelessWidget {
  final Function press;
  final List users;

  AssociationListViewCard({
    Key? key,
    required this.users,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];

        return GestureDetector(
          onTap: () => {
            press(user),
            // setState(() {
            //   selectedCountry = user;
            // })
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                GestureDetector(
                  child: Card(
                    elevation: 8.0,
                    // color: isSelected
                    //     ? const Color.fromARGB(255, 201, 200, 200)
                    //     : null,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 5.0, vertical: 6.0),
                    child: Column(
                      children: [
                        SizedBox(
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            // leading: Container(
                            //   height: 50,
                            //   width: 50,
                            //   child: const AvatarScreen(),
                            // ),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 30,
                                      child: Text(
                                        user.userName,
                                        style: AppStyles.heading1(context),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "user.fullName",
                                        style: AppStyles.blockText(context),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       "EmailId : ",
                                //       style: AppStyles.heading1(context),
                                //     ),
                                //     Expanded(
                                //       child: Text(
                                //         "user.emailId",
                                //         style: AppStyles.blockText(context),
                                //         maxLines: 1,
                                //         overflow: TextOverflow.ellipsis,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       "Phone ",
                                //       style: AppStyles.heading1(context),
                                //     ),
                                //     Text(
                                //       "user.mobile",
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
                                //       user.flatNumber.toString(),
                                //       style: AppStyles.blockText(context),
                                //       maxLines: 1,
                                //       overflow: TextOverflow.ellipsis,
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward,
                              color: const Color(0xff1B5694),
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
