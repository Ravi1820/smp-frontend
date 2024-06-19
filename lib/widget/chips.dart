import 'package:flutter/material.dart';

class FeatureNotAvailableChip extends StatelessWidget {
  final bool featureAvailable;

  const FeatureNotAvailableChip({Key? key, required this.featureAvailable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return featureAvailable
        ? Container() // Feature is available, return an empty container
        :const Padding(
          padding:   EdgeInsets.all(8.0),
          child:  Chip(
              backgroundColor: Colors.red,
              label: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Feature will implement soon',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        );
  }
}
