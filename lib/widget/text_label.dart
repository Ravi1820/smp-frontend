import 'package:flutter/material.dart';

class CustomTextLabel extends StatelessWidget {
  final String? labelText;
  final String? manditory;

  const CustomTextLabel({
    Key? key,
    this.labelText,
    this.manditory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle headerLeftTitle = TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.04,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      color: const Color(0xff1B5694),
    );

    return Padding(
      padding: const EdgeInsets.only(top: 18, right: 5),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: labelText!, style: headerLeftTitle),
            const WidgetSpan(
              child: SizedBox(width: 5),
            ),
            TextSpan(
              text: manditory,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
