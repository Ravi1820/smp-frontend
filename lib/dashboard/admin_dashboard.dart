import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:flutter/material.dart';
import '../utils/Utils.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({
    super.key,
    required this.handleDrawerItemTap1,
    required this.issueCount,
  });
  final int issueCount;
  final Function(String) handleDrawerItemTap1;

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(builder: (context, constraints) {
      double gridIconSize = constraints.maxWidth * 0.06;
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Utils.dashboardExpandedContainer(
                    context,
                    Icons.security,
                    Strings.MANAGE_STAFF,
                    handleDrawerItemTap1,
                  ),
                ),
                Expanded(
                  child: Utils.dashboardExpandedContainer(
                    context,
                    Icons.person,
                    Strings.MANAGE_RESIDENT,
                    handleDrawerItemTap1,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      handleDrawerItemTap1(Strings.MANAGE_COMPLAINTS);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(FontSizeUtil.SIZE_03),
                      child: Stack(
                        children: [
                          Container(
                            decoration: AppStyles.decoration(context),
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.pending_actions,
                                      size: gridIconSize,
                                      color: const Color(0xff1B5694),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.all(FontSizeUtil.SIZE_02),
                                      child: Text(
                                        Strings.MANAGE_COMPLAINTS,
                                        style: AppStyles.dashboardFont(context),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (issueCount != 0)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(FontSizeUtil.SIZE_04),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  issueCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
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
                    Strings.MANAGE_POLLS,
                    handleDrawerItemTap1,
                  ),
                ),
                Expanded(
                  child: Utils.dashboardExpandedContainer(
                    context,
                    Icons.inventory_outlined,
                    Strings.MANAGE_INVENTORARY,
                    handleDrawerItemTap1,
                  ),
                ),
                Expanded(
                  child: Utils.dashboardExpandedContainer(
                    context,
                    Icons.group,
                    Strings.ASSOCIATION_ADMINISTRATION,
                    handleDrawerItemTap1,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
