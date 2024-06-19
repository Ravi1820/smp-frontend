import 'package:SMP/contants/base_api.dart';
import 'package:SMP/model/resident_model.dart';
import 'package:SMP/model/security_search_resident_model.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecuritySearchResidentListViewCard extends StatefulWidget {
  final Function press;
  final List users;
  final String baseImageIssueApi;
  final List selectedCountries;

  const SecuritySearchResidentListViewCard({
    Key? key,
    required this.users,
    required this.press,
    required this.baseImageIssueApi,
    required this.selectedCountries,
  }) : super(key: key);

  @override
  _SecuritySearchResidentListViewCardState createState() =>
      _SecuritySearchResidentListViewCardState();
}

class _SecuritySearchResidentListViewCardState
    extends State<SecuritySearchResidentListViewCard> {
  bool showSecurtiy = true;

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
      baseImageIssueApi =  BaseApiImage.baseImageUrl(id!, "profile");
    });
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.users.length,
            itemBuilder: (context, index) {
              final user = widget.users[index];
              final isSelected = widget.selectedCountries.contains(user);

              return GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
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
                          child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              leading: SizedBox(
                                height: 50,
                                width: 50,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: (user.picture != null &&
                                      user.picture!.isNotEmpty) ?
                                    Image.network(
                                      '$baseImageIssueApi${user.picture.toString()}',
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 100,
                                      errorBuilder: (context, error,
                                          stackTrace) {
                                        return const AvatarScreen();
                                      },
                                    )
                                  :
                                    const AvatarScreen(),
                                ),
                              ),
                              title: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.start,
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(

                                    Utils.addResidentDetails(
                                      user.fullName,
                                      user.flatNummber,
                                      user.blockName!,),

                                    style: AppStyles.blockText(
                                        context),
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    user.roleName ?? "",
                                    style: AppStyles.heading(
                                        context),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                ],
                              ),
                              trailing: GestureDetector(

                                onTap: (){
                                    Utils.makingPhoneCall(
                                        user.mobileNumber);
                                },
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width /
                                          12.0,
                                  width:
                                      MediaQuery.of(context).size.width /
                                          12.0,
                                  child: Container(
                                    decoration:
                                        AppStyles.circleGreen(context),
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
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
