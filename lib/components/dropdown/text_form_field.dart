import 'package:SMP/theme/common_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final TextInputType keyboardType;
  final EdgeInsets scrollPadding;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>?
      inputFormatter; // Change to List<TextInputFormatter>?
  final String? Function(String?)? validator; // Update this line
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged; // Update this line
  final TextEditingController controller;
  const CustomTextField({
    Key? key,
    // this.controller,
    required this.onChanged,
    required this.hintText,
    required this.keyboardType,
    required this.scrollPadding,
    this.inputFormatter,
    required this.validator,
    required this.textInputAction,
    required this.onSaved,
   required this.controller,
  }) : super(key: key);

  // get scrollPadding => null;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

//
class _CustomTextFieldState extends State<CustomTextField> {
  // var textInputAction;

  // get textInputAction => null;

  @override
  Widget build(BuildContext context) {
    TextStyle headerPlaceHolder = TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.04,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      color: const Color.fromARGB(181, 27, 85, 148),
    );

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: TextFormField(
          controller: widget.controller,
          textInputAction: widget.textInputAction,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatter,
          scrollPadding: widget.scrollPadding,
          style: AppStyles.heading1(context),
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: InputBorder.none,
            hintStyle: headerPlaceHolder,
          ),
          onChanged: widget.onChanged,
          validator: widget.validator,
          onSaved: widget.onSaved,
        ),
      ),
    );
  }
}
