// import 'package:SMP/theme/common_style.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class HospitalGridViewCard extends StatelessWidget {
//   final Function press;

//   final List users;

//   const HospitalGridViewCard(
//       {super.key, required this.users, required this.press});

//   @override
//   Widget build(BuildContext context) {
//     return GridView.count(
//       crossAxisCount: 2,
//       crossAxisSpacing: 3.0,
//       mainAxisSpacing: 7.0,
//       childAspectRatio: 0.8, // Adjust this value as needed
//       children: List.generate(
//         users.length,
//         (index) {
//           return Builder(builder: (context) {
//             final movie = users[index];

//             return InkWell(
//               onTap: () {},
//               child: Card(
//                 elevation: 1.0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                     border: Border.all(
//                       color: Colors.blueAccent,
//                       width: 1.0,
//                     ),
//                     gradient: const LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         Color(0xFF82D9FF),
//                         Color.fromARGB(172, 186, 227, 243),
//                         Color(0xFF82D9FF),
//                       ],
//                     ),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment:
//                         MainAxisAlignment.center, // Center children vertically

//                     children: <Widget>[
//                       Card(
//                         elevation: 15,
//                         margin: const EdgeInsets.only(
//                           left: 10,
//                           right: 10,
//                         ),
//                         shadowColor: Colors.amber,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Container(
//                           height: 120,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Colors.blueAccent,
//                               width: 1.0,
//                             ),
//                             borderRadius: BorderRadius.circular(
//                                 15), // Apply border radius here
//                           ),
//                           // child: ClipRRect(
//                           //   borderRadius: BorderRadius.circular(
//                           //       15), // Apply border radius for the image
//                           //   child: Image.memory(
//                           //     movie.apartmentImages as Uint8List,
//                           //     fit: BoxFit.fitWidth,
//                           //   ),
//                           // ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 4.0),
//                         child: Center(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment
//                                 .center, // Center children horizontally
//                             mainAxisAlignment: MainAxisAlignment
//                                 .center, // Center children vertically
//                             children: <Widget>[
//                               const SizedBox(
//                                 height: 5,
//                               ),
//                               Text(
//                                 movie.name,
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 1,
//                                 style: AppStyles.heading1(context),
//                               ),
//                               // Text(
//                               //   movie.mobile,
//                               //   style: AppStyles.heading1(context),
//                               //   overflow: TextOverflow.ellipsis,
//                               //   maxLines: 1,
//                               // ),
//                               // const SizedBox(
//                               //   height: 5,
//                               // ),
//                               // Padding(
//                               //   padding:
//                               //       const EdgeInsets.symmetric(horizontal: 10),
//                               //   child: GestureDetector(
//                               //     onTap: () => {press(movie)},
//                               //     child: ClipRRect(
//                               //       borderRadius: const BorderRadius.only(
//                               //         bottomLeft: Radius.circular(20),
//                               //         topRight: Radius.circular(20),
//                               //       ),
//                               //       child: Container(
//                               //         padding: const EdgeInsets.symmetric(
//                               //             horizontal: 10, vertical: 10),
//                               //         decoration: BoxDecoration(
//                               //           color: Theme.of(context)
//                               //               .colorScheme
//                               //               .primary,
//                               //           borderRadius: BorderRadius.circular(5),
//                               //         ),
//                               //         child: const Text(
//                               //           "View Apartment",
//                               //           style: TextStyle(
//                               //             color: Colors.white,
//                               //             fontSize: 10,
//                               //           ),
//                               //         ),
//                               //       ),
//                               //     ),
//                               //   ),
//                               // ),
                         
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           });
//         },
//       ),
//     );
//   }
// }
