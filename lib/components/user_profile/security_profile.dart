import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:flutter/material.dart';
import '../../utils/Strings.dart';

class SecurityProfile extends StatelessWidget {
  final List users;

  const SecurityProfile({super.key, required this.users});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: EdgeInsets.all(FontSizeUtil.SIZE_05),
          color: const Color.fromARGB(255, 240, 245, 240),
          shadowColor: Colors.blueGrey,
          elevation: FontSizeUtil.CONTAINER_SIZE_10,
          child: Table(
            children: <TableRow>[
              TableRow(
                children: <Widget>[
                  TableCell(
                    child: Padding(
                      padding:  EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                      child: Text(Strings.EMAIL_LABEL_TEXT, style: AppStyles.heading1(context)),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
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
                      padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                      child: Text(
                        Strings.ADDRESS_LABEL_TEXT,
                        style: AppStyles.heading1(context),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
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
                      padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                      child: Text(
                      Strings.AGE_LABEL_TEXT,
                        style: AppStyles.heading1(context),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
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
                      padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                      child: Text(
                        Strings.GENDER_LABEL_TEXT,
                        style: AppStyles.heading1(context),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
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
                      padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                      child: Text(
                        Strings.MOBILE_LABEL_TEXT,
                        style: AppStyles.heading1(context),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
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
                      padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                      child: Text(
                        Strings.SHIFT_START_TIME,
                        style: AppStyles.heading1(context),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                      child: Text(
                        user.shiftStartTime.toString(),
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
                      padding:  EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                      child: Text(
                       Strings.SHIFT_END_TIME,
                        style: AppStyles.heading1(context),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                      child: Text(
                        user.shiftEndTime.toString(),
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
