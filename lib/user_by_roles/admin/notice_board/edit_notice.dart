import 'dart:convert';

import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/profile.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/notice_board/notification_list.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:html_editor_enhanced/html_editor.dart';

class EditNoticeScreen extends StatefulWidget {
   EditNoticeScreen(
      {super.key,
      required this.id,
      required this.message,
        required this.navigatorListener,
      required this.header});

  final int id;
  final String message;
  final String header;
  NavigatorListener? navigatorListener;


  @override
  State<EditNoticeScreen> createState() {
    return _EditNoticeScreenState();
  }
}

class _EditNoticeScreenState extends State<EditNoticeScreen> with ApiListener ,NavigatorListener{
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var _enteredNoticeName = '';
  var _enteredNoticeHeader = '';

  int messageId = 0;

  final TextEditingController _controllerNoticeMessage =
      TextEditingController();

  final TextEditingController _controllerNoticeHeader = TextEditingController();

  @override
  void initState() {
    super.initState();
    // controller = HtmlEditorController();
    _getUserProfile();
    setState(() {
      _controllerNoticeMessage.text = widget.message;
      _controllerNoticeHeader.text = widget.header;

      messageId = widget.id;
    });
    _getDataFromOriginal();
  }


  @override
  dispose() {
    _disposeData();
    super.dispose();
  }

  bool _isNetworkConnected = false, _isLoading = false;

  String? token;
  int apartmentId = 0;
  String imageUrl = '';
  String profilePicture = '';
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
    var id = prefs.getInt('id');
    var profilePicture = prefs.getString('profilePicture');

    setState(() {
      emailId = email!;
      userName = userNam!;

      userType = roles!;
      apartmentId = apartId!;
      userId = id!;
      imageUrl = profilePicture!;
    });
  }

  bool showErrorMessage = false;

  bool showPurposeErrorMessage = false;
  bool showHeaderErrorMessage = false;

  Color _containerBorderColor1 = Colors.white; // Added this line
  Color _boxShadowColor1 = const Color.fromARGB(255, 100, 100, 100);
  Color _containerBorderColor = Colors.white; // Added this line
  Color _boxShadowColor = const Color.fromARGB(255, 100, 100, 100);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: 'Update Notice',
            // menuOpen: () {
            //   _scaffoldKey.currentState!.openDrawer();
            // },
            profile: () {
              Navigator.of(context).push(createRoute(const UserProfile()));
            },
          ),
        ),
        // drawer: const DrawerScreen(),
        backgroundColor: Colors.white,
        body: AbsorbPointer(
          absorbing: _isLoading,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Card(
                              margin: const EdgeInsets.all(15),
                              shadowColor: Colors.blueGrey,
                              child: Container(
                                decoration: AppStyles.decoration(context),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Form(
                                    key: _formKey,
                                    child: Table(
                                      children: <TableRow>[
                                        TableRow(children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                Strings.SUBJECT,
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      27, 86, 148, 1.0),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Stack(
                                                alignment: Alignment.centerLeft,
                                                children: <Widget>[
                                                  FocusScope(
                                                    child: Focus(
                                                        onFocusChange:
                                                            (hasFocus) {
                                                          setState(() {
                                                            _containerBorderColor =
                                                                hasFocus
                                                                    ? const Color
                                                                            .fromARGB(
                                                                        255,
                                                                        0,
                                                                        137,
                                                                        250)
                                                                    : Colors
                                                                        .white;
                                                            _boxShadowColor = hasFocus
                                                                ? const Color
                                                                        .fromARGB(
                                                                    162,
                                                                    63,
                                                                    158,
                                                                    235)
                                                                : const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    100,
                                                                    100,
                                                                    100);
                                                          });
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color:
                                                                    _boxShadowColor1,
                                                                blurRadius: 6,
                                                                offset:
                                                                    const Offset(
                                                                        0, 2),
                                                              ),
                                                            ],
                                                            border: Border.all(
                                                              color:
                                                                  _containerBorderColor,
                                                            ),
                                                          ),
                                                          // height: 100,
                                                          child: TextFormField(
                                                            keyboardType:
                                                                TextInputType
                                                                    .emailAddress,
                                                            controller:
                                                                _controllerNoticeHeader,
                                                            maxLines: null,
                                                            style: AppStyles
                                                                .heading1(
                                                                    context),
                                                            decoration:
                                                                const InputDecoration(
                                                              border: InputBorder
                                                                  .none,
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 14),
                                                              prefixIcon: Icon(
                                                                Icons.description,
                                                                color: Color(
                                                                    0xff4d004d),
                                                              ),
                                                              hintText: Strings.SUBJECT_HINT_TEXT,
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .black38),
                                                            ),
                                                            validator: (value) {
                                                              if (value == null ||
                                                                  value.isEmpty ||
                                                                  value
                                                                          .trim()
                                                                          .length <=
                                                                      1) {
                                                                setState(() {
                                                                  showHeaderErrorMessage =
                                                                      true;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  showHeaderErrorMessage =
                                                                      false;
                                                                });
                                                                return null;
                                                              }
                                                              return null;
                                                            },
                                                            onChanged: (value) {
                                                              if (value.isEmpty ||
                                                                  value
                                                                          .trim()
                                                                          .length <=
                                                                      1) {
                                                                setState(() {
                                                                  showHeaderErrorMessage =
                                                                      true;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  showHeaderErrorMessage =
                                                                      false;
                                                                });
                                                              }
                                                            },
                                                            onSaved: (value) {
                                                              _enteredNoticeHeader =
                                                                  value!;
                                                            },
                                                          ),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                              if (showHeaderErrorMessage == true)
                                                const Text(
                                                Strings.SUBJECT_ERROR_TEXT,
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              const SizedBox(height: 10),
                                              const Text(
                                                Strings.MESSAGE,
                                                style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      27, 86, 148, 1.0),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Stack(
                                                alignment: Alignment.centerLeft,
                                                children: <Widget>[
                                                  FocusScope(
                                                    child: Focus(
                                                        onFocusChange:
                                                            (hasFocus) {
                                                          setState(() {
                                                            _containerBorderColor1 =
                                                                hasFocus
                                                                    ? const Color
                                                                            .fromARGB(
                                                                        255,
                                                                        0,
                                                                        137,
                                                                        250)
                                                                    : Colors
                                                                        .white;
                                                            _boxShadowColor1 = hasFocus
                                                                ? const Color
                                                                        .fromARGB(
                                                                    162,
                                                                    63,
                                                                    158,
                                                                    235)
                                                                : const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    100,
                                                                    100,
                                                                    100);
                                                          });
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color:
                                                                    _boxShadowColor1,
                                                                blurRadius: 6,
                                                                offset:
                                                                    const Offset(
                                                                        0, 2),
                                                              ),
                                                            ],
                                                            border: Border.all(
                                                              color:
                                                                  _containerBorderColor1,
                                                            ),
                                                          ),
                                                          height: 100,
                                                          child: TextFormField(
                                                            controller:
                                                                _controllerNoticeMessage,
                                                            keyboardType:
                                                                TextInputType
                                                                    .multiline,
                                                            maxLines: null,
                                                            style: AppStyles
                                                                .heading1(
                                                                    context),
                                                            decoration:
                                                                const InputDecoration(
                                                              border: InputBorder
                                                                  .none,
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 14),
                                                              prefixIcon: Icon(
                                                                Icons.description,
                                                                color: Color(
                                                                    0xff4d004d),
                                                              ),
                                                              hintText: Strings.MESSAGE_HINT_TEXT,
                                                              hintStyle: TextStyle(
                                                                  color: Colors
                                                                      .black38),
                                                            ),
                                                            validator: (value) {
                                                              if (value == null ||
                                                                  value.isEmpty ||
                                                                  value
                                                                          .trim()
                                                                          .length <=
                                                                      1) {
                                                                setState(() {
                                                                  showPurposeErrorMessage =
                                                                      true;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  showPurposeErrorMessage =
                                                                      false;
                                                                });
                                                                return null;
                                                              }
                                                              return null;
                                                            },
                                                            onChanged: (value) {
                                                              if (value.isEmpty ||
                                                                  value
                                                                          .trim()
                                                                          .length <=
                                                                      1) {
                                                                setState(() {
                                                                  showPurposeErrorMessage =
                                                                      true;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  showPurposeErrorMessage =
                                                                      false;
                                                                });
                                                              }
                                                            },
                                                            onSaved: (value) {
                                                              _enteredNoticeName =
                                                                  value!;
                                                            },
                                                          ),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                              if (showPurposeErrorMessage == true)
                                                const Text(
                                                  Strings.MESSAGE_ERROR_TEXT,
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ]),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff1B5694),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 50,
                                        vertical: 15,
                                      ),
                                    ),
                                    onPressed: () async {
                                      // print(controller);
                                      if (_formKey.currentState!.validate() &&
                                          showPurposeErrorMessage == false && showHeaderErrorMessage==false) {
                                        _formKey.currentState!.save();
                                        if(await checkData() ){
                                          _editNoticeApi();
                                        }
                                        else {
                                          Utils.showToast(
                                            Strings.UPDATE_POLL_ERROR_TEXT);
                                        }

                                         } else {
                                        var msg =
                                            Strings.MANDATORY_FIELD_TEXT;

                                        errorAlert(context, msg);
                                      }
                                    },
                                    child: const Text(Strings.UPDATE_TEXT,style:TextStyle(color: Colors.white) ),
                                  ),
                                  const SizedBox(width: 30),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff1B5694),
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 50,
                                        vertical: 15,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      // Navigator.of(context).pop
                                      // (
                                      // createRoute(const NoticeBoardList()));
                                    },
                                    child: const Text(Strings.CANCEL_TEXT,style:TextStyle(color: Colors.white) ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 130),
                          ],
                        ),
                      ),
                    ),
                    const FooterScreen(),
                  ],
                ),
              ),
              if (_isLoading) Positioned(child: LoadingDialog()),
            ],
          ),
        ),
      ),
    );
  }

  _editNoticeApi() async {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          _isLoading = true;
          String responseType = "editNotice";
          String editedHeader = _controllerNoticeHeader.text;
          String editedMessage = _controllerNoticeMessage.text;

          String createNoticeURL =
              '${Constant.editNoticesURL}?noticeId=$messageId&content=$editedMessage&noticeHeader=$editedHeader';
          NetworkUtils.putUrlNetWorkCall(
            createNoticeURL,
            this,
            responseType,
          );
        }
        else {
          Utils.printLog("else called");
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
    // Utils.sessonExpired(context,  "Session is expired. Please login again");
    if (status == 401) {
      Utils.sessonExpired(context);
    } else {
      Utils.showToast(Strings.API_ERROR_MSG_TEXT);
    }
  }

  @override
  onSuccess(response, res) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      if (res == "editNotice") {
        Map<String, dynamic> jsonResponse = json.decode(response);

        if (jsonResponse['status'] == "success") {
          successDialogWithListner(
              context, jsonResponse['message'], const NoticeBoardList(),this);
          Utils.printLog("Existing Notice Updated ${jsonResponse}");
          // Utils.writeCounter(bool.parse("true"));
          Utils.writeCounter("true", Strings.NOTICE_FILE_NAME);
        } else {
          Utils.showToast(jsonResponse['message']);
        }
      }
    } catch (error) {
      print("Error 1");
      errorAlert(
        context,
        response.toString(),
      );
    }
  }



  _getDataFromOriginal() async {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('header',  _controllerNoticeHeader.text );
    prefs.setString('noticeMessage', _controllerNoticeMessage.text);

  }
  _disposeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
       prefs.remove('header');
       prefs.remove('noticeMessage');

  }

  Future<bool> checkData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
     var orignalHeader =  prefs.getString('header');
     var originalNotice = prefs.getString('noticeMessage');
     Utils.printLog(' Orignalheader : $orignalHeader');
     Utils.printLog('OriginalNotice: $originalNotice');
     return
       _controllerNoticeHeader.text !=  orignalHeader ||
    _controllerNoticeMessage.text!= originalNotice;




  }

  @override
  onNavigatorBackPressed() {
    Navigator.pop(context);
    widget.navigatorListener!.onNavigatorBackPressed();
  }


}
