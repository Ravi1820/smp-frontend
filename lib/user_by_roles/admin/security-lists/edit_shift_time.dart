import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/security-lists/security-lists.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:flutter/material.dart';

class EditSecurityShiftTime extends StatefulWidget {
  @override
  const EditSecurityShiftTime({
    super.key,
    required this.securityId,
    required this.shiftStartTime,
    required this.shiftEndTime,
  });

  final int securityId;

  final String shiftStartTime;
  final String shiftEndTime;

  @override
  State<EditSecurityShiftTime> createState() {
    return _EditSecurityShiftTime();
  }
}

class _EditSecurityShiftTime extends State<EditSecurityShiftTime>
    with ApiListener {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isNetworkConnected = false, _isLoading = true;

  final TextEditingController _controllershiftStartTime =
      TextEditingController();
  final TextEditingController _controllershiftEndTime = TextEditingController();

  int securityId = 0;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    securityId = widget.securityId;
    _controllershiftStartTime.text = widget.shiftStartTime;
    _controllershiftEndTime.text = widget.shiftEndTime;
    super.initState();
  }

  DateTime currentDate = DateTime.now();

  bool showErrorMessage = false;

  String? _enteredAdmittedDate;
  String? _enteredDichargedDate;

  String? _guestPollEndErrorMessage;
  String? _guestPollStartErrorMessage;

  Future<void> datePicker(BuildContext context, String type) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentDate),
    );

    if (pickedTime != null) {
      if (type == "Shift Start Time") {
        setState(() {
          currentDate = DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          _enteredAdmittedDate = pickedTime.format(context);
          _controllershiftStartTime.text = _enteredAdmittedDate ?? '';
        });
      }
      if (type == "Discharged Date") {
        setState(() {
          currentDate = DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          _enteredDichargedDate = pickedTime.format(context);
          _controllershiftEndTime.text = _enteredDichargedDate ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: 'Update Shift Time',
          profile: () async {
            // Navigator.of(context).push(createRoute(const DashboardScreen()));
          },
    
          // menuOpen: () {
          //   _scaffoldKey.currentState!.openDrawer();
          // },
          // onBack: () {
          //   Navigator.pop(context);
          // },
        ),
      ),
      // drawer: const DrawerScreen(),
      body: AbsorbPointer(
        absorbing: _isLoading,
        child: Center(
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
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
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 20),
                        const SizedBox(height: 10),
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
                                    TableRow(
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            const Text(
                                              'Shift Start Time',
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
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Color.fromARGB(
                                                            255, 100, 100, 100),
                                                        blurRadius: 6,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  height: 50,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(6.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              datePicker(context,
                                                                  "Shift Start Time");
                                                            },
                                                            child: AbsorbPointer(
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    _controllershiftStartTime,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  prefixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .date_range_outlined,
                                                                    color: Color(
                                                                        0xff4d004d),
                                                                  ),
                                                                  hintText:
                                                                      'Shift Start Time',
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .black38),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                                onChanged:
                                                                    (value) {},
                                                                onSaved: (value) {
                                                                  _enteredDichargedDate =
                                                                      value;
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            datePicker(context,
                                                                "Shift Start Time");
                                                          },
                                                          child: const Icon(
                                                            Icons.date_range,
                                                            color:
                                                                Color(0xff4d004d),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            // if (_guestPollStartErrorMessage !=
                                            //     null)
                                            //   Text(
                                            //     _guestPollEndErrorMessage!,
                                            //     style: const TextStyle(
                                            //       color: Colors.red,
                                            //       fontSize: 15,
                                            //     ),
                                            //   ),
                                            if (_guestPollStartErrorMessage !=
                                                null)
                                              Text(
                                                _guestPollStartErrorMessage!,
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 10),
                                            const Text(
                                              'Shift End Time',
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
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    boxShadow: const [
                                                      BoxShadow(
                                                        color: Color.fromARGB(
                                                            255, 100, 100, 100),
                                                        blurRadius: 6,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                  height: 50,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(6.0),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              datePicker(context,
                                                                  "Discharged Date");
                                                            },
                                                            child: AbsorbPointer(
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    _controllershiftEndTime,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  prefixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .date_range_outlined,
                                                                    color: Color(
                                                                        0xff4d004d),
                                                                  ),
                                                                  hintText:
                                                                      'Shift End Time',
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                          .black38),
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                                onChanged:
                                                                    (value) {
                                                                  // Handle onChanged if needed
                                                                },
                                                                onSaved: (value) {
                                                                  _enteredDichargedDate =
                                                                      value;
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            datePicker(context,
                                                                "Discharged Date");
                                                          },
                                                          child: const Icon(
                                                            Icons.date_range,
                                                            color:
                                                                Color(0xff4d004d),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            if (_guestPollEndErrorMessage != null)
                                              Text(
                                                _guestPollEndErrorMessage!,
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            if (_guestPollEndErrorMessage != null)
                                              Text(
                                                _guestPollEndErrorMessage!,
                                                style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * 0.03,
                            horizontal: MediaQuery.of(context).size.width * 0.1,
                          ),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                _updateShiftTime();

                                // Provider.of<MovieListViewModel>(context,
                                //         listen: false)
                                //     .updateShiftTime(
                                //   securityId,
                                //   _controllershiftStartTime.text,
                                //   _controllershiftEndTime.text,
                                // )
                                //     .then(
                                //   (response) async {
                                //     if (response.statusCode == 200) {
                                //       var message = response.body;
                                //       successDialog(context, message,
                                //           const SecurityLists());
                                //     } else {
                                //       // ignore: avoid_print
                                //       print("ERRORs: ${response.statusCode}");
                                //       var responseJson = response.body;
                                //       // ignore: avoid_print
                                //       print("Error: $responseJson");
                                //       errorDialog(context, "Error: $responseJson",
                                //           const SecurityLists());
                                //     }
                                //   },
                                // ).catchError((error) {
                                //   // ignore: avoid_print
                                //   print("Error: $error");
                                //   errorDialog(
                                //       context, error, const SecurityLists());
                                // });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff1B5694),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.05),
                            ),
                            child: Text(
                              "Update Shift Time",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ),
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  child: FooterScreen(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _updateShiftTime() async {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          String responseType = "editShiftTime";
          String startTime = _controllershiftStartTime.text;
          String endTime = _controllershiftEndTime.text;

          String editShiftTimeURL =
              '${Constant.updateShiftTimeURL}?shiftStart=$startTime&shiftEnd=$endTime&userId=$securityId';

          NetworkUtils.updateNetWorkCall(editShiftTimeURL, responseType, this);
        } else {
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
    if(status==401){
      Utils.sessonExpired(context);
    }else{
    Utils.showToast(Strings.API_ERROR_MSG_TEXT);
    }
  }

  @override
  onSuccess(response, String responseType) async {
    try {
      setState(() {
        if (responseType == 'editShiftTime') {
          var message = response;
          successDialog(context, message, const SecurityLists());
          // issueCount = jsonDecode(response);
          // } else if (responseType == 'noticeList') {
          //   List<Notice> movieList = (json.decode(response) as List)
          //       .map((item) => Notice.fromJson(item))
          //       .toList();
          //   noticeList = movieList;
          // }
          // else if (responseType == 'allDevice') {
          // List<DeviceTokenModel> deviceTokens = (json.decode(response) as List)
          //     .map((item) => DeviceTokenModel.fromJson(item))
          //     .where((element) => element.pushNotificationToken != null)
          //     .toList();

          // allDeviceId = deviceTokens.map((device) => device.pushNotificationToken!).toList();

          // Utils.printLog("Success text === $allDeviceId");
        }
        // else if (responseType == 'allDevice') {
        //   List<DeviceTokenModel> filteredNotifications = response
        //       .where((element) => element.pushNotificationToken != null)
        //       .toList();

        //   allDeviceId = filteredNotifications;

        //   Utils.printLog("Success text === $allDeviceId");
        // }
      });
    } catch (error) {
      Utils.printLog("Error text === $response");
    }
  }
}
