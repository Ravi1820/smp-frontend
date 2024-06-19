

import 'dart:convert';
import 'dart:io';

import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/model/inventory_model.dart';
import 'package:SMP/model/update_user_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/admin/inventory/get_goods_by_date.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/widget/drawer.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AddInventoryScreen extends StatefulWidget {
  AddInventoryScreen({super.key, required this.navigatorListener});

  NavigatorListener? navigatorListener;

  @override
  State<AddInventoryScreen> createState() {
    return _AddInventoryState();
  }
}

class _AddInventoryState extends State<AddInventoryScreen>
    with ApiListener, NavigatorListener {
  final _formKey = GlobalKey<FormState>();
  bool _isNetworkConnected = false, _isLoading = false;

  var _enterInventoryName = '';
  var _enterQuantity = '';

  int apartmentId = 0;
  int pinCode = 0;
  String? token = '';
  int? userId = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    _smpStorage();
  }


  void _smpStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var apartId = prefs.getInt('apartmentId');

    var id = prefs.getInt('id');

    setState(() {
      token = token!;
      apartmentId = apartId!;
      userId = id!;
    });
  }


  File? _selectedImage;


  void _takePicture() async {
    ImageSource? source = await Utils.takePicture(context);
    if (source != null) {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(source: source, maxWidth: 600);
      if (pickedFile != null) {
        setState(() {
          _selectedImage= File(pickedFile.path);
        });
      }
    }
  }

  bool showErrorMessage = false;
  bool showCategoryErrorMessage = false;
  bool showDescriptionErrorMessage = false;
  bool showDescriptionErrorMessage1 = false;

//  Colors.white;
  String? _selectedGender;
  String? _selectedPriority;
  String? _selectedCategory;

  final priority = ['Incoming', 'Outgoing'];
  final genders = ['General', 'Security', 'Maintenance'];
  // Color _containerBorderColor = Colors.white; // Added this line
  // Color _boxShadowColor = const Color.fromARGB(255, 100, 100, 100);
  Color _containerBorderColor1 = Colors.white; // Added this line
  Color _boxShadowColor1 = const Color.fromARGB(255, 100, 100, 100);

  Color _quantityBboxShadowColor = const Color.fromARGB(255, 100, 100, 100);

  Color _quantityBoxShadowColor1 = Colors.white;

  var _enteredPassword = '';

  DateTime currentDate = DateTime.now();

  String? _enteredAdmittedDate;
  String? _enteredDichargedDate;

  final TextEditingController _dichargeDateController = TextEditingController();

  final TextEditingController _admittedDateController = TextEditingController();

  Future<void> datePicker(BuildContext context, String type) async {
    DateTime? userSelectedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (userSelectedDate == null) {
      return;
    } else {
      TimeOfDay? userSelectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentDate),
      );

      if (userSelectedTime == null) {
        return;
      }

      DateTime selectedDateTime = DateTime(
        userSelectedDate.year,
        userSelectedDate.month,
        userSelectedDate.day,
        userSelectedTime.hour,
        userSelectedTime.minute,
      );

      String formattedDateTime =
          DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime);

      if (type == "Admitted Date") {
        setState(() {
          _enteredAdmittedDate = formattedDateTime;
          _dichargeDateController.text = _enteredAdmittedDate ?? '';
        });
      } else if (type == "Discharged Date") {
        setState(() {
          _enteredDichargedDate = formattedDateTime;
          _admittedDateController.text = _enteredDichargedDate ?? '';
        });
      }
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration = BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(255, 255, 255, 1),
          Color.fromRGBO(255, 255, 255, 1),
        ],
      ),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(1, 4),
        ),
      ],
    );
    Widget content = InkWell(
      onTap: _takePicture,
      child: Container(
        margin: const EdgeInsets.only(right: 10, top: 10),
        height: 100,
        width: 100,
        decoration: decoration,
        child: Center(
          child: Image.asset(
            'assets/images/Vector-1.png',
            height: 50,
            width: 50,
            color: const Color.fromRGBO(27, 86, 148, 1.0),
          ),
        ),
      ),
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Container(
          margin: const EdgeInsets.only(top: 10),
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 233, 162, 0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                _selectedImage!,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }


    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        // Navigator.of(context)
        //     .push(createRoute(DashboardScreen(isFirstLogin: false)));
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            title: 'Add Inventory',
            profile: () async {
              Navigator.of(context)
                  .push(createRoute(DashboardScreen(isFirstLogin: false)));
            },

          ),
        ),
        // drawer: const DrawerScreen(),
        body: AbsorbPointer(
          absorbing: _isLoading,
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Container(
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
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 10),
                        Card(
                          margin: const EdgeInsets.all(15),
                          shadowColor: Colors.blueGrey,
                          child: Container(
                            decoration: decoration,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Form(
                                key: _formKey,
                                child: Table(
                                  children: <TableRow>[
                                    TableRow(children: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start, // Align content to the start (left)

                                        children: [
                                          RichText(
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Inventory Name ',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        27, 86, 148, 1.0),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Stack(
                                            alignment: Alignment.centerLeft,
                                            children: <Widget>[
                                              FocusScope(
                                                child: Focus(
                                                  onFocusChange: (hasFocus) {
                                                    setState(() {
                                                      _containerBorderColor1 =
                                                          hasFocus
                                                              ? const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  0,
                                                                  137,
                                                                  250)
                                                              : Colors.white;
                                                      _boxShadowColor1 = hasFocus
                                                          ? const Color.fromARGB(
                                                              162, 63, 158, 235)
                                                          : const Color.fromARGB(
                                                              255, 100, 100, 100);
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: _boxShadowColor1,
                                                          blurRadius: 6,
                                                          offset:
                                                              const Offset(0, 2),
                                                        ),
                                                      ],
                                                      border: Border.all(
                                                        color:
                                                            _containerBorderColor1,
                                                      ),
                                                    ),
                                                    child: TextFormField(
                                                      scrollPadding:
                                                          EdgeInsets.only(
                                                              bottom: MediaQuery.of(
                                                                          context)
                                                                      .viewInsets
                                                                      .bottom *
                                                                  1.40),
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter.deny(Strings.EMOJI_DENY_REGEX)
                                                      ],
                                                      style: AppStyles.heading1(
                                                          context),
                                                      decoration:
                                                          const InputDecoration(
                                                        border: InputBorder.none,
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: 5, left: 20),
                                                        hintText:
                                                            'Enter inventory name',
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.black38),
                                                      ),
                                                      onChanged: (value) {
                                                        String? validationMessage;

                                                        if (value.isEmpty) {
                                                          validationMessage =
                                                              'name cannot be empty';
                                                        }
                                                        if (validationMessage !=
                                                            null) {
                                                          setState(() {
                                                            showDescriptionErrorMessage =
                                                                true;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            showDescriptionErrorMessage =
                                                                false;
                                                          });
                                                        }
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            showDescriptionErrorMessage =
                                                                true;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            showDescriptionErrorMessage =
                                                                false;
                                                          });
                                                          return null;
                                                        }
                                                      },
                                                      onSaved: (value) {
                                                        _enterInventoryName =
                                                            value!;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          if (showDescriptionErrorMessage)
                                            const Text(
                                              'Inventory is required',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15),
                                            ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ]),
                                    TableRow(children: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start, // Align content to the start (left)

                                        children: [
                                          RichText(
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Quantity ',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        27, 86, 148, 1.0),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Stack(
                                            alignment: Alignment.centerLeft,
                                            children: <Widget>[
                                              FocusScope(
                                                child: Focus(
                                                  onFocusChange: (hasFocus) {
                                                    setState(() {
                                                      _quantityBoxShadowColor1 =
                                                          hasFocus
                                                              ? const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  0,
                                                                  137,
                                                                  250)
                                                              : Colors.white;
                                                      _quantityBboxShadowColor =
                                                          hasFocus
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
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color:
                                                              _quantityBboxShadowColor,
                                                          blurRadius: 6,
                                                          offset:
                                                              const Offset(0, 2),
                                                        ),
                                                      ],
                                                      border: Border.all(
                                                        color:
                                                            _quantityBoxShadowColor1,
                                                      ),
                                                    ),
                                                    child: TextFormField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      scrollPadding:
                                                          EdgeInsets.only(
                                                              bottom: MediaQuery.of(
                                                                          context)
                                                                      .viewInsets
                                                                      .bottom *
                                                                  1.40),
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                        LengthLimitingTextInputFormatter(
                                                            10)
                                                      ],
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      style: AppStyles.heading1(
                                                          context),
                                                      decoration:
                                                          const InputDecoration(
                                                        border: InputBorder.none,
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: 5, left: 20),
                                                        hintText:
                                                            'Enter quantity',
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.black38),
                                                      ),
                                                      onChanged: (value) {
                                                        String? validationMessage;

                                                        if (value.isEmpty) {
                                                          validationMessage =
                                                              'name cannot be empty';
                                                        }
                                                        if (validationMessage !=
                                                            null) {
                                                          setState(() {
                                                            showDescriptionErrorMessage1 =
                                                                true;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            showDescriptionErrorMessage1 =
                                                                false;
                                                          });
                                                        }
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            showDescriptionErrorMessage1 =
                                                                true;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            showDescriptionErrorMessage1 =
                                                                false;
                                                          });
                                                          return null;
                                                        }
                                                      },
                                                      onSaved: (value) {
                                                        _enterQuantity = value!;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          if (showDescriptionErrorMessage1)
                                            const Text(
                                              'Quantity is required',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15),
                                            ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ]),
                                    TableRow(children: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start, // Align content to the start (left)

                                        children: [
                                          const SizedBox(height: 10),
                                          RichText(
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Type ',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        27, 86, 148, 1.0),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
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
                                                height: 45,
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: ButtonTheme(
                                                    alignedDropdown: true,
                                                    child:
                                                        DropdownButtonFormField<
                                                            String>(
                                                      isExpanded: true,
                                                      value: _selectedPriority,
                                                      items: priority.map((item) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: item,
                                                          child: Text(item,
                                                              style: AppStyles
                                                                  .heading1(
                                                                      context)),
                                                        );
                                                      }).toList(),
                                                      onChanged: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            showErrorMessage =
                                                                true;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            _selectedPriority =
                                                                value;
                                                          });
                                                          setState(() {
                                                            showErrorMessage =
                                                                false;
                                                          });
                                                        }
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          setState(() {
                                                            showErrorMessage =
                                                                true;
                                                          });
                                                          // return 'Please select a category';
                                                        } else {
                                                          setState(() {
                                                            showErrorMessage =
                                                                false;
                                                          });
                                                          return null;
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                        border: InputBorder
                                                            .none, // Remove the bottom border line
                                                        //           prefixIcon: Icon(Icons
                                                        //               .precision_manufacturing),
                                                        hintText: "Select Type",
                                                        contentPadding:
                                                            EdgeInsets.symmetric(
                                                                horizontal: 16),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          if (showErrorMessage)
                                            const Text(
                                              'Please select any type',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 15),
                                            ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ]),
                                    TableRow(children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          RichText(
                                            text: const TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: 'Upload Image ',
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        27, 86, 148, 1.0),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          content,
                                        ],
                                      ),
                                    ]),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 50),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              _formKey.currentState!.save();

                              print(_selectedCategory);
                              print(_selectedPriority);

                              if (_formKey.currentState!.validate() &&
                                  showDescriptionErrorMessage == false &&
                                  showErrorMessage == false &&
                                  showCategoryErrorMessage == false) {
                                _formKey.currentState!.save();
                                // if (_selectedImage != null) {
                                _addInventoryApi();
                                // } else {
                                //   Utils.showToast("Please select image");
                                // }
                              } else {
                                Utils.showToast(
                                    "Please fill all mandatory fields");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff1B5694),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.all(15),
                            ),
                            child: const Text("Submit",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                )),
                          ),
                        ),
                        const SizedBox(height: 150),
                        // const FooterScreen()
                      ],
                    ),
                  ),
                ),
              ),
              if (_isLoading) Positioned(child: LoadingDialog()),
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

  _addInventoryApi() async {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          _isLoading = true;
          var responseType = 'addInventorary';
          String keyName = "goodsDetails";

          String partURL = Constant.addInventory;
          NetworkUtils.filePostUploadNetWorkCall(partURL, keyName,
              _getJsonData().toString(), _selectedImage, this, responseType);
        }
        else {
          Utils.printLog("else called");
          _isLoading = false;
          Utils.showCustomToast(context);
        }
      });
    });
  }

  _getJsonData() {
    final data = {
      '"goodsName"': '"$_enterInventoryName"',
      '"quantity"': '"$_enterQuantity"',
      '"movementType"': '"$_selectedPriority"',
      // '"priority"': '"$_selectedPriority"',
      '"apartmentId"': apartmentId
    };

    return data;
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
      //  Goods added to inventory successfully!!
      InventoryModel inventoryModel =
          InventoryModel.fromJson(json.decode(response));
      setState(() {
        _isLoading = false;
        if (inventoryModel.status! == "success") {
          //  successAlert(context, inventoryModel.message!);

          successDialogWithListner(
              context,
              inventoryModel.message!,
              // "Goods added to inventory successfully!!",
              const GetGoodsByDate(),
              this);
        } else {
          errorAlert(context, inventoryModel.message!);
        }
      });
      // Utils.showToast(inventoryModel.message!);
    } catch (error) {
      // successDialog(context, "Goods added to inventory successfully!!",
      //     const GetGoodsByDate());
      print("Error 1");
      // errorAlert(context, response.toString());
    }
  }



  @override
  onNavigatorBackPressed() {
    Navigator.pop(context);
    widget.navigatorListener!.onNavigatorBackPressed();
  }
}
