// import 'package:SMP/view_model/global_search_view_model.dart';
// import 'package:flutter/material.dart';

// class SecurityGlobalSeaechedGridView extends StatelessWidget {
//   final Function(GlobalSearchViewModel) press;

//   final List<GlobalSearchViewModel> users;

//   const SecurityGlobalSeaechedGridView(
//       {super.key, required this.users, required this.press});

//   @override
//   Widget build(BuildContext context) {
//     TextStyle headerPlaceHolder = TextStyle(
//         fontFamily: 'Roboto',
//         fontSize: MediaQuery.of(context).size.width * 0.04,
//         fontStyle: FontStyle.normal,
//         fontWeight: FontWeight.w500,
//         color: const Color(0xff1B5694));

//     TextStyle headerLeftTitle = TextStyle(
//       fontFamily: 'Roboto',
//       fontSize: MediaQuery.of(context).size.width * 0.05,
//       fontStyle: FontStyle.normal,
//       fontWeight: FontWeight.w600,
//       color: const Color(0xff1B5694),
//     );
//     return ListView.builder(
//       itemCount: users.length,
//       itemBuilder: (context, index) {
//         final user = users[index];
//         return GestureDetector(
//           // onTap: () => {press(user)},
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Stack(
//                 clipBehavior: Clip.none,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10),
//                     child: Container(
//                       // constraints: const BoxConstraints(maxHeight: 145),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         border: Border.all(
//                           color: Colors.blueAccent,
//                           width: 1.0,
//                         ),
//                         gradient: const LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                             Color(0xFF82D9FF),
//                             Color.fromARGB(172, 186, 227, 243),
//                             Color(0xFF82D9FF), // Start color
//                           ],
//                         ),
//                       ),
//                       padding: const EdgeInsets.only(
//                         top: 10,
//                         bottom: 10,
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Card(
//                             elevation: 15,
//                             margin: const EdgeInsets.only(left: 10),
//                             shadowColor: Colors.amber,
//                             child: Container(
//                               height: 120,
//                               width: 120,
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   color: Colors.blueAccent,
//                                   width: 1.0,
//                                 ),
//                               ),
//                               child: ClipRRect(
//                                 child: Image.asset(
//                                   "assets/images/apartment.png",
//                                   width: double.infinity,
//                                   fit: BoxFit.fitHeight,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                             Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Text(
//                                       'Name :',
//                                       style: headerLeftTitle,
//                                     ),
//                                     Text(
//                                       user.name,
//                                       style: headerLeftTitle,
//                                       overflow: TextOverflow.ellipsis,
//                                       maxLines: 1,
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 5),
//                                 Row(
//                                   children: [
//                                     Text(
//                                       'Block :',
//                                       style: headerLeftTitle,
//                                     ),
//                                     Text(
//                                       user?.blockName ?? "N/A",
//                                       style: headerPlaceHolder,
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 5),
//                                 Row(
//                                   children: [
//                                     Text(
//                                       'Floor :',
//                                       style: headerLeftTitle,
//                                     ),
//                                     Text(
//                                       user?.floorName?? "N/A",
//                                       style: headerPlaceHolder,
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Text(
//                                           'Flat :',
//                                           style: headerLeftTitle,
//                                         ),
//                                         Text(
//                                           user?.flatNumber.toString()?? "N/A",
//                                           style: headerPlaceHolder,
//                                         ),
//                                       ],
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 30),
//                                       child: GestureDetector(
//                                         onTap: () => {press(user)},
//                                         child: ClipRRect(
//                                           borderRadius: const BorderRadius.only(
//                                               bottomLeft: Radius.circular(20),
//                                               topRight: Radius.circular(20)),
//                                           child: Container(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 10, vertical: 10),
//                                             decoration: BoxDecoration(
//                                               color: Theme.of(context)
//                                                   .colorScheme
//                                                   .primary,
//                                               borderRadius:
//                                                   BorderRadius.circular(5),
//                                             ),
//                                             child: const Text(
//                                               "View",
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 10,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
                        
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
