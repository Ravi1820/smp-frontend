// import 'package:flutter/material.dart';

// void deletConformationAlert(
//   BuildContext context,
//   String message,
//   Function? deleteSecurity,
// ) {
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         contentPadding: const EdgeInsets.only(top: 10.0, right: 10.0),
//         content: Container(
//           margin: const EdgeInsets.only(left: 0.0, right: 0.0),
//           child: Stack(
//             children: <Widget>[
//               Container(
//                 padding: const EdgeInsets.only(
//                   top: 18.0,
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
//                     const Icon(
//                       Icons.error,
//                       size: 64,
//                       color: Colors.red,
//                     ),
//                     const SizedBox(height: 16),
//                     const Center(
//                       child: Text(
//                         'Confirm Deletion!',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red,
//                         ),
//                       ),
//                     ),
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
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           height: 30,
//                           child: ElevatedButton(
//                             style: OutlinedButton.styleFrom(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20.0),
//                                 side: const BorderSide(
//                                   width: 1,
//                                 ),
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 15, vertical: 0),
//                             ),
//                             onPressed: deleteSecurity,
//                             child: const Text("Ok"),
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                       ],
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

// import 'package:flutter/material.dart';

// void deleteConformationAlert(
//   BuildContext context,
//   String message,
//   Function? deleteFunction,
// ) {
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         contentPadding: const EdgeInsets.only(top: 10.0, right: 10.0),
//         content: Container(
//           margin: const EdgeInsets.only(left: 0.0, right: 0.0),
//           child: Stack(
//             children: <Widget>[
//               Container(
//                 padding: const EdgeInsets.only(
//                   top: 18.0,
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
//                     const Icon(
//                       Icons.error,
//                       size: 64,
//                       color: Colors.red,
//                     ),
//                     const SizedBox(height: 16),
//                     const Center(
//                       child: Text(
//                         'Confirm Deletion!',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red,
//                         ),
//                       ),
//                     ),
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
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           height: 30,
//                           child: ElevatedButton(
//                             style: OutlinedButton.styleFrom(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20.0),
//                                 side: const BorderSide(
//                                   width: 1,
//                                 ),
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 15,
//                                 vertical: 0,
//                               ),
//                             ),
//                             onPressed: () {
//                               // Invoke the deleteFunction if it's not null
//                               if (deleteFunction != null) {
//                                 deleteFunction();
//                               }
//                               Navigator.pop(context);
//                             },
//                             child: const Text("Ok"),
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                       ],
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

// import 'package:flutter/material.dart';

// void deleteConformationAlert({
//   required BuildContext context,
//   required String message,
//   required Function() deleteSecurity,
// }) {
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         contentPadding: const EdgeInsets.only(top: 10.0, right: 10.0),
//         content: Container(
//           margin: const EdgeInsets.only(left: 0.0, right: 0.0),
//           child: Stack(
//             children: <Widget>[
//               Container(
//                 padding: const EdgeInsets.only(
//                   top: 18.0,
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
//                     const Icon(
//                       Icons.error,
//                       size: 64,
//                       color: Colors.red,
//                     ),
//                     const SizedBox(height: 16),
//                     const Center(
//                       child: Text(
//                         'Confirm Deletion!',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.red,
//                         ),
//                       ),
//                     ),
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
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           height: 30,
//                           child: ElevatedButton(
//                             style: OutlinedButton.styleFrom(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20.0),
//                                 side: const BorderSide(
//                                   width: 1,
//                                 ),
//                               ),
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 15,
//                                 vertical: 0,
//                               ),
//                             ),
//                             onPressed: deleteSecurity,
//                             child: const Text("Ok"),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                       ],
//                     ),
//                      const SizedBox(
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

import 'package:flutter/material.dart';

void deleteConfirmationAlert({
  required BuildContext context,
  required String message,
  required Function() onConfirm,
}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
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
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        'Confirm Deletion!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: const TextStyle(
                        color: Color.fromRGBO(27, 86, 148, 1.0),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
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
                            // onPressed: () {
                            //   onConfirm();
                            // },
                            onPressed: onConfirm,

                            child: const Text("Ok"),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
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
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
