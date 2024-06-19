// import 'package:SMP/widget/footers.dart';
// import 'package:SMP/widget/header.dart';
// import 'package:SMP/view_model/smp_view_model.dart';
// import 'package:SMP/view_model/visitor_view_model.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class SocietyDuesScreen extends StatefulWidget {
//   const SocietyDuesScreen({super.key});
//   @override
//   State<SocietyDuesScreen> createState() {
//     return _SocietyDuesScreen();
//   }
// }
//
// class _SocietyDuesScreen extends State<SocietyDuesScreen> {
//   bool setShowlistflag = false;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   List<VisitorViewModel> originalUsers = [];
//   List<VisitorViewModel> usersList = [];
//   String query = "";
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   void editUserChoice(users) {}
//
//   Future<void> _choose() async {}
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
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     BoxDecoration decoration = BoxDecoration(
//       gradient: const LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: [
//           Color.fromRGBO(255, 255, 255, 1),
//           Color.fromRGBO(255, 255, 255, 1),
//         ],
//       ),
//       borderRadius: BorderRadius.circular(10),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.withOpacity(0.5),
//           spreadRadius: 2,
//           blurRadius: 5,
//           offset: const Offset(1, 4),
//         ),
//       ],
//     );
//     getList();
//
//     Widget content = Padding(
//       padding: EdgeInsets.all(8.0),
//       // child: MonthalyMaintanceViewCard(),
//     );
//
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       key: _scaffoldKey,
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(kToolbarHeight),
//         child: CustomAppBar(
//           title: 'Monthly Maintenance Fees',
//           profile: () {},
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
//               Expanded(child: content),
//               const FooterScreen(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
