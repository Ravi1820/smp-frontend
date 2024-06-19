import 'package:SMP/theme/common_style.dart';
import 'package:SMP/view_model/movie_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BlockListViewCard extends StatefulWidget {
  final Function press;
  final List users;
  final String selectedUser;

  const BlockListViewCard({
    super.key,
    required this.users,
    required this.press,
    required this.selectedUser,
  });

  @override
  State<BlockListViewCard> createState() => _BlockListViewCardCardState();
}

class _BlockListViewCardCardState extends State<BlockListViewCard> {
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
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Card(
                      elevation: 8.0,
                      color: isSelected
                          ? Color.fromARGB(255, 201, 200, 200)
                          : null,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 3.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.blockName,
                                    style: AppStyles.heading1(context),
                                  ),
                                  const SizedBox(height: 5),
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
