import 'dart:convert';
import 'dart:io';
import 'package:SMP/contants/constant_url.dart';
import 'package:SMP/contants/success_dialog.dart';
import 'package:SMP/model/api_responce_model.dart';
import 'package:SMP/network/NetworkUtils.dart';
import 'package:SMP/presenter/api_listener.dart';
import 'package:SMP/theme/common_style.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/widget/avatar.dart';
import 'package:SMP/contants/error_alert.dart';
import 'package:SMP/login.dart';
import 'package:SMP/widget/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:SMP/widget/footers.dart';

class ExistingOwnerRegistrationScreen extends StatefulWidget {
  const ExistingOwnerRegistrationScreen(
      {super.key,
      required this.userName,
      required this.email,
      required this.apatmentId});

  final String? userName;
  final String? email;
  final int? apatmentId;
  @override
  State<ExistingOwnerRegistrationScreen> createState() {
    return _ExistingOwnerRegistrationState();
  }
}

class _ExistingOwnerRegistrationState
    extends State<ExistingOwnerRegistrationScreen>
    with SingleTickerProviderStateMixin, ApiListener {
  bool showErrorMessage = false;
  final _formKey = GlobalKey<FormState>();
  // var _enteredUserName = '';
  var _enteredConfirmPassword = '';

  bool _isNetworkConnected = false, isLoading = true;

  bool _isLoading = false;
  var _enteredPassword = '';
  var _enteredEmail = '';
  var _enteredUserName = '';

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController = TextEditingController();




  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  int apartId = 0;
  @override
  void initState() {
    super.initState();
    apartId = widget.apatmentId!;
    _userNameController.text = widget.userName!;
    _emailController.text = widget.email!;
  }

  var confirmPass;

  bool showEmailErrorMessage = false;
  bool showConfirmErrorMessage = false;
  String? _passwordErrorMessage;
  bool showPassword = false;
  bool showConfiremPassword = false;

  File? _selectedImage;

  // void _takePicture() async {
  //   final imagePicker = ImagePicker();
  //   final pickedImage =
  //       await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);
  //
  //   if (pickedImage == null) {
  //     return;
  //   }
  //
  //   setState(() {
  //     _selectedImage = File(pickedImage.path);
  //   });
  // }




  void _takePicture() async {
    showDialog<ImageSource>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.only(top: 10.0, right: 10.0),
        content: Container(
          margin: const EdgeInsets.only(left: 0.0, right: 0.0),
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                  top: 18.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(16.0),
                  // boxShadow: const <BoxShadow>[
                  //   BoxShadow(
                  //     color: Colors.black26,
                  //     blurRadius: 0.0,
                  //     offset: Offset(0.0, 0.0),
                  //   ),
                  // ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Choose image source',
                        style: AppStyles.heading(context),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                      width: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: const BorderSide(
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 0,
                              ),
                            ),
                            onPressed: () =>
                                Navigator.pop(context, ImageSource.gallery),
                            child: const Text("Gallery"),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: const BorderSide(
                                  width: 1,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 0,
                              ),
                            ),
                            onPressed: () =>
                                Navigator.pop(context, ImageSource.camera),
                            child: const Text("Camera"),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                      width: 5.0,
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
                  child: const Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.close, size: 25, color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((ImageSource? source) async {
      if (source == null) return;

      final imagePicker = ImagePicker();

      final pickedFile =
      await imagePicker.pickImage(source: source, maxWidth: 600);

      if (pickedFile == null) {
        return;
      }

      setState(() => _selectedImage = File(pickedFile.path));
    });
  }


  bool isValidEmail(String email) {
    // Define a regular expression pattern for a valid email address
    const pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  @override
  Widget build(context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    Widget content = GestureDetector(
      onTap: _takePicture,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(alignment: Alignment.center, child: const AvatarScreen()),
          Positioned(
            bottom: 7.0,
            right: 8.0,
            child: GestureDetector(
              onTap: _takePicture,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(
                        38, 105, 177, 1) 
                    ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      );
    }

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 100,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 100,
                        alignment: Alignment.center,
                        child: content,
                      ),
                      const Text(
                        'Register your Account',
                        style: TextStyle(
                          color: Color.fromRGBO(27, 86, 148, 1.0),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 10),
                          const Text(
                            'Full Name',
                            style: TextStyle(
                              color: Color.fromRGBO(27, 86, 148, 1.0),
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
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 100, 100, 100),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                height: 55,
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: _userNameController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter
                                          .allow(
                                        RegExp(
                                            r"[a-zA-Z,#0-9]+|\s"),
                                      ),
                                    ],
                                    style: const TextStyle(color: Colors.black87),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(top: 14),
                                      prefixIcon: Icon(
                                        Icons.person_2_rounded,
                                        color: Color(0xff4d004d),
                                      ),
                                      hintText: 'Name',
                                      hintStyle: TextStyle(color: Colors.black38),
                                    ),
                                    onSaved: (value) {
                                      _enteredUserName = value!;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Email',
                            style: TextStyle(
                              color: Color.fromRGBO(27, 86, 148, 1.0),
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
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 100, 100, 100),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                height: 55,
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: _emailController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r"[a-zA-Z0-9._%+-@]+|\s"),
                                      ),
                                    ],
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(color: Colors.black87),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(top: 14),
                                      prefixIcon: Icon(
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
                              ),
                            ],
                          ),
                          if (showEmailErrorMessage)
                            const Text(
                              "Please enter valid email address",
                              style: TextStyle(color: Colors.red, fontSize: 15),
                            ),
                          const SizedBox(height: 10),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Password ',
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
                          const SizedBox(height: 10),
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 100, 100, 100),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                height: 55,
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _passwordController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r"[a-zA-Z0-9._%+-@]+|\s"),
                                    ),
                                  ],
                                  style: const TextStyle(color: Colors.black87),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        const EdgeInsets.only(top: 14),
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Color(0xff4d004d),
                                    ),
                                    hintText: 'Password',
                                    hintStyle:
                                        const TextStyle(color: Colors.black38),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        showPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: const Color(0xff4d004d),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          showPassword = !showPassword;
                                        });
                                      },
                                    ),
                                  ),
                                  obscureText: !showPassword,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value.isEmpty) {
                                        _passwordErrorMessage =
                                        'Password  cannot be empty ';
                                      } else if (value.length < 6) {
                                        _passwordErrorMessage =
                                        'Password should contain minimum 6 characters';
                                      } else {
                                        _passwordErrorMessage = null;
                                      }
                                    });
                                  },

                                  validator: (value) {
                                    String? validationMessage;

                                    if (value == null || value.isEmpty) {
                                      validationMessage =
                                      'Password cannot be empty';
                                    }
                                    if (validationMessage != null) {
                                      setState(() {
                                        _passwordErrorMessage = validationMessage;
                                      });
                                    } else {
                                      setState(() {
                                        _passwordErrorMessage = null;
                                      });
                                    }
                                    return null;
                                  },

                                  onSaved: (value) {
                                    _enteredPassword = value!;
                                  },
                                ),


                              ),
                            ],
                          ),
                          if (_passwordErrorMessage != null)
                            Text(
                              _passwordErrorMessage!,
                              style: TextStyle(color: Colors.red, fontSize: 15),
                            ),
                          const SizedBox(height: 10),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Confirm Password ',
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
                          const SizedBox(height: 10),
                          Stack(
                            alignment: Alignment.centerLeft,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 100, 100, 100),
                                      blurRadius: 6,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                height: 55,
                                child: TextFormField(
                                  controller:_confirmPasswordController,
                                  scrollPadding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(context).viewInsets.bottom *
                                            0.9,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r"[a-zA-Z0-9._%+-@]+|\s"),
                                    ),
                                  ],
                                  // keyboardType: TextInputType.numberWithOptions(),
                                  style: const TextStyle(color: Colors.black87),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding:
                                        const EdgeInsets.only(top: 14),
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Color(0xff4d004d),
                                    ),
                                    hintText: 'Confirm Password',
                                    hintStyle:
                                        const TextStyle(color: Colors.black38),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        showConfiremPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: const Color(0xff4d004d),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          showConfiremPassword =
                                              !showConfiremPassword;
                                        });
                                      },
                                    ),
                                  ),
                                  obscureText: !showConfiremPassword,
                                  onChanged: (value) {
                                    setState(() {
                                      showConfirmErrorMessage = value.isEmpty ||
                                          value != _passwordController.text;
                                    });
                                  },
                                  validator: (value) {
                                    // if (value == null || value.isEmpty) {
                                    //   return 'Please enter confirm password';
                                    // } else if (value !=
                                    //     _passwordController.text) {
                                    //   return 'Must be matched with password';
                                    // }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _enteredConfirmPassword = value!;
                                  },
                                ),
                              ),
                            ],
                          ),
                          if (showConfirmErrorMessage)
                            const Text(
                              'Must be Matched With Password.',
                              style: TextStyle(color: Colors.red, fontSize: 15),
                            ),
                          const SizedBox(height: 10),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 50),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {

                            if (_formKey.currentState!.validate()   ) {

                              if (_passwordController.text ==
                                  _confirmPasswordController.text) {
                                _formKey.currentState!.save();
                                _registerOtpData();
                              } else {
                                errorAlert(
                                  context,
                                  "Password does not match",
                                );
                              }


                            } else {
                              errorAlert(
                                context,
                                "Please fill mandatory fields",
                              );
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
                          child: const Text(
                            "Verify",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 90),
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

  _registerOtpData() async {
    Utils.getNetworkConnectedStatus().then((status) {
      Utils.printLog("network status : $status");
      setState(() {
        _isNetworkConnected = status;
        _isLoading = status;
        if (_isNetworkConnected) {
          _isLoading = true;
          var responseType = 'registerResident';
          String keyName = "registerOTP";
          String partURL =
              '${Constant.verifyResidentURL}?userName=$_enteredUserName&email=$_enteredEmail&pwd=$_enteredPassword&apartmentId=$apartId';
          NetworkUtils.filePutUploadNetWorkCall(
              partURL, keyName, _selectedImage, this, responseType);
        }
        else {
          Utils.printLog("else called");
          _isLoading = false;
         // Utils.showToast(Strings.NETWORK_CONNECTION_ERROR);
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
      if (responseType == 'registerResident') {
        setState(() {
          _isLoading = false;
        });

        ApiResponceModel responceModel =
            ApiResponceModel.fromJson(json.decode(response));
        if (responceModel.status == "error") {
          errorAlert(
            context,
            responceModel.message!,
          );
        } else {
          successDialog(context, responceModel.message!, const LoginScreen());

          //      Fluttertoast.showToast(
          //   msg: responceModel.message!,
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.CENTER,
          //   timeInSecForIosWeb: 1,
          //   backgroundColor: Colors.gree,
          //   textColor: Colors.white,
          //   fontSize: 16.0,
          // );
          //  print("verify email else part");
          // Navigator.of(context).push(createRoute(
          //   ExistingOwnerRegistrationScreen(
          //     userName: responceModel.value!.fullName!,
          //     email: responceModel.value!.emailId,
          //     apatmentId: apatmentId,
          //   ),
          // ));
        }

        //   var message =
        //       "Registered successfully \nplease Login with your credientials";

        //   successDialog(context, message, const LoginScreen());
        // } else {
        //   Fluttertoast.showToast(
        //     msg: "Something wrong",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.CENTER,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 16.0,
        //   );
      }
    } catch (error) {
      print("Error parsing JSON: $error");
    }
  }
}
