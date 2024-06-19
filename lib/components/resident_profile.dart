import 'dart:convert';

import 'package:SMP/user_by_roles/resident/curve_button.dart';
import 'package:SMP/view_model/movie_view_model.dart';
import 'package:SMP/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResidentProfileCard extends StatelessWidget {
  final List users;

  const ResidentProfileCard({
    super.key,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle headerPlaceHolder = TextStyle(
        fontFamily: 'Roboto',
        fontSize: MediaQuery.of(context).size.width * 0.04,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        color: const Color(0xff1B5694));

    TextStyle headerLeftTitle = TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.05,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      color: const Color(0xff1B5694),
    );

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 120),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.blueAccent,
                          width: 1.0,
                        ),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF82D9FF),
                            Color.fromARGB(172, 186, 227, 243),
                            Color(0xFF82D9FF),
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Card(
                            elevation: 15,
                            margin: const EdgeInsets.only(left: 10),
                            shadowColor: Colors.amber,
                            child: Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blueAccent,
                                  width: 1.0,
                                ),
                              ),
                            
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.userName!,
                                  style: headerLeftTitle,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  user.emailId,
                                  style: headerPlaceHolder,
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      user.mobile!,
                                      style: headerPlaceHolder,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: GestureDetector(
                                        onTap: () => {},
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              topRight: Radius.circular(20)),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: const Text(
                                              "View Apartment",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
