import 'dart:io';

import 'package:SMP/theme/common_style.dart';
import 'package:SMP/user_by_roles/resident/my_vehicle/add_new_vehilce.dart';
import 'package:SMP/user_by_roles/security/global_serach_by_security.dart';
import 'package:SMP/user_by_roles/security/global_vehicle_search.dart';
import 'package:SMP/utils/Strings.dart';
import 'package:SMP/utils/Utils.dart';
import 'package:SMP/utils/routes_animation.dart';
import 'package:SMP/utils/size_utility.dart';
import 'package:SMP/widget/footers.dart';
import 'package:SMP/widget/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

// import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'package:permission_handler/permission_handler.dart';

class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({
    super.key,
  });

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  File? _selectedImage;
  bool showVehicleNumberErrorMessage = false;
  TextEditingController _textEditingController = TextEditingController();
  String _extractedText = '';

  Color _containerBorderColor1 = Colors.white; // Added this line
  Color _boxShadowColor1 = const Color.fromARGB(255, 100, 100, 100);

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void pickFile() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedImage.path);
    });

    // Extract text when a new image is picked
    await extractTextAndUpdateController();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = GestureDetector(
      onTap: pickFile,
      child: Container(
        width: MediaQuery.of(context).size.width - 1.03,
        height: FontSizeUtil.CONTAINER_SIZE_200,
        decoration: BoxDecoration(
          color: const Color(0x3018A7FF),
          borderRadius: BorderRadius.circular(FontSizeUtil.SIZE_05),
          border: Border.all(
            color: const Color(0x8218A7FF),
            width: FontSizeUtil.SIZE_03,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.cloud_upload,
                size: FontSizeUtil.CONTAINER_SIZE_50,
                color:const Color(0xFF18A7FF),
              ),
              Text(
                Strings.SCAN_VEHICLE_TITLE,
                style: TextStyle(
                  fontSize: FontSizeUtil.CONTAINER_SIZE_20,
                  color:const Color(0xFF18A7FF),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'roboto',
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: pickFile,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_10),
          child: Image.file(
            _selectedImage!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: FontSizeUtil.CONTAINER_SIZE_200,
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: Strings.SCAN_VEHILCE_HEADER,
          profile: () {},
        ),
      ),
      body: Stack(
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
              children: <Widget>[
                SizedBox(
                  height: FontSizeUtil.CONTAINER_SIZE_30,
                ),
                FocusScope(
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      setState(() {
                        _containerBorderColor1 = hasFocus
                            ? const Color.fromARGB(255, 0, 137, 250)
                            : Colors.white;
                        _boxShadowColor1 = hasFocus
                            ? const Color.fromARGB(162, 63, 158, 235)
                            : const Color.fromARGB(255, 100, 100, 100);
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: FontSizeUtil.SIZE_08),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              FontSizeUtil.CONTAINER_SIZE_10),
                          boxShadow: [
                            BoxShadow(
                              color: _boxShadowColor1,
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: Border.all(
                            color: _containerBorderColor1,
                          ),
                        ),
                        height: FontSizeUtil.CONTAINER_SIZE_100,
                        child: TextFormField(
                          controller: _textEditingController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r"[a-zA-Z0-9._%+-@]+|\s"),
                            ),
                          ],
                          keyboardType: TextInputType.multiline,
                          maxLines: 30,
                          scrollPadding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom *
                                  1.40),
                          textInputAction: TextInputAction.done,
                          style: AppStyles.heading1(context),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                top: FontSizeUtil.CONTAINER_SIZE_14,
                                left: FontSizeUtil.CONTAINER_SIZE_13),
                            hintText: Strings.VEHICLE_NUMBER_PLACEHOLDER,
                            hintStyle: const TextStyle(color: Colors.black38),
                          ),
                          onChanged: (value) {
                            setState(() {
                              // manuallyEnteredText = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                showVehicleNumberErrorMessage = true;
                              });
                            } else {
                              setState(() {
                                showVehicleNumberErrorMessage = false;
                              });
                              return null;
                            }
                          },
                          onSaved: (value) {
                            // _enteredVehicleNumber = value!;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Stack(
                  children: [
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width - 1.03,
                        margin: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_20),
                        padding: EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD6DAE6),
                          borderRadius:
                              BorderRadius.circular(FontSizeUtil.SIZE_05),
                        ),
                        child: content,
                      ),
                    ),
                    if (_selectedImage != null)
                      Positioned(
                        bottom: FontSizeUtil.CONTAINER_SIZE_10,
                        right: FontSizeUtil.CONTAINER_SIZE_10,
                        child: GestureDetector(
                          onTap: () {
                            _showImagePreviewDialog();
                          },
                          child:  Icon(
                            Icons.remove_red_eye_sharp,
                            size: FontSizeUtil.CONTAINER_SIZE_30,
                            color: Color(0xff1B5694),
                          ),
                        ),
                      )
                  ],
                ),
              ],
            ),
          ),
          const FooterScreen(),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: FontSizeUtil.CONTAINER_SIZE_40,
            right: 0,
            left: 0,
            child: Container(
              padding:
                   EdgeInsets.symmetric(vertical: FontSizeUtil.CONTAINER_SIZE_15, horizontal: FontSizeUtil.CONTAINER_SIZE_100),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  if (_selectedImage != null){
                    Utils.showToast("Coming Soon");
                  }
                  else{
                    Utils.showToast("Please scan vehicle");
                  }

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1B5694),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(FontSizeUtil.CONTAINER_SIZE_15),
                  ),
                  padding:  EdgeInsets.all(FontSizeUtil.CONTAINER_SIZE_15),
                ),
                child: const Text(Strings.VEHICLE_ALLOW_TEXT,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Utils.titleText,
                    )),
              ),
            ),
          ),
          Positioned(
            bottom: FontSizeUtil.CONTAINER_SIZE_50,
            right: FontSizeUtil.CONTAINER_SIZE_10,
            child: FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
                Navigator.of(context)
                    .push(createRoute(GlobalVehicleSearchBySecurity(
                        // navigatorListener: this,
                        )));
              },
              backgroundColor: const Color(0xff1B5694),
              foregroundColor: Colors.white,
              child: const Icon(Icons.call),
            ),
          ),
        ],
      ),
    );
  }

  void _showImagePreviewDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Stack(
            children: [
              Container(
                // width: double.infinity,
                // height: 300,
                child: _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        fit: BoxFit.contain,
                      )
                    : SizedBox.shrink(),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: AppStyles.circle1(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // Widget _extractTextView() {
  //   String manuallyEnteredText = ''; // Store manually entered text
  //
  //   return Column(
  //     children: [
  //
  //     ],
  //   );
  // }

  String? extractVehicleNumber(String text) {
    // Regular expression pattern for Indian vehicle numbers (e.g., KA 01 AB 1234)
    RegExp regExp = RegExp(r'([A-Z]{2}\s?\d{1,2}\s?[A-Z]{1,2}\s?\d{1,4})');

    // Search for vehicle number matches in the text
    Iterable<Match> matches = regExp.allMatches(text);

    // Extract the first match (vehicle number)
    if (matches.isNotEmpty) {
      return matches.first.group(0);
    } else {
      return null; // No vehicle number found
    }
  }

  Future<void> extractTextAndUpdateController() async {
    if (_selectedImage != null) {
      final text = await _extractText(_selectedImage!);
      setState(() {
        _extractedText = text ?? '';
        _textEditingController.text = _extractedText;
      });
    }
  }

  Future<String?> _extractText(File file) async {
    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );
    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    String text = recognizedText.text;
    textRecognizer.close();
    return text;
  }
}
