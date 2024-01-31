import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobigic_test/splashScreen.dart';

class firstSplashScreen extends StatefulWidget {
  @override
  _firstSplashScreenState createState() => _firstSplashScreenState();
}

class _firstSplashScreenState extends State<firstSplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a delay for 2 seconds and then navigate to the second splash screen
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SplashScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset('assets/spl.png')),
    );
  }
}
