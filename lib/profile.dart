import 'dart:convert';

import 'package:SMP/components/user_profile/resident_profile.dart';
import 'package:SMP/contants/base_api.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/edit_profile.dart';
import 'package:SMP/login.dart';
import 'package:SMP/presenter/AlertListener.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/appartment_data_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/color.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/resident/family_members/view_family_member.dart';
import 'package:SMP/user_by_roles/resident/family_members/add_family_member.dart';
import 'package:SMP/user_by_roles/resident/my_vehicle/resident_my_vehicle_list.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/colors_utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'contants/constant_url.dart';
import 'network/NetworkUtils.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({
    super.key,
  });

  @override
  State<UserProfile> createState() {
    return _UserProfileState();
  }
}

Widget buildAvatar() {
  return Container(alignment: Alignment.center, child: const AvatarScreen());
}

class _UserProfileState extends State<UserProfile>
    with NavigatorListener, AlertListener, ApiListener {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int? userId = 0;
  String? role = '';
  String? userName = '';
  String? emailId = '';
  String? mobile = '';
  String? address = '';
  String? age = '';

  String? gender = '';
  String? state = '';
  String? pinCode = '';
  String? imageUrl = '';
  String? baseImageIssueApi = '';
  String? appartmentDetails = '';
  bool _isNetworkConnected = false, _isLoading = false;

  double _xOffset = 0;
  double _yOffset = 0;

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _getUser());
  }

  String passcode = "";

  Future<void> _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(Strings.APARTMENTID);

    baseImageIssueApi = BaseApiImage.baseImageUrl(id!, "profile");

    Utils.printLog(baseImageIssueApi!);

    final apartmantName = prefs.getString(Strings.APARTMENTNAME);

    final blockName = prefs.getString(Strings.BLOCK_NAME);
    final flatName = prefs.getString(Strings.FLAT_NAME);
    final profile = prefs.getString(Strings.PROFILEPICTURE);
    Utils.printLog(profile!);

    String pin = '12345';

    setState(() {
      userId = prefs.getInt(Strings.ID);
      userName = prefs.getString(Strings.USERNAME);
      emailId = prefs.getString(Strings.EMAIL);
      mobile = prefs.getString(Strings.MOBILE) ?? "";
      imageUrl = prefs.getString(Strings.PROFILEPICTURE);
      address = prefs.getString("address");
      gender = prefs.getString(Strings.GENDER);
      pinCode = prefs.getString(Strings.PINCODE);
      state = prefs.getString(Strings.STATE);
      age = prefs.getString(Strings.AGE);
      appartmentDetails =
          (flatName!.isNotEmpty ? flatName + ", " : "") + blockName!;

      passcode = '$pin,$userName,$apartmantName,$blockName,$flatName,$profile,';

      role = prefs.getString(Strings.ROLES);
      print("Role for backend:${role}");
      switch (role) {
        case 'ROLE_FLAT_TENANT':
          role = 'Tenant';
          break;
        case 'ROLE_ADMIN':
          role = Strings.ADMIN;
          break;
        case 'ROLE_FLAT_OWNER':
          role = Strings.OWNER;
          break;
        case 'ROLE_SECURITY':
          role = Strings.SECURITY;
          break;
        default:
          role = '';
      }
      Utils.printLog('role:$role');
    });
  }

  List usersList = [];

  Future<void> getList() async {}

  String? dropdownValue;
  bool light = true;

  var isEnabled = false;
  final animationDuration = const Duration(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    getList();

    Widget profileContent = Padding(
      padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
      child: ResidentProfile(
          users: emailId!,
          apartmentDetails: appartmentDetails!,
          address: address!,
          age: age!,
          gender: gender!,
          mobile: mobile!,
          role: role!),
    );

    Widget imageContent = GestureDetector(
      child: const AvatarScreen(),
    );

    if (imageUrl!.isNotEmpty) {
      imageContent = GestureDetector(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_50),
          child: Stack(
            children: <Widget>[
              if (imageUrl != null && imageUrl!.isNotEmpty)
                Image.network(
                  '$baseImageIssueApi${imageUrl.toString()}',
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
      );
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .push(createRoute(DashboardScreen(isFirstLogin: false)));
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
              title: Strings.PROFILE_HEADER,
              logout: () async {
                Utils.showLogoutDialog(context, this);
              }),
        ),
        body: AbsorbPointer(
          absorbing: _isLoading,
          child: Stack(
            children: <Widget>[
              Container(
                //  height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 255, 255, 255),
                      Color.fromARGB(255, 255, 255, 255),
                      Color.fromARGB(255, 255, 255, 255),
                      Color.fromARGB(255, 255, 255, 255),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: FontSizeUtil.SIZE_05,
                        bottom: FontSizeUtil.CONTAINER_SIZE_50,
                      ),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: FontSizeUtil.CONTAINER_SIZE_30),
                                    child: Container(
                                      height: FontSizeUtil.CONTAINER_SIZE_100,
                                      width: FontSizeUtil.CONTAINER_SIZE_100,
                                      alignment: Alignment.center,
                                      child: imageContent,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.all(FontSizeUtil.SIZE_08),
                                    child: Container(
                                      decoration: AppStyles.circle1(context),
                                      alignment: Alignment.topLeft,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditProfile(
                                                userId: userId!,
                                                userName: userName!,
                                                userType: emailId!,
                                                address: address!,
                                                email: emailId!,
                                                phone: mobile!,
                                                age: age!,
                                                pinCode: pinCode!,
                                                gender: gender!,
                                                state: state!,
                                                profilePicture: imageUrl!,
                                                baseImageIssueApi:
                                                    baseImageIssueApi!,
                                                navigatorListener: this,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              FontSizeUtil.SIZE_03),
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            userName!,
                            style: TextStyle(
                              color: const Color(0xFF1B5694),
                              fontSize: FontSizeUtil.LABEL_TEXT_SIZE_20,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: FontSizeUtil.SIZE_03),
                          Text(
                            role!,
                            style: TextStyle(
                              color: const Color(0xFF1B5694),
                              fontSize: FontSizeUtil.LABEL_TEXT_SIZE_18,
                              // fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                          profileContent,
                          if (role == Strings.TENANT || role == Strings.OWNER)
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(createRoute(
                                    const ViewFamilyMemberScreen()));
                              },
                              child: Card(
                                elevation: 8.0,
                                color: const Color.fromARGB(255, 240, 245, 240),
                                shadowColor: Colors.blueGrey,
                                margin: EdgeInsets.symmetric(
                                  horizontal: FontSizeUtil.CONTAINER_SIZE_15,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: FontSizeUtil.SIZE_08),
                                      child: const Icon(
                                        Icons.home_outlined,
                                        color: Color(0xff1B5694),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal:
                                              FontSizeUtil.CONTAINER_SIZE_15,
                                        ),
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              Strings.MY_FAMALY_HEADER,
                                              style:
                                                  AppStyles.heading1(context),
                                            ),
                                            SizedBox(
                                                height: FontSizeUtil.SIZE_05),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.all(FontSizeUtil.SIZE_08),
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Color(0xff1B5694),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),

                          if (role == Strings.TENANT || role == Strings.OWNER)
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(createRoute(
                                    const ViewMyVehicleScreen()));
                              },
                              child: Card(
                                elevation: FontSizeUtil.SIZE_08,
                                color: SmpAppColors.cardColor,
                                shadowColor: SmpAppColors.blueGrey,
                                margin: EdgeInsets.symmetric(
                                  horizontal: FontSizeUtil.CONTAINER_SIZE_15,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: FontSizeUtil.SIZE_08),
                                      child: const Icon(
                                        Icons.car_repair,
                                        color: Color(0xff1B5694),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal:
                                          FontSizeUtil.CONTAINER_SIZE_15,
                                        ),
                                        title: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              Strings.MY_VEHICLE_HEADER,
                                              style:
                                              AppStyles.heading1(context),
                                            ),
                                            SizedBox(
                                                height: FontSizeUtil.SIZE_05),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      EdgeInsets.all(FontSizeUtil.SIZE_08),
                                      child: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: SmpAppColors.drawerIconColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          SizedBox(
                            height: FontSizeUtil.CONTAINER_SIZE_10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (_isLoading) const Positioned(child: LoadingDialog()),
              const FooterScreen(),
            ],
          ),
        ),
        floatingActionButton:

        Stack(
          children: [
            // Container placed below the FloatingActionButton
            Positioned(
              bottom: FontSizeUtil.CONTAINER_SIZE_50 - _yOffset,
              right: FontSizeUtil.CONTAINER_SIZE_10 - _xOffset,
              child: Container(
                width: FontSizeUtil.CONTAINER_SIZE_200, // Adjust width as needed
                height: FontSizeUtil.CONTAINER_SIZE_200, // Adjust height as needed
                color: Colors.transparent, // Make container transparent
                // Add any other styling or constraints here
              ),
            ),
            Positioned(
              bottom: FontSizeUtil.CONTAINER_SIZE_50 - _yOffset,
              right: FontSizeUtil.CONTAINER_SIZE_10 - _xOffset,
              child: GestureDetector(
                onPanStart: (details) {
                  // You can add any necessary actions when dragging starts
                },
                onPanUpdate: (details) {
                  setState(() {
                    // Update offsets based on gesture delta
                    _xOffset += details.delta.dx;
                    _yOffset += details.delta.dy;
                  });
                },
                onPanEnd: (details) {
                  // You can add any necessary actions when dragging ends
                },
                child: FloatingActionButton(
                  heroTag: "btn2",
                  onPressed: () {
                    // Handle button press
                    showQRCode(context, passcode);
                  },
                  backgroundColor: const Color(0xff1B5694),
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.qr_code),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  onNavigatorBackPressed() {
    _getUser();
  }

  @override
  onRightButtonAction(BuildContext context) {
    _getNetworkData();
  }

  void _getNetworkData() {
    Utils.getNetworkConnectedStatus().then((status) {
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        print(_isNetworkConnected);
        if (_isNetworkConnected) {
          _isLoading = true;
          String responseType = "logout";

          String loginURL = '${Constant.logOutURL}?userId=$userId';

          NetworkUtils.postUrlNetWorkCall(loginURL, this, responseType);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          //  Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
          Utils.showCustomToast(context);
        }
      });
    });
  }

  @override
  onSuccess(response, String responseType) {
    Utils.clearLogoutData(context);
  }

  @override
  onFailure(status) {
    setState(() {
      _isLoading = false;
    });

    if (status == 401) {
      Utils.sessonExpired(context);
    } else {
      Utils.showToast(Strings.API_ERROR_MSG_TEXT);
    }
  }
}

void showQRCode(BuildContext context, passcode) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 25.0, left: 8.0, bottom: 8.0, right: 8.0),
              child: Container(
                width: 340,
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: QrImageView(
                              data: passcode.toString(),
                              size: MediaQuery.of(context).size.width * 0.54,
                              gapless: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 5.0,
              top: 5.0,
              child: Container(
                decoration: AppStyles.circle1(context),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Align(
                    alignment: Alignment.topRight,
                    child: Icon(
                      Icons.close,
                      size: 25,
                      color: Colors.white,
                    ),
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

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
