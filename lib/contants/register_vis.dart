import 'package:flutter/material.dart';

void registerSuccessDialog(
    BuildContext context, String message, Widget screen) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              size: 64,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromRGBO(27, 86, 148, 1.0),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          SizedBox(
            height: 30,
            child: ElevatedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: const BorderSide(
                    width: 1,
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              ),
              onPressed: () {
                Navigator.pop(context);

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => screen),
                  (Route<dynamic> route) => false,
                );
                // waitingVisitorAlert(context, "Waiting");
              },
              child: const Text("Ok"),
            ),
          ),
        ],
      );
    },
  );
}
