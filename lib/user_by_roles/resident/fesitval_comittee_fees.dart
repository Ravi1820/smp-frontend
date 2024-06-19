// import 'package:SMP/widget/footers.dart';
// import 'package:SMP/widget/header.dart';
// import 'package:SMP/dashboard/dashboard.dart';
// import 'package:SMP/utils/routes_animation.dart';
// import 'package:SMP/view_model/smp_view_model.dart';
// import 'package:SMP/view_model/visitor_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// // import 'package:razorpay_flutter/razorpay_flutter.dart';
//
// class FestivalComitteScreen extends StatefulWidget {
//   const FestivalComitteScreen({super.key});
//   @override
//   State<FestivalComitteScreen> createState() {
//     return _FestivalComitteScreen();
//   }
// }
//
// class _FestivalComitteScreen extends State<FestivalComitteScreen> {
// bool setShowlistflag = false;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   List<VisitorViewModel> originalUsers = [];
//   List<VisitorViewModel> usersList = [];
//   String query = "";
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _choose();
//   // }
//
//   // late Razorpay _razorpay;
//
//   @override
//   void initState() {
//     super.initState();
//             WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
//
//     // _razorpay = Razorpay();
//     // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }
//
//   @override
//   void dispose() {
//     // _razorpay.clear();
//     super.dispose();
//   }
//
//   // void _handlePaymentSuccess(PaymentSuccessResponse response) {
//   //   // Handle successful payment
//   //   // Show success dialog
//
//   //   showDialog(
//   //     barrierDismissible: false,
//   //     context: context,
//   //     builder: (BuildContext context) {
//   //       return AlertDialog(
//   //         content: Column(
//   //           mainAxisSize: MainAxisSize.min,
//   //           children: [
//   //             const Icon(
//   //               Icons.check_circle,
//   //               size: 64,
//   //               color: Colors.green,
//   //             ),
//   //             const SizedBox(height: 16),
//   //             const Text(
//   //               'Payment Success',
//   //               style: TextStyle(
//   //                 fontSize: 24,
//   //                 fontWeight: FontWeight.bold,
//   //                 color: Colors.green,
//   //               ),
//   //             ),
//   //             const SizedBox(height: 16),
//   //             Text(
//   //               'Payment ID: ${response.paymentId}',
//   //               textAlign: TextAlign.center,
//   //               style: const TextStyle(
//   //                 color: Color.fromRGBO(27, 86, 148, 1.0),
//   //                 fontSize: 16,
//   //                 fontWeight: FontWeight.bold,
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //         actions: <Widget>[
//   //           Center(
//   //             child: SizedBox(
//   //               height: 30,
//   //               child: ElevatedButton(
//   //                 style: OutlinedButton.styleFrom(
//   //                   shape: RoundedRectangleBorder(
//   //                     borderRadius: BorderRadius.circular(20.0),
//   //                     side: const BorderSide(
//   //                       width: 1,
//   //                     ),
//   //                   ),
//   //                   padding:
//   //                       const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
//   //                 ),
//   //                 onPressed: () {
//   //                   Navigator.pop(context);
//   //                 },
//   //                 child: const Text("Ok"),
//   //               ),
//   //             ),
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }
//
//   // void _handlePaymentError(PaymentFailureResponse response) {
//   //   // Handle payment failure
//   //   // Show error dialog
//   //   showDialog(
//   //     context: context,
//   //     builder: (BuildContext context) {
//   //       return AlertDialog(
//   //         title: const Text('Payment Error'),
//   //         content: Text('Error: ${response.message}'),
//   //         actions: [
//   //           TextButton(
//   //             onPressed: () {
//   //               Navigator.of(context).pop();
//   //             },
//   //             child: const Text('OK'),
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }
//
//   // void _handleExternalWallet(ExternalWalletResponse response) {
//   //   // Handle external wallet response
//   //   // Show external wallet dialog
//   //   showDialog(
//   //     context: context,
//   //     builder: (BuildContext context) {
//   //       return AlertDialog(
//   //         title: const Text('External Wallet'),
//   //         content: Text('Wallet Name: ${response.walletName}'),
//   //         actions: [
//   //           TextButton(
//   //             onPressed: () {
//   //               Navigator.of(context).pop();
//   //             },
//   //             child: const Text('OK'),
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }
//
//   void editUserChoice(users) {
//     // Navigator.push(
//       // context,
//     //   MaterialPageRoute(
//     //     builder: (context) => EditApartment(
//     //       apartmentId: users.id,
//     //       name: users.name,
//     //       emailId: users.emailId,
//     //       mobile: users.mobile,
//     //       landline: users.landline,
//     //       address1: users.address_1,
//     //       address2: users.address_2,
//     //       state: users.state,
//     //       pinCode: users.pinCode,
//     //       country: users.country,
//     //     ),
//     //   ),
//     // );
//   }
//
//   Future<void> _choose() async {
//     // Provider.of<MovieListViewModel>(context, listen: false).fetchVisitorsList();
//   }
//
//   void _filterList(String query) {
//     setState(() {
//       this.query = query;
//     });
//   }
//
//   void getList() {
//     final hospitalLists = Provider.of<SmpListViewModel>(context);
//
//     setState(() {
//       usersList = hospitalLists.visitorList;
//
//       // if (query.isNotEmpty) {
//       //   originalUsers = usersList.where((user) {
//       //     final nameMatches =
//       //         user.visitorName.toLowerCase().contains(query.toLowerCase());
//       //     return nameMatches;
//       //   }).toList();
//       // } else {
//       //   originalUsers = usersList;
//       // }
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     getList();
//
//     // Widget content = Padding(
//     //   padding: const EdgeInsets.all(8.0),
//     //   child: MonthalyMaintanceViewCard(),
//     //     openCheckout: openCheckout
//     // );
//
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       key: _scaffoldKey,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(kToolbarHeight),
//         child: CustomAppBar(
//           title: 'Festival Committee Fees',
//           //  menuOpen: () {
//           //     _scaffoldKey.currentState!.openDrawer();
//           //   },
//           // onBack: () async {
//           //   Navigator.of(context).push(createRoute(const DashboardScreen()));
//           // },
//         ),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color.fromARGB(255, 255, 255, 255),
//               Color.fromARGB(255, 255, 255, 255),
//               Color.fromARGB(255, 255, 255, 255),
//               Color.fromARGB(255, 255, 255, 255),
//             ],
//           ),
//         ),
//         child: Center(
//           child: Column(
//             children: <Widget>[
//               const SizedBox(height: 10),
//               // Expanded(child: content),
//               const FooterScreen(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
// }
