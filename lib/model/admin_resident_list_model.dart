import 'package:SMP/contants/base_api.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminResidentListModel extends StatefulWidget {
  final Function press;
  final List users;
  final String baseImageIssueApi;
  final List selectedCountries;

  const AdminResidentListModel({
    Key? key,
    required this.users,
    required this.press,
    required this.baseImageIssueApi,
    required this.selectedCountries,
  }) : super(key: key);

  @override
  _AdminResidentListModelState createState() => _AdminResidentListModelState();
}

class _AdminResidentListModelState extends State<AdminResidentListModel> {
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
      baseImageIssueApi = BaseApiImage.baseImageUrl(id!, "profile");
    });
  }

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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: FontSizeUtil.SIZE_05),
            child: Column(
              children: [
                GestureDetector(
                  child: Card(
                    elevation: FontSizeUtil.SIZE_08,
                    color: isSelected
                        ? const Color.fromARGB(255, 201, 200, 200)
                        : Colors.white,
                    margin: EdgeInsets.symmetric(
                        horizontal: FontSizeUtil.SIZE_05,
                        vertical: FontSizeUtil.SIZE_06),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: FontSizeUtil.SIZE_10,
                          vertical: FontSizeUtil.SIZE_10),
                      leading: SizedBox(
                        height: FontSizeUtil.CONTAINER_SIZE_50,
                        width: FontSizeUtil.CONTAINER_SIZE_50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              FontSizeUtil.CONTAINER_SIZE_50),
                          child: (user.profilePicture != null &&
                                  user.profilePicture!.isNotEmpty)
                              ? Image.network(
                                  '$baseImageIssueApi${user.profilePicture.toString()}',
                                  fit: BoxFit.cover,
                                  height: FontSizeUtil.CONTAINER_SIZE_100,
                                  width: FontSizeUtil.CONTAINER_SIZE_100,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const AvatarScreen();
                                  },
                                )
                              : const AvatarScreen(),
                        ),
                      ),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Utils.addResidentDetails(
                              user.fullName,
                              user.flatNumber,
                              user.blockName!,
                            ),
                            style: AppStyles.blockText(context),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            user.role ?? "",
                            style: AppStyles.heading(context),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          Utils.makingPhoneCall(user.mobileNumber);
                        },
                        child: SizedBox(
                          height: MediaQuery.of(context).size.width / 12.0,
                          width: MediaQuery.of(context).size.width / 12.0,
                          child: Container(
                            decoration: AppStyles.circleGreen(context),
                            child: Padding(
                              padding: EdgeInsets.all(FontSizeUtil.SIZE_03),
                              child: const Icon(
                                Icons.call,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
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
