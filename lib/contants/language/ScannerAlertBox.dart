import 'package:SMP/presenter/navigator_lisitner.dart';
import 'package:flutter/material.dart';

void scannerAlertBox(BuildContext context, String message, Widget screen) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline, // Change the icon to error
              size: 64,
              color: Colors.orange, // Change the color to red for error
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
          ],
        ),
        actions: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => screen),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text("OK"),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

void errorDialogWithListner(BuildContext context, String message,
    StatefulWidget screen, NavigatorListener listener) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error, // Change the icon to error
              size: 64,
              color: Colors.red,
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

                if (listener != null) {
                  listener.onNavigatorBackPressed();
                }
                // Utils.routeTransitionStateFullWithReplace(context,  screen);
                // Navigator.of(context).pushAndRemoveUntil(
                //   MaterialPageRoute(builder: (context) => screen),
                //   (Route<dynamic> route) => false,
                // );
              },
              child: const Text("Ok"),
            ),
          ),
        ],
      );
    },
  );
}
