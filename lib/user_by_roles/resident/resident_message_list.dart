import 'dart:convert';

import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/model/message_list.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/owner_list/messages.dart';

import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../admin/owner_list/admin_resident_list.dart';

class ResidentMessage extends StatefulWidget {
  const ResidentMessage({super.key});

  @override
  State<ResidentMessage> createState() => _ResidentMessageState();
}

class _ResidentMessageState extends State<ResidentMessage> with ApiListener {
  // bool _isLoading = true;
//
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();
    _choose();
  }

  int residentId = 0;
  int? blockCount;
  int senderId = 0;
  bool _isNetworkConnected = false, _isLoading = true;

  int apartmentId = 0;

  List messageList = [];
  String? baseImageIssueApi = '';

  Future<void> _choose() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');
    blockCount = prefs.getInt(Strings.BLOCKCOUNT);
    final apartmentsId = prefs.getInt('apartmentId');

    print(apartmentsId);

    setState(() {
      baseImageIssueApi = BaseApiImage.baseImageUrl(id!, "profile");

      _isLoading = true;
      residentId = id!;
      apartmentId = apartmentsId!;
    });
    print("SenderId : $id");
    print("ReciverId : $senderId");

    //  void _getNoticeList() {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "noticeList";

          String allNoticeURL =
              '${Constant.getChatMessageURL1}?receiverId=$id&apartmentId=$apartmentId';

          NetworkUtils.getNetWorkCall(allNoticeURL, responseType, this);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  onFailure(status) {
    setState(() {
      _isLoading = false;
    });
    // Utils.sessonExpired(context,  "Session is expired. Please login again");
    if (status == 401) {
      Utils.sessonExpired(context);
    } else {
      Utils.showToast(Strings.API_ERROR_MSG_TEXT);
    }
  }

  @override
  onSuccess(response, String responseType) async {
    try {
      setState(() async {
        if (responseType == 'noticeList') {
          var jsonResponse = json.decode(response);

          MessageListModel notice = MessageListModel.fromJson(jsonResponse);
          if (notice.status == 'success' && notice.messages != null) {
            messageList = notice.values!;
          }

          _isLoading = false;
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      // Utils.printLog("Error text === $response");
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).push(createRoute(DashboardScreen(
          isFirstLogin: false,
        )));

        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: Strings.MESSAGE_LIST_HEADER,
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
                    child: messageList.isNotEmpty
                        ? Container(
                            child: ListView.builder(
                              itemCount: messageList.length,
                              itemBuilder: (context, index) {
                                return buildListItem(
                                  messageList[index],
                                );
                              },
                            ),
                          )
                        : _isLoading
                            ? Container()
                            : Padding(
                                padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
                                child: Center(
                                  child: Text(
                                    Strings.NO_MESSAGES_TEXT,
                                    style: AppStyles.heading(context),
                                  ),
                                ),
                              ),
                  ),
                  const FooterScreen(),
                ],
              ),
              if (_isLoading) const Positioned(child: LoadingDialog()),
            ],
          ),
        ),
        floatingActionButton: Stack(
          children: [
            Positioned(
              bottom:  FontSizeUtil.CONTAINER_SIZE_50,
              right:  FontSizeUtil.CONTAINER_SIZE_10,
              child: FloatingActionButton(
                heroTag: "btn2",
                onPressed: () {
                  Navigator.of(context).push(createRoute(
                    AdminResidentListScreen(
                      id: apartmentId,
                      blockName: '',
                      blockCount: blockCount,
                      screenName: Strings.MESSAGE_SCRREN,
                    ),
                  ));
                },
                backgroundColor: const Color(0xff1B5694),
                foregroundColor: Colors.white,
                child: const Icon(Icons.maps_ugc_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListItem(Values teamMember) {
    return Padding(
      padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
      child: Card(
        elevation: 2,
        child: Container(
          decoration: AppStyles.decoration(context),
          child: Padding(
            padding: EdgeInsets.all(FontSizeUtil.SIZE_08),
            child: ListTile(
              leading: SizedBox(
                height:  FontSizeUtil.CONTAINER_SIZE_55,
                width:  FontSizeUtil.CONTAINER_SIZE_50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular( FontSizeUtil.CONTAINER_SIZE_50),
                  child: Stack(
                    children: <Widget>[
                      if (teamMember.senderPicture != null &&
                          teamMember.senderPicture!.isNotEmpty)
                        Image.network(
                          '$baseImageIssueApi${teamMember.senderPicture.toString()}',
                          fit: BoxFit.cover,
                          height:  FontSizeUtil.CONTAINER_SIZE_100,
                          width:  FontSizeUtil.CONTAINER_SIZE_100,
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
              title: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      teamMember.senderName ?? "",
                      style:  TextStyle(
                        color:const Color(0xff1B5694),
                        fontSize:  FontSizeUtil.CONTAINER_SIZE_15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                   SizedBox(height: FontSizeUtil.SIZE_10),
                ],
              ),
              trailing:  SizedBox(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: FontSizeUtil.CONTAINER_SIZE_15),
                  child:const Icon(
                    Icons.arrow_forward_ios,
                  ),
                ),
              ),
              onTap: () => {
                {
                  Navigator.of(context).push(
                    createRoute(
                      Message(
                          residentId: teamMember.senderId!,
                          residentDeviseToken:
                              teamMember.senderDeviceToken ?? "",
                          residetName: teamMember.senderName!),
                    ),
                  ),
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
