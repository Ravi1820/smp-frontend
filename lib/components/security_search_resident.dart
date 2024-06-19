import 'package:SMP/contants/base_api.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecuritySearchView extends StatefulWidget {
  final Function press;
  final List users;
  final String baseImageIssueApi;

  const SecuritySearchView({
    Key? key,
    required this.users,
    required this.press,
    required this.baseImageIssueApi,
  }) : super(key: key);

  @override
  _SecuritySearchViewViewState createState() => _SecuritySearchViewViewState();
}

class _SecuritySearchViewViewState extends State<SecuritySearchView> {
  List selectedCountry = [];

  String baseImageIssueApi = '';

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('apartmentId');

    setState(() {
      baseImageIssueApi = BaseApiImage.baseImageUrl(id!, "profile");
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        final user = widget.users[index];
        final isSelected = selectedCountry == user;

       // String appartmentDetails =
       //      (user.flatNummber!.isNotEmpty ?user.flatNummber + ", " : "") + blockName!;

        return GestureDetector(
          onTap: () => {
            // widget.press(user),
            // setState(() {
            //   selectedCountry = user;
            // })
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                              // leading:
                              leading: SizedBox(
                                height: 50,
                                width: 50,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Stack(
                                    children: <Widget>[
                                      if (user.userInfo.picture != null &&
                                          user.userInfo.picture!.isNotEmpty)
                                        Image.network(
                                          '$baseImageIssueApi${user.userInfo.picture.toString()}',
                                          fit: BoxFit.cover,
                                          height: 100,
                                          width: 100,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const AvatarScreen();
                                          },
                                        )
                                      else
                                        const AvatarScreen()
                                    ],
                                  ),
                                ),
                              ),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // Text(
                                      //   "Name : ",
                                      //   style: AppStyles.heading1(context),
                                      // ),
                                      Expanded(
                                        child: Text(


                                          Utils.addResidentDetails(
                                              user.userInfo.name,
                                            user.flatInfo.flatNumber.toString(),
                                            user.flatInfo.blockName!,),

                                          style: AppStyles.blockText(context),
                                          maxLines: 5,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Row(
                                  //   children: [
                                  //     Text(
                                  //       "Block : ",
                                  //       style: AppStyles.heading1(context),
                                  //     ),
                                  //     Expanded(
                                  //       child: Text(
                                  //         user.flatInfo.blockName!,
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
                                  //
                                ],
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  Utils.makingPhoneCall(user.userInfo.phone);
                                },
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width / 12.0,
                                  width:
                                      MediaQuery.of(context).size.width / 12.0,
                                  child: Container(
                                    decoration: AppStyles.circleGreen(context),
                                    child: const Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: Icon(
                                        Icons.call,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
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
