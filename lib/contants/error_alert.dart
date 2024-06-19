import 'package:flutter/material.dart';

void errorAlert(
  BuildContext context,
  String message,
) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding:const EdgeInsets.only(top: 10.0,right: 10.0),
        content: Container(
          margin: const EdgeInsets.only(left: 0.0, right: 0.0),
          child: Stack(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                  top: 18.0,
                ),
                margin: const EdgeInsets.only(top: 13.0,),
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   shape: BoxShape.rectangle,
                //   borderRadius: BorderRadius.circular(16.0),
                //   boxShadow: const <BoxShadow>[
                //     BoxShadow(
                //       color: Colors.black26,
                //       blurRadius: 0.0,
                //       offset: Offset(0.0, 0.0),
                //     ),
                //   ],
                // ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Icon(
                      Icons.error,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),

                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: const TextStyle(
                        color: Color.fromRGBO(27, 86, 148, 1.0),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20.0,
                      width: 5.0,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);

                    // Do nothing to prevent closing on icon tap
                  },
                  child: const Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.close, size: 25, color: Colors.red),
                  ),
                ),
              ),
              // GestureDetector to handle clicks outside the dialog content
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);

                    // Do nothing to prevent closing on outside tap
                  },
                ),
              ),
            ],
          ),
        ),
        // Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     const Icon(
        //       Icons.error, // Change the icon to error
        //       size: 64,
        //       color: Colors.red, // Change the color to red for error
        //     ),
        //     const SizedBox(height: 16),
        //     const Text(
        //       'Error!',
        //       style: TextStyle(
        //         fontSize: 24,
        //         fontWeight: FontWeight.bold,
        //         color: Colors.red,
        //       ),
        //     ),
        //     const SizedBox(height: 16),
        //     Text(
        //       message,
        //       style: const TextStyle(
        //         color: Color.fromRGBO(27, 86, 148, 1.0),
        //         fontSize: 16,
        //         fontWeight: FontWeight.bold,
        //       ),
        //       textAlign: TextAlign.center,
        //     ),
        //   ],
        // ),
        // actions: <Widget>[
        //   SizedBox(
        //     height: 30,
        //     child: ElevatedButton(
        //       style: OutlinedButton.styleFrom(
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(20.0),
        //           side: const BorderSide(
        //             width: 1,
        //           ),
        //         ),
        //         padding:
        //             const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        //       ),
        //       onPressed: () {
        //         Navigator.pop(context);
        //       },
        //       child: const Text("Ok"),
        //     ),
        //   ),
        // ],
      );
    },
  );
}
