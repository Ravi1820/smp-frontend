//

import 'dart:convert';

import 'package:SMP/contants/base_api.dart';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/model/payment_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocietyDuesScreen extends StatefulWidget {
  SocietyDuesScreen({
    super.key,
    required this.feesId,
    required this.feesName,
  });

  int feesId;
  String feesName;

  @override
  State<SocietyDuesScreen> createState() {
    return _SocietyDuesScreen();
  }
}

class _SocietyDuesScreen extends State<SocietyDuesScreen> with ApiListener {
  List paymentLists = [];
  bool _isNetworkConnected = false, _isLoading = true;

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    super.initState();
    _getNoticeList();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    TextStyle headerPlaceHolder = TextStyle(
        fontFamily: 'Roboto',
        fontSize: MediaQuery.of(context).size.width * 0.04,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w500,
        color: const Color(0xff1B5694));

    Widget content = Expanded(
        child: paymentLists.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView.builder(
                  itemCount: paymentLists.length,
                  itemBuilder: (context, index) {
                    final payment = paymentLists[index];
                    return GestureDetector(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Container(
                                  decoration: AppStyles.decoration(context),
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  "Month :",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: headerPlaceHolder,
                                                ),
                                                Text(
                                                  payment.month,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: AppStyles.heading1(
                                                      context),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Text(
                                                  "Amount :",
                                                  style: headerPlaceHolder,
                                                ),
                                                Text(
                                                  // "",
                                                  //  double.parse(payment.fineAmount).toString(),
                                                  payment.amount.toString(),
                                                  style: AppStyles.heading1(
                                                      context),
                                                ),
                                              ],
                                            ),
                                            // const SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Status :",
                                                      style: headerPlaceHolder,
                                                    ),
                                                    Text(
                                                      payment.paidStatus,
                                                      style: AppStyles.heading1(
                                                          context),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      print(baseImageIssueApis);
                                                      _showSoS(context, payment,
                                                          baseImageIssueApis);
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .only(
                                                              bottomLeft: Radius
                                                                  .circular(20),
                                                              topRight: Radius
                                                                  .circular(
                                                                      20)),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10,
                                                                vertical: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: const Text(
                                                          "Pay Now",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Due Date :",
                                                  style: headerPlaceHolder,
                                                ),
                                                Text(
                                                  DateFormat(
                                                          'y-MM-dd hh:mm:ss a')
                                                      .format(DateTime.parse(
                                                          payment.startDate)),
                                                  style: AppStyles.heading1(
                                                      context),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              payment.feesDescription,
                                              // "Kindly ensure to pay 3 business days (i.e., excluding Bank & Public Holidays) ahead of Due Date.",
                                              style:
                                                  AppStyles.bodyText(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            : Center(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'There are no dues',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff1B5694),
                    ),
                  ),
                ),
              ));

    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: widget.feesName,
          // menuOpen: () {
          //   _scaffoldKey.currentState!.openDrawer();
          // },
          profile: () => {
            Navigator.pop(context),
          },
        ),
      ),
      // drawer: const DrawerScreen(),
      body: AbsorbPointer(
        absorbing: _isLoading,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
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
                    child: Column(
                      children: <Widget>[content],
                    ),
                  ),
                  if (_isLoading) const Positioned(child: LoadingDialog()),
                ],
              ),
            ),
            const SizedBox(
              child: FooterScreen(),
            ),
          ],
        ),
      ),
    );
  }

  String? baseImageIssueApis = '';

  Future<void> _getNoticeList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     var id = prefs.getInt('id');
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        baseImageIssueApis = BaseApiImage.baseImageUrl(id!, "profile");

        print(baseImageIssueApis);
        _isNetworkConnected = status;

        if (_isNetworkConnected) {
          String responseType = "allPaymentList";
          var feesId = widget.feesId;

          String allNoticeURL =
              '${Constant.getAllResidentPaymentURL}?residentId=$id&feesTypeId=$feesId';

          NetworkUtils.getNetWorkCall(allNoticeURL, responseType, this);
        } else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
        }
        _isLoading = status;
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

        if (responseType == 'allPaymentList') {
          Utils.printLog("Success $response");
          List<PaymentModel> resolvedIssueList = (json.decode(response) as List)
              .map((item) => PaymentModel.fromJson(item))
              .toList();

          setState(() {
            paymentLists = resolvedIssueList;
          });
        }
      });
    } catch (error) {
      Utils.printLog("Error $response");

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSoS(BuildContext context, payment, baseImageIssueApi) {
    print(
        '$baseImageIssueApi${payment.apartment.paymentQrCodeImage.toString()}');
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(builder: (stfContext, stfSetState) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            content: Container(
              width: 350,
              decoration: AppStyles.decoration(stfContext),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Expanded(
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: Text(
                                  'QR Image',
                                  style: TextStyle(
                                    color: Color.fromRGBO(27, 86, 148, 1.0),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(stfContext).pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: AppStyles.circle1(context),
                                child: const Icon(
                                  Icons.close_sharp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            child: (payment
                                    .apartment.paymentQrCodeImage.isNotEmpty)
                                ? Image.network(
                                    '$baseImageIssueApi${payment.apartment.paymentQrCodeImage.toString()}',
                                    fit: BoxFit.cover,
                                    height: 100,
                                    width: 100,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        "assets/images/no-img.png",
                                        fit: BoxFit.cover,
                                        height: 100,
                                        width: 100,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    "assets/images/no-img.png",
                                    fit: BoxFit.fill,
                                    height: 100,
                                    width: 100,
                                  ),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            payment.apartment.upiId,
                            style: AppStyles.blockText(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}
