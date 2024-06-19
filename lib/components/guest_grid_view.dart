import 'package:SMP/contants/base_api.dart';
import 'package:SMP/model/notice_board_model.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/resident/curve_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuestGridViewCard extends StatefulWidget {
  final Function press;
  final List users;

  const GuestGridViewCard(
      {super.key, required this.users, required this.press});

  @override
  State<GuestGridViewCard> createState() => _GuestGridViewCardState();
}

class _GuestGridViewCardState extends State<GuestGridViewCard> {
  // widget.baseImageIssueApi
  String baseImageIssueApi = '';
  @override
  void initState() {
    super.initState(); // Widget imageContent = GestureDetector(

    getImage();

    // setState(() {
    //   // baseImageIssueApi = widget.baseImageIssueApi;
    // });
    // );
  }

  getImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('apartmentId');
    String? baseImageApis = BaseApiImage.baseImageUrl(id!, "visitor");
    setState(() {
      baseImageIssueApi = baseImageApis;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle headerLeftTitle = TextStyle(
        fontFamily: 'Roboto',
        fontSize: MediaQuery.of(context).size.width * 0.04,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        color: const Color(0xff1B5694));

    TextStyle headerPlaceHolder = TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.05,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      color: const Color(0xff1B5694),
    );

    return ListView.builder(
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        final user = widget.users[index];
        return GestureDetector(
          onTap: () => _showDetailsDialog(
              context, user, widget.press, headerLeftTitle, headerPlaceHolder),
          // onTap: () => {press(user)},
          // // onTap: () => {press(user)},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 120),
                      decoration: AppStyles.decoration(context),
                      padding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Stack(
                                  children: <Widget>[
                                    if (user.image != null &&
                                        user.image!.isNotEmpty)
                                      Image.network(
                                        '$baseImageIssueApi${user.image.toString()}',
                                        fit: BoxFit.cover,
                                        height: 100,
                                        width: 100,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          // Handle image loading errors here
                                          return Image.asset(
                                            "assets/images/no-img.png",
                                            fit: BoxFit.cover,
                                            height: 100,
                                            width: 100,
                                          );
                                        },
                                      )
                                    else
                                      Image.asset(
                                        "assets/images/no-img.png",
                                        fit: BoxFit.fill,
                                        height: 200,
                                        width: 100,
                                      ),
                                  ],
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
                                  user.visitorName,
                                  style: headerPlaceHolder,
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      user.guestMobile,
                                      style: headerLeftTitle,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: Color(0xff1B5694),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.symmetric(
                                    //       horizontal: 10),
                                    //   child: CustomButton(
                                    //     label: 'View Profile',
                                    //     onPressed: () {},
                                    //   ),
                                    // ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  user.purpose,
                                  style: headerLeftTitle,
                                ),
                                const SizedBox(height: 5),
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

  void _showDetailsDialog(
      BuildContext context, user, press, headerLeftTitle, headerPlaceHolder) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: SizedBox(
            height: 500,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildTableRow("Guest Name", user.visitorName,
                      headerLeftTitle, headerPlaceHolder),
                  _buildTableRow("Block", user.residentUser.blockNumber,
                      headerLeftTitle, headerPlaceHolder),
                  // _buildTableRow("Floor ", user.residentUser.floorNumber,
                  //     headerLeftTitle, headerPlaceHolder),
                  _buildTableRow("Flat", user.residentUser.flatNumber,
                      headerLeftTitle, headerPlaceHolder),
                  //   _buildTableRow("Owner ID", user.ownerIdToMeet.toString(),
                  //       headerLeftTitle, headerPlaceHolder),
                  _buildTableRow("Guest Gender", user.gender, headerLeftTitle,
                      headerPlaceHolder),
                  _buildTableRow("Purpose", user.purpose, headerLeftTitle,
                      headerPlaceHolder),
                  _buildTableRow("Mobile", user.guestMobile, headerLeftTitle,
                      headerPlaceHolder),
                  _buildTableRow("Identiy Type", user.proofType,
                      headerLeftTitle, headerPlaceHolder),
                  _buildTableRow("Identiy Number", user.proofDetails,
                      headerLeftTitle, headerPlaceHolder),
                  _buildTableRow("From Address", user.fromAddress,
                      headerLeftTitle, headerPlaceHolder),
                  _buildTableRow("Statue", user.status, headerLeftTitle,
                      headerPlaceHolder),
                  _buildTableRow("In Time", user.checkedIn, headerLeftTitle,
                      headerPlaceHolder),
                  _buildTableRow("Out Time", user.checkedOut, headerLeftTitle,
                      headerPlaceHolder),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            SizedBox(
              height: 30,
              child: ElevatedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(
                        color: Color.fromARGB(255, 0, 123, 255), width: 2),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Close"),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTableRow(String leftText, String rightText,
      TextStyle headerLeftTitle, TextStyle headerPlaceHolder) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(leftText, style: headerLeftTitle),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(rightText, style: headerPlaceHolder),
          ),
        ),
      ],
    );
  }
}
