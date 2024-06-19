//
// import 'package:SMP/dashboard/dashboard.dart';
// import 'package:SMP/utils/routes_animation.dart';
// import 'package:SMP/utils/size_utility.dart';
// import 'package:SMP/widget/chips.dart';
// import 'package:SMP/widget/drawer.dart';
// import 'package:flutter/material.dart';
// import 'package:SMP/widget/footers.dart';
// import 'package:SMP/widget/header.dart';
//
// class ApprovalScreen extends StatefulWidget {
//   const ApprovalScreen({
//     super.key,
//   });
//
//   @override
//   State<ApprovalScreen> createState() => _ApprovalScreenState();
// }
//
// class _ApprovalScreenState extends State<ApprovalScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   @override
//   Widget build(BuildContext context) {
//     bool isFeatureAvailable = false;
//     TextStyle headerTitle =  TextStyle(
//         fontFamily: "Poppins",
//         fontSize:  FontSizeUtil.CONTAINER_SIZE_20,
//         fontWeight: FontWeight.w600,
//         color: Color(0xff1B5694));
//     TextStyle count = TextStyle(
//         fontSize: Theme.of(context)
//             .textTheme
//             .bodyLarge!
//             .fontSize, // Access the font size
//         fontWeight: FontWeight.w700,
//         color: Theme.of(context).primaryColor);
//
//
//     BoxDecoration decoration = BoxDecoration(
//       gradient: const LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: [
//           Color(0xFF82D9FF), // Start color
//           Color.fromARGB(172, 186, 227, 243), // End color
//           Color(0xFF82D9FF), // Start color
//         ],
//       ),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withOpacity(0.5),
//           spreadRadius: 2,
//           blurRadius: 5,
//           offset: const Offset(0, 3),
//         ),
//       ],
//     );
//
//     return  WillPopScope(
//       onWillPop: () async {
//         return false;
//       },
//       child: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: const Size.fromHeight(kToolbarHeight),
//           child: CustomAppBar(
//             title: 'Approvals',
//             menuOpen: () {
//               _scaffoldKey.currentState!.openDrawer();
//             },
//             home: () async {
//             },
//           ),
//         ),
//         body: Column(
//           children: [
//             Expanded(
//               child: Container(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Color.fromARGB(255, 255, 255, 255),
//                       Color.fromARGB(255, 255, 255, 255),
//                       Color.fromARGB(255, 255, 255, 255),
//                       Color.fromARGB(255, 255, 255, 255),
//                     ],
//                   ),
//                 ),
//                 child: Column(
//                   children: <Widget>[
//                     SizedBox(height:  FontSizeUtil.CONTAINER_SIZE_20),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         height:  FontSizeUtil.CONTAINER_SIZE_55,
//
//                         decoration: decoration,
//                         child: Center(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Expanded(
//                                 child: Center(
//                                     child: Text("Approvals", style: headerTitle)),
//                               ),
//                               Text("1", style: count),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     FeatureNotAvailableChip(featureAvailable: isFeatureAvailable),
//
//                     // TextFormField()
//                     // ... other content ...
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(
//               child: FooterScreen(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
