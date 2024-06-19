// import 'package:flutter/material.dart';

// class LogoScreen extends StatelessWidget {
//   const LogoScreen({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: ClipRRect(
//         child: Image.asset(
//           "assets/images/logo-png.png",
//           fit: BoxFit.cover,
//           width: 100,
//           height: 100,
//         ),
//       ),
//     );
//   }
// }

import 'package:SMP/theme/common_style.dart';
import 'package:flutter/material.dart';

class LogoScreen extends StatelessWidget {
  const LogoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: AppStyles.circle(context),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            
            child: Image.asset(
              "assets/images/SMP.png",
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 40,),
        //   child: Text(
        //     'SMP',
        //     style: TextStyle(
        //       fontFamily: 'Roboto',
        //       fontSize: MediaQuery.of(context).size.width * 0.07,
        //       fontStyle: FontStyle.normal,
        //       fontWeight: FontWeight.w600,
        //       color: const Color(0xff1B5694),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
