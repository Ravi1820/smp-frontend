import 'package:SMP/contants/base_api.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/edit_profile.dart';
import 'package:SMP/login.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:SMP/widget/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shared_preferences/shared_preferences.dart';

class WaitingAppBar extends StatefulWidget implements PreferredSizeWidget {
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

  WaitingAppBar({
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
  });

  @override
  State<WaitingAppBar> createState() => _WaitingAppBarState();

  @override
  Size get preferredSize => throw UnimplementedError();
}

class _WaitingAppBarState extends State<WaitingAppBar> with NavigatorListener {
  String? imageUrl = '';
  int userId = 0;
  String? role = '';
  String? userName = '';
  String? emailId = '';
  String mobile = '';
  String? address = '';
  String? age = '';
  String? fullName = '';
  String? gender = '';
  String? state = '';
  String? pinCode = '';

  String? baseImageIssueApi = '';

  bool _isNetworkConnected = false, _isLoading = true;

  @override
  void initState() {
    super.initState();


    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  Future<void> _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apartmentId = prefs.getInt('apartmentId');

    baseImageIssueApi = BaseApiImage.baseImageUrl(apartmentId!, "profile");

    setState(() {

      userName = prefs.getString("waitingUserName");
      emailId = prefs.getString("waitingUserEmail");
      mobile = prefs.getString("waitingUserPhone") ?? "";
      role = prefs.getString("waitingUserRole") ?? "";

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
            border: Border.all(
              color: const Color.fromARGB(192, 177, 177, 177),
              width: 1.0,
            ),
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
                      return Image.asset(
                        "assets/images/no-img.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      );
                    },
                  )
                else
                  Image.asset(
                    "assets/images/no-img.png",
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
              ],
            ),
          ),
        ),
      );
    }


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
    if (widget.menuOpen != null) {
      leading.add(
        SizedBox(
          width: 40,
          child: IconButton(
            icon: const Icon(Icons.menu),
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
              // margin: (widget.profile != null)
              //     ? const EdgeInsets.only(left: 80)
              //     : const EdgeInsets.only(right: 20),
              margin: const EdgeInsets.only(left: 20) ,
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
}
