import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/edit_profile.dart';
import 'package:SMP/login.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/profile.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:SMP/widget/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/Strings.dart';


import 'dart:io' show Platform;

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Function()? onBack;
  final Function()? menuOpen;
  final Function()? notification;
  final Function()? logout;
  final Function()? profile;
  final Function()? logo;

  final Function()? add;
  final Function()? home;
  final bool? disabled;
  final Function()? sos;
final String? screen;
  CustomAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.menuOpen,
    this.add,
    this.home,
    this.notification,
    this.logout,
    this.profile,
    this.sos,
    this.logo,
    this.disabled,
    this.screen,

  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}

class _CustomAppBarState extends State<CustomAppBar>
    with NavigatorListener, ApiListener {
  String? imageUrl = '';
  int? userId = 0;
  late String role = '';
  String? userName = '';
  String? emailId = '';
  String mobile = '';
  String? address = '';
  String? age = '';
  String? fullName = '';
  String? gender = '';
  String? state = '';
  String? pinCode = '';
  String? flatName = '';
  String? blockName = '';
  String? baseImageIssueApi = '';
  bool _isNetworkConnected = false, _isLoading = true;
  // bool showBackButton = false;


  @override
  void initState() {
    super.initState();

    if (widget.profile != null) {
      print("profile button cliekd ");
      _getUser();
    }

    // if (Platform.isIOS) {
    //   showBackButton =true;
    //
    // } else if (Platform.isAndroid) {
    //   showBackButton =true;
    //
    // }
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  Future<void> _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final apartmentId = prefs.getInt('apartmentId');
    role = prefs.getString(Strings.ROLES)!;
    baseImageIssueApi = BaseApiImage.baseImageUrl(apartmentId!, "profile");

    setState(() {
      userName = prefs.getString("userName");
      emailId = prefs.getString("email");
      mobile = prefs.getString("mobile") ?? "";
      imageUrl = prefs.getString("profilePicture");
      address = prefs.getString("address") ?? "";
      fullName = prefs.getString("fullName");
      gender = prefs.getString("gender");
      pinCode = prefs.getString("pinCode");
      state = prefs.getString("state") ?? "";
      age = prefs.getString("age");
      userId = prefs.getInt("id");
      flatName = prefs.getString(Strings.FLAT_NAME);
      blockName = prefs.getString(Strings.BLOCK_NAME);

      print("Role for backend:${role}");
      switch (role) {
        case 'ROLE_FLAT_TENANT':
          role = 'Tenant';
          break;
        case 'ROLE_ADMIN':
          role = 'Admin';
          break;
        case 'ROLE_FLAT_OWNER':
          role = 'Owner';
          break;
        case 'ROLE_SECURITY':
          role = 'Security';
          break;
        default:
          role = '';
      }
      Utils.printLog('role:$role');
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget imageContent = GestureDetector(
      child: const AvatarScreen(),
    );

    if (imageUrl!.isNotEmpty) {
      imageContent = GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            // border: Border.all(
            //   color: const Color.fromARGB(192, 177, 177, 177),
            //   width: 1.0,
            // ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Stack(
              children: <Widget>[
                if (imageUrl != null && imageUrl!.isNotEmpty)
                  Image.network(
                    '$baseImageIssueApi${imageUrl.toString()}',
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
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

    List<PopupMenuEntry<String>> profileMenuItems = [
      PopupMenuItem<String>(
        value: "view_profile",
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: AppStyles.circle1(context),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfile(
                              userId: userId!,
                              userName: userName!,
                              userType: emailId!,
                              address: address!,
                              email: emailId!,
                              phone: mobile,
                              age: age!,
                              pinCode: pinCode!,
                              // fullName: fullName!,
                              gender: gender!,
                              state: state!,
                              profilePicture: imageUrl!,
                              baseImageIssueApi: baseImageIssueApi!,
                              navigatorListener: this),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 100,
              width: 100,
              alignment: Alignment.center,
              child: imageContent,
            ),
            Text(role!, style: AppStyles.heading(context)),
            const SizedBox(
              height: 8,
            ),
            Container(
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          // padding: const EdgeInsets.only(
                          //     top: 10, left: 10, bottom: 10),
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Align(
                            alignment: Alignment
                                .center, // Align the text to the top left
                            child: Text(
                              Utils.addResidentDetails(
                                  userName, flatName, blockName),
                              // userName!,
                              style: AppStyles.heading1(context),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              emailId!,
                              style: AppStyles.heading1(context),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align children to the start
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 10),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              mobile!,
                              style: AppStyles.heading1(context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: "log_out",
        child: Row(
          children: <Widget>[
            const Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(top: 10, left: 40, bottom: 10),
                child: Icon(
                  Icons.logout,
                  color: Color(0xff1B5694),
                ),
              ),
            ),
            Expanded(
              flex: 3, // Adjust the flex value to control the width
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text("Logout", style: AppStyles.heading1(context)),
              ),
            ),
          ],
        ),
      ),
    ];

    List<Widget> actions = [];

    if (widget.notification != null) {
      actions.add(
        Container(
          padding: const EdgeInsets.only(right: 10),
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  width: 50,
                  child: IconButton(
                    onPressed: widget.notification,
                    icon: const Icon(Icons.notifications_active_rounded,
                        color: Colors.lightBlueAccent),
                  ),
                ),
              ),
              const Positioned(
                right: 4,
                top: 4,
                child: badges.Badge(
                  badgeContent: Text('3'),
                ),
              ),
            ],
          ),
        ),
      );
    }
    if (widget.sos != null) {
      actions.add(
        IconButton(
          onPressed: widget.sos,
          icon: const Icon(Icons.sos, color: Colors.white),
        ),
      );
    }
    if (widget.profile != null) {
      actions.add(
        PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'view_profile') {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>const UserProfile(),
                ),
              );
            } else if (value == 'log_out') {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    // contentPadding:
                    //     const EdgeInsets.only(top: 10.0, right: 10.0),
                    content:  Stack(
                        children: <Widget>[
                          Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                              

                                Text(
                                  "Log out?",
                                  style: AppStyles.heading(context),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                const SizedBox(height: 16),
                                const Text(
                                  "Are you sure, Do you want to logout?",
                                  style: TextStyle(
                                    color: Color.fromRGBO(27, 86, 148, 1.0),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 20.0,
                                  width: 5.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: ElevatedButton(
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: const BorderSide(
                                              width: 1,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 0,
                                          ),
                                        ),
                                        onPressed: () async {
                                          Utils.getNetworkConnectedStatus()
                                              .then((status) {
                                            setState(() {
                                              _isNetworkConnected = status;
                                              _isLoading = status;
                                              print(_isNetworkConnected);
                                              if (_isNetworkConnected) {
                                                _isLoading = true;
                                                String responseType = "logout";

                                                String loginURL =
                                                    '${Constant.logOutURL}?userId=$userId';

                                                NetworkUtils.postUrlNetWorkCall(
                                                    loginURL,
                                                    this,
                                                    responseType);
                                                Navigator.pop(context);
                                              }
                                              else {
                                                Utils.printLog("else called");
                                                _isLoading = false;
                                                Utils.showCustomToast(context);
                                              }
                                            });
                                          });
                                        },
                                        child: const Text("Logout"),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 0.0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Align(
                                alignment: Alignment.topRight,
                                child: Icon(
                                  Icons.close,
                                  size: 25,
                                  color: Color(0xff1B5694),
                                ),
                              ),
                            ),
                          ),
                        ],
                    ),
                  );
                },
              );
            }
          },
          itemBuilder: (context) => profileMenuItems,
          offset: const Offset(0, 57),
          child: Container(
            height: 40,
            width: 40,
            child: const ProfileAvatarScreen(),
          ),
        ),
      );
    }

    if (widget.logout != null) {
      actions.add(
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: IconButton(
              onPressed: widget.logout,
              icon: Image.asset(
                "assets/images/logout-icon.png",
                height: 23,
                width: 23,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    if (widget.add != null) {
      actions.add(
        IconButton(
          onPressed: widget.add,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
        ),
      );
    }

    List<Widget> leading = [];
    if(Utils.showBackButton && widget.menuOpen ==null &&  widget.screen !=  Strings.DASHBOARD_SCREEN){
      leading.add(
        SizedBox(
          width: 40,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,color: Colors.white,),
            onPressed: (){Navigator.pop(context);},
          ),
        ),
      );
    }
    if (widget.menuOpen != null) {
      leading.add(
        SizedBox(
          width: 40,
          child: IconButton(
            icon: const Icon(Icons.menu,color: Colors.white),
            onPressed: widget.menuOpen,
          ),
        ),
      );
    }

    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: leading,
          ),
          GestureDetector(
            onTap: widget.disabled == true
                ? null
                : () {
                    // Navigator.pop(context);
                    Navigator.of(context).push(
                        createRoute(DashboardScreen(isFirstLogin: false)));
                  },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                "assets/images/SMP.png",
                fit: BoxFit.cover,
                width: 35,
                height: 35,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: (widget.profile != null || widget.logout != null)
                  ? const EdgeInsets.only(left: 5)
                  : const EdgeInsets.only(right: 40),
              child: Align(
                alignment: Alignment.center,
                child: Center(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Utils.appBarTitleText,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ], // Center the entire row
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromRGBO(113, 177, 245, 1),
              Color.fromRGBO(35, 84, 136, 1),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Row(
            children: actions,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  onNavigatorBackPressed() {
    _getUser();
  }

  @override
  onFailure(status) {
    Utils.clearLogoutData(context);
    if (status == 401) {
      Utils.sessonExpired(context);
    } else {
      Utils.showToast(Strings.API_ERROR_MSG_TEXT);
    }
  }

  @override
  onSuccess(response, String responseType) {
    try {
      Utils.clearLogoutData(context);

      Utils.printLog(response);
    } catch (e) {
      Utils.printLog("Error $response");
    }
  }
}
