 

import 'package:flutter/material.dart';

const Color blue = Color(0xFFEBF4FF);

final ThemeData appTheme = ThemeData(
  primaryColor: const Color(0xff1B5694),
  
  hintColor: const Color(0xff1B5694), // Customize your accent color
  fontFamily: 'Poppins', // Customize your font

  textTheme: const TextTheme(
    bodySmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    bodyLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
  ),
);
