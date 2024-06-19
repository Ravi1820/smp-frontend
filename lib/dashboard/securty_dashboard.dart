import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/utils.dart';
import 'package:flutter/material.dart';

class SecurityDashboard extends StatelessWidget {
  const SecurityDashboard({
    super.key,
    required this.handleDrawerItemTap1,
  });
  final Function(String) handleDrawerItemTap1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Utils.dashboardExpandedContainer(
                  context,
                  Icons.person_add_alt,
                  Strings.ADD_VISITOR,
                  handleDrawerItemTap1,
                ),
              ),
              Expanded(
                child: Utils.dashboardExpandedContainer(
                  context,
                  Icons.list_alt,
                  Strings.PENDING_APPROVAL_LIST,
                  handleDrawerItemTap1,
                ),
              ),
              Expanded(
                child: Utils.dashboardExpandedContainer(
                  context,
                  Icons.call,
                  Strings.CONTACT_OWNERS,
                  handleDrawerItemTap1,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Utils.dashboardExpandedContainer(
                  context,
                  Icons.pending_actions,
                  Strings.PRE_APPROVAL_ENTRIES,
                  handleDrawerItemTap1,
                ),
              ),
              Expanded(
                child: Utils.dashboardExpandedContainer(
                  context,
                  Icons.vertical_split_outlined,
                  Strings.VISITORS_LIST_LABEL,
                  handleDrawerItemTap1,
                ),
              ),
              Expanded(
                child: Utils.dashboardExpandedContainer(
                  context,
                  Icons.car_repair,
                  Strings.VEHICLE_MANAGEMENT,
                  handleDrawerItemTap1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
