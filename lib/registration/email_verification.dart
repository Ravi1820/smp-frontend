import 'dart:convert';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/login.dart';
import 'package:SMP/model/movies.dart';
import 'package:SMP/model/responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/appartment_data_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/registration/existing_resident_otp.dart';
import 'package:SMP/registration/new_owner_registration.dart';
import 'package:SMP/registration/waiting_for_approval.dart';
import 'package:SMP/user_by_roles/admin/select_details/apartment_list.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/loader.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:SMP/widget/footers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExistingOwnerEmailRegistrationScreen extends StatefulWidget {
  const ExistingOwnerEmailRegistrationScreen({super.key});

  @override
  State<ExistingOwnerEmailRegistrationScreen> createState() {
    return _ExistingOwnerEmailRegistrationScreenState();
  }
}

class _ExistingOwnerEmailRegistrationScreenState
    extends State<ExistingOwnerEmailRegistrationScreen>
    with ApiListener, AppartmentDataListener {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showErrorMessage = false;
  final _formKey = GlobalKey<FormState>();
  var _enteredEmail = '';
  String? _selectedHospitalId;
  bool _isLoading = false;
  bool _isNetworkConnected = false, isLoading = true;
  int? selectedApartmentId;
  String? selectedApartmentName;
  bool showEmailErrorMessage = false;
  List apartmentList = [];

  @override
  void initState() {
    super.initState();
  }

  bool isValidEmail(String email) {
    const pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  @override
  Widget build(context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AbsorbPointer(
        absorbing: _isLoading,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: keyboardHeight),
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
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: FontSizeUtil.CONTAINER_SIZE_35,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.23),
                      const Text(
                        Strings.VERIFY_ACCPUNT_TEXT,
                        style: TextStyle(
                          color: Color.fromRGBO(27, 86, 148, 1.0),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: FontSizeUtil.CONTAINER_SIZE_30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: Strings.CHOOSE_APARTMENT_TEXT,
                                  style: TextStyle(
                                    color: Color.fromRGBO(27, 86, 148, 1.0),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 0, 0, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();

                                  // Clear apartment data
                                  prefs.remove("selectedApartmentName");
                                  prefs.remove("selectedApartmentId");

                                  // Clear block data
                                  prefs.remove("selectedBlockName");
                                  prefs.remove("selectedBlockId");

                                  // Clear floor data
                                  prefs.remove("selectedFloorName");
                                  prefs.remove("selectedFloorId");

                                  Navigator.of(context).push(createRoute(
                                      AprtmentList(dataListener: this)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        FontSizeUtil.CONTAINER_SIZE_10),
                                    boxShadow: const [
                                      BoxShadow(
                                        color:
                                            Color.fromARGB(255, 100, 100, 100),
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  height: FontSizeUtil.CONTAINER_SIZE_50,
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(
                                            FontSizeUtil.CONTAINER_SIZE_10),
                                        child: selectedApartmentName != null
                                            ? Text(
                                                selectedApartmentName!,
                                                style: TextStyle(
                                                    fontSize: FontSizeUtil
                                                        .CONTAINER_SIZE_16),
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            : Text(
                                                Strings
                                                    .CHOOSE_APARTMENT_PLACEHOLDER,
                                                style: TextStyle(
                                                    fontSize: FontSizeUtil
                                                        .CONTAINER_SIZE_16),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: FontSizeUtil.SIZE_08),
                                        child: const Icon(
                                          Icons.arrow_forward,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                          const Text(
                            Strings.EMAIL_ID_LABEL,
                            style: TextStyle(
                              color: Color.fromRGBO(27, 86, 148, 1.0),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      FontSizeUtil.CONTAINER_SIZE_10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 100, 100, 100),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                height: FontSizeUtil.CONTAINER_SIZE_55,
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(color: Colors.black87),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        top: FontSizeUtil.CONTAINER_SIZE_15),
                                    prefixIcon: const Icon(
                                      Icons.mail,
                                      color: Color(0xff4d004d),
                                    ),
                                    hintText: 'Email Id',
                                    hintStyle: TextStyle(color: Colors.black38),
                                  ),
                                  onChanged: (value) {
                                    if (isValidEmail(value)) {
                                      setState(() {
                                        showEmailErrorMessage = false;
                                      });
                                    } else {
                                      setState(() {
                                        showEmailErrorMessage = true;
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    if (value == null ||
                                        !value.contains('@') ||
                                        value.isEmpty ||
                                        value.trim().length > 50) {
                                      setState(() {
                                        showEmailErrorMessage = true;
                                      });
                                    } else {
                                      setState(() {
                                        showEmailErrorMessage = false;
                                      });
                                      return null;
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _enteredEmail = value!;
                                  },
                                ),
                              ),
                            ],
                          ),
                          if (showEmailErrorMessage)
                            Text(
                              Strings.EMAIL_ADDRESS_ERROR_TEXT,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: FontSizeUtil.CONTAINER_SIZE_15),
                            ),
                          SizedBox(height: FontSizeUtil.CONTAINER_SIZE_10),
                        ],
                      ),
                      SizedBox(height: FontSizeUtil.CONTAINER_SIZE_30),
                      Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: FontSizeUtil.CONTAINER_SIZE_25,
                                horizontal: FontSizeUtil.CONTAINER_SIZE_50),
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _isLoading = false;
                                });
                                FocusScope.of(context).unfocus();

                                if (_formKey.currentState!.validate() &&
                                    showEmailErrorMessage == false &&
                                    selectedApartmentId != null) {
                                  _formKey.currentState!.save();

                                  _verifyEmailData();
                                } else {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  errorAlert(
                                    context,
                                    Strings.ALERT_ERROR,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff1B5694),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      FontSizeUtil.CONTAINER_SIZE_15),
                                ),
                                padding: EdgeInsets.all(
                                    FontSizeUtil.CONTAINER_SIZE_15),
                              ),
                              child: const Text(
                                Strings.VERIFY_EMAIL_TEXT,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: FontSizeUtil.CONTAINER_SIZE_90),
                    ],
                  ),
                ),
              ),
            ),
            if (_isLoading) const Positioned(child: LoadingDialog()),
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
    );
  }

  void _verifyEmailData() {
    Utils.getNetworkConnectedStatus().then((status) {
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        print(_isNetworkConnected);
        if (_isNetworkConnected) {
          _isLoading = true;
          String responseType = "verifyEmail";

          String loginURL =
              '${Constant.verifyEmailURL}?email=$_enteredEmail&apartmentId=$selectedApartmentId';

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
  onSuccess(response, responseType) async {
    Utils.printLog("text === $response");

    try {
      if (responseType == 'email') {
        List<ApartmentModel> movieList = (json.decode(response) as List)
            .map((item) => ApartmentModel.fromJson(item))
            .toList();

        setState(() {
          apartmentList = movieList;
        });
      } else if (responseType == 'verifyEmail') {
        ResponceModel responceModel =
            ResponceModel.fromJson(json.decode(response));
        if (responceModel.status == "rejected") {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                contentPadding:  EdgeInsets.only(top: FontSizeUtil.CONTAINER_SIZE_10, right: FontSizeUtil.CONTAINER_SIZE_10),
                content: Stack(
                  children: <Widget>[
                    Container(
                      padding:  EdgeInsets.only(
                        top: FontSizeUtil.CONTAINER_SIZE_18,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_16),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 0.0,
                            offset: Offset(0.0, 0.0),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                           Icon(
                            Icons.error,
                            size: FontSizeUtil.CONTAINER_SIZE_65,
                            color: Colors.red,
                          ),
                           SizedBox(height: FontSizeUtil.CONTAINER_SIZE_30),
                          Text(
                            responceModel.message!,
                            style:  TextStyle(
                              color:const Color.fromRGBO(27, 86, 148, 1.0),
                              fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: FontSizeUtil.CONTAINER_SIZE_20,
                            width: FontSizeUtil.SIZE_05,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: FontSizeUtil.CONTAINER_SIZE_30,
                                child: ElevatedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_20),
                                      side: const BorderSide(
                                        width: 1,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: FontSizeUtil.CONTAINER_SIZE_15,
                                      vertical: 0,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);

                                    Navigator.of(context).push(createRoute(
                                      NewOwnerRegistrationScreen(
                                          emailId: _enteredEmail),
                                    ));
                                  },
                                  child: const Text(Strings.YES_TEXT),
                                ),
                              ),
                               SizedBox(
                                width: FontSizeUtil.CONTAINER_SIZE_10,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: FontSizeUtil.CONTAINER_SIZE_20,
                            width: FontSizeUtil.SIZE_05,
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
                        child:  Align(
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.close,
                            size: FontSizeUtil.CONTAINER_SIZE_25,
                            color:const Color(0xff1B5694),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else if (responceModel.status == "error") {
          if (responceModel.message == "You have already registered") {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  contentPadding: EdgeInsets.only(top: FontSizeUtil.CONTAINER_SIZE_10, right:FontSizeUtil.CONTAINER_SIZE_10),
                  content: Container(
                    margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding:  EdgeInsets.only(
                            top: FontSizeUtil.CONTAINER_SIZE_18,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_16),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 0.0,
                                offset: Offset(0.0, 0.0),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                               Icon(
                                Icons.warning,
                                size: FontSizeUtil.CONTAINER_SIZE_65,
                                color: Colors.orange,
                              ),
                               SizedBox(height: FontSizeUtil.CONTAINER_SIZE_30),
                              Text(
                                responceModel.message!,
                                style:  TextStyle(
                                  color:const Color.fromRGBO(27, 86, 148, 1.0),
                                  fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: FontSizeUtil.CONTAINER_SIZE_20,
                                width: FontSizeUtil.SIZE_05,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: FontSizeUtil.CONTAINER_SIZE_30,
                                    child: ElevatedButton(
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_20),
                                          side: const BorderSide(
                                            width: 1,
                                          ),
                                        ),
                                        padding:  EdgeInsets.symmetric(
                                          horizontal: FontSizeUtil.CONTAINER_SIZE_15,
                                          vertical: 0,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.of(context).push(createRoute(
                                          const LoginScreen(),
                                        ));
                                      },
                                      child: const Text(Strings.LOGIN_TEXT),
                                    ),
                                  ),
                                   SizedBox(
                                    width: FontSizeUtil.CONTAINER_SIZE_10,
                                  ),
                                ],
                              ),
                               SizedBox(
                                height: FontSizeUtil.CONTAINER_SIZE_20,
                                width: FontSizeUtil.SIZE_05,
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
                            child:  Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                Icons.close,
                                size: FontSizeUtil.CONTAINER_SIZE_25,
                                color:const Color(0xff1B5694),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  contentPadding:  EdgeInsets.only(top: FontSizeUtil.CONTAINER_SIZE_10, right: FontSizeUtil.CONTAINER_SIZE_10),
                  content: Container(
                    margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding:  EdgeInsets.only(
                            top: FontSizeUtil.CONTAINER_SIZE_18,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_16),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 0.0,
                                offset: Offset(0.0, 0.0),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              const Icon(
                                Icons.error,
                                size: 64,
                                color: Colors.red,
                              ),
                              SizedBox(height: FontSizeUtil.CONTAINER_SIZE_30),

                               Text(
                                Strings.NOT_VALID_USER_TEXT,
                                style: TextStyle(
                                  color:const Color.fromRGBO(27, 86, 148, 1.0),
                                  fontSize: FontSizeUtil.CONTAINER_SIZE_16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                               SizedBox(
                                height:FontSizeUtil.CONTAINER_SIZE_20,
                                width: FontSizeUtil.SIZE_05,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: FontSizeUtil.CONTAINER_SIZE_30,
                                    child: ElevatedButton(
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_20),
                                          side: const BorderSide(
                                            width: 1,
                                          ),
                                        ),
                                        padding:  EdgeInsets.symmetric(
                                          horizontal: FontSizeUtil.CONTAINER_SIZE_15,

                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);

                                        Navigator.of(context).push(createRoute(
                                          NewOwnerRegistrationScreen(
                                              emailId: _enteredEmail),
                                        ));
                                      },
                                      child: const Text(Strings.YES_TEXT),
                                    ),
                                  ),
                                   SizedBox(
                                    width: FontSizeUtil.CONTAINER_SIZE_10,
                                  ),
                                ],
                              ),
                               SizedBox(
                                height: FontSizeUtil.CONTAINER_SIZE_20,
                                width: FontSizeUtil.SIZE_05,
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
                            child:  Align(
                              alignment: Alignment.topRight,
                              child: Icon(
                                Icons.close,
                                size: FontSizeUtil.CONTAINER_SIZE_25,
                                color:const Color(0xff1B5694),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        } else {
          Navigator.of(context).push(createRoute(
            ExistingOwnerRegistrationOTPScreen(
              userId: responceModel.userId!,
              apartmentId: selectedApartmentId,
              emailId: _enteredEmail,
            ),
          ));
        }
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      print("Error parsing JSON: $error");
    }
  }

  @override
  onBackPressed() {
    // _getApartmentId();

    // Navigator.pop(context);
    // TODO: implement onBackPressed
    // throw UnimplementedError();
  }

  @override
  onDataClicked(id, name, available, dataType) {
    setState(() {
      if (dataType == Strings.APPARTMENT_NAME) {
        selectedApartmentName = name;
        selectedApartmentId = id;
      }
      // if (dataType == Strings.BLOCK_NAME) {
      //   selectedBlockName = name;
      //   selectedBlockId = id;
      // }
      // if (dataType == Strings.FLOOR_NAME) {
      //   selectedFloorName = name;
      //   selectedFloorId = id;
      // }
    });
    // TODO: implement onDataClicked
    // throw UnimplementedError();
  }
}
