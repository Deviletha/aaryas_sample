import 'dart:async';
import 'package:aaryas_sample/screens/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomNav()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ClipRRect(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: BorderRadius.circular(20), // Image border
        child: SizedBox.fromSize(
          size: Size.fromRadius(90), // Image radius
          child: Image.asset(
            "assets/aryas_logo.png",
            fit: BoxFit.cover,
          ),
        ),
      )),
    );
  }
}
