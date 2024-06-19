import 'package:flutter/material.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/utils.dart';

class TenantDashboard extends StatelessWidget {
  const TenantDashboard({
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
                  Icons.notifications_rounded,
                  Strings.MY_VISITORS,
                  handleDrawerItemTap1,
                ),
              ),
              Expanded(
                child: Utils.dashboardExpandedContainer(
                  context,
                  Icons.person_4,
                  Strings.VIEW_RESIDENT,
                  handleDrawerItemTap1,
                ),
              ),
              Expanded(
                child: Utils.dashboardExpandedContainer(
                  context,
                  Icons.manage_history,
                  Strings.MANAGE_ISSUES,
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
                  Icons.poll,
                  Strings.VIEW_POLLS,
                  handleDrawerItemTap1,
                ),
              ),
              Expanded(child: Container()),
              Expanded(child: Container()),
            ],
          ),
        ),
      ],
    );
  }
}
