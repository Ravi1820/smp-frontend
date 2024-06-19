import 'package:SMP/contants/base_api.dart';
import 'package:SMP/model/global_search.dart';
import 'package:SMP/model/resident_model.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/view_model/global_search_view_model.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalSearchResidentGridView extends StatefulWidget {
  final Function press;
  final List users;
  final String baseImageIssueApi;
  final List<ApiResponse> selectedCountries;

  const GlobalSearchResidentGridView({
    Key? key,
    required this.users,
    required this.press,
    required this.baseImageIssueApi,
    required this.selectedCountries,
  }) : super(key: key);

  @override
  _GlobalSearchResidentGridViewState createState() =>
      _GlobalSearchResidentGridViewState();
}

class _GlobalSearchResidentGridViewState
    extends State<GlobalSearchResidentGridView> {
  List selectedCountry = [];
  bool showSecurtiy = true;
  String userType = '';
  int residentId = 0;
  String baseImageIssueApi = '';

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  Future<void> _getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final roles = prefs.getString('roles');
    final id = prefs.getInt('id');
    final apartId = prefs.getInt('apartmentId');
    setState(() {
      userType = roles!;
      residentId = id!;
      baseImageIssueApi = BaseApiImage.baseImageUrl(apartId!, "profile");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        final user = widget.users[index];
        // final isSelected = selectedCountry == user;
        final isSelected = widget.selectedCountries.contains(user);

        return GestureDetector(
          onLongPress: () {
            setState(() {
              if (isSelected) {
                widget.selectedCountries.remove(user);
              } else {
                showSecurtiy = false;
                widget.selectedCountries.add(user);
              }
            });
          },
          // onTap: () => {
          //   // widget.press(user),
          //   setState(() {
          //     selectedCountry = user;
          //   })
          // },
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
                            leading: SizedBox(
                              height: FontSizeUtil.CONTAINER_SIZE_50,
                              width: FontSizeUtil.CONTAINER_SIZE_50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    FontSizeUtil.CONTAINER_SIZE_50),
                                child: Stack(
                                  children: <Widget>[
                                    if (user.userInfo.picture != null &&
                                        user.userInfo.picture != null &&
                                        user.userInfo.picture.isNotEmpty)
                                      Image.network(
                                        '$baseImageIssueApi${user.userInfo.picture.toString()}',
                                        fit: BoxFit.cover,
                                        height: FontSizeUtil.CONTAINER_SIZE_100,
                                        width: FontSizeUtil.CONTAINER_SIZE_100,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                FontSizeUtil.CONTAINER_SIZE_50),
                                            child: const AvatarScreen(),
                                          );
                                        },
                                      )
                                    else
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            FontSizeUtil.CONTAINER_SIZE_50),
                                        child: const AvatarScreen(),
                                      ),
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
                                    Text(
                                      "Name : ",
                                      style: AppStyles.heading1(context),
                                    ),
                                    Expanded(
                                      child: Text(
                                        user.userInfo.name,
                                        style: AppStyles.blockText(context),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Block : ",
                                      style: AppStyles.heading1(context),
                                    ),
                                    Text(
                                      user.flatInfo.blockName!,
                                      style: AppStyles.blockText(context),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Floor : ",
                                      style: AppStyles.heading1(context),
                                    ),
                                    Text(
                                      user.flatInfo.floorNumber!.toString(),
                                      style: AppStyles.blockText(context),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Flat : ",
                                      style: AppStyles.heading1(context),
                                    ),
                                    Text(
                                      user.flatInfo.flatNumber.toString(),
                                      style: AppStyles.blockText(context),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
