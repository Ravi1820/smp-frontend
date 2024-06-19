

import 'package:flutter/material.dart';

class CustomSnackbar extends SnackBar {
  CustomSnackbar({
    Key? key,
    required String title,
    required String body,
    required VoidCallback onButton1Pressed,
    required VoidCallback onButton2Pressed,
  }) : super(
          key: key,
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      onPressed: onButton1Pressed,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 0, 0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.all(20.0),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(
                      onPressed: onButton2Pressed,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff1B5694),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.all(20.0),
                        child: const Text(
                          'Approve',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          backgroundColor: Colors.blue,
          duration: const Duration(minutes: 5),
        );
}

void showMiddleSnackBar(BuildContext context, CustomSnackbar customSnackbar) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const SizedBox.shrink(),
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      duration: customSnackbar.duration,
    ),
  );
  OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.center,
          child: customSnackbar,
        ),
      ),
    ),
  );
  Overlay.of(context).insert(overlayEntry);
  Future.delayed(customSnackbar.duration, () {
    overlayEntry.remove();
  });
}
