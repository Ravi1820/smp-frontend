import 'dart:convert';

import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/model/fees_type_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/resident/society_dues.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeesType extends StatefulWidget {
  const FeesType({super.key});

  @override
  State<FeesType> createState() => _FeesTypeState();
}

class _FeesTypeState extends State<FeesType> with ApiListener {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();
    _getApartmentData();
  }

  int residentId = 0;
  int senderId = 0;
  bool _isNetworkConnected = false, _isLoading = true;
  int apartmentId = 0;
  List messageList = [];

  Future<void> _getApartmentData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apartId = prefs.getInt('apartmentId');
    var apartName = prefs.getString('apartmentName');

    setState(() {
      apartmentId = apartId!;
    });

    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        print(_isNetworkConnected);
        String responseType = "email";
        if (_isNetworkConnected) {
          _isLoading = true;
          NetworkUtils.getNetWorkCall(
              Constant.getAllFeesTypeURL, responseType, this);
        } else {
          print("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
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

  @override
  onSuccess(response, String responseType) {
    try {
      setState(() {
        _isLoading = false;
        if (responseType == 'email') {
          setState(() {
            List<FeesTypeModel> apartlist = (json.decode(response) as List)
                .map((item) => FeesTypeModel.fromJson(item))
                .toList();

            messageList = apartlist;
            _isLoading = false;
          });
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: Strings.SOCIETY_DUES_HEADER,
          profile: () {},
        ),
      ),
      // drawer: const DrawerScreen(),
      body: AbsorbPointer(
        absorbing: _isLoading,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                    child: ListView.builder(
                      itemCount: messageList.length,
                      itemBuilder: (context, index) {
                        return buildListItem(
                          messageList[index],
                        );
                      },
                    ),
                  ),
                ),
                const FooterScreen()
              ],
            ),
            if (_isLoading) const Positioned(child: LoadingDialog()),
          ],
        ),
      ),
    );
  }

  Widget buildListItem(teamMember) {
    return Padding(
      padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
      child: Card(
        elevation: FontSizeUtil.SIZE_02,
        child: Container(
          decoration: AppStyles.decoration(context),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: FontSizeUtil.SIZE_08),
            child: ListTile(
              title: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      teamMember.feesType ?? "",
                      style: TextStyle(
                        color:const Color(0xff1B5694),
                        fontSize: FontSizeUtil.CONTAINER_SIZE_15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: FontSizeUtil.SIZE_10),
                ],
              ),
              trailing: SizedBox(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: FontSizeUtil.CONTAINER_SIZE_15),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
              ),
              onTap: () => {
                Navigator.of(context).push(
                  createRoute(
                    SocietyDuesScreen(
                        feesId: teamMember.id!, feesName: teamMember.feesType),
                  ),
                ),
              },
            ),
          ),
        ),
      ),
    );
  }
}
