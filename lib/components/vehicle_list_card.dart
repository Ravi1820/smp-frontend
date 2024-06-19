import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../contants/base_api.dart';

class VehicleListViewCard extends StatefulWidget {
  final Function press;
  final List users;
  final String baseImageIssueApi;
  final List selectedFamilyMember;
  final Function(List) onSelectedMembersChanged;

  const VehicleListViewCard({
    Key? key,
    required this.users,
    required this.press,
    required this.baseImageIssueApi,
    required this.selectedFamilyMember,
    required this.onSelectedMembersChanged,
  }) : super(key: key);

  @override
  State<VehicleListViewCard> createState() {
    return _VehicleListViewCardState();
  }
}

class _VehicleListViewCardState extends State<VehicleListViewCard> {
  String baseImageIssueApi = '';

  @override
  void initState() {
    super.initState();

    _getUser();
  }

  _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('apartmentId');

    setState(() {
      baseImageIssueApi = BaseApiImage.baseImageUrl(id!, "profile");
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        final user = widget.users[index];
        final isSelected = widget.selectedFamilyMember.contains(user.id);
        return GestureDetector(
          onLongPress: () {
            setState(() {
              widget.selectedFamilyMember.add(user.id);
              widget.onSelectedMembersChanged(widget.selectedFamilyMember);
            });
          },
          onTap: () {
            if (widget.selectedFamilyMember.isNotEmpty) {
              setState(() {
                if (widget.selectedFamilyMember.contains(user.id)) {
                  widget.selectedFamilyMember.remove(user.id);
                } else {
                  widget.selectedFamilyMember.add(user.id);
                }
                widget.onSelectedMembersChanged(widget.selectedFamilyMember);
              });
            } else {
              widget.press(user);
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: FontSizeUtil.SIZE_05,
                horizontal: FontSizeUtil.SIZE_05),
            child: Column(
              children: [
                GestureDetector(
                  child: Card(
                    elevation: FontSizeUtil.SIZE_08,
                    margin: EdgeInsets.symmetric(
                        horizontal: FontSizeUtil.SIZE_05,
                        vertical: FontSizeUtil.SIZE_06),
                    color: isSelected
                        ? const Color.fromARGB(255, 201, 200, 200)
                        : null,
                    child: Column(
                      children: [
                        SizedBox(
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: FontSizeUtil.SIZE_10,
                                vertical: FontSizeUtil.SIZE_10),
                            leading: SizedBox(
                              height: FontSizeUtil.CONTAINER_SIZE_50,
                              width: FontSizeUtil.CONTAINER_SIZE_50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_50,),
                                child: (user.vehicleImage != null &&
                                        user.vehicleImage!.isNotEmpty)
                                    ? Image.network(
                                        '$baseImageIssueApi${user.vehicleImage.toString()}',
                                        fit: BoxFit.cover,
                                        height:FontSizeUtil.CONTAINER_SIZE_100,
                                        width:FontSizeUtil.CONTAINER_SIZE_100,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(Icons.car_repair);
                                        },
                                      )
                                    : Container(
                                        decoration:
                                            AppStyles.decoration(context),
                                        child: const Icon(Icons.car_repair)),
                              ),
                            ),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                user.vehicleNumber != null
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              user.vehicleNumber,
                                              // Strings.VEHICLE_NUMBER_PLACEHOLDER1,
                                              style:
                                                  AppStyles.blockText(context),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                                user.vehicleType != null
                                    ? Row(
                                        children: [
                                          Text(
                                            user.vehicleType,
                                           // Strings.VEHICLE_TYPE_PLACEHOLDER1,
                                            style: AppStyles.blockText(context),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                user.status != null
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              user.status,
                                             // Strings.VEHICLE_SLOT_PLACEHOLDER1,
                                              style:
                                                  AppStyles.blockText(context),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container()
                              ],
                            ),
                            trailing: widget.selectedFamilyMember.isEmpty
                                ?  Icon(
                                    Icons.arrow_forward,
                                    size: FontSizeUtil.CONTAINER_SIZE_25,
                                    color:const Color(0xff1B5694),
                                  )
                                : const SizedBox(),
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
