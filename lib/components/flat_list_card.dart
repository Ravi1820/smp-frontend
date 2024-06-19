import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:flutter/material.dart';

import '../utils/Strings.dart';

class FlatListViewCard extends StatefulWidget {
  final Function press;
  final List users;
  final String selectedUser;

  const FlatListViewCard({
    super.key,
    required this.users,
    required this.press,
    required this.selectedUser,
  });

  @override
  State<FlatListViewCard> createState() => _FlatListViewCardState();
}

class _FlatListViewCardState extends State<FlatListViewCard> {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding:  EdgeInsets.symmetric(vertical: FontSizeUtil.SIZE_05),
                    child: Card(
                      elevation: FontSizeUtil.SIZE_08,
                      color: isSelected
                          ? const Color.fromARGB(255, 201, 200, 200)
                          : null,
                      margin:  EdgeInsets.symmetric(
                          horizontal: FontSizeUtil.SIZE_05, vertical: FontSizeUtil.SIZE_03),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding:  EdgeInsets.symmetric(
                                horizontal: FontSizeUtil.CONTAINER_SIZE_15,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Flat ${user.flatNumber} ",
                                    style: AppStyles.heading1(context),
                                  ),
                                   SizedBox(height: FontSizeUtil.SIZE_05),
                                  user.vacant == Strings.ACTIVE_TEXT?
                                  Text(
                                   Strings.OCC_TEXT,
                                    style: AppStyles.heading1(context),
                                  ):
                                  Text(
                                    Strings.VAC_TXT,
                                    style: AppStyles.heading1(context),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
