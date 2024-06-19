// import 'package:flutter/material.dart';

// class ProductTitleWithImage extends StatelessWidget {
//   const ProductTitleWithImage({super.key});

//   // final Product product;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding:  EdgeInsets.symmetric(horizontal: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           SizedBox(
//             height: 10,
//           ),
//           Text(
//             "Resident Email",
//             style: TextStyle(color: Colors.white),
//           ),
//           Text(
//             product.email,
//             style: Theme.of(context)
//                 .textTheme
//                 .titleLarge!
//                 .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: kDefaultPaddin),
//           Row(
//             children: <Widget>[
//               Container(
//                 // width: 90,
//                 child: RichText(
//                   text: TextSpan(
//                     children: [
//                       TextSpan(text: "Name\n"),
//                       TextSpan(
//                         text: product.title,
//                         style: Theme.of(context)
//                             .textTheme
//                             .headlineSmall!
//                             .copyWith(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               // SizedBox(width: kDefaultPaddin),
//               // Expanded(
//               //   child: Hero(
//               //     tag: "1",
//               //     child: Image.asset(
//               //       // product.image,
//               //       // height: 210,
//               //       width: 210,
//               //       fit: BoxFit.fill,
//               //     ),
//               //   ),
//               // )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
