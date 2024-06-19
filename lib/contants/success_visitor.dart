// import 'package:flutter/material.dart';

// void successVisitorAlert(
//   BuildContext context,
//   String message,
// ) {
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       Future.delayed(const Duration(seconds: 15), () {
//         Navigator.pop(context);
//       });
//       return 
//       AlertDialog(
//         contentPadding: const EdgeInsets.only(top: 10.0, right: 10.0),
//         content: Container(
//           margin: const EdgeInsets.only(left: 0.0, right: 0.0),
//           child: Stack(
//             children: <Widget>[
//               Container(
//                 padding: const EdgeInsets.only(
//                   top: 18.0,
//                 ),
//                 margin: const EdgeInsets.only(
//                   top: 13.0,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.rectangle,
//                   borderRadius: BorderRadius.circular(16.0),
//                   boxShadow: const <BoxShadow>[
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 0.0,
//                       offset: Offset(0.0, 0.0),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: <Widget>[
//                     const SizedBox(
//                       height: 10.0,
//                     ),
//                     const Icon(
//                       Icons.check_circle,
//                       size: 64,
//                       color: Colors.green,
//                     ),
//                     const SizedBox(height: 16),
//                     const SizedBox(height: 16),
//                     Text(
//                       message,
//                       style: const TextStyle(
//                         color: Color.fromRGBO(27, 86, 148, 1.0),
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(
//                       height: 20.0,
//                       width: 5.0,
//                     ),
//                   ],
//                 ),
//               ),
//               Positioned(
//                 right: 0.0,
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Align(
//                     alignment: Alignment.topRight,
//                     child: Icon(Icons.close, size: 25, color: Colors.red),
//                   ),
//                 ),
//               ),
//               Positioned.fill(
//                 child: GestureDetector(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
