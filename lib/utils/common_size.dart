import 'package:flutter/material.dart';

class SmpCommonSize {
  static TextStyle heading1(BuildContext context) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.050,
    );
  }

  static TextStyle heading2(BuildContext context) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.040,
    );
  }

  static TextStyle heading3(BuildContext context) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.width * 0.030,
    );
  }
}
