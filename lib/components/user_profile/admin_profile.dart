import 'package:SMP/theme/common_style.dart';
import 'package:SMP/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';

class AdminProfile extends StatelessWidget {
  final List users;

  const AdminProfile({super.key, required this.users});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return 
        Card(
          margin: const EdgeInsets.all(5),
          color: const Color.fromARGB(255, 240, 245, 240),
          shadowColor: Colors.blueGrey,
          elevation: 10,
          child: Table(
            children: <TableRow>[
              TableRow(
                children: <Widget>[
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text("Email", style: AppStyles.heading1(context)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        user.emailId,
                        style: AppStyles.heading(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: <Widget>[
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Address",
                        style: AppStyles.heading1(context),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        user.address ?? "",
                        style: AppStyles.heading(context),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: <Widget>[
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Age",
                        style: AppStyles.heading1(context),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        user.age ?? "",
                        style: AppStyles.heading(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: <Widget>[
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Gender",
                        style: AppStyles.heading1(context),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        user.gender ?? "",
                        style: AppStyles.heading(context),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: <Widget>[
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Mobile",
                        style: AppStyles.heading1(context),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        user.mobile ?? "",
                        style: AppStyles.heading(context),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: <Widget>[
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Block",
                        style: AppStyles.heading1(context),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        user.blockNumber ?? "",
                        style: AppStyles.heading(context),
                      ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: <Widget>[
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Flat",
                        style: AppStyles.heading1(context),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        user.flatNumber ?? "",
                        style: AppStyles.heading(context),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
