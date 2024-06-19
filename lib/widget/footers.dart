
import 'package:SMP/utils/Utils.dart';
import 'package:flutter/material.dart';

class FooterScreen extends StatelessWidget {
  const FooterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: buildFooter(),
    );
  }
}

Widget buildFooter() {
  final double footerHeight = Utils.showBackButton ? 80 : 0;
  final CrossAxisAlignment textAlignment =
  Utils.showBackButton ? CrossAxisAlignment.start : CrossAxisAlignment.center;
  final MainAxisAlignment mainAxisAlignment =
  Utils.showBackButton ? MainAxisAlignment.start : MainAxisAlignment.center;

  return Container(
    color: Colors.transparent,
    width: double.infinity,
    // height: footerHeight,
    child: Stack(
      children: [

        Image.asset(
          Utils.showBackButton ?  "assets/images/ios_footer.png" :
          "assets/images/SMP_footer.png",
          width: double.infinity,
          fit: BoxFit.fitHeight,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.transparent, // Set background color to transparent
            padding: Utils.showBackButton
                ? const EdgeInsets.only(left: 2.0, right: 2.0, bottom: 15.0)
                : const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: textAlignment,
              children: [
                Expanded(
                  child: Text(
                    'Powered by KSNALabs © ${DateTime.now().year}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
