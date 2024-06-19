import 'package:SMP/contants/base_api.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _choose();
  }

  void _choose() {
    Future.delayed(const Duration(seconds: 3), () async {
      Navigator.pushReplacementNamed(context, '/main');
      //
      // // BaseApi.BASE_API = "https://192.168.1.7:8082";
      // BaseApi.BASE_API =
      //     "https://ec2-3-6-91-225.ap-south-1.compute.amazonaws.com:8082";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: const Color(0xFFf1f7fd),
            child: Image.asset(
              "assets/images/Smp1.png",
              height: MediaQuery.of(context).size.height,
            ),
          )
        ],
      ),
    );
  }
}
