import 'package:SMP/contants/auth_services.dart';
import 'package:SMP/dashboard/dashboard.dart';
import 'package:SMP/login.dart';
import 'package:SMP/utils/Utils.dart';

import 'package:SMP/view_model/smp_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: SmpListViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SMP',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(),
          primarySwatch: Colors.indigo,
          hintColor: const Color.fromARGB(255, 67, 89, 112),
        ),

        initialRoute: '/',
        home: FutureBuilder<bool>(
          future: _authService.isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              Utils.printLog(snapshot.data.toString());
              bool isLoggedIn = snapshot.data ?? false;
              return isLoggedIn ?  DashboardScreen(isFirstLogin: true) : const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
