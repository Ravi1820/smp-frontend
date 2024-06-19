// import 'package:flutter/material.dart';

// class CustomDialog extends StatelessWidget {
//   const CustomDialog({super.key, required this.message});

//   final String message;

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(    
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
//       elevation: 0.0,
//       backgroundColor: Colors.transparent,
//       child: dialogContent(context),
//     );
//   }

//   Widget dialogContent(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(left: 0.0, right: 0.0),
//       child: Stack(
//         children: <Widget>[
//           Container(
//             padding: const EdgeInsets.only(
//               top: 18.0,
//             ),
//             margin: const EdgeInsets.only(top: 13.0, right: 8.0),
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.rectangle,
//                 borderRadius: BorderRadius.circular(16.0),
//                 boxShadow: const <BoxShadow>[
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 0.0,
//                     offset: Offset(0.0, 0.0),
//                   ),
//                 ]),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[
//                 const SizedBox(
//                   height: 10.0,
//                 ),
//                 const Icon(
//                   Icons.error,
//                   size: 64,
//                   color: Colors.red,
//                 ),
//                 const SizedBox(height: 16),
//                 const Center(
//                   child: Text(
//                     'Error!',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.red,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   message,
//                   style: const TextStyle(
//                     color: Color.fromRGBO(27, 86, 148, 1.0),
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(
//                   height: 20.0,
//                   width: 5.0,
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             right: 0.0,
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Align(
//                 alignment: Alignment.topRight,
//                 child: CircleAvatar(
//                   backgroundColor: Colors.red,
//                   child: Icon(Icons.close, size: 25, color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({Key? key, required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 0.0, right: 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              top: 18.0,
            ),
            margin: const EdgeInsets.only(top: 13.0, right: 8.0),
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
                const SizedBox(
                  height: 10.0,
                ),
                const Icon(
                  Icons.error,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Error!',
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
              ],
            ),
          ),
          Positioned(
            right: 0.0,
            child: GestureDetector(
              onTap: () {
                // Do nothing to prevent closing on icon tap
              },
              child: const Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.close, size: 25, color: Colors.white),
                ),
              ),
            ),
          ),
          // GestureDetector to handle clicks outside the dialog content
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                // Do nothing to prevent closing on outside tap
              },
            ),
          ),
        ],
      ),
    );
  }
}
