import 'package:aaryas_sample/screens/BottomNavBar.dart';
import 'package:aaryas_sample/screens/SplashScreen.dart';
import 'package:aaryas_sample/screens/homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aaryas Application',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: SplashScreen(),
    );
  }
}