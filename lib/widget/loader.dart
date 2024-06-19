import 'package:SMP/theme/common_style.dart';
import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return  Dialog(
      child: Container(

        decoration: AppStyles.decoration(context),
        child:const Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Loading ...'),
            ],
          ),
        ),
      ),
    );
  }
}
