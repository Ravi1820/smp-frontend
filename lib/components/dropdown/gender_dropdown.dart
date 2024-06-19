import 'package:SMP/theme/common_style.dart';
import 'package:flutter/material.dart';

// class DropdownWidget extends StatefulWidget {
//    DropdownWidget({
//     Key? key,
//     required this.genders,
//     required this.value,
//     this.validate,
//     required this.onGenderChanged,
//     required this.placeholder,
//   }) : super(key: key);
//
//   final String placeholder;
//    String? value;
//   final List<String> genders;
//   final Function(String?) onGenderChanged;
//   final String? Function(String?)? validate;
//
//   @override
//   State<DropdownWidget> createState() {
//     return _DropdownWidgetState();
//   }
// }
//
// class _DropdownWidgetState extends State<DropdownWidget> {
//   // String? _selectedGender;
//
//   String? _validate(String? value) {
//     if (widget.validate != null) {
//       final customError = widget.validate!(value);
//       if (customError != null) {
//         return customError;
//       }
//     }
//
//     if (value == null || value.isEmpty) {
//       return "Please select any gender.";
//     }
//
//     return null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     TextStyle headerPlaceHolder = TextStyle(
//       fontFamily: 'Roboto',
//       fontSize: MediaQuery.of(context).size.width * 0.04,
//       fontStyle: FontStyle.normal,
//       fontWeight: FontWeight.w400,
//       color: const Color.fromARGB(181, 27, 85, 148),
//     );
//
//     return Stack(
//       alignment: Alignment.centerLeft,
//       children: <Widget>[
//         Container(
//           decoration: const BoxDecoration(
//             border: Border(
//               bottom: BorderSide(
//                 color: Colors.grey,
//                 width: 1.0,
//               ),
//             ),
//           ),
//           width: double.infinity,
//           margin: const EdgeInsets.only(right: 0),
//           child: DropdownButtonHideUnderline(
//             child: Padding(
//               padding: const EdgeInsets.only(right: 14),
//               child: ButtonTheme(
//                 child: DropdownButton<String>(
//                   isExpanded: true,
//                   value: widget.value,
//                   items: widget.genders.map((item) {
//                     return DropdownMenuItem<String>(
//                       value: item,
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(item),
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       widget.value = value!;
//                     });
//                     widget.onGenderChanged(widget.value);
//                   },
//                   hint: Text(
//                     widget.placeholder,
//                     style: headerPlaceHolder,
//                   ),
//                   selectedItemBuilder: (context) {
//                     return widget.genders.map<Widget>((item) {
//                       return Align(
//                         alignment: Alignment.centerLeft,
//                         child: Padding(
//                           padding: EdgeInsets.zero,
//                           child: Text(
//                             item,
//                             style: AppStyles.heading1(context),
//                           ),
//                         ),
//                       );
//                     }).toList();
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }



class DropdownWidget extends StatefulWidget {
  DropdownWidget({
    Key? key,
    required this.genders,
    required this.value,
    this.validate,
    required this.onGenderChanged,
    required this.placeholder,
  }) : super(key: key);

  final String placeholder;
  String? value; // Change the type to nullable string
  final List<String> genders;
  final Function(String?) onGenderChanged;
  final String? Function(String?)? validate;

  @override
  State<DropdownWidget> createState() {
    return _DropdownWidgetState();
  }
}

class _DropdownWidgetState extends State<DropdownWidget> {
  @override
  Widget build(BuildContext context) {
    TextStyle headerPlaceHolder = TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.04,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      color: const Color.fromARGB(181, 27, 85, 148),
    );

    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
          ),
          width: double.infinity,
          margin: const EdgeInsets.only(right: 0),
          child:
          DropdownButtonHideUnderline(
            child: Padding(
              padding: const EdgeInsets.only(right: 14),
              child: ButtonTheme(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: widget.value, // Use the provided value directly
                  items: widget.genders.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(item),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      widget.value = value; // Update the value in the widget
                    });
                    widget.onGenderChanged(widget.value);
                  },
                  hint: Text(
                    widget.placeholder,
                    style: headerPlaceHolder,
                  ),
                  selectedItemBuilder: (context) {
                    return widget.genders.map<Widget>((item) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: Text(
                            item,
                            style: AppStyles.heading1(context),
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

