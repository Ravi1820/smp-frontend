import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';

import '../../utils/Strings.dart';
import '../../utils/Utils.dart';

class ResidentProfile extends StatelessWidget {
  final String users;
  final String address;
  final String age;
  final String gender;
  final String mobile;
  final String role;
  final String apartmentDetails;

  const ResidentProfile(
      {super.key,
      required this.users,
      required this.address,
      required this.age,
      required this.gender,
      required this.mobile,
        required this.role,
        required this.apartmentDetails,
      
      });

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.all(5),
      color: const Color.fromARGB(255, 240, 245, 240),
      shadowColor: Colors.blueGrey,
      elevation: 10,
      child: Table(
        columnWidths:const {
          0: FlexColumnWidth(1.5),
          1: FlexColumnWidth(4),

        },
        children: <TableRow>[
          if((address!=null && address.isNotEmpty) || (apartmentDetails!=null && apartmentDetails.isNotEmpty))
            TableRow(
              children: <Widget>[
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                    child: Text(
                     Strings.ADDRESS_LABEL_TEXT,
                      style: AppStyles.label(context),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:  EdgeInsets.only(top: FontSizeUtil.CONTAINER_SIZE_10),
                    child: Text(
                      Utils.addResidentDetails("",apartmentDetails ,address ,),
                      style: AppStyles.value(context),
                    ),
                  ),
                ),
              ],
            ),

          if(users !=null && users.isNotEmpty)
          TableRow(
            children: <Widget>[
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                  child: Text(Strings.EMAIL_LABEL_TEXT, style: AppStyles.label(context)),
                ),
              ),
              TableCell(
                child: Padding(
                  padding:  EdgeInsets.all(FontSizeUtil.SIZE_08),
                  child: Text(
                    users,
                    style: AppStyles.value(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),

          if(age !=null && age.isNotEmpty)
          TableRow(
            children: <Widget>[
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                  child: Text(
                    Strings.AGE_LABEL_TEXT,
                    style: AppStyles.label(context),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                  child: Text(
                    age ?? "",
                    style: AppStyles.value(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          if(gender !=null && gender.isNotEmpty)
          TableRow(
            children: <Widget>[
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                  child: Text(
                   Strings.GENDER_LABEL_TEXT,
                    style: AppStyles.label(context),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                  child: Text(
                    gender ?? "",
                    style: AppStyles.value(context),
                  ),
                ),
              ),
            ],
          ),
          if(mobile !=null && mobile.isNotEmpty)
          TableRow(
            children: <Widget>[
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                  child: Text(
                    Strings.MOBILE_LABEL_TEXT,
                    style: AppStyles.label(context),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                  child: Text(
                    mobile ?? "",
                    style: AppStyles.value(context),
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
    //   },
    // );
  }
}
