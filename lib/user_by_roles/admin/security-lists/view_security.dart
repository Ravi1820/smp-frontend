import 'dart:convert';
import 'dart:io';

import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/success_alert.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/profile.dart';
import 'package:SMP/registration/existing_resident_otp.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/security-lists/edit_security.dart';
import 'package:SMP/user_by_roles/admin/security-lists/edit_shift_time.dart';
import 'package:SMP/user_by_roles/admin/security-lists/security-lists.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/loader.dart';
// import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../presenter/navigator_lisitner.dart';
import '../../../utils/size_utility.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;

class ViewSecurity extends StatefulWidget {
  ViewSecurity({
    super.key,
    required this.securityId,
    required this.userName,
    required this.emailId,
    required this.mobile,
    required this.age,
    required this.state,
    required this.address,
    required this.pinCode,
    required this.shiftStartTime,
    required this.shiftEndTime,
    required this.gender,
    required this.securityImage,
    required this.apartmentId,
    required this.status,
    required this.baseImageIssueApi,
    required this.navigatorListener,
  });

  int securityId;
  int apartmentId;
  String status;
  String userName;
  String age;
  String state;
  String gender;
  String securityImage;
  String baseImageIssueApi;
  String emailId;
  String mobile;
  String address;
  String pinCode;
  String shiftStartTime;
  String shiftEndTime;
  NavigatorListener navigatorListener;

  @override
  State<ViewSecurity> createState() {
    return _ViewSecurity();
  }
}

class _ViewSecurity extends State<ViewSecurity>
    with ApiListener, NavigatorListener {
  final _formKey = GlobalKey<FormState>();
  final screenshotController = ScreenshotController();

  bool _isNetworkConnected = false, _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var _enteredEmailId = '';
  var _enteredMobile = '';
  var _enteredLandline = '';
  var _enteredHospitalName = '';
  var _enteredAddress2 = '';
  var _enteredAddress1 = '';
  var _enteredState = '';
  var _enteredPincode = '';
  var _enteredCountry = '';
  int fileCount = 0;
  final TextEditingController _controllershiftEndTime = TextEditingController();
  String initialShiftStartTime = '';

  bool showEdit = false;
  bool showDuration = false;
  int apartmentId = 0;
  int securityId = 0;
  String fullName = '';
  String age = '';
  String state = '';
  String pinCode = '';
  String address = '';
  String emailId = '';
  String shiftEndTime = '';
  String shiftStartTime = '';
  String mobile = '';
  String gender = '';
  String imageUrl = '';
  String status = '';
  String baseImageIssueApi = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();
    _getRoles();

    apartmentId = widget.apartmentId;
    securityId = widget.securityId;
    imageUrl = widget.securityImage;
    fullName = widget.userName;
    age = widget.age;
    state = widget.state;
    baseImageIssueApi = widget.baseImageIssueApi;
    pinCode = widget.pinCode;
    shiftEndTime = widget.shiftEndTime;
    emailId = widget.emailId;
    address = widget.address;
    shiftStartTime = widget.shiftStartTime;
    status = widget.status;
    _controllershiftEndTime.text = widget.shiftStartTime;
    mobile = widget.mobile;
    gender = widget.gender;
    calculateDuration(shiftStartTime, shiftEndTime);
  }

  String userType = '';

  Future<void> _getRoles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final roles = prefs.getString('roles');
    setState(() {
      userType = roles!;
    });
  }

  int counterValue = 0;

  void calculateDuration(String startTime, String endTime) {
    print("StartTime $startTime");
    print("EndTime $endTime");

    // Define date format for time with AM/PM indicator
    DateFormat formatWithAMPM = DateFormat("h:mm a");

    DateTime? start;
    DateTime? end;
    Duration? duration;

    try {
      start = formatWithAMPM.parse(startTime);
      end = formatWithAMPM.parse(endTime);
    } catch (e) {
      print("Error parsing time: $e");
      // Handle parsing error
    }

    if (start != null && end != null) {
      duration = end.difference(start);
      double hours = duration.inMinutes / 60;

      print(hours);

      int roundedHours = hours.round();
      setState(() {
        if (roundedHours < 0) {
          roundedHours = 24 + roundedHours;
        }
        counterValue = roundedHours;
      });

      print("Duration: ${hours.toStringAsFixed(2)}");
    } else {
      // Handle case where start or end time is null
      print("Invalid start or end time.");
    }
  }

  void calculateEndTime(String startTime) {
    print("StartTime $startTime");

    DateFormat formatWithoutAMPM = DateFormat("HH:mm");

    DateFormat formatWithAMPM = DateFormat("h:mm a");

    DateTime start;
    if (startTime.isNotEmpty) {
      if (startTime.contains("AM") || startTime.contains("PM")) {
        start = formatWithAMPM.parse(startTime);
      } else {
        start = formatWithoutAMPM.parse(startTime);
      }

      Duration duration = Duration(hours: 8);

      DateTime end = start.add(duration);

      String formattedEndTime = formatWithAMPM.format(end);

      print("End Time: $formattedEndTime");
    }
  }

  getTime() {
    print(shiftStartTime);
    print(shiftEndTime);
  }

  void editUserChoice() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSecurityShiftTime(
          securityId: widget.securityId,
          shiftStartTime: widget.shiftStartTime,
          shiftEndTime: widget.shiftEndTime,
        ),
      ),
    );
  }

  void editUserChoice1() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EditSecurity(
          securityId: widget.securityId,
          userName: widget.userName,
          securityImage: widget.securityImage,
          mobile: widget.mobile,
          emailId: widget.emailId,
          age: widget.age,
          state: widget.state,
          address: widget.address,
          pinCode: widget.pinCode,
          shiftStartTime: widget.shiftStartTime,
          shiftEndTime: widget.shiftEndTime,
          gender: widget.gender,
          apartmentId: widget.apartmentId,
          baseImageIssueApi: widget.baseImageIssueApi,
          navigatorListener: widget.navigatorListener,
        ),
      ),
    );
  }

  String? _enteredAdmittedDate;
  String? _enteredDichargedDate;

  DateTime currentDate = DateTime.now();

  void _showTimePicker(BuildContext context) async {
    DateTime now = DateTime.now();
    setState(() {
      initialShiftStartTime = shiftStartTime;
      print('initialShiftStartTime : ${initialShiftStartTime}');
    });

    DatePicker.showTime12hPicker(
      context,
      theme: picker.DatePickerTheme(
        containerHeight: 210.0,
      ),
      showTitleActions: true,
      onConfirm: (time) {
        print('confirm $time');
        int hour = time.hour;
        String period = 'AM'; // Default to AM
        if (hour >= 12) {
          period = 'PM';
          hour = hour == 12 ? 12 : hour - 12;
        }
        hour = hour == 0 ? 12 : hour;

        String minutes = time.minute.toString().padLeft(2, '0');
        shiftStartTime = '$hour:$minutes $period';
        print('shiftStartTime after confirm : $shiftStartTime');
        (context as Element).markNeedsBuild();
        setState(() {
          showDuration = true;
        });
        print(
            "setEndTimeWithDefaultDuration method called with start time: $shiftStartTime");
        setEndTimeWithDefaultDuration(shiftStartTime);
        Utils.printLog('shiftStartTime : $shiftStartTime');
      },
      currentTime: DateTime(now.year, now.month, now.day, now.hour + 2),
      locale: picker.LocaleType.en,
    );
    (context as Element).markNeedsBuild();
  }

  void setEndTimeWithDefaultDuration(String startTime) {
    // Define date format for time with AM/PM indicator
    DateFormat formatWithAMPM = DateFormat("h:mm a");

    // Parse start time into a DateTime object
    DateTime start = formatWithAMPM.parse(startTime);

    DateTime end = start.add(Duration(hours: 8));
    print(' DateTime end :${start.add(Duration(hours: 8))}');
    String endFormatted = formatWithAMPM.format(end);

    setState(() {
      shiftEndTime = endFormatted;
      Utils.printLog('shiftEndTime : ${shiftEndTime}');
      counterValue = 8;
    });
  }

  void updateShiftEndTime() {
    Utils.printLog('shiftStartTime : ${shiftStartTime}');
    int hour = int.parse(shiftStartTime.split(':')[0]);
    Utils.printLog('hour after spliting : ${hour}');
    int minute = int.parse(shiftStartTime.split(':')[1].split(' ')[0]);
    Utils.printLog('minute after spliting : ${minute}');
    String period = shiftStartTime.split(' ')[1];
    Utils.printLog('peroid after spliting : ${period}');
    int duration = counterValue * 60;
    minute += duration;
    hour += minute ~/ 60;
    minute %= 60;

    // Adjust the period if necessary
    if (hour >= 12) {
      period = 'PM';
      if (hour > 12) {
        hour -= 12;
      }
    } else {
      period = 'AM';
      if (hour == 0) {
        hour = 12;
      }
    }

    shiftEndTime =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  Future<void> getPdf() async {
    setState(() {
      _isLoading = true;
    });
    final Uint8List? imageBytes = await screenshotController.capture();
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Center(
            child:
                pw.Image(pw.MemoryImage(imageBytes!), fit: pw.BoxFit.contain),
          );
        },
      ),
    );
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    if (statuses[Permission.storage]!.isGranted) {
      var documents;
      if (Utils.showBackButton) {
        documents = (await getApplicationDocumentsDirectory())
            .absolute
            .path; // Await the result here
      } else {
        Directory dir = Directory('/storage/emulated/0/Download');
        documents = dir?.path;
      }
      if (documents != null) {
        String savename = "Smp_${fileCount}.pdf";
        String savePath = "${documents}/${savename}";
        print(savePath);
        final file = File(savePath);
        await file.writeAsBytes(await pdf.save());
        setState(() {
          fileCount++;
        });
        setState(() {
          _isLoading = false;
        });
        print('File downloaded successfully: $savePath');
        Utils.showSuccessToast(Strings.FILE_DOWNLOAD_SUCCESS);
      } else {
        Utils.showErrorToast(Strings.FILE_DOWNLOAD_PATH_ERROR);
        print('Error getting download path');
      }
    } else {
      Utils.showErrorToast(Strings.FILE_DOWNLOAD_PERMISSION_ERROR);
      print('Storage permission not granted');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageContent = GestureDetector(
      child: const AvatarScreen(),
    );

    if (imageUrl!.isNotEmpty) {
      imageContent = GestureDetector(
        child: Container(
          decoration: BoxDecoration(),
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
                  const AvatarScreen()
              ],
            ),
          ),
        ),
      );
    }

    TextStyle headerLeftTitle = TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.04,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      color: const Color(0xff1B5694),
    );

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: Strings.VIEW_SECURITY_HEADER,
            profile: () {
              Navigator.of(context).push(createRoute(const UserProfile()));
            },
          ),
        ),
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
                        child: Screenshot(
                          controller: screenshotController,
                          child: Column(
                            children: [
                              SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                              Container(
                                height: FontSizeUtil.CONTAINER_SIZE_100,
                                width: FontSizeUtil.CONTAINER_SIZE_100,
                                alignment: Alignment.center,
                                child: imageContent,
                              ),
                              Card(
                                margin: EdgeInsets.all(
                                    FontSizeUtil.CONTAINER_SIZE_15),
                                shadowColor: Colors.blueGrey,
                                child: Container(
                                  decoration: AppStyles.decoration(context),
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        FontSizeUtil.CONTAINER_SIZE_10),
                                    child: Form(
                                      key: _formKey,
                                      child: Table(
                                        columnWidths: const {
                                          0: FlexColumnWidth(2),
                                          1: FlexColumnWidth(3),
                                          // 2: FlexColumnWidth(4),
                                        },
                                        children: <TableRow>[
                                          TableRow(
                                            children: <Widget>[
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: FontSizeUtil
                                                          .CONTAINER_SIZE_18,
                                                      left:
                                                          FontSizeUtil.SIZE_05),
                                                  child: Text(
                                                      Strings
                                                          .SECURITY_NAME_LABEL,
                                                      style: headerLeftTitle),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: FontSizeUtil
                                                          .CONTAINER_SIZE_18,
                                                      left:
                                                          FontSizeUtil.SIZE_05),
                                                  child: Text(
                                                    fullName,
                                                    style: AppStyles.blockText(
                                                        context),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: FontSizeUtil
                                                          .CONTAINER_SIZE_28,
                                                      left:
                                                          FontSizeUtil.SIZE_05),
                                                  child: Text(
                                                      Strings
                                                          .SECURITY_MOBILE_LABEL,
                                                      style: headerLeftTitle),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: FontSizeUtil
                                                          .CONTAINER_SIZE_28,
                                                      left:
                                                          FontSizeUtil.SIZE_05),
                                                  child: Text(mobile,
                                                      style:
                                                          AppStyles.blockText(
                                                              context)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: FontSizeUtil
                                                          .CONTAINER_SIZE_28,
                                                      left:
                                                          FontSizeUtil.SIZE_05),
                                                  child: Text(
                                                      Strings
                                                          .SECURITY_EMAIL_ID_LABEL,
                                                      style: headerLeftTitle),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: FontSizeUtil
                                                          .CONTAINER_SIZE_28,
                                                      left:
                                                          FontSizeUtil.SIZE_05),
                                                  child: Text(emailId,
                                                      style:
                                                          AppStyles.blockText(
                                                              context)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: FontSizeUtil
                                                          .CONTAINER_SIZE_28,
                                                      left:
                                                          FontSizeUtil.SIZE_05),
                                                  child: Text(
                                                      Strings
                                                          .SECURITY_ADDRESS_LABEL,
                                                      style: headerLeftTitle),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: FontSizeUtil
                                                          .CONTAINER_SIZE_28,
                                                      left:
                                                          FontSizeUtil.SIZE_05),
                                                  child: Text(address,
                                                      style:
                                                          AppStyles.blockText(
                                                              context)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: FontSizeUtil
                                                          .CONTAINER_SIZE_28,
                                                      left:
                                                          FontSizeUtil.SIZE_05),
                                                  child: Text(
                                                      Strings
                                                          .SECURITY_AGE_LABEL,
                                                      style: headerLeftTitle),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: FontSizeUtil
                                                          .CONTAINER_SIZE_28,
                                                      left:
                                                          FontSizeUtil.SIZE_05),
                                                  child: Text(age,
                                                      style:
                                                          AppStyles.blockText(
                                                              context)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: FontSizeUtil
                                                          .CONTAINER_SIZE_28,
                                                      left:
                                                          FontSizeUtil.SIZE_05),
                                                  child: Text(
                                                      Strings
                                                          .SECURITY_STATE_LABEL,
                                                      style: headerLeftTitle),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: FontSizeUtil
                                                          .CONTAINER_SIZE_28,
                                                      left:
                                                          FontSizeUtil.SIZE_05),
                                                  child: Text(state,
                                                      style:
                                                          AppStyles.blockText(
                                                              context)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: FontSizeUtil
                                                          .CONTAINER_SIZE_28,
                                                      left:
                                                          FontSizeUtil.SIZE_05),
                                                  child: Text(
                                                      Strings
                                                          .SECURITY_PINCODE_LABEL,
                                                      style: headerLeftTitle),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: FontSizeUtil
                                                          .CONTAINER_SIZE_28,
                                                      left:
                                                          FontSizeUtil.SIZE_05),
                                                  child: Text(pinCode,
                                                      style:
                                                          AppStyles.blockText(
                                                              context)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: FontSizeUtil
                                                          .CONTAINER_SIZE_28,
                                                      left:
                                                          FontSizeUtil.SIZE_05),
                                                  child: Text(
                                                      Strings
                                                          .SECURITY_STATUS_LABEL,
                                                      style: headerLeftTitle),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: FontSizeUtil
                                                          .CONTAINER_SIZE_28,
                                                      left:
                                                          FontSizeUtil.SIZE_05),
                                                  child: Text(
                                                      status
                                                              .substring(0, 1)
                                                              .toUpperCase() +
                                                          status
                                                              .substring(1)
                                                              .toLowerCase(),
                                                      style:
                                                          AppStyles.blockText(
                                                              context)),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: <Widget>[
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: FontSizeUtil
                                                          .CONTAINER_SIZE_28,
                                                      left:
                                                          FontSizeUtil.SIZE_05),
                                                  child: Text(
                                                      Strings
                                                          .SHIFT_END_TIME_TEXT,
                                                      style: headerLeftTitle),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: FontSizeUtil
                                                          .CONTAINER_SIZE_28,
                                                      left:
                                                          FontSizeUtil.SIZE_05),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            if (showEdit) {
                                                              _showTimePicker(
                                                                  context);
                                                            }
                                                          },
                                                          child: Text(
                                                              shiftStartTime,
                                                              style: AppStyles
                                                                  .blockText(
                                                                      context)),
                                                        ),
                                                      ),
                                                      if (showEdit)
                                                        Container(
                                                          decoration:
                                                              AppStyles.circle1(
                                                                  context),
                                                          child: InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                showEdit =
                                                                    false;
                                                              });
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .all(FontSizeUtil
                                                                      .SIZE_03),
                                                              child: const Icon(
                                                                Icons
                                                                    .cancel_outlined,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      SizedBox(
                                                          width: FontSizeUtil
                                                              .CONTAINER_SIZE_10),
                                                      if (!showEdit &&
                                                          userType ==
                                                              "ROLE_ADMIN")
                                                        Container(
                                                          decoration:
                                                              AppStyles.circle1(
                                                                  context),
                                                          child: InkWell(
                                                            onTap: () {
                                                              _showTimePicker(
                                                                  context);
                                                              setState(() {
                                                                showEdit =
                                                                    !showEdit;
                                                              });
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .all(FontSizeUtil
                                                                      .SIZE_03),
                                                              child: const Icon(
                                                                Icons.edit,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      SizedBox(
                                                          width: FontSizeUtil
                                                              .CONTAINER_SIZE_10),
                                                      if (showEdit)
                                                        Container(
                                                          decoration: AppStyles
                                                              .circleGreen(
                                                                  context),
                                                          child: InkWell(
                                                            onTap: () {
                                                              if (counterValue >
                                                                      0 &&
                                                                  initialShiftStartTime !=
                                                                      shiftStartTime) {
                                                                _updateShiftTime();
                                                                setState(() {
                                                                  showDuration =
                                                                      false;
                                                                });
                                                              } else {
                                                                Utils.showToast(
                                                                    Strings
                                                                        .SELECT_SHIFT_TIME_WARNING);
                                                              }
                                                            },
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .all(FontSizeUtil
                                                                      .SIZE_03),
                                                              child: const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (showDuration)
                                            TableRow(
                                              children: <Widget>[
                                                TableCell(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: FontSizeUtil
                                                            .CONTAINER_SIZE_33,
                                                        left: FontSizeUtil
                                                            .SIZE_05),
                                                    child: Text(
                                                      Strings
                                                          .ADJUCT_DURATION_LABEL,
                                                      style: headerLeftTitle,
                                                    ),
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      top: FontSizeUtil
                                                          .CONTAINER_SIZE_18,
                                                    ),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          height: FontSizeUtil
                                                              .CONTAINER_HEGIHT_SIZE,
                                                          width: FontSizeUtil
                                                              .CONTAINER_WIDTH_SIZE,
                                                          decoration: AppStyles
                                                              .decoration(
                                                                  context),
                                                          child: IconButton(
                                                            icon: const Icon(
                                                                Icons.remove),
                                                            onPressed: () {
                                                              setState(() {
                                                                if (counterValue >
                                                                    0) {
                                                                  counterValue--;
                                                                  updateShiftEndTime();
                                                                } else {
                                                                  Utils.showToast(
                                                                      Strings
                                                                          .SHIFT_DURATION_LESS_ERROR_LABEL);
                                                                }
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .all(FontSizeUtil
                                                                  .CONTAINER_SIZE_15),
                                                          child: Text(
                                                            '$counterValue',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    FontSizeUtil
                                                                        .CONTAINER_SIZE_16),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: FontSizeUtil
                                                              .CONTAINER_HEGIHT_SIZE,
                                                          width: FontSizeUtil
                                                              .CONTAINER_WIDTH_SIZE,
                                                          decoration: AppStyles
                                                              .decoration(
                                                                  context),
                                                          child: IconButton(
                                                            icon: const Icon(
                                                                Icons.add),
                                                            onPressed: () {
                                                              setState(() {
                                                                if (counterValue <
                                                                    12) {
                                                                  counterValue++;
                                                                  updateShiftEndTime();
                                                                } else {
                                                                  Utils.showToast(
                                                                      Strings
                                                                          .SHIFT_DURATION_MORE_ERROR_LABEL);
                                                                }
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          TableRow(
                                            children: <Widget>[
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: FontSizeUtil
                                                          .CONTAINER_SIZE_28,
                                                      left:
                                                          FontSizeUtil.SIZE_05),
                                                  child: Text(
                                                      Strings
                                                          .SHIFT_END_TIME_LABEL,
                                                      style: headerLeftTitle),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      top: FontSizeUtil
                                                          .CONTAINER_SIZE_33,
                                                      bottom:
                                                          FontSizeUtil.SIZE_05,
                                                      left:
                                                          FontSizeUtil.SIZE_05),
                                                  child: Text(shiftEndTime,
                                                      style:
                                                          AppStyles.blockText(
                                                              context)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: FontSizeUtil.CONTAINER_SIZE_20),
                              if (userType == Strings.ROLEADMIN_1)
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xff1B5694),
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                FontSizeUtil.CONTAINER_SIZE_15),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                FontSizeUtil.CONTAINER_SIZE_25,
                                            vertical:
                                                FontSizeUtil.CONTAINER_SIZE_15,
                                          ),
                                        ),
                                        onPressed: () {
                                          editUserChoice1();
                                        },
                                        child: const Text(
                                          Strings.EDIT_PROFILE_BTN_TEXT,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              SizedBox(height: FontSizeUtil.CONTAINER_SIZE_20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const FooterScreen(),
                  ],
                ),
              ),
              if (_isLoading) const Positioned(child: LoadingDialog()),
            ],
          ),
        ),
        floatingActionButton: userType == "ROLE_ADMIN"
            ? Padding(
                padding: EdgeInsets.only(
                    bottom: FontSizeUtil.CONTAINER_SIZE_50,
                    left: FontSizeUtil.CONTAINER_SIZE_50),
                child: FloatingActionButton(
                  onPressed: getPdf,
                  backgroundColor: const Color(0xff1B5694),
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.picture_as_pdf),
                ),
              )
            : Container(),
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
          String startTime = shiftStartTime;
          String endTime = shiftEndTime;
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
    if (status == 401) {
      Utils.sessonExpired(context);
    } else {
      Utils.showToast(Strings.API_ERROR_MSG_TEXT);
    }
  }

  @override
  onSuccess(response, String responseType) async {
    try {
      setState(() {
        _isLoading = false;
        if (responseType == 'editShiftTime') {
          ResponceModel responceModel =
              ResponceModel.fromJson(json.decode(response));
          if (responceModel.status == "success") {
            successDialogWithListner(
                context, responceModel.message!, SecurityLists(), this);
          }
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Utils.printLog("Error text === $response");
    }
  }

  @override
  onNavigatorBackPressed() {
    Navigator.pop(context);
    widget.navigatorListener!.onNavigatorBackPressed();
  }
}
