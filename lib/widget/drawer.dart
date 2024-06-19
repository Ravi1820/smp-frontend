import 'package:SMP/user_by_roles/admin/admin_aminity_management/register_aminity.dart';
import 'package:SMP/user_by_roles/admin/my_approval/my_approval_tabs.dart';
import 'package:SMP/user_by_roles/admin/security-lists/security-lists.dart';
import 'package:SMP/user_by_roles/admin/vehicle_management_by_admin/admin_all_vehicle_list.dart';
import 'package:SMP/user_by_roles/admin/verify_password.dart';
import 'package:SMP/contants/base_api.dart';
import 'package:SMP/profile.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/notice_board/notification_list.dart';
import 'package:SMP/user_by_roles/resident/resident_message_list.dart';
import 'package:SMP/user_by_roles/security/approval_list.dart';
import 'package:SMP/user_by_roles/security/global_serach_by_security.dart';
import 'package:SMP/user_by_roles/security/visitors_list.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/colors_utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../presenter/drawer_back_listener.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key, required this.listener}) : super(key: key);

  static const double drawerWidth = 290;
  final DrawerBackListener listener;

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  initState() {
    super.initState();
    _getUserProfile();
  }

  int apartmentId = 0;
  String imageUrl = '';
  String baseImageIssueApi = '';
  String userName = "";
  String userType = "";
  String emailId = '';
  int userId = 0;

  _getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final roles = prefs.getString('roles');
    var apartId = prefs.getInt('apartmentId');
    final userNam = prefs.getString('userName');
    final email = prefs.getString('email');
    var profileImage = prefs.getString("profilePicture");
    final id = prefs.getInt('id');

    setState(() {
      emailId = email!;
      userName = userNam!;
      baseImageIssueApi = BaseApiImage.baseImageUrl(apartId!, "profile");
      userType = roles!;
      apartmentId = apartId;
      userId = id!;
      imageUrl = profileImage!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: DrawerScreen.drawerWidth,
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 3, 3, 3),
          color: const Color.fromARGB(103, 165, 217, 241),
          child: ListView(
            children: userType == Strings.ROLEADMIN_1
                ? _buildAdminDrawerItems(imageUrl, baseImageIssueApi, userName,
                    userType, context, widget.listener)
                    : userType == Strings.ROLEOWNER ||
                            userType == Strings.ROLETENANT
                        ? _buildResidentDrawerItems(imageUrl, baseImageIssueApi,
                            userName, userType, context, widget.listener)
                        : [],
          ),
        ),
      ),
    );
  }
}

List<Widget> _buildResidentDrawerItems(profileImage, baseImageIssueApi,
    userName, type, context, DrawerBackListener listner) {
  Widget imageContent = GestureDetector(
    child: const AvatarScreen(),
  );

  if (profileImage!.isNotEmpty) {
    imageContent = GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_50),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_50),
          child: Stack(
            children: <Widget>[
              if (profileImage != null && profileImage!.isNotEmpty)
                Image.network(
                  '$baseImageIssueApi${profileImage.toString()}',
                  fit: BoxFit.cover,
                  width: FontSizeUtil.CONTAINER_SIZE_100,
                  height: FontSizeUtil.CONTAINER_SIZE_100,
                  errorBuilder: (context, error, stackTrace) {
                    // Handle image loading errors here
                    return const AvatarScreen();
                  },
                )
              else
                const AvatarScreen(),
            ],
          ),
        ),
      ),
    );
  }

  return <Widget>[
    DrawerHeader(
      padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: FontSizeUtil.CONTAINER_SIZE_100,
                width: FontSizeUtil.CONTAINER_SIZE_100,
                alignment: Alignment.center,
                child: imageContent,
              ),
              Expanded(
                child: Text(
                  '$userName',
                  style: AppStyles.heading(context),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    ListTile(
      dense: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.person,
            color: Color(0xff1B5694),
          ),
          SizedBox(
            width: FontSizeUtil.CONTAINER_SIZE_10,
          ),
          Expanded(
              child: Text(Strings.PROFILE_TEXT, style: AppStyles.drawerStyle(context))),
        ],
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(createRoute(const UserProfile()));
      },
    ),
    Divider(
      height: FontSizeUtil.SIZE_001,
      color:const Color.fromARGB(255, 89, 0, 255),
    ),
    ListTile(
      dense: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.message,
            color: Color(0xff1B5694),
          ),
          SizedBox(
            width: FontSizeUtil.CONTAINER_SIZE_10,
          ),
          Expanded(
              child: Text(Strings.MESSAGES, style: AppStyles.drawerStyle(context))),
        ],
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(createRoute(const ResidentMessage()));
      },
    ),
    Divider(
      height: FontSizeUtil.SIZE_001,
      color:const Color.fromARGB(255, 89, 0, 255),
    ),
    ListTile(
      dense: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.password,
            color: Color(0xff1B5694),
          ),
          SizedBox(
            width: FontSizeUtil.CONTAINER_SIZE_10,
          ),
          Expanded(
              child: Text(Strings.CHANGE_PASSWORD,
                  style: AppStyles.drawerStyle(context))),
        ],
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(createRoute(const VerifyPasswordScreen()));
      },
    ),
    Divider(
      height: FontSizeUtil.SIZE_001,
      color: const Color.fromARGB(255, 89, 0, 255),
    ),
    ListTile(
      dense: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.security,
            color: Color(0xff1B5694),
          ),
           SizedBox(
            width: FontSizeUtil.CONTAINER_SIZE_10,
          ),
          Expanded(
              child: Text(Strings.CONTACT_SECURITY,
                  style: AppStyles.drawerStyle(context))),
        ],
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(createRoute(const SecurityLists()));
      },
    ),
    Divider(
      height: FontSizeUtil.SIZE_001,
      color:const Color.fromARGB(255, 89, 0, 255),
    ),
    ListTile(
      dense: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.logout,
            color: Color(0xff1B5694),
          ),
          SizedBox(
            width: FontSizeUtil.CONTAINER_SIZE_10,
          ),
          Expanded(
              child: Text(Strings.LOGOUT_TEXT, style: AppStyles.drawerStyle(context))),
        ],
      ),
      onTap: () async {
        Navigator.pop(context);
        listner.onDrawerClosed(context);
      },
    ),
  ];
}

List<Widget> _buildAdminDrawerItems(
    profileImage, baseImageIssueApi, userName, type, context, listner) {
  Widget imageContent = GestureDetector(
    child: const AvatarScreen(),
  );

  if (profileImage!.isNotEmpty) {
    imageContent = GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_50),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_50),
          child: Stack(
            children: <Widget>[
              if (profileImage != null && profileImage!.isNotEmpty)
                Image.network(
                  '$baseImageIssueApi${profileImage.toString()}',
                  fit: BoxFit.cover,
                  width: FontSizeUtil.CONTAINER_SIZE_100,
                  height: FontSizeUtil.CONTAINER_SIZE_100,
                  errorBuilder: (context, error, stackTrace) {
                    return const AvatarScreen();
                  },
                )
              else
                const AvatarScreen(),
            ],
          ),
        ),
      ),
    );
  }

  return <Widget>[
    DrawerHeader(
      padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: FontSizeUtil.CONTAINER_SIZE_100,
                width: FontSizeUtil.CONTAINER_SIZE_100,
                alignment: Alignment.center,
                child: imageContent,
              ),
              Expanded(
                child: Text(
                  '$userName',
                  style: AppStyles.heading(context),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    ListTile(
      dense: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.upload_file,
            color: Color(0xff1B5694),
          ),
           SizedBox(
            width: FontSizeUtil.CONTAINER_SIZE_10,
          ),
          Expanded(
            child: Text(
              Strings.VISITORS_LIST,
              style: AppStyles.drawerStyle(context),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(
          createRoute(
            VisitorsList(title: Strings.VISITORS_LIST),
          ),
        );
      },
    ),
    Divider(
      height: FontSizeUtil.SIZE_001,
      color:const Color.fromARGB(255, 89, 0, 255),
    ),
    ListTile(
      dense: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.notification_add,
            color: Color(0xff1B5694),
          ),
          SizedBox(
            width: FontSizeUtil.CONTAINER_SIZE_10,
          ),
          Expanded(
              child: Text(Strings.MANAGENOTICE,
                  style: AppStyles.drawerStyle(context))),
        ],
      ),
      onTap: () {
        Navigator.pop(context);

        Navigator.of(context).push(createRoute(const NoticeBoardList()));
      },
    ),
    Divider(
      height: FontSizeUtil.SIZE_001,
      color:const Color.fromARGB(255, 89, 0, 255),
    ),
    ListTile(
      dense: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.message,
            color: Color(0xff1B5694),
          ),
          SizedBox(
            width: FontSizeUtil.CONTAINER_SIZE_10,
          ),
          Expanded(
              child: Text(Strings.MESSAGES,
                  style: AppStyles.drawerStyle(context))),
        ],
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(createRoute(const ResidentMessage()));
      },
    ),
    Divider(
      height: FontSizeUtil.SIZE_001,
      color:const Color.fromARGB(255, 89, 0, 255),
    ),
    ListTile(
      dense: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.approval,
            color: Color(0xff1B5694),
          ),
          SizedBox(
            width: FontSizeUtil.CONTAINER_SIZE_10,
          ),
          Expanded(
              child: Text(Strings.MY_APPROVALS,
                  style: AppStyles.drawerStyle(context))),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(createRoute(const MyApprovalTabsScreen()));
      },
    ),
    Divider(
      height:FontSizeUtil.SIZE_001,
      color:SmpAppColors.dividerColor,
    ),

    ListTile(
      dense: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.car_repair,
            color: SmpAppColors.drawerIconColor,
          ),
          SizedBox(
            width: FontSizeUtil.CONTAINER_SIZE_10,
          ),
          Expanded(
              child: Text(Strings.VEHICLE_MANAGEMENT_LABEL,
                  style: AppStyles.drawerStyle(context),),),
        ],
      ),
      onTap: () {
        Navigator.pop(context);
        Utils.navigateToPushScreen(context, const AdminALlVehicleListScreen());
      },
    ),

    Divider(
      height:FontSizeUtil.SIZE_001,
      color:SmpAppColors.dividerColor,
    ),

    ListTile(
      dense: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.admin_panel_settings,
            color: SmpAppColors.drawerIconColor,
          ),
          SizedBox(
            width: FontSizeUtil.CONTAINER_SIZE_10,
          ),
          Expanded(
            child: Text(Strings.AMINITY_MANAGEMENT_LABEL,
              style: AppStyles.drawerStyle(context),),),
        ],
      ),
      onTap: () {
        Navigator.pop(context);
        Utils.navigateToPushScreen(context,  RegisterAminity());
      },
    ),
    Divider(
      height: FontSizeUtil.SIZE_001,
      color:SmpAppColors.dividerColor,
    ),
    ListTile(
      dense: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.password,
            color: Color(0xff1B5694),
          ),
          SizedBox(
            width: FontSizeUtil.CONTAINER_SIZE_10,
          ),
          Expanded(
              child: Text(Strings.CHANGE_PASSWORD,
                  style: AppStyles.drawerStyle(context))),
        ],
      ),
      onTap: () {
        Utils.backPressed(context);
        Utils.navigateToPushScreen(context,const VerifyPasswordScreen());
      },
    ),

    Divider(
      height: FontSizeUtil.SIZE_001,
      color:SmpAppColors.dividerColor,
    ),
    ListTile(
      dense: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(
            Icons.logout,
            color: Color(0xff1B5694),
          ),
          SizedBox(
            width: FontSizeUtil.CONTAINER_SIZE_10,
          ),
          Expanded(
              child: Text(Strings.LOGOUT_TEXT, style: AppStyles.drawerStyle(context))),
        ],
      ),
      onTap: () async {
        Navigator.pop(context);
        listner.onDrawerClosed(context);
      },
    ),
  ];
}

