import 'package:SMP/utils/Utils.dart';
import 'package:flutter/material.dart';

class AppStyles {
  static TextStyle heading1(BuildContext context) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.04,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      color: const Color(0xff1B5694),
    );
  }

  static TextStyle label(BuildContext context) {
    return  TextStyle(
      fontFamily: 'Roboto',
      fontStyle: FontStyle.normal,
      fontSize:MediaQuery.of(context).size.width * 0.04,
      fontWeight: FontWeight.bold,
      color: Color(0xff1B5694),
    );
  }
  static TextStyle value(BuildContext context) {
    return  TextStyle(
      fontFamily: 'Roboto',
      fontSize:MediaQuery.of(context).size.width * 0.04,
      fontStyle: FontStyle.normal,

      color: Color(0xff1B5694),
    );
  }

  static TextStyle noticeHeader1(BuildContext context) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.044,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      color: const Color(0xff1B5694),
    );
  }



  static TextStyle dashboardFont(BuildContext context) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.035,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      color: const Color(0xff1B5694),
    );
  }

  static TextStyle heading1Block(BuildContext context) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.04,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      color: const Color.fromARGB(255, 0, 0, 0),
    );
  }


  static TextStyle heading(BuildContext context) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.05,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      color: const Color(0xff1B5694),
    );
  }



  static TextStyle share(BuildContext context) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize:  MediaQuery.of(context).size.width * 0.04,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      color: const Color(0xff1B5694),
    );
  }

  static TextStyle call(BuildContext context) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.04,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      color:  Colors.green,
    );
  }
  static TextStyle reject(BuildContext context) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.04,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      color: Color.fromARGB(250, 200, 0, 0),
    );
  }

  static TextStyle heading2(BuildContext context) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.03,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      color: const Color.fromARGB(181, 27, 85, 148),
    );
  }

  static TextStyle heading3(BuildContext context) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.02,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w200,
      color: const Color.fromARGB(181, 27, 85, 148),
    );
  }

  static TextStyle heading4(BuildContext context) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.01,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w100,
      color: const Color.fromARGB(181, 27, 85, 148),
    );
  }

  static TextStyle bodyText(BuildContext context) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.04,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      color: const Color.fromARGB(181, 27, 85, 148),
    );
  }

  static TextStyle blockText(BuildContext context) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.045,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
  }
  static TextStyle redText(BuildContext context) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.045,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      color: Colors.red,
    );
  }


  static TextStyle securityOnlineText(BuildContext context) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.045,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      color: Colors.green,
    );
  }
  static TextStyle securityOffLineText(BuildContext context) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.045,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      color: Colors.grey,
    );
  }

  static TextStyle noticeBlockText(BuildContext context) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.04,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
  }

  static TextStyle blockText1(BuildContext context) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.035,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );
  }

  static TextStyle drawerStyle(BuildContext context) {
    return const TextStyle(
      fontFamily: 'Roboto',
      fontSize: Utils.drawerText,
      // fontSize: MediaQuery.of(context).size.width * 0.035,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      color: Color(0xff1B5694),
    );
  }

  static TextStyle bodyText1(BuildContext context) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.04,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.normal,
      color: const Color(0xff1B5694),
    );
  }

  static TextStyle disabled(BuildContext context) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery.of(context).size.width * 0.04,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      color: Colors.grey,
    );
  }

  static BoxDecoration decorationTable(BuildContext context) {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(255, 255, 255, 1),
          Color.fromRGBO(255, 255, 255, 1),
        ],
      ),
      // borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          // offset: const Offset(1, 4),
        ),
      ],
    );
  }

  static BoxDecoration noticeHeaderContainer(BuildContext context) {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(255, 255, 255, 1),
          Color.fromRGBO(255, 255, 255, 1),
        ],
      ),
       borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),

      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(1, 4),
        ),
      ],
    );
  }
  static BoxDecoration selectedDecoration(BuildContext context ,bool isSelected){
    return  BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isSelected
            ? [
          const Color.fromARGB(255, 201, 200, 200),
          const Color.fromARGB(255, 201, 200, 200),
        ]
            : [
          Colors.white,
          Colors.white
        ], // Use transparent color if isSelected is false
      ),


      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(1, 4),
        ),
      ],
    );
  }

  static BoxDecoration decoration(BuildContext context) {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(255, 255, 255, 1),
          Color.fromRGBO(255, 255, 255, 1),
        ],
      ),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(1, 4),
        ),
      ],
    );
  }

  static BoxDecoration profile(BuildContext context) {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(255, 255, 255, 1),
          Color.fromRGBO(255, 255, 255, 1),
        ],
      ),
      border: Border.all(
        color: Colors.grey.withOpacity(0.5),
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(50),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(1, 4),
        ),
      ],
    );
  }
  static errorStyle (BuildContext context) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontSize: MediaQuery
          .of(context)
          .size
          .width * 0.03,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      color: const Color.fromARGB(255, 255, 0, 0),
    );
  }




  static BoxDecoration background(BuildContext context) {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(255, 255, 255, 1),
          Color.fromRGBO(255, 255, 255, 1),
        ],
      ),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(1, 4),
        ),
      ],
    );
  }

  static BoxDecoration circle(BuildContext context) {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff1B5694),
          Color(0xff1B5694),
        ],
      ),
      borderRadius: BorderRadius.circular(50),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(1, 4),
        ),
      ],
    );
  }

  static BoxDecoration circle1(BuildContext context) {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromARGB(255, 148, 27, 27),
          Color.fromARGB(255, 148, 27, 27),
        ],
      ),
      borderRadius: BorderRadius.circular(50),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(1, 4),
        ),
      ],
    );
  }

  static BoxDecoration circleGreen(BuildContext context) {
    return BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromARGB(255, 55, 148, 27),
          Color.fromARGB(255, 51, 148, 27),
        ],
      ),
      borderRadius: BorderRadius.circular(50),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(1, 4),
        ),
      ],
    );
  }

 static  headerPlaceHolder( BuildContext context){
    return TextStyle(
       fontFamily: 'Roboto',
       fontSize: MediaQuery.of(context).size.width * 0.04,
       fontStyle: FontStyle.normal,
       fontWeight: FontWeight.w400,
       color: const Color.fromARGB(181, 27, 85, 148));

 }

}
